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

If you're a web developer or somebody that works with modern Javascript a lot, you're probably familiar with `npm`. `npm` is the *N*ode *P*ackage *M*anager - it lets you manage your project and the dependencies for it. It does this by installing the packages you specify into the `node_modules` directory in your project, so that each project gets its own clean copy of the dependencies it uses.

In Python, the package manager is called `pip`. `pip`...installs packages. That's about it. Coming from JS dev, it isn't immediately obvious how to create a new Python project and add dependencies to it. Conventional wisdom is to create a `setup.py` file and new "virtual environment" using the `virtualenv` tool. That creates an isolated environment for your Python project and stores the dependencies there without having to mess with your system Python environment.

With [Poetry](https://python-poetry.org/), things look a lot more like using `npm` (or `cargo`, for Rust developers) - it's one tool that manages your project, your virtual environment, and your dependencies. In this post, I aim to teach you how to use Poetry effectively.

## Installation

Installing Poetry is as simple as running

```bash
$ pip install --user poetry
```

in your terminal. After that, you should have the `poetry` command available to you. If you don't, you may need to add `$HOME/.local/bin` to your `PATH`.

## Starting a new project

Ready for this one?

```bash
$ poetry new project-name
```

Revolutionary. For the purposes of this article, we'll call our project `first-steps`, which changes our command above to

```bash
$ poetry new first-steps
```
