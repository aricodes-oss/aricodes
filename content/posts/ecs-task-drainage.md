+++
title = "AWS ECS and the case of the missing health checks"
description = "My tasks are randomly dying and I am afraid."
date = "2021-04-18T21:02:04-04:00"
author = "Ari"
authorTwitter = "realwillowtw" #do not include @
showFullContent = false
draft = true
+++

Last night, we thought we had successfully migrated our backend from Zappa serverless to running in Docker containers on ECS Fargate. The reasons for this migration were numerous, but ultimately fell under "ECS fits our usecase better."

One magical side effect of this is that our backend now exists for longer than the request lifecycle, so we don't have to wait for Django to warm up to serve a new request. This application was interfacing with a _much_ older database (think DB2 kind of old) to serve certain requests, and this database isn't particularly quick by modern standards, so any amount of latency reduction we could manage helped the end user experience.

This morning however, our end user experience was not that great as nobody could actually use our app. Some coffee and panicking later, we had our problem assessment. Here's what was happening.

1. Our backend containers would spin up
2. They would run fine for 5 minutes, give or take a few seconds
3. Our load balancer would inform us that their healthcheck requests had timed out
4. Our backend containers were pruned

What made this exceptionally odd was that this exact configuration was being used for another one of our services that was running successfully. For security purposes (read: "the business refuses to pay for cloudwatch logs") we didn't have request logging enabled. Our working assumption was that the traffic was getting blackholed by a security group misconfiguration.

```Dockerfile
FROM node:latest
```
