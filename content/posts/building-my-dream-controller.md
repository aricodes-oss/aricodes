+++
title = "Building My Dream Controller"
date = "2021-09-06T18:49:16-04:00"
author = "Ari"
authorTwitter = "realwillowtw" #do not include @
cover = ""
tags = ["gaming", "speedrunning", "controller", "arcade stick", "mods", "guides", "tutorials"]
keywords = ["gaming", "speedrunning", "controller", "arcade stick", "fight stick", "b0xx", "frame1", "8bitdo", "mods", "hardware mods", "hardware modification", "cad", "3d printing", "sla", "guides", "tutorials", "how-to"]
description = "Want a B0XX but don't want to pay a premium and wait forever? Me too. Let's make our own."
showFullContent = false
draft = true
+++

# Just get to the instructions!

[Here's where the actual build starts.](#things-youll-need)

# Background

There's been a host of new game controllers coming out recently, designed to give a classic "arcade stick" or "fight stick" experience for modern hardware. Personally, I'm a huge fan of these controllers. I have a fine motor control disorder (more on that later) and precisely timed button presses on small buttons or minute analog stick adjustments are exceptionally difficult for me, if not impossible. Arcade sticks solve this problem well, with an ergonomic button layout that uses large (30mm!) buttons, and very large tactile sticks that act more like a d-pad than a stick.

# Fine motor control disorder?

Yep.

I suffer from [dyspraxia](https://www.nhs.uk/conditions/developmental-coordination-disorder-dyspraxia/), which means that I have the fine motor control of the average 6 year old (despite being in my mid-20s at time of writing). Fortunately I'm able to (relatively) comfortably perform actions that involve full finger movements, such as typing and playing the piano, but unfortunately I lack the ability to accurately manipulate my fingertips by themselves.

Finding ways to translate fingertip movement into whole-finger or whole-hand movement is one of the things I struggle with on a daily basis, but it fortunately has not much impacted my life or career. School was difficult growing up - I can't reliably operate a pencil or pen and computers were not yet the standard - but moving to the professional world has been almost completely painless.

# Okay, but what about for people that don't have that?

Even for people without neurological disorders, these kinds of controllers can be a *godsend* in ergonomics and alleviating RSI. Competitive Super Smash Bros. Melee (or Melee, for short) players have been moving to what I call "button-style" arcade sticks for some time to assist with the extremely high rates of RSI that they suffer from. Chief amongst these would be 20XX's "B0XX" controller, which is built from the ground up for Melee players.

# The B0XX

While I'm personally not a Melee player or fan (Smash Ultimate is my particular poison), even I can appreciate the aesthetics and ergonomics of the B0XX. I mean, *look* at this thing!

![The B0XX, in all its glory](https://cdn.shopify.com/s/files/1/0055/9297/3401/products/FrontOnAngle_post_processed_c200120f-ab41-41bd-8e08-17b194510684_2048xFixed_1200x1200.png?v=1570303664)

It's *gorgeous*! It's also a whopping [$230 and perpetually only available through preorder](https://b0xx.com/collections/all/products/b0xx). This is not without good reason - the B0XX is not mass produced and it's a very high quality product - but that automatically excludes it from my list of possibilities.

Another issue I have with the B0XX is that it doesn't have the flexibility I need from it. I want to be able to use this on my Nintendo Switch, my RetroPie, and my desktop PC. The B0XX natively only supports:

 - Gamecube control
 - A form of `dinput`
 - Simulating a keyboard

While I could write my own custom firmware for it (and did work with the community surrounding the B0XX to discuss the feasibility of it - it would actually be rather easy), this ultimately just informed me that the B0XX was not a good fit for my purposes.

Fortunately, 8bitdo had me covered.

# 8bitdo Enters The Ring

I use an [8bitdo Pro 2](https://amzn.to/3jOGsPp) as my controller of choice when not using an arcade stick - partially because I primarily play 2D games and I *love* that d-pad, and partially because it supports an **enormous** range of protocols:

 - Nintendo Switch
 - X-input (XBox, most modern desktop PC applications)
 - D-input (Playstation, Android, legacy PC applications)
 - MacOS

It also has a great piece of [accompanying software](https://support.8bitdo.com/ultimate/pro2.html) that allows you to rebind its controls in any given mode, set macros, and update the firmware.

This is PERFECT! If only it came in an arcade stick form factor -

![8bitdo arcade stick](https://images.nintendolife.com/2978a371a265a/8bitdo-arcade-stick.original.jpg)

Oh. *Awesome.*

The 8bitdo arcade stick uses the exact same software as the pro 2 for management, and only costs [$90 at time of writing](https://amzn.to/3tmCT5T). The only problem with it, in my opinion, is the stick. I want buttons. Fortunately, the arcade stick is designed to be fully moddable and is easy to crack open and mess with.

Let's get to it!

# Things you'll need

As a forewarning, all of the Amazon links in this article are Amazon affiliate links. Purchasing through them helps support me at no extra cost to you, but I would remiss not to include this disclaimer so you could avoid that if you desired.

**Tools:**

 - [A dremel/rotary tool with a jeweler's attachment for smaller work](https://amzn.to/3haVVr4)
 - [A dremel cutting bit - this is the one I used](https://amzn.to/38LQ4UA)
 - [A torx T10 wrench](https://www.amazon.com/gp/product/B00I5THF9M/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&th=1)
 - [Some standard philips and flathead screwdrivers](https://www.amazon.com/gp/product/B0189YWOIO/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1), here's the kit that I use regularly. It is **WELL** worth the investment.
 - [Four 30mm sanwa arcade buttons](https://amzn.to/3BMrS0L) - these are pretty well standardized, so feel free to substitute with whatever 30mm arcade buttons you like.
 - [Some spade connectors to hook up to the buttons](https://amzn.to/3jPGned)
 - [A soldering iron](https://amzn.to/2VjSxCC) - it doesn't have to be *good*, just hot. I personally use [this one](https://amzn.to/3h7xyuD) nowadays, but the first one I linked is significantly cheaper and is what I performed this mod with.
 - [An 8bitdo arcade stick](https://amzn.to/3tmCT5T)
 - A friend with a 3D printer or access to one
 - An STL file for the button mount

I've got 2 STL files here that can be printed through any given 3D printer, the only difference being the button arrangement. I personally went for the claw grip style in SLA printing, but you have options! The claw grip is significantly more ergonomic and places less strain on the thumb when pressing the down button, but some people do love the WASD-style diamond.

**Claw Grip:**

![Claw grip mod](/arcade-stick/claw-grip.png)

[Link to the STL file](/arcade-stick/claw-mod.stl)

**Diamond Grip:**

![Diamond grip mod](/arcade-stick/diamond-grip.png)

[Link to the STL file](/arcade-stick/diamond-mod.stl)

# Opening up the controller

Use the torx T10 star wrench that you got earlier to remove the 6 screws located on the back of the arcade stick and open the shell. Disconnect the ribbon cable that's running between the USB port on the bottom of the shell so you're only left with the top half. Here's what you'll be looking at:

![Arcade stick internals](/arcade-stick/internals.png)

# Removing the old stick

The joystick will be on the right side. You'll need to remove the ball from the top of the stick before removing it fully. Use a flathead screwdriver to hold the large bolt on the bottom of the stick in place, then twist the ball to the left. It should unscrew from the stick proper.

After that, simply unscrew the 4 screws holding the stick down, unplug its cable (the one on the far right), and pull it through. You now have a blank slate with which to work!

# Cutting a hole

At this point, I kind of just eyeballed it. The mod is designed to secure to the front panel by the four corners, but other than that, just use the dremel to cut a hole in the plastic until the 3D printed part fits in. To do this I had to remove the gold standoffs to which the original stick was attached, which I carefully cut around with the dremel and then wrenched off with pliers.

Once the circular base of the part fits into the stick, **you are done cutting**. Rejoice!

# Desoldering the connector

If you take a look at the stick you just removed, you'll notice some wires coming off of it to a connector that was previously plugged into the control board. If you look at the control board, the first 4 cables are labelled "UDLR" - which stands for up/down/left/right. The latter 4 are unlabelled, and I'm assuming are just a 5V logic signal.

Desolder the cables from the joystick by holding a hot soldering iron against their contact points and gently pulling until the cable comes free. Each directional input has two wires - I made sure to keep mine paired up with their unlabelled counterpart by taping them together, but that may not be necessary. Experiment at your own (minimal) risk.

# Rebuilding our connector

After that, crimp those wires into those lovely red female spade connectors you bought earlier.

For those that have never crimped before: Run the wire into the spade connector and make sure there is metal-on-metal contact, and then crush the plastic part into place so the wire doesn't come out. I just used some pliers for this, but there are many crimping tools available for more money. It really is just that simple, don't let any actually qualified electrical engineers tell you otherwise.

# Connecting the wires

At this point, take the 4 arcade buttons you bought and pop them into the 3D printed part. They should fit right in, and there are wing slots in each button hole so that the stabilizers can extend properly and hold them firmly in place.

Now pay careful attention to which button is meant for which direction. On the claw grip this is obvious, but the diamond grip is symmetrical so watch out!

Taking our janky connector, connect each pair of wires to the two terminals on each button. It does not matter which terminal is connected to which wire as long as it's the paired set you distinguished earlier. The order for these is printed on the control board where the connector goes in, so make sure the right buttons have the right wires!

At this point, you're probably saying "Oh my god, these spade connectors are a tight fit. Are you sure they're the right ones?" - Yes. They are the right ones. Spade connectors can be an *extremely* tight fit, I (once more) used some pliers to push them firmly onto the pins to ensure optimal contact and a firm connection.

# Seating the final product

Now, we just go in reverse order! Plug the connector into the board, reattach the ribbon cable from the back of the case to the front of the case, reattach the torx T10 screws to hold the assembly together, and set the grip mod into the hole you cut for it. The spade connectors are a bit long and tend to push the grip mod up, but you can safely bend the posts they're attached to in either direction (with your bare hands, ***not pliers***) so the wires don't push up on it.

Once you're satisfied that it's working, you can superglue the grip mod to the remaining plastic corners. Congratulations! You now have a *really* cool controller.

# Issues? Questions?

If you have any questions, need a different grip mod for your purposes, or are just lost following this - feel free to reach out and [email me](/contact) at any time!
