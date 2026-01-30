# small-time

`small-time` is a simple datetime library forked from [Morrow](https://github.com/mojoto/morrow.mojo).
This is not a long-term solution, but a temporary fix until proper datetime support is added to Mojo.

![Mojo Version](https://img.shields.io/badge/Mojo%F0%9F%94%A5-26.1-orange)
![Build Status](https://github.com/thatstoasty/small-time/actions/workflows/build.yml/badge.svg)
![Test Status](https://github.com/thatstoasty/small-time/actions/workflows/test.yml/badge.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Adding the `small-time` package to your project

First, you'll need to configure your `pixi.toml` file to include the Modular community Conda channel. Add `"https://repo.prefix.dev/modular-community"` to the list of channels.

### Installing it from the `modular-community` Conda channel

Run the following commands in your terminal:

```bash
pixi add small-time && pixi install
```

This will add `small-time` to your project's dependencies and install it along with its dependencies.

### Building it from source

There's two ways to build `small-time` from source: directly from the Git repository or by cloning the repository locally.

#### Building from source: Git

Run the following commands in your terminal:

```bash
pixi add -g "https://github.com/thatstoasty/small-time.git" && pixi install
```

#### Building from source: Local

```bash
# Clone the repository to your local machine
git clone https://github.com/thatstoasty/small-time.git

# Add the package to your project from the local path
pixi add -s ./path/to/small-time && pixi install
```
