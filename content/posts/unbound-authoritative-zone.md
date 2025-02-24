+++
title = "Using Unbound as an Authoritative Nameserver"
date = "2025-02-20T16:09:13-08:00"
#dateFormat = "2006-01-02" # This value can be configured for per-post date formatting
author = "Aria"
cover = "https://nlnetlabs.nl/static/logos/Unbound/Unbound_FC_Shaded_cropped.svg"
tags = ["unbound", "dns", "pihole", "raspberry pi"]
keywords = ["unbound", "dns", "pihole", "raspberry pi", "raspberry pi 4"]
description = "Unbound is commonly paired with [Pi-hole](https://pi-hole.net/) for local DNS resolution. But what if we want our own private zone that's only available on the local network? This post explores and documents just how to do that."
showFullContent = false
readingTime = true
hideComments = false
draft = true
+++

# Just get to the instructions!

[Sure thing!](#tldr)

# Introduction

We've talked about [pi-hole](https://pi-hole.net/) several times before and it certainly needs no introduction. While it's a fantastic tool for network-wide adblocking, the project (intentionally) falls short as an extensible DNS server as it simply forwards queries to an upstream provider. This is suboptimal in two key regards: privacy, and configuration; and the intersection of these issues is what we're focusing on today.

## Tackling problems

First off, let's start with privacy. There is an excellent [high-level overview on the pi-hole docs website](https://docs.pi-hole.net/guides/dns/unbound/) that goes over this, but the short version is "we can either trust Cloudflare not to lie to us and monitor our queries OR we can resolve every query from the root nameservers ourselves." Resolving the queries ourselves is slower because we don't get to benefit from a regional cache network, but it also nearly guarantees that our upstream response hasn't been poisoned.

Configuration is our other sore spot. Pihole will allow you to
