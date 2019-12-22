# NervesBbg

Nerves trial on BeagleBone Green

## Operation Steps

### Getting Started

```
$ mix nerves.new nerves_bbg --target bbb 
$ cd nerves_bbg

$ export MIX_TARGET=bbb
$ mix deps.get
$ mix firmware

# Insert microSD to host
$ mix firmware.burn

# Insert microSD to BBG
# Connet host and BBG with microUSB cable
# Hold down the USER/BOOT button, and power on with Power button
$ picocom /dev/tty.usbmodemBBG2190115095

iex(3)> NervesBbg.hello
:world

# Or
$ ssh nerves.local -i ~/.ssh/id_rsa
Warning: Permanently added 'nerves.local,172.31.123.1' (RSA) to the list of known hosts.
Interactive Elixir (1.9.1) - press Ctrl+C to exit (type h() ENTER for help)
Toolshed imported. Run h(Toolshed) for more info
RingLogger is collecting log messages from Elixir and Linux. To see the
messages, either attach the current IEx session to the logger:

  RingLogger.attach

or print the next messages in the log:

  RingLogger.next

iex(nerves_bbg@nerves.local)1> NervesBbg.hello
:world

```

## Targets

Nerves applications produce images for hardware targets based on the
`MIX_TARGET` environment variable. If `MIX_TARGET` is unset, `mix` builds an
image that runs on the host (e.g., your laptop). This is useful for executing
logic tests, running utilities, and debugging. Other targets are represented by
a short name like `rpi3` that maps to a Nerves system image for that platform.
All of this logic is in the generated `mix.exs` and may be customized. For more
information about targets see:

https://hexdocs.pm/nerves/targets.html#content

## Getting Started

To start your Nerves app:
  * `export MIX_TARGET=my_target` or prefix every command with
    `MIX_TARGET=my_target`. For example, `MIX_TARGET=rpi3`
  * Install dependencies with `mix deps.get`
  * Create firmware with `mix firmware`
  * Burn to an SD card with `mix firmware.burn`

## Learn more

  * Official docs: https://hexdocs.pm/nerves/getting-started.html
  * Official website: https://nerves-project.org/
  * Forum: https://elixirforum.com/c/nerves-forum
  * Discussion Slack elixir-lang #nerves ([Invite](https://elixir-slackin.herokuapp.com/))
  * Source: https://github.com/nerves-project/nerves
