+++
title = "Making a Modern Python Package with Poetry"
date = "2021-05-24T19:40:42-04:00"
author = "Ari"
authorTwitter = "realwillowtw" #do not include @
cover = ""
tags = ["python", "packaging", "getting started", "beginner", "beginner questions", "tutorials"]
keywords = ["python", "packaging", "getting started", "beginner", "beginner questions", "tutorials", "python for beginners", "how to make a python package", "pip package", "pip", "pip packaging"]
description = "Make a full commandline application, without any of the setup.py hassle!"
showFullContent = false
+++

# Purpose

One of the main problems the Python community faces is complex packaging. Despite being one of the easier languages to get started and go to production with, Python packaging is rather convoluted. There's not a lot of quality tutorials out there that cover building your own package using `setup.py`, and the ones that do exist leave out some critical information like the concept of sub-modules and how to import them.

Fortunately, there is an easier solution to all of this! It's called [Poetry](https://python-poetry.org/) and it makes building Python packages incredibly easy.

# Introducing Poetry

If you're a web developer or somebody that works with modern Javascript a lot, you're probably familiar with `npm`. `npm` is the **N**ode **P**ackage **M**anager - it lets you manage your project and the dependencies for it. It does this by installing the packages you specify into the `node_modules` directory in your project, so that each project gets its own clean copy of the dependencies it uses.

In Python, the package manager is called `pip`. `pip`...installs packages. That's about it. Coming from JS dev, it isn't immediately obvious how to create a new Python project and add dependencies to it. Conventional wisdom is to create a `setup.py` file and new "virtual environment" using the `virtualenv` tool. That creates an isolated environment for your Python project and stores the dependencies there without having to mess with your system Python environment.

With [Poetry](https://python-poetry.org/), things look a lot more like using `npm` (or `cargo`, for Rust developers) - it's one tool that manages your project, your virtual environment, and your dependencies. In this post, I aim to teach you how to use Poetry effectively.

## Installation

Installing Poetry is as simple as running

{{< code language="bash" >}}
$ pip install --user poetry
{{< /code >}}

in your terminal. After that, you should have the `poetry` command available to you. If you don't, you may need to add `$HOME/.local/bin` to your `PATH`.

{{< code language="bash" title="~/.bashrc" >}}
export PATH="$PATH:$HOME/.local/bin"
{{< /code >}}

## Starting a new project

Ready for this one?

{{< code language="bash" >}}
$ poetry new project-name
{{< /code >}}

Revolutionary. For the purposes of this article, we'll call our project `first-steps`, which changes our command above to

{{< code language="bash" >}}
$ poetry new first-steps
Created package first_steps in first-steps
{{< /code >}}

Great! Let's take a look at what's in this directory.

{{< code language="bash" >}}
$ cd first-steps && ls
first_steps  pyproject.toml  README.rst  tests
{{< /code >}}

`first_steps` is the directory where all of our code is going to be stored, and the name of our package. If somebody installs this package, they refer to it in their code by that name. This typically looks like `from first_steps import something`.

`pyproject.toml` is the package configuration file. The vast majority of the time, you're not going to be editing this manually.

## Building our package

For simplicity's sake, we're going to be making a package that does exactly one thing and does it well: it increments a number. We'll be providing both a CLI utility and a programmatic interface so that developers of all creeds can use our revolutionary module.

We'll start with the programmatic interface! Create `first_steps/increment.py` and fill it out as follows

{{< code language="python" title="first_steps/increment.py" >}}
def increment(num: int):
  return num + 1
{{< /code >}}

If you have no idea how to read that code, I would strongly recommend checking out my post on [learning to code](/posts/i-want-to-learn-to-code/) before this one.

Right now, users of your package would have to import this by typing `from first_steps.increment import increment`. That's a bit too wordy for my tastes, so let's go change that.

{{< code language="python" title="first_steps/\_\_init\_\_.py" >}}
from .increment import increment
{{< /code >}}

You can test this

Now it's just `from first_steps import increment`. Easy! Now all we need is a commandline interface. Let's over-engineer the shit out of it so we can tour more of Poetry's features.

## Over-Engineering a CLI

[click](https://pypi.org/project/click/) is an _excellent_ package for building fully featured and complex commandline interfaces with minimal overhead and an easy learning curve. For this package, we do not need it at all. We're going to use it anyways though, because we need to learn two things about working with Poetry:

 1. Managing dependencies
 2. Exporting a command from your package

Let's start by initializing our project's virtual environment and adding a dependency on `click`. Virtual environments are handled automatically and transparently with `poetry`, so there's no need to worry about juggling them yourself.

{{< code language="bash" >}}
$ poetry add click
{{< /code >}}
