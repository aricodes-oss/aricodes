+++
title = '"How do I Learn to Code?"'
date = "2021-04-24T02:16:19-04:00"
author = "Aria"
authorTwitter = "realwillowtw" #do not include @
tags = ["getting started", "beginner questions", "beginner"]
description = "I get asked a lot about how to learn to code. The answer isn't as easy and clear cut as I would really like it be."
showFullContent = false
+++

I get asked a lot about how to learn to code. The answer isn't as easy and clear cut as I would like it to be.

There's a lot of different disciplines of software engineering - almost too many to count, and certainly too many to name. Within each of those there are plenty of specific disciplines and distinctions, which can leave a beginner feeling _very_ overwhelmed.

I find it easiest, in that situation, to answer this question by asking "What do you want to make?"

# Before we begin...

Let's take a look at some possible responses to that. As always, my opinion is reflective of my own experience - some might disagree with my recommendations, and that's fine! The only wrong way to learn is the way you don't enjoy.

And that's probably the most important aspect - learn in a way that helps you do the things you want to do. If you have a basic understanding of Python, or Ruby, or Javascript, or whatever language you like, then you know enough to start learning more for a project. If halfway through a book on Python you're bored and want to get to the good stuff, go learn by doing! If you want to make a Discord bot, you can google "python discord" and get days on end of easy to grasp tutorials and resources.

Above all, make sure you're enjoying it. If it feels like pointless work, it probably is.

# I want to make websites!

In that situation, I recommend looking into frontend development first and then branching into backend development. Those terms are probably completely meaningless to you right now, and that’s okay! You’ll learn as you go along. That’ll be a recurring theme here, don’t worry about it.

One of the things that sets web development aside from other disciplines is the sheer number of areas it covers. In a very simplified view - there's making things look and feel nice for the user to interact with on the frontend, there's handling the user's data and building the more complex interactions they have with it on the backend, there's number crunching in data science, and there's systems administration/devops work with handling servers and deployments.

If it sounds like a lot, that's because it _is_ a lot. But don't despair! Most web developers don't do _all_ of those things. Typically they specialize. Unfortunately, you won't know what you like the most until you try a little bit of everything.

While it wasn't how I personally learned (because they didn't exist at the time), I would recommend going through something called a bootcamp, which is an online course done at your own pace that teaches you everything you need to know and provides a supportive community willing to give help and feedback.

There are many many opinions on this, but I would advise going through [Free Code Camp](https://www.freecodecamp.org/). I've audited their course a year or so back and it taught all the right fundamentals I think a good web developer needs. You may not necessarily be immediately ready for a job as a junior engineer afterwards, but you will know enough to get yourself there.

## Topics I recommend reading up on

### React

React is a frontend web framework that makes handling complex state and user interaction easy. Despite what the average Hacker News commenter will tell you, you're not a bad person for using technologies newer than 1998 to build modern applications.

In my work, I use React extensively. It helps me meet the needs of the business without having to painstakingly write thousands of lines of JQuery boilerplate, or handling convoluted server side logic to interact with state.

### Javascript (in general)

The better your Javascript chops are, the better your React chops are. Javascript is also very commonly used on the backend nowadays, making it a full stack language. Many of your tools for web development will _also_ be written in Javascript, and it runs natively in the browser.

### Python (or Ruby (or both!))

Of course, not everything can be/should be/is done in Javascript. It has a lot of general "jank" as a language. To be a well rounded web developer, you should also learn about Python and/or Ruby and their most popular web frameworks - which are Django and Ruby on Rails, respectively.

### Go and Rust

Sometimes, your backend code needs to run _really_ fast and be extremely efficient. For the overwhelming majority of use cases, that is not the case - Django and Python will comfortably serve an enormous amount of concurrent users at high speeds. Sometimes though, you work for Google or Dropbox or Discord, and you need every last millisecond of performance you can eek out. In those situations, you're going to be writing code in a lower level language like Go or Rust.

Getting at least passingly familiar with those two languages will help you understand systems programming and some advanced concepts that come in handy now and then. Your code will also run super fast, which is always a good feeling.

# I wanna work with servers and networking and the cloud and all this cool new tech!

Hey, me too!! I find that stuff really cool, and systems administration is a focus of mine.

The first thing you need to know is that _the world runs on Linux._ You’re probably used to Windows or Mac on your home PC, but nearly every website or program you access on the internet is running their systems on Linux. And for good reason! To get into systems administration (or systems engineering or network engineering or cloud engineering...you get the gist) you need to be really familiar with Linux (or UNIX or POSIX or \*NIX) fundamentals.

Unfortunately there’s no book or bootcamp I can recommend that will teach you everything you need to know, but it is _very_ easy to learn hands on!

The source that I learned enough to be dangerous with is [linuxcommand.org](https://linuxcommand.org/). It may be a little older, but the majority of what it teaches you hasn't changed much (if at all) since the 80s and 90s. Going through that should get you comfortable around a command line and help you understand concepts such as "parameters" and "arguments" and "scripting."

I highly recommend going through that. After that - get a Linux computer and make it do stuff! Set up a virtual machine in AWS EC2 or just running in VirtualBox on your home computer. Get familiar with it. After understanding the fundamentals (what a package manager is and what it does, how the file system is laid out, what directories and file permissions are), start writing programs to do things on there!

To write those programs, you’ll need to know a programming (or scripting) language. One of the most beginner friendly languages out there is Python, and many people (including myself!) write Python every day for their career. The book I would recommend the most for that is [“Learn Python 3 the Hard Way” by Zed Shaw](https://shop.learncodethehardway.org/access/buy/9/). It is an exceptionally verbose and digestible book that teaches you all about Python fundamentals.

There is also ["Automate the Boring Stuff with Python" by Al Sweigart](https://automatetheboringstuff.com/), which is available to read online for free or as a download for a small fee. This is a lot more practical approach to learning Python, focused on building things as opposed to just learning the language. There are benefits to each approach, and I recommend evaluating each of them to find the way that works best for you.

# I have absolutely no idea what I want to do, I just wanna code!

Totally fair! That’s exactly how I started out, and I found out what I loved to do later as I kept exploring the field. In that situation, I still recommending picking up a good started programming language. Python is always a fantastic choice - see the previous section for a link to the book I recommend for that - but I personally started with Ruby. Both are very accessible!

To learn Ruby - there’s a _very_ fun read called “Why’s Poignant Guide to Ruby.” It’s written with an incredible sense of humor and tones of fantastically whimsy that I haven’t found an equivalent for in any other language. This is fairly representative of Ruby developers - they tend to treat their code more as an artform than as a science (spoiler alert - it’s both). That book is [available 100% free online](https://poignant.guide) and is updated to this day for modern versions of Ruby.

Outside of that, if you’re leaning more towards the web end of things, JavaScript is where it’s at. It’s kind of taken over the world as of late. I don’t have a good book on learning JavaScript for you, but I believe the “Learn Code the Hard Way” series will have you covered, and there are **_many_** tutorials online if you just search “how to learn JavaScript.” I have faith that you can find some. If you want to know if I think a source is credible or of quality, you are more than welcome to [contact me](/contact).

# I want to make video games!

Don’t.

All jokes aside - I’m not a particularly good resource for learning game development, but I know plenty of people that do it. I do consulting on game development projects to help game devs architect their code and implement features such as randomizers or external interactions, but I do not often begin and create a game by myself.

Independent game development is nearly totally defined by the tools that you use to do it. A programming language is a tool, but it's the base unit upon which other things are built off of. In game development, you primarily interact with something called a "game engine." A game engine is usually presented as a very sophisticated editor that handles a lot of the groundwork for you to build games. You don't have to worry about writing code to display sprites on a screen and update that 60 times per second, you just have to write the code to define how those sprites interact.

I would recommend gaining some relative fluency in a programming language before attempting to jump into game development. C# (pronounced "see sharp") is one of the more commonly used languages in game development, due to the popularity of the Unity game engine.

I personally prefer the Godot game engine, which allows you to write code in many different languages: C#, C++, and GDScript (a language heavily inspired by Python) out of the box, and provides the facilities necessary to create bindings for other languages. I would recommend sticking to GDScript however, as it is much more easy to work with for beginners than the other languages available and can do everything they can.

Basically: learn to code first (see previous sections on just generally learning to program) and then download a game engine (Unity, Unreal, and Godot are popular free ones) and go through the tutorials attached with it.

As for my warnings - game development is a _horrifically_ predatory industry that underpays and overworks everyone involved. They keep doing this because there is a limitless line of people with unbounded passion willing to work in terrible conditions just to have the opportunity to work on making games. There's some excellent books by Jason Schreir that go into more detail on this, but generally: be wary of game development.

# Wrapping up...

If you've made it this far, congratulations! You've read a truly impressive wall of text. It can be a lot of information to process, but it all boils down to this:

- Just jump in and make something. You'll learn while you do it.
- When you meet other programmers, learn from each other.
- Enjoy what you're doing. Programming is an art form like any other - if you're not having fun doing it, you're probably in the wrong field.
