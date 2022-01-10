+++
title = "Fixing \"DAP Init Failed\" from your Picoprobe"
date = "2022-01-10T01:21:00-05:00"
author = "Ari"
authorTwitter = "realwillowtw" #do not include @
cover = "/picoprobe/cover.jpg"
tags = ["rp2040", "raspberry pi", "pico", "debugging", "short"]
keywords = ["rp2040", "raspberry pi", "pico", "raspberry pico", "picoprobe", "probe", "serial", "openocd", "on chip debugger", "serial debugging", "dap init failed", "debugging", "short", "help", "maker", "microcontroller", "micro controller"]
description = "I kept getting \"DAP Init Failed\" but all of my connections were correct. Let's find out why, and fix it."
showFullContent = false
+++

# Just get to the instructions!

[You got it.](#things-youll-need)

# Background

I needed some functionality that CircuitPython just didn't offer on my Pico, so I followed the excellent [Getting started with C/C++](https://datasheets.raspberrypi.com/pico/getting-started-with-pico.pdf) paper put out by the Raspberry Pi company. This worked great up until the part where I didn't want to unplug and replug my Pico constantly to update the firmware.

This was probably one of the most difficult things to debug I have ever experienced. Typically I find that I'm doing something obviously wrong and dumb when I can't find any results when searching, but that was not the case here.

Following the instructions in appendix A, I set up a pretty typical picoprobe setup:

![My non-working PicoProbe setup](/picoprobe/initial-setup.jpg)

...and ran it as the documentation suggested with a test example:

{{< code language="bash" >}}
$ openocd -f interface/picoprobe.cfg -f target/rp2040.cfg -c "program test.elf verify reset exit"
Open On-Chip Debugger 0.11.0-gdf76ec7 (2022-01-07-19:52)
Licensed under GNU GPL v2
For bug reports, read
    http://openocd.org/doc/doxygen/bugs.html
Info : only one transport option; autoselect 'swd'
adapter speed: 5000 kHz

Info : Hardware thread awareness created
Info : Hardware thread awareness created
Info : RP2040 Flash Bank Command
Info : clock speed 5000 kHz
Info : DAP init failed
in procedure 'program'
** OpenOCD init failed **
shutdown command invoked
{{< /code >}}

Wait, what? Why did that fail? With no further error message? The troubleshooting advice I could find on the internet fell under two categories:

 1. The wires are connected to the wrong pins
 2. The picos do not share a common ground

After quintuple checking my connections and contacting a friend of mine that is a qualified electrical engineer, everything was right. I even tried flashing 5 or 6 different Picos (I keep a drawer of them around, in case of sudden inspiration) and the result was the same with absolutely all of them.

I used a multimeter to verify continuity, resistance, and isolation of every single connection. All of them were right.

So what gives?

# The Problem

The problem, put shortly, is that the connection just wasn't good enough between the picos. I'm not sure where the failure was - it could be in the carrier boards, it could've been in the dupont wires, it could've just been a weird fluke.

Either way, there was some issue that I was not able to measure and the result was a connection that was not stable enough for a 5mHz connection.

# The Solution

Put shortly - make your own damn carrier out of protoboard and hand-crimped dupont wires using a minimum of 22ga wire. Somebody in the (unofficial) Pico community discord suggested doing so, and this solved my problem right quick.

If you know what that means, congratulations! Read no further. Your problem has been solved.

If not, let's go onto the build.

# Things you'll need

As a forewarning, all of the Amazon links in this article are Amazon affiliate links. Purchasing through them helps support me at no extra cost to you, but I would be remiss not to include this disclaimer so you could avoid that if you desired.

**Tools/Supplies:**

 - [A soldering iron](https://amzn.to/3h7xyuD)
 - [Solder](https://amzn.to/31JYbRO)
 - [22ga wire in a variety of colors](https://amzn.to/3JY1qWU)
 - [Dupont wire crimping kit](https://amzn.to/3fcraAA)
 - [Wire cutters and strippers](https://amzn.to/3ndtzPY)
 - [Protoboard + male/female pin headers](https://amzn.to/3q9M2yK)
 - [A multimeter](https://amzn.to/3qblcq6)

# Making the carrier

This is altogether pretty straightforward, but to break it down step-by-step:

 1. Take two Picos and [solder male headers onto them, pointing downwards](https://magpi.raspberrypi.com/articles/how-to-solder-gpio-pin-headers-to-raspberry-pi-pico#:~:text=The%20easiest%20way%20to%20use%20Pico%2C%20though%2C%20is,Pico%2C%20and%20two%2020-pin%202.54%E2%80%89mm%20male%20header%20strips.). There are 20 pins on either side. Do not solder headers to the three debugging pins on the bottom, we will be doing something else with those later.
 2. Insert the male headers into a set of female headers to ensure the spacing is correct, and then place both Picos spaced at least 3 holes apart on the protoboard.
 3. Solder the female headers onto the protoboard, ensuring good contact between the pins and the pads.

# Validating connections

This part will be a bit tedious, but well worth the effort. While the Picos are still sitting inside of the female headers, take your multimeter and turn it to continuity mode. On the multimeter I recommended, it's 4 clicks to the right from the initial off position. To make the multimeter beep when a connection is detected (recommended!) hold down the `FUNC` button for ~1 second. Test this by touching the probes together, it should beep.

Now take one probe and touch the tip to the solder joint on the Pico. Take the other and touch it to where the female header is soldered on the bottom of the board. The multimeter should emit a loud, clear tone. Do this for all 40 pins on each board.

This is time consuming, but I find it to be absolutely necessary. If the connection is not strong and consistent all the way down, this will not work.

# Ensuring there are no shorts

Take your multimeter in continuity mode and check every pin against its neighbors. There should be no connections. If there are any, you need to reflow and separate the solder until there is no longer a connection between the neighboring pins. I find that I get best results with this running my soldering iron at around 350 degrees - any hotter and it tends to melt neighboring pins and join them together, which is less than ideal.

# Connecting the debugging pins

Take a set of female headers and cut 3 of them off the strip. Place them facing upwards on the Pico on the right side (the one you will be flashing), ensuring that they are pointing towards your face if you are looking top down at the chip. Solder those in place, ensure there are no shorts, and then carry on!

# Make a custom connector for them

This is the hard part, but fortunately, you should have more than enough materials to make as many mistakes as you like. The debugging pins on the Pico are misaligned with the grid of the protoboard underneath, so we're going to make our own connector.

Start by taking another 3 female headers and soldering them on the protoboard a little bit below your second Pico (the one you will be flashing). It's okay to have plenty of space between the Pico and these headers, as we'll be making wires shortly.

Using that dupont wire crimping kit, make 3 male-to-male wires to connect between these headers and the ones we just soldered onto the Pico. Extra length is okay, just make sure you can easily plug and unplug them from the board.

Normally I would provide instructions on crimping, but frankly, I just kind of squeeze the connectors around the wires with pliers and hope that it fits. Your mileage may vary.

Now that that part is done, we're in the clear! Let's take it home.

# Form the necessary connections

There's a great connection diagram in the ["getting started"](https://datasheets.raspberrypi.com/pico/getting-started-with-pico.pdf) PDF linked earlier. For the sake of simplicity, I've uploaded it here:

![Wiring diagram](/picoprobe/wiring-diagram.png)

Since we're using protoboard and not breadboard, you'll have to run wires to adjacent holes on the protoboard and short them with a solder connection. Using a lower temperature on your soldering iron (somewhere around 320 degrees is what I normally do) makes this _significantly_ easier - trying this at 485 degrees caused surrounding connections to reflow and short, and I would not recommend trying it.

Make sure that the ground connections are strongly connected - this is one of the most important aspects. In my setup, those are the black wires. You should have something looking a little bit like this on the top:

![Topside connections](/picoprobe/connections-top.jpg)

...aaaaaand a little bit like this on the bottom:

![Bottom connections](/picoprobe/connections-bottom.jpg)

Your solder is going to look a little bumpy, and that's okay. As long as there are no unintentional shorts and the connections are strong, you'll be just fine.

# Done!

Now, the real test! Flash the [picoprobe firmware](https://www.raspberrypi.com/documentation/microcontrollers/raspberry-pi-pico.html#debugging-using-another-raspberry-pi-pico) from the Raspberry Pi website to the Pico on the left. After that, you should be able to successfully flash the Pico on the right using the same command we tried at first:

{{< code language="bash" >}}
$ openocd -f interface/picoprobe.cfg -f target/rp2040.cfg -c "program test.elf reset verify exit"
Open On-Chip Debugger 0.11.0-gdf76ec7 (2022-01-07-19:52)
Licensed under GNU GPL v2
For bug reports, read
	http://openocd.org/doc/doxygen/bugs.html
Info : only one transport option; autoselect 'swd'
adapter speed: 5000 kHz

Info : Hardware thread awareness created
Info : Hardware thread awareness created
Info : RP2040 Flash Bank Command
Info : clock speed 5000 kHz
Info : SWD DPIDR 0x0bc12477
Info : SWD DLPIDR 0x00000001
Info : SWD DPIDR 0x0bc12477
Info : SWD DLPIDR 0x10000001
Info : rp2040.core0: hardware has 4 breakpoints, 2 watchpoints
Info : rp2040.core1: hardware has 4 breakpoints, 2 watchpoints
Info : starting gdb server for rp2040.core0 on 3333
Info : Listening on port 3333 for gdb connections
target halted due to debug-request, current mode: Thread
xPSR: 0xf1000000 pc: 0x000000ee msp: 0x20041f00
target halted due to debug-request, current mode: Thread
xPSR: 0xf1000000 pc: 0x000000ee msp: 0x20041f00
** Programming Started **
Info : RP2040 B0 Flash Probe: 2097152 bytes @10000000, in 512 sectors

target halted due to debug-request, current mode: Thread
xPSR: 0x01000000 pc: 0x00000178 msp: 0x20041f00
target halted due to debug-request, current mode: Thread
xPSR: 0x01000000 pc: 0x00000178 msp: 0x20041f00
target halted due to debug-request, current mode: Thread
xPSR: 0x01000000 pc: 0x00000178 msp: 0x20041f00
target halted due to debug-request, current mode: Thread
xPSR: 0x01000000 pc: 0x00000178 msp: 0x20041f00
target halted due to debug-request, current mode: Thread
xPSR: 0x01000000 pc: 0x00000178 msp: 0x20041f00
Info : Writing 24576 bytes starting at 0x0
target halted due to debug-request, current mode: Thread
xPSR: 0x01000000 pc: 0x00000178 msp: 0x20041f00
target halted due to debug-request, current mode: Thread
xPSR: 0x01000000 pc: 0x00000178 msp: 0x20041f00
target halted due to debug-request, current mode: Thread
xPSR: 0x01000000 pc: 0x00000178 msp: 0x20041f00
target halted due to debug-request, current mode: Thread
xPSR: 0x01000000 pc: 0x00000178 msp: 0x20041f00
target halted due to debug-request, current mode: Thread
xPSR: 0x01000000 pc: 0x00000178 msp: 0x20041f00
target halted due to debug-request, current mode: Thread
xPSR: 0x01000000 pc: 0x00000178 msp: 0x20041f00
target halted due to debug-request, current mode: Thread
xPSR: 0x01000000 pc: 0x00000178 msp: 0x20041f00
** Programming Finished **
** Verify Started **
target halted due to debug-request, current mode: Thread
xPSR: 0x01000000 pc: 0x00000178 msp: 0x20041f00
target halted due to debug-request, current mode: Thread
xPSR: 0x01000000 pc: 0x00000178 msp: 0x20041f00
** Verified OK **
** Resetting Target **
shutdown command invoked
{{< /code >}}

...and we have a success! After building my own carrier for flashing, I haven't had a single issue getting my PicoProbe to work.

# Bonus - using Go instead of C/C++

I personally dislike using C/C++ for development, and much prefer Go. I've got [an example repository](https://github.com/aricodes-oss/raspberry-pico-go) up on Github showing how to set that up, including a simple `Makefile` that will flash this firmware through your PicoProbe.

# Issues? Questions?

If you have any questions, are still getting errors, or are just lost following this - feel free to reach out and [email me](/contact) at any time!
