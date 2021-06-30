+++
title = "Building an 8 Node Raspberry Pi 4 Cluster (with Docker Swarm)"
date = "2021-06-30T02:12:49-04:00"
author = "Ari"
authorTwitter = "realwillowtw" #do not include @
cover = "/pi-cluster/splash.png"
tags = ["raspberry pi", "docker", "cluster"]
keywords = ["raspberry pi", "raspberry pi 4", "raspbian", "docker", "cluster", "cluster computing", "axiom verge", "randomizer"]
description = "Or the story of how I made something completely overkill"
showFullContent = false
draft = true
+++

Most people visiting this blog have probably heard of the Raspberry Pi before. I'd wager that most people visiting this blog actually *own* at least one or more of the devices. I've actually lost count of how many I own at this point, and I just added 8 more to that number. They're extremely useful and serve a wide variety of purposes.

For those that are somehow not in the know - a Raspberry Pi is a single board computer that's roughly the dimensions of a credit card. Or like...a stack of 7 or 8 credit cards, with the IO ports. They're remarkably capable devices, and the Raspberry Pi 4 is the most powerful device yet. They have 4 physical ARM cores on the device (with a base clock of 1.5GHz) and up to 8GB of LPDDR4-3200 SDRAM. They boot off of a micro SD card slotted into the device and can be powered over a 5V/3A DC connection through USB-C.

This is all to say that they're small, they're powerful, and they're cheap. An absolutely maxed out Pi 4 costs a little under $100. For something that can single handedly fulfill almost all of your home server needs, that's practically free - or at least a no-brainer investment to any sysadmin on a budget.

In lieu of a proper transition to the next section, here's a picture of the cluster.

![The Pi cluster, in all its glory](/pi-cluster/cluster-1.jpg)

# What are we going to do here?

I wanna get you prepared to build your own Pi cluster, and learn from my mistakes. I'll get you a list of materials, some setup instructions, and some rationalizations for my own choices.

# Why did you build this?

I'm so glad you asked.

I'm one of the developers for the [free Axiom Verge randomizer DLC](https://www.axiomverge.com/blog/announcing-axiom-verges-first-ever-free-content-update-in-open-beta-now). There's a lot of complexity that goes into building a randomizer, particularly for a metroidvania, but I'll spare you the gory details. As part of the whole "making a quality product" thing, we really wanted to make sure the randomizer would not generate "dead seeds."

A dead seed is defined as any seed that cannot be completed by the player. That is a *very* large definition. Fortunately, as speedrunners, we have a pretty good idea of what things are possible and what things are not. For instance, an item can not be located in an area that requires that item to get there. Proving that the randomizer cannot produce those kinds of seeds is easier said than done.

We could, in theory, add a manual check in the code to make sure it doesn't generate those kinds of situations. How do we handle that though? Just come up with another seed? Shuffle the items again? And how do we scale that? There's over 130 unique items in Axiom Verge, each that provides various abilities to perform various checks. That code gets messy real quick.

Clearly this is a problem for unit tests - provide your seed as an input, and make your assertions on the output of the randomization engine. This also has some scaling problems however - generating a seed is not computationally cheap. Dependent upon the machine it's running on, this can take around 700ms on the high end to generate before starting the game. This is negligible for a one-off operation that a heavy randomizer user would be running once an hour on average, but is a lot to cover our search space.

# Our search space

There's 3 logic levels, so each numeric seed has 3 different forms it can take. Seeds are (ultimately) stored as an unsigned 32 bit integer, so that's 4,294,967,295 unique numeric seeds. Arithmetic tells us that's 12,884,901,885 potential arrangements of items. There's likely a lot of overlap there, but we just don't know until we generate the seeds.

So, let's generate the seeds. We built an SDK that isolates the randomizer engine from the game itself and allows us to generate arbitrary seeds and test their output. I modified this lightly to absolutely murder however many CPU cores it can grab and run seeds in parallel. On my desktop machine, this was estimated to take 2 straight weeks of redlining the CPU. Unfortunately, I use that. Thus, the cluster was born: a set of machines that do nothing but slowly churn out Axiom Verge randomizer seeds.

# What you need

As a forewarning, all of these links are Amazon Affiliate links.

 - [8 Raspberry Pi 4B computers with 8GB of RAM](https://amzn.to/3w6QazB)
 - 8 Raspberry Pi PoE+ Hats (specifically the PoE+ model to deliver up to 3A to each Pi - no link because I can't find them anywhere)
 - [A C4Labs Cloudlet Cluster Case](https://amzn.to/2TkcNTG)
 - [A breadboard (or 4)](https://amzn.to/2Ue69OK)
 - [Some jumper cables](https://amzn.to/3x71pcu)
 - [A breadboard power supply capable of delivering 5V](https://amzn.to/3w7afWf)
 - [A 9 port PoE ethernet switch](https://amzn.to/2UTvsGo)
 - [Cat6A cables that support PoE and also look good](https://amzn.to/3hlJc45)
 - [8x 128GB micro SD cards](https://amzn.to/3x8sFaD)
 - A really cool boss who buys you 5 of the 8 nodes for your birthday
 - A nearly unlimited amount of patience

If that sounds like a lot of supplies or really expensive, that's because it is! It's stupidly expensive. It's also stupidly overpowered, even for what I'm using it for. 5 of the nodes are dedicated to crunching and seeds, and 3 of the nodes *have replaced every other server in my house*. That's a non-trivial amount of servers.

This is *32* physical cores at 1.5GHz (or a little more with a light overclock I have applied, but don't do that) and *64GB* of DDR4 RAM. This cluster collectively makes one ridiculous machine.

# Corners you can cut

You can build a cluster with a minimum of 2 nodes and it's gonna work great.

You can build it without power over ethernet, which adds more cables but saves a ton of money.

You can use Raspberry Pis with less memory on them.

You can buy smaller micro SD cards for them (although I wouldn't go below 64gb, and those are pretty cheap).

The cloudlet case is not strictly necessary. It cuts down on noise (enough that I would not run this cluster without it) and helps cooling performance, but eliminating that also gets rid of the breadboards + power supplies + jumper wires.
