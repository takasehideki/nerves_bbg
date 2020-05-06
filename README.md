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

### Blinking LEDs

- Provision to use LEDs
```
iex(1)> ls "/sys/class/leds"
beaglebone:green:usr0     beaglebone:green:usr1     beaglebone:green:usr2     beaglebone:green:usr3    

# Edit mix.exs
$ git diff mix.exs
diff --git a/mix.exs b/mix.exs
index 62ace16..326b2e7 100644
--- a/mix.exs
+++ b/mix.exs
@@ -47,6 +47,7 @@ defmodule NervesBbg.MixProject do
       # Dependencies for all targets except :host
       {:nerves_runtime, "~> 0.6", targets: @all_targets},
       {:nerves_pack, "~> 0.2", targets: @all_targets},
+      {:nerves_leds, "~> 0.8", targets: @all_targets},
 
       # Dependencies for specific targets
       {:nerves_system_bbb, "~> 2.6", runtime: false, targets: :bbb},

# Edit config/target.exs
$ git diff config/target.exs 
diff --git a/config/target.exs b/config/target.exs
index be595ce..db0749f 100644
--- a/config/target.exs
+++ b/config/target.exs
@@ -83,6 +83,16 @@ config :mdns_lite,
     }
   ]
 
+# configuration for PocketBeagle on-board LEDs (target bbb)
+config :blinky, led_list: [:led0, :led1, :led2, :led3]
+config :nerves_leds,
+  names: [
+    led0: "beaglebone:green:usr0",
+    led1: "beaglebone:green:usr1",
+    led2: "beaglebone:green:usr2",
+    led3: "beaglebone:green:usr3"
+  ]
+
 # Import target specific config. This must remain at the bottom
 # of this file so it overrides the configuration defined above.
 # Uncomment to use target specific configurations

```

- Re-Build & Burn firm
```
$ mix deps.get
$ mix firmware
$ ./upload.sh

```

- Blinking LEDs
```
$ ssh nerves.local

iex(3)> alias Nerves.Leds
Nerves.Leds
iex(4)> Leds.set led3: true
true
iex(5)> Leds.set led1: :heartbeat
true

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
