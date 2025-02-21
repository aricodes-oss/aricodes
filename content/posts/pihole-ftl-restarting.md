+++
title = "What to do if Pihole-FTL is constantly restarting"
date = "2021-08-07T17:41:29-04:00"
author = "Aria"
authorTwitter = "realwillowtw" #do not include @
cover = "https://wp-cdn.pi-hole.net/wp-content/uploads/2018/12/pihole-text-logo-white.png.webp"
tags = ["raspberry pi", "docker", "debugging", "short", "dns"]
keywords = ["raspberry pi", "raspberry", "pi", "pi4", "raspberry pi 4", "raspberry pi 4b", "docker", "containerization"]
description = "This is a remarkably difficult issue to search for. Fortunately, it's an easy fix."
showFullContent = false
draft = false
+++

What I've got for you today is much shorter than my average rant, as the problem and solution are both very simple but hard to search for. Let's get directly into the issue!

# What's happening?

If you're running PiHole in a docker container and are seeing "Lost connection to API" on your dashboard and ads are not being blocked, chances are you're *also* seeing something like this in the logs:

```
Starting pihole-FTL (no-daemon) as root
Stopping pihole-FTL
kill: usage: kill [-s sigspec | -n signum | -sigspec] pid | jobspec ... or kill -l [sigspec]
Starting pihole-FTL (no-daemon) as root
Stopping pihole-FTL
```

That belongs in the hall of fame for "completely useless error messages." That tells me *exactly* nothing about what's going on here, which is really rather characteristic of shell script error output - but I digress.

# Why is PiHole-FTL constantly?

PiHole-FTL uses `/dev/shm` to write its data into a RAM disk. Docker limits the size of this space to 64mb by default. This can be adjusted at the CLI when using `docker run`, but I don't know anybody that memorizes `docker run` commands instead of using `docker-compose` or `k8s` service definitions.

# How do I fix it?

That depends on how you're running this container! Here we're going to tell it that it can consume up to 2gb of host memory so that we have plenty of room to grow.

## docker-compose

Update your service definition to include the following:

```
shm_size: '2g'
```

## docker swarm

Docker swarm ignores that option in service definitions because Docker has made some incredibly questionable decisions about what functionality is available in swarm mode service definitions.

The workaround is to add a `tmpfs` volume mount to your service definitions:

```
volumes:
  - type: tmpfs
    target: /dev/shm
    tmpfs:
      size: 2048000000
```

# That's it!

Update your service and PiHole-FTL should actually start up correctly. If you have any questions or find that this doesn't work for you, please feel free to [shoot me an email](/contact) and I'll help you debug it!
