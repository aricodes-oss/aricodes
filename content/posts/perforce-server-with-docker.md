+++
title = "Making a Perforce Server With Docker"
date = "2021-05-28T16:49:12-04:00"
author = "Ari"
authorTwitter = "realwillowtw" #do not include @
cover = "https://techmeetups.com/wp-content/uploads/2013/08/Perforce.png"
tags = ["perforce", "docker", "getting started", "tutorials", "intermediate"]
keywords = ["perforce", "docker", "docker compose", "docker-compose", "tutorials", "perforce on docker", "how to make a perforce server with docker", "how to", "how-to"]
description = "There's not many Perforce docker images out there. Here's why, and how to make one."
showFullContent = false
draft = false
+++

# Purpose

There's not many [Perforce](https://www.perforce.com/) docker images out there, and I haven't found _any_ that are maintained and well documented. There's actually a pretty good reason for that - Perforce is _messy_. It leaves files all over the system, there's no real option to constrain it to a specific area, and it makes some assumptions about how you want your system to be run that don't really translate to a containerized environment very well.

Fortunately, because Docker is magic, we can remedy most of these things. By the end of this, you'll have your own Perforce server running comfortably on your own infrastructure. We'll be using the industry standard `docker-compose` container orchestrator for this, but a similar configuration can be shipped to Docker Swarm and Kubernetes.

As this is targetted at people that _probably_ aren't running large scale clustering software, we're going to stick with `docker-compose` and focus on a single server.

# What is Perforce?

[Perforce](https://www.perforce.com/) is a version control system geared towards game developers. It handles large files, binary files, and locks on those files better than most other version control systems. Other version control systems you may be familiar with are `git`, `subversion` (or `svn` for short), and `mercurial` (or `hg` for short).

For most workloads, you'd want to choose `git`. That statement is almost purely backed by my opinion, but `git` is the most popular version control system for a reason. It's fantastic for _most_ things.

One thing `git` doesn't do well is handle large binary files. I'll spare the gory details of this, but storing a frequently edited video file (such as a cutscene or animation for a video game) makes `git` _very_ unhappy. Hence, Perforce.

# Prerequisites

For this tutorial we're going to assume that you have installed `docker` and `docker-compose` and have the `docker` daemon running on your machine. This is normally the part where I would put simple instructions on how to do that, but Docker is reorganizing its packages and install processes and my instructions would be quickly outdated.

We'll also assume that you're familiar with very basic command line navigation. If you're not, you probably shouldn't be trying to administer systems and should consult with someone that does.

If you want to learn, I **highly** recommend going to [linuxcommand.org](https://linuxcommand.org/). That's where I learned basic terminal literacy, and you can go through everything you need to know in the span of a few hours.

***Update 2021/12/122*** - Marc Wilson from [PCWDLD](https://www.pcwdld.com) sent me an email with a Linux commandline cheatsheet that should be useful for people that want a quicker way to get some shell literacy. You can [check it out here](https://www.pcwdld.com/linux-commands-cheat-sheet). Thanks Marc!!

That aside, let's dig into it!

# The problems with Perforce

Perforce makes a lot of assumptions about how it's going to be run. It assumes that it is going to be a daemon, managed manually by CLI interactions or an admin interface. That doesn't translate well to Docker, where a "system" only exists to do one thing and its lifecycle is managed automatically.

It also places files all over the system. You can configure a data directory, but its database is initialized from where the start command is run instead of in a dedicated location and all non-volume files in a Docker container are ephemeral.

This is fairly typical behavior and works well for installing the server on a bare metal machine, but nowadays it is often desirable to isolate all of your services from each other.

Let's dig into solving this problem.

# Creating our service

Let's create a `docker-compose` project. This translates to doing a few very simple operations.

{{< code language="bash" >}}
$ mkdir perforce && cd perforce
$ touch docker-compose.yml
$ touch Dockerfile
{{< /code >}}

Now we need to make some volumes. A `volume`, to Docker, is a folder inside the container that is physically located outside of the container. That means we can have persistent data and configuration directories.

Let's define our service here.

{{< code language="yaml" title="docker-compose.yml" >}}
version: '3'
services:
	perforce:
		build:
			context: .
			dockerfile: Dockerfile
		restart: unless-stopped
		volumes:
			- ./perforce-data:/perforce-data
			- ./dbs:/dbs
		environment:
			- P4PORT=1666
			- P4ROOT=/perforce-data
		ports:
			- 1666:1666
{{< /code >}}

Here we've defined our service with three volumes - one for data, one for configuration, and one for what Perforce refers to as "databases." Let's go and make those directories now.

{{< code language="bash" >}}
$ mkdir perforce-data
$ mkdir p4dctl.conf.d
$ mkdir dbs
{{< /code >}}

And that's...actually it! Now we need to figure out what our image looks like.

# Making our image

Perforce has some [good documentation for installing it on Ubuntu](https://www.perforce.com/perforce/doc.current/manuals/p4sag/Content/P4SAG/install.linux.packages.install.html), and luckily for us, there's an official Ubuntu docker image that we can base ours off of.

Let's go fill out that `Dockerfile`!

{{< code language="dockerfile" title="Dockerfile" >}}
FROM ubuntu:focal

# Update our main system

RUN apt-get update
RUN apt-get dist-upgrade -y

# Get some dependencies for adding apt repositories

RUN apt-get install -y wget gnupg

# Add perforce repo

RUN wget -qO - https://package.perforce.com/perforce.pubkey | apt-key add -
RUN echo 'deb http://package.perforce.com/apt/ubuntu focal release' > /etc/apt
/sources.list.d/perforce.list
RUN apt-get update

# Actually install it

RUN apt-get install -y helix-p4d

# Go into our directory, start Perforce, and view the log outputs

CMD cd /dbs && p4dctl start master && tail -F /perforce-data/logs/log
{{< /code >}}

Aaaaaaaaand that's that! With `docker-compose`, volumes are not mounted until you reach the container entrypoint. The entrypoint, in this case, is defined with the `CMD` directive. As such, we have to enter our `dbs` directory there and no earlier.

# Populating the configuration directory

Perforce, in all its majesty, will create files in our `etc` directory during installation that it requires to run its configuration script. Fortunately, we can grab those from our newly built image and stash them in our volume mount.

{{< code language="bash" >}}
$ docker-compose run -T --rm perforce tar czvf - -C /etc/perforce/p4dctl.conf.d  . | tar xvzf - -C p4dctl.conf.d/
{{< /code >}}

Now we just need to add one more volume to our `docker-compose` service declaration to have those files mounted in the running container:

{{< code language="yaml" title="docker-compose.yml" >}}
version: '3'
services:
	perforce:
		build:
			context: .
			dockerfile: Dockerfile
		restart: unless-stopped
		volumes:
			- ./perforce-data:/perforce-data
      - ./p4dctl.conf.d:/etc/perforce/p4dctl.conf.d
			- ./dbs:/dbs
		environment:
			- P4PORT=1666
			- P4ROOT=/perforce-data
		ports:
			- 1666:1666
{{< /code >}}

Now we're ready to actually configure our server! Perforce includes a nice little helper script for this.

{{< code language="bash" >}}
$ docker-compose run --rm perforce /opt/perforce/sbin/configure-helix-p4d.sh
{{< /code >}}

Configure the server name as `master`, ensure that the server root is set to `/perforce-data`, and that the port is set to `1666`. You'll also set up superuser credentials for your server during this step.

# Spinning it up

Spinning up your new service is almost disappointingly easy. We just set it running, and leave it be.

{{< code language="bash" >}}
$ docker-compose up --build -d
{{< /code >}}

And that's it! You've now got a Perforce server running on port `1666` on this machine. Go make the game of your dreams!

# Troubleshooting

A number of issues can potentially come up during this. Try spinning up your service without detaching it (`docker-compose up --build` - note the lack of `-d` in that command) to see the log output. If it's running but detached, you can run `docker-compose logs -f` to view the log output in real time.

I do not personally use Perforce and devised this tutorial for a friend, but I have verified on multiple environments that it is working. If you find any errors or have any questions, always feel free to [email me](/contact)!
