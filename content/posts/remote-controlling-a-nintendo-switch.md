+++
title = "Remote Controlling a Nintendo Switch for Fun and Profit"
date = "2021-06-04T20:08:01-04:00"
author = "Ari"
authorTwitter = "realwillowtw" #do not include @
cover = ""
tags = ["nintendo", "switch", "homebrew", "projects"]
keywords = ["nintendo", "nintendo switch", "switch", "homebrew", "sys-hid", "sys-botbase", "sys-netcheat"]
description = "For a long time I've wanted to proxy controller input from my PC to my Nintendo Switch, and now I can!"
showFullContent = false
draft = false
+++

For a long time I've wanted to proxy controller input from my PC to my Nintendo Switch, and with the introduction of [sys-botbase](https://github.com/olliz0r/sys-botbase) that is now a reality.

"But Ari," I hear you asking, "why would you want to do that? That sounds like it just adds latency."

I'm glad you asked, anonymous reader, because the answer is "because you can do some truly dumb things that way."

# Why?

Let's start with the obvious. If I'm running my controller inputs through my computer, I don't have to worry about what the Nintendo Switch thinks is an acceptable input method. I can map a PS4 or PS5 controller to the Switch. This was already possible for certain types of controllers (namely XBox controllers) through Switch homebrew, but now I can take that to a ridiculous degree.

There's some benefits to doing that - configuring an input display for a speedrunning stream is much easier, for instance. But that's not the only benefit.

A computer can support as many controllers as you can plug into it at once, whereas the Switch supports either 4 or 8 dependent upon what you classify as a "controller." `sys-botbase` only supports emulation of one controller at this time, which brings us to our first really dumb idea:

# 2 players 1 controller

A project I've been passively working on for a while is a "2p1c box" - where you plug two controllers in and get one controller feed out. You would be able to configure which buttons each controller is allowed to press, and suddenly you can do 2p1c runs while maintaining social distancing!

# "Onemind" for any Switch game

You can also apply a very similar concept for "onemind" runs. For those unfamiliar with the term, it originates from a [ROMhack of Super Mario World created by dotsarecool](http://www.dotsarecool.com/twitch/hacks.html) that randomly switches control of Mario between player 1 and player 2, to often hilarious results.

If you haven't already, go watch [authorblues and LackAttack24 speedrun this hack at AGDQ 2020](https://www.youtube.com/watch?v=MRmZSan5cj0). It's an incredibly entertaining run.

Implementing this with `sys-botbase` is pretty trivial. The project is still pretty early on its lifecycle, but I'm excited to see where it goes!

# Some sample code

All of the code for this is available [here](https://github.com/markrawls/switch-relay), as a Python package.

Let's take a look at the meat of it:

{{< code language="python" >}}
# Pygame is the easiest way to read joystick inputs I know of
import pygame

import os
import socket
import sys
from math import trunc
from time import sleep
from multiprocessing import Process, Queue

# We need to map PyGame input codes to what sys-botbase is expecting
from switch_relay.mapping import BUTTONS, TRIGGERS, STICKS, DPAD_X, DPAD_Y

# This doesn't need to render anything, so stub out Pygame's video system
os.environ["SDL_VIDEODRIVER"] = "dummy"

# ...then init Pygame and the joystick submodule
pygame.init()
pygame.joystick.init()

# Create a socket connection but don't connect it yet
switch = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Utility function for formatting and sending data over the socket
def send(data):
    switch.sendall((data + "\r\n").encode())

# A "packet" here being the minimum of one command sent to the switch
# In retrospect this doesn't necessarily need to exist,
# but saves me some format string chicanery later
def make_packet(command, data):
    return f"{command} {data}"


# A receiver process for all of our events - we want to avoid
# as much latency as possible, so send events the moment we have them
def reader_proc(queue):
    while True:
        msg = queue.get()
        send(msg)
        if msg == "DONE":
            break


# Finally, our entrypoint
def cli():
    if len(sys.argv) > 1:
        ip = sys.argv[1]
    else:
        ip = input("Enter the IP address of your Switch > ")

    # Spawn up a queue and a second process to read from it
    pqueue = Queue()
    reader_p = Process(target=reader_proc, args=((pqueue),))
    reader_p.daemon = True
    reader_p.start()

    # Connect to the switch
    switch.connect((ip, 6000))

    # Initialize Pygame's event engine for all available joysticks
    joysticks = [pygame.joystick.Joystick(i) for i in range(pygame.joystick.get_count())]

    for joystick in joysticks:
        joystick.init()

    # We need to calculate the difference between previous d-pad
    # and current d-pad state, as they count as buttons
    # instead of a HAT or AXIS in sys-botbase
    dpad_state = {
        "LEFT": False,
        "RIGHT": False,
        "DOWN": False,
        "UP": False,
    }

    # Same deal for the sticks
    x_names = ["LEFT", "RIGHT"]
    y_names = ["DOWN", "UP"]

    stick_state = {
        "LEFT": {
            0: "",
            1: "",
        },
        "RIGHT": {
            3: "",
            4: "",
        },
    }

    # At time of writing, this is an undocumented feature of sys-botbase
    # but we don't want it to sleep at all between processing inputs
    send("configure mainLoopSleepTime 0")
    send("configure buttonClickSleepTime 0")
    send("configure keySleepTime 0")

    # This is probably unnecessary, but is leftover from getting a
    # comfortable and lag-free Breath of the Wild experience
    send("configure pollRate 32000")

    # Now we just get inputs, translate them, and send them down the pipe!
    while True:
        for event in pygame.event.get():
            if event.type == pygame.JOYAXISMOTION:
                if event.axis in TRIGGERS.keys():
                    if event.value > -0.9:
                        pqueue.put(make_packet("press", TRIGGERS[event.axis]))
                    else:
                        pqueue.put(make_packet("release", TRIGGERS[event.axis]))
                else:
                    stick_name = STICKS[event.axis]
                    multiplier = -32767 if event.axis not in [0, 3] else 32767

                    stick_state[stick_name][event.axis] = hex(trunc(event.value * multiplier))
                    pqueue.put(
                        make_packet(
                            "setStick",
                            "{} {} {}".format(stick_name, *stick_state[stick_name].values()),
                        )
                    )

            if event.type == pygame.JOYBUTTONDOWN:
                pqueue.put(make_packet("press", BUTTONS[event.button]))
            if event.type == pygame.JOYBUTTONUP:
                pqueue.put(make_packet("release", BUTTONS[event.button]))

            if event.type == pygame.JOYHATMOTION:
                x_val, y_val = event.value

                if x_val != 0:
                    pqueue.put(make_packet("press", "D{}".format(DPAD_X[x_val])))
                    dpad_state[DPAD_X[x_val]] = True
                else:
                    for direction in x_names:
                        if dpad_state[direction]:
                            pqueue.put(make_packet("release", f"D{direction}"))
                            dpad_state[direction] = False

                if y_val != 0:
                    pqueue.put(make_packet("press", "D{}".format(DPAD_Y[y_val])))
                    dpad_state[DPAD_Y[y_val]] = True
                else:
                    for direction in y_names:
                        if dpad_state[direction]:
                            pqueue.put(make_packet("release", f"D{direction}"))
                            dpad_state[direction] = False

        # These microscopic sleeps help keep Python from slamming the CPU
        sleep(0.00001)

if __name__ == "__main__":
    cli()
{{< /code >}}

Realistically, the only limit here is your imagination. I'm looking forward to working more with this incredible project in the future. Controlling a Switch remotely is only the tip of the iceberg when it comes to `sys-botbase` - you can actually read and write to arbitrary locations in memory over the same socket interface. It's not as focused or user friendly as it was with `sys-netcheat` (the project that this was based on, effectively presenting a "cheat engine"-esque commandline interface over a socket), but it's still early on in the project's lifespan.

# Stay tuned for more on this!

I'm working with a few popular Twitch streamers to integrate this into their streams, for a "Twitch plays" or "Crowd Control"-esque experience on their real physical hardware. I'll also be publishing the code and specs of the 2p1c/onemind box as well as a build log whenever I wind up making those, which will be whenever it's less janky to build using a Raspberry Pi Pico microcontroller.

I'm also going to be documenting my upcoming Pi 4 Docker Swarm cluster build, complete with instructions.
