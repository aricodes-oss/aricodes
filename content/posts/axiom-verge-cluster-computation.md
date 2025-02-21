+++
title = "Brute Forcing Every Axiom Verge Randomizer Seed"
date = "2021-07-03T02:28:25-04:00"
author = "Aria"
authorTwitter = "realwillowtw" #do not include @
cover = "https://images.squarespace-cdn.com/content/4f7c8818e4b000a129e38a56/1391298296571-8MUWBQFA0DJXFPL3SARS/CanvasBackground.png?content-type=image%2Fpng"
tags = ["game development", "cluster", "analysis", "deep dive"]
keywords = ["axiom verge", "thomas happ", "game development", "game dev", "cluster", "cluster computation", "raspberry pi", "pi", "docker", "docker swarm", "kubernetes"]
description = "Q: How do you mathematically prove that your video game can be beaten? A: Significantly more money and effort than it is worth. Let's explore that."
showFullContent = false
draft = false
+++

# What is Axiom Verge?

[Axiom Verge](https://www.axiomverge.com/) is a popular metroidvania from 2015 with a sequel coming out Soon (tm). Up until very recently it was developed solely by one person, named Tom Happ. He and Dan Adelman form Thomas Happ Games LLC, with Dan handling the business side of things. Tom is an absolutely incredible developer and one of the most talented engineers I have ever had the pleasure of working with, and he's very much in touch with the speedrunning community surrounding his game. I happen to speedrun Axiom Verge, and as such got introduced to him through marathon commentary and just hanging around the AVSR discord server.

When Tom found out that we (I say we, I was not involved in this version) had built a randomizer for his game, he was *ecstatic*. He wanted to build one himself but it seemed like too large of a task and would hold up shipping the game for quite some time. After discussing it with him, our team decided to build the randomizer into the game for him. This involved scrapping our old code entirely, signing a few (very minimally restrictive) NDAs, and getting to work.

Tom was absolutely correct about how much work it would be. AV is structured in such a way that the actual act of randomizing the items is easy - we just need to shift some values in a lookup table that maps item spawning nodes to items - but the genre of game makes it particularly difficult to ensure that all items can be collected and the game can be beaten. After about a year on the project (and getting back in touch with Tom), we entered private beta.

"Metroidvanias" are platformers that are known for being non-linear and housing a large number of secrets. Axiom is no exception to this, and it is a *very* large game.

# What is a randomizer?

A randomizer, in short, takes the items and powerups that are found during normal gameplay and changes where they can be found. This is a good way to breathe new life into old games, as it effectively generates a new experience for the player each and every time. Figuring out where to go in a randomizer is like solving a puzzle and scratches that same itch. Randomizers are particularly well suited to metroidvanias due to their nonlinear nature and large amount of hiding places. This does come with some associated complexity though, which I won't be getting into here.

# So who are you and what is this post about?

I'm one of the developers for the [free Axiom Verge randomizer DLC](https://www.axiomverge.com/blog/announcing-axiom-verges-first-ever-free-content-update-in-open-beta-now). For the post - as part of the whole "making a quality product" thing, we really wanted to make sure the randomizer would not generate "dead seeds."

A dead seed is defined as any seed that cannot be completed by the player. That is a *very* large definition. Fortunately, as speedrunners, we have a pretty good idea of what things are possible and what things are not. For instance, an item can not be located in an area that requires that item to get there. Proving that the randomizer cannot produce those kinds of seeds is easier said than done.

We could, in theory, add a manual check in the code to make sure it doesn't generate those kinds of situations. How do we handle that though? Just come up with another seed? Shuffle the items again? And how do we scale that? There's over 130 unique items in Axiom Verge, each that provides various abilities to perform various checks. That code gets messy real quick.

Clearly this is a problem for unit tests - provide your seed as an input, and make your assertions on the output of the randomization engine. This also has some scaling problems however - generating a seed is not computationally cheap. Dependent upon the machine it's running on, this can take around 700ms on the high end to generate before starting the game. This is negligible for a one-off operation that a heavy randomizer user would be running once an hour on average, but is a lot to cover our search space.

# Our search space

There's 3 logic levels, so each numeric seed has 3 different forms it can take. Seeds are (ultimately) stored as an unsigned 32 bit integer, so that's 4,294,967,295 unique numeric seeds. Arithmetic tells us that's 12,884,901,885 potential arrangements of items. There's likely a lot of overlap there, but we just don't know until we generate the seeds.

So, let's generate the seeds. We built an SDK that isolates the randomizer engine from the game itself and allows us to generate arbitrary seeds and test their output. I modified this lightly to absolutely murder however many CPU cores it can grab and run seeds in parallel. On my desktop machine, this was estimated to take 2 straight weeks of redlining the CPU. Unfortunately, I use that. Thus, [my Raspberry Pi cluster](/posts/building-a-pi-cluster/) was born: a set of machines that do nothing but slowly churn out Axiom Verge randomizer seeds.

# How the "miner" is set up

Now that we have a simple framework for testing our randomizer, we just need to run the tests. I created an ingest service with NodeJS, Redis (for message queueing), and sqlite (for storing all of the data). This ingest service has "reservations," which are ranges of numeric seeds for the worker to generate. The worker retrieves one of these reservations, processes all of those seeds in parallel (using dotnet's built in `Parallel.For`), and then submits the reservation back to the web service with the completed seed data. With the reservation size I found to be most optimal for this arrangement, this winds up being a couple megabytes.

This isn't at truckload of data, but it does mean sqlite will take a while to insert these. Since all of these are running on Raspberry Pis and the storage is networked, this insertion and indexing can take up to about 20-30 seconds. I'm using Celery to take this completed bundle and queue up a task in Redis to go convert all of these fields (strings by default) into singular bytes and then insert them into the databse. If I had to go back and rearchitect this project, I would be using Python for the backend as it has significantly better support for the Celery protocol, but we live and we learn.

The keen eye amongst you may notice that this is a *lot* of data. With the compression of item fields to be single bytes we cut down on this size by an amount that's larger than what I'm willing to calculate, but it still winds up being nearly 2 terabytes of data (with some napkin math). That's why the storage is networked - it's storing the data on my NAS, where I've got 30tb of free space. This slows down the insertion operations, but not by enough that it's a bottleneck with the task queue model.

The reason I'm not using Postgres or another "real" database is simple - I found it really didn't change the performance by an appreciable amount. Sqlite is a really fantastic tool for this kind of project and saves some overhead in running a full on database server. It also makes it veeeeeeery easy to move the database to a more powerful machine for indexing and analysis.

# How this is deployed

That part was easy. I built docker images for the web service, worker, and miner for ARM64 and sent them off to the private registry running on [the cluster](/posts/building-a-pi-cluster/). After that, it's a simple matter of setting up a service definition

{{< code language="yaml" >}}
version: '3'
services:
  web:
    image: cluster.gov:5000/seed-web:latest
    volumes:
      - /shared/seeds.db:/code/data.db
    ports:
      - 3000:3000
    depends_on:
      - messages
    networks:
      - seeds

  worker:
    image: cluster.gov:5000/seed-web:latest
    command: yarn worker
    volumes:
      - /shared/seeds.db:/code/data.db
    depends_on:
      - miner
      - web
      - messages
    networks:
      - seeds

  messages:
    image: redis:latest
    volumes:
      - /shared/redis:/data
    networks:
      - seeds

  miner:
    image: cluster.gov:5000/seed-miner:latest
    depends_on:
      - web
      - messages
      - db
    networks:
      - seeds
    deploy:
      placement:
        constraints:
          - node.role!=manager
networks:
  seeds:
{{< /code >}}

...and deploying it. Once everything is up and running, I'll scale the `seeds_miner` service up to however many nodes I feel like occupying and let it run for as long as it needs to. By my math, this'll take a little over 2 months to do with the Pis alone, which is fine by me. We tested a non-trivial amount of random seeds before releasing the current version of the public beta (~15,000,000) and found all of them to be completable within our parameters. My desktop also kicks in its processing power with the cluster to generate seeds when I'm not using it, and that spits them out significantly faster than the entire cluster combined can generate them. Turns out that an i9-9900k clocked at 5GHz (with custom loop water cooling because I hate having money) can work just a *touch* faster than some Raspberry Pis.

# Why are you not doing this on a GPU?

Great question! That was actually the first thing I considered before "build a whole damn cluster." The short answer is "Have you ever *tried* GPGPU programming? It sucks."

The long answer is that the code for the randomizer is complex to the extent that I really don't want to translate it to C or C++, and running C# on a GPU is significantly more difficult than it needs to be. Every library I located was either direly out of date, had an incredibly narrow set of supported use cases, did not support OpenCL, or required a large payment. Combined with the fact that I use an AMD GPU (because I like having Linux support) and therefore cannot use CUDA, my options are very limited.

Also - and I cannot stress this enough - GPGPU programming just sucks really hard. I hope that smarter people than I develop abstractions for doing arbitary work on GPUs in the future, but as of right now, that's far outside of my expertise and frankly I wanted to build a cluster anyways.

# Can I help?

I'd love to crowdsource some compute power for this! I'm looking into doing that as we speak, so check back here for when I can get a release sent out.
