+++
title = "PiHole Container Exiting as \"Complete\" After 3 Minutes"
date = "2021-08-09T18:03:56-04:00"
author = "Aria"
authorTwitter = "realwillowtw" #do not include @
cover = "https://wp-cdn.pi-hole.net/wp-content/uploads/2018/12/pihole-text-logo-white.png.webp"
tags = ["raspberry pi", "docker", "debugging", "short", "dns"]
keywords = ["raspberry pi", "raspberry", "pi", "pi4", "raspberry pi 4", "raspberry pi 4b", "docker", "containerization"]
description = "This one is a little bit easier to search for, but alas, still a bit obtuse."
showFullContent = false
+++

If you're deploying PiHole to a docker swarm cluster, it's likely that you're seeing the container exit after 3 minutes with a status message of "completed" - which is a bit strange, given that it's a DNS server and its job is only complete when it's replaced with a new one.

This is a failure of the `healthcheck` system built into Docker - for some reason, healthy containers are considered "done" and pruned + replace. This...does not make sense.

Fortunately, these checks can be easily disabled:

{{< code language="yaml" >}}
version: '3.8'
services:
  pihole:
    image: pihole/pihole:latest
    healthcheck:
      disable: true
    # ...rest of your service definition goes here
{{< /code >}}

That's it! I'm going to investigate the problem a little bit further and figure out exactly *why* that's happening, but for the time being, this is a good enough workaround for me.
