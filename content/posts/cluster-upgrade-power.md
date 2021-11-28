+++
title = "Pi Cluster Upgrades: A real power supply!"
date = "2021-11-28T00:40:48-05:00"
author = "Ari"
authorTwitter = "realwillowtw" #do not include @
cover = "/pi-cluster/psu.jpg"
tags = ["raspberry pi", "docker", "cluster", "tutorials", "cluster upgrade series"]
keywords = ["raspberry pi", "raspberry pi 4", "raspbian", "docker", "cluster", "cluster computing", "randomizer", "docker swarm", "swarm mode", "kubernetes", "hardware mods", "from scratch", "maker", "indie maker", "maker projects", "jeff geerling", "geerlingguy", "meanwell", "mean well", "power distribution"]
description = "Getting a sufficient amount of power is harder than it sounds"
showFullContent = false
draft = true
+++

# The series insofar:

 1. [Reasoning and project introduction](/posts/pi-cluster-upgrades)
 2. [Designing and building the power supply](/posts/cluster-upgrade-power) (you are here)

# Introduction

On our previous episode of "overengineering a Pi cluster" I mentioned that I made a series of upgrades to my existing cluster that are going to be built into a rack unit soon. I also mentioned that power over ethernet (or PoE) is not a good fit for my usecase, for a variety of reasons I won't repeat here.

Before we get into what exactly I did, let's talk a little bit about electricity.

# Disclaimer

Note that I will be simplifying some for the sake of brevity, and that I am not an electrical engineer. I do consult a qualified electrical engineer before attempting to build things from my stance of limited understanding, and I ***strongly*** recommend that you do the same.

# Electrical terms you should know for this

For simple DC power applications like this, we're mostly concerned with _volts_, _amps_, and _watts_. These are all relatively simple concepts to understand, so let's go through them briefly.

> **Volts** are a measurement of potential energy. It can be thought of as the pressure pushing the electrons through a circuit - 5 volts (or 5V in shorthand) is commonly used for handling digital logic signals as well as power.

> **Amps** (or amperes) are used to measure the strength of an electrical current. The device being powered by a circuit will pull as many amps as it needs, and power sources are typically rated for supplying up to a specific number of amps.

> **Watts** are a unit of measurement to say *how much* power is being drawn. Watts can be calculated with an extremely simple formula - it's `volts * amps`. 5 volts at 3 amps is 15 watts - or in shorthand, 5V 3A = 15W.

If you take one thing away from this posts, make it the formula for calculating wattage.

# Okay, so what do we need?

The Raspberry Pi foundation makes some excellent documentation, and inside of that they have a [section for power supply requirements](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#power-supply).

Knowing what we learned from the previous section, we can decipher this some. For DC current in this application (AC is spooky magic and we do not talk about it), we pretty much only care about volts and amps for our power supply.

The relevant parts of the documentation are:

> The power supply requirements differ by Raspberry Pi model. **All models require a 5.1V supply**, but the current required generally increases according to model.

| Pi Model | Recommended Capacity | Total USB Peripheral Draw | Bare-board active current consumption |
| -------- | -------------------- | ------------------------- | ------------------------------------- |
|Raspberry Pi 4 Model B | **3.0A** | 1.2A | 600mA |

(emphasis mine)

---

So, armed with this information, we know two things:

1. Each of our Pi 4s needs a **5.1V** power supply
2. They can each draw up to **15.3** watts with its USB ports populated

You can supply just regular 5 volts, undervolting a device is typically not dangerous and at worst just results in the device not booting or functioning properly, but we'll be tuning our PSU to supply 5.1V here so each Pi is happy and healthy.

For the sake of making the math just a little bit easier, we'll be rounding down to just 5V here.

Using that expensive college education I dropped out of, I have successfully deduced that this means we will need **120 watts of available capacity** for 8 Pis. That's actually not that bad in terms of computer power supplies - you likely have 600W or above power supply in your computer right now - but it does mean we need to do some shopping for a power supply that will take mains power (AC 120 volts at either 10 or 15 amps) and magic that into DC power 5V 24A.

You will want some headroom so that sudden surges (such as when all nodes boot at once) aren't an issue, so let's aim for a 200W power supply (or 5V 40A).

# Required materials

As is usual, all amazon links are affiliate links.

| Item | Price in USD |
| ---- | ----- |
| [15A AC pigtail cable](https://amzn.to/3xwBQTd) | $15 |
| [DC barrel plug (2.1mm x 5.5mm) pigtails](https://amzn.to/310Ec0p) | $9 |
| [8 DC barrel plug (2.1mm x 5.5mm) to USB-C elbow connectors](https://amzn.to/2Zw6YWr) | $6 for 2 |
| [14ga wire](https://amzn.to/3G9Xccj) | $23 |
| [Meanwell LRS-200-5](https://amzn.to/3CUX9Pf) | $37 |
| [Power distribution terminal block](https://amzn.to/3nWtilp) | $23 |

**Total**: $130 with the wire spools, $108 without. You may already have 14ga or 18ga wire laying about from other projects.

# Optional materials/niceties

We'll be making/extending some wires here, so you'll need either heatshrink (recommended) or electrical tape (jank approved) to cover the joins and prevent them from shorting.

I also used some eyelet connectors because I don't fuck around when it comes to handling mains power and I wanted that to have good contact with the PSU and no exposed wire for me to accidentally touch. I already had this kit from [building my fight stick](/posts/building-my-dream-controller/), but it's included here.

| Item | Price in USD |
| ---- | ------------ |
| [Heat gun](https://amzn.to/3CXWA7y) | $30 |
| [Heat shrink tubing](https://amzn.to/3cV9FUn) | $10 |
| [Eyelet/spade/fork connectors](https://amzn.to/3ldd2dO) | $18 |

**Total**: $58, although if you work on electronics regularly you likely have all of this already laying around and they will last for quite a few projects.
