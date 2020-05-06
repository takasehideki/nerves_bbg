# NervesBbg

Nerves trial on BeagleBone Green

## Operation Steps

### Getting Stated

- Quick start

```
$ mix nerves.new nerves_bbg --target bbb 
$ cd nerves_bbg

$ export MIX_TARGET=bbb
$ mix deps.get
$ mix firmware

# Insert microSD to hostPC
$ mix burn

# Insert microSD to BBG,
# and Connet host and BBG with microUSB cable
# Hold down the USER/BOOT button, and power on with Power button
$ ssh nerves.local 
Warning: Permanently added 'nerves.local,172.31.123.1' (RSA) to the list of known hosts.
Interactive Elixir (1.10.2) - press Ctrl+C to exit (type h() ENTER for help)
Toolshed imported. Run h(Toolshed) for more info.
RingLogger is collecting log messages from Elixir and Linux. To see the
messages, either attach the current IEx session to the logger:

  RingLogger.attach

or print the next messages in the log:

  RingLogger.next

iex(1)> NervesBbg.hello 
:world
iex(2)> uname
Nerves nerves-1509 nerves_bbg 0.1.0 (a6418d17-a4e0-52e9-3825-b380a2c297df) arm
iex(3)> exit 
Connection to nerves.local closed.

```

### Connect by ssh on VirtualEther

- Generate RSA key
```
$ ssh-keygen -t rsa -f ~/.ssh/id_rsa
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /Users/takase/.ssh/nerves_bbg_id_rsa.
Your public key has been saved in /Users/takase/.ssh/nerves_bbg_id_rsa.pub.
The key fingerprint is:
SHA256:TcVUlgUEaTzGCpe0oGZyh+LuWaSI6HFySv249rK8owk takase@TAKASE-MacBookPro-8.local
The key's randomart image is:
+---[RSA 2048]----+
|        ...*+==+.|
|       o..ooO..  |
|    o * .oo+ .   |
|   . * . o.      |
|    . . S .      |
|...o o           |
|E+.+o .          |
|+ O=oo           |
| =o*Xo           |
+----[SHA256]-----+
```

- Provision ssh configuration
```
$ cat ssh_config.txt >> ~/.ssh/config
```

- Connect via ssh
```
$ ssh nerves.local 
Warning: Permanently added 'nerves.local,172.31.123.1' (RSA) to the list of known hosts.
Interactive Elixir (1.10.2) - press Ctrl+C to exit (type h() ENTER for help)
Toolshed imported. Run h(Toolshed) for more info.
RingLogger is collecting log messages from Elixir and Linux. To see the
messages, either attach the current IEx session to the logger:

  RingLogger.attach

or print the next messages in the log:

  RingLogger.next

iex(1)> NervesBbg.hello 
:world
iex(2)> uname
Nerves nerves-1509 nerves_bbg 0.1.0 (a6418d17-a4e0-52e9-3825-b380a2c297df) arm
iex(3)> exit 
Connection to nerves.local closed.
```

### Upload by ssh on VirtualEther

```
$ mix firmware.gen.script

Nerves environment
  MIX_TARGET:   bbb
  MIX_ENV:      dev

Writing upload.sh...


$ ./upload.sh
Path: ./_build/bbb_dev/nerves/images/nerves_bbg.fw
Product: nerves_bbg 0.1.0
UUID: a6418d17-a4e0-52e9-3825-b380a2c297df
Platform: bbb

Uploading to nerves.local...
Warning: Permanently added '[nerves.local]:8989,[172.31.123.1]:8989' (RSA) to the list of known hosts.
Running fwup...
fwup: Upgrading partition B
100% [====================================] 26.52 MB in / 26.75 MB out     
Success!
Elapsed time: 12.533 s
Rebooting...

```

# Original README.md

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
