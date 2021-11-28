+++
title = "Upgrading my Pi Cluster"
date = "2021-11-27T23:53:08-05:00"
author = "Ari"
authorTwitter = "realwillowtw" #do not include @
cover = ""
tags = ["raspberry pi", "docker", "cluster", "tutorials", "cluster upgrade series"]
keywords = ["raspberry pi", "raspberry pi 4", "raspbian", "docker", "cluster", "cluster computing", "randomizer", "docker swarm", "swarm mode", "kubernetes", "hardware mods", "from scratch", "maker", "indie maker", "maker projects", "jeff geerling", "geerlingguy"]
description = "Helping my cluster (and yours!) achieve its full potential"
showFullContent = false
draft = false
+++

# The series insofar:

 1. [Reasoning and project introduction](/posts/pi-cluster-upgrades) (you are here)
 2. [Designing and building the power supply](/posts/cluster-upgrade-power)

# Introduction

I've learned a lot of things recently, most of them regarding electrical engineering. For a long time my technical focus has been solely on software engineering (hence the website about me coding) but I've always been interested in making devices and hardware systems. People that do this kind of "full stack + a little bit of hardware" stuff are generally called makers, and it's never been easier to make one.

With the Raspberry Pico being a cheap and grotesquely overpowered microcontroller, I've begun making a couple of small projects that marry software and hardware. These include:

 - A robot that shoots speedrunners with ping-pong balls whenever they get a red split
 - A tamagotchi-like device that hooks up to your computer to add multiplayer and minigame functionality
 - A small box that allows you to play local co-op Nintendo Switch games over a network connection

...and more. All of these will be written about in great detail on this site when they're complete, of course. But the one I'm most excited about is creating an extensible, accessible rack system for a Raspberry Pi cluster.

# ...don't those exist already?

_Sort of, but not really._ Every rack-mountable Pi cluster solution I've found makes at least one of the following assumptions:

 - You have and want to use PoE hats for all of your Pis
 - You are using [Raspberry Pi compute modules](https://www.pishop.us/product/raspberry-pi-compute-module-4-4gb-8gb-cm4004008/)
 - You only want 4-8 nodes
 - You are using a Pi 3B or earlier

For me, none of this is true. Let's address each of those.

## False Assumption 1: I want to use PoE

If you read [the initial post where I set up this cluster](/posts/building-a-pi-cluster/), you'll probably notice that I got PoE+ hats for each Pi. If you're extremely observant, you'll notice that the network switch I chose has a 63 watt power budget. When you are exclusively booting 8 Raspberry Pis, that is _almost_ sufficient. This is likely not the time for me to delineate what watts, volts, and amps are, but the short version is that a Pi4 by itself draws ~9 watts and 9x8 is 72.

Finding a PoE+ switch that supplies much more than 63 watts at gigabit speeds is pretty difficult to do, unless you go rack mounted with active cooling. While I am okay with both of those things, they are prohibitively expensive and there's some things I don't like about PoE for this usecase.

Namely, I am not Jeff Geerling - I do not have an unlimited supply of PoE hats, an added cost of ~$40 per Pi is too much in my opinion, and this cluster is in a space where I can unfortunately hear the whine of the fans for PoE's immense amount of waste heat.

PoE also functionally excludes me from doing any serious overclocking due to thermal concerns, and I like my Pi 4s running at 2gHz (instead of the base 1.5gHz).

So overall, PoE is not a good fit fot me. I'd much rather get a proper PSU and distribute that somehow.

## False Assumption 2: I am using CM4 modules

Much like before, I am not Jeff Geerling. I don't have a ton of CM4 boards. I actually only have 2 that I paid quite a lot of money to get - one of which is powering my OpenWRT router, the other of which came from the factory dead.

As an aside, if you're not watching [Jeff Geerling](https://www.youtube.com/c/JeffGeerling) on YouTube, you're missing out. He focuses on Raspberry Pis/compute modules and all of the cool things you can do with them, and has a similar clustering project - although his uses Pi 3 boards and kubernetes instead of Pi 4s and docker swarm.

That aside - CM4 boards are ***extremely*** difficult to come by, even from scalpers. Sadly, this means they're not an option for me.

## False Assumption 3: I only want 4-8 nodes

Nope. I want as many nodes as I can fit in there. Having done some math (which is highly unusual for me), I've determined that I can fit a Pi + a mount for it + breathing room for drawing air for cooling in nearly 30mm exactly. The inner diameter of a standard server rack is 17.75 inches, and this translates to me being able to comfortably fit 15 Pis in 1U.

I could likely squeeze down on breathing room to add another couple Pis in, but for wiring and power distribution purposes 15 or 16 Pis actually works out really nicely - and I want to make kits and source files available to people to build their own rack cluster on the cheap, so everything needs to be easy to assemble.

## False Assumption 4: I am using a Pi 3B or earlier

I am using Raspberry Pi Model 4B boards for each of my nodes. Specifically I am using the model with 8gb(!) of RAM on them, making them comfortably able to handle most applications with quite a lot of headroom. They're also overclockable to 2gHz (or 2.175gHz if you're feeling spicy) and that gives me an exceptional amount of compute power for not a lot of money.

Unfortunately, this does mean they consume a lot more power than a model 3, and that produces a lot of issues for most rack solutions I have found. Many are not guaranteed to fit the slightly different form factor of the Pi 4, and I have yet to find one that can supply as much power in a single unit as I need.

# So what do we do about it?

Well, if you're me, you make an open source modular rack mount system for your Pi cluster. Most comparable solutions are several hundred dollars at a minimum (to the extent that comparable solutions exist - see the prior paragraphs for why there's nothing I can find that fills this niche). I think I can do it in about $100-$150 total, not counting assembly/design time.

It will be open source hardware as well, and make heavy use of 3D printing with standard PLA filament. This means you can print your own chassis and mount system very cheaply, or you can have me/my manufacturing partner do that for you for an additional fee.

Stay tuned and check out the following posts about the upgrades I'm making to my cluster!
