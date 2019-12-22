# NervesBbg

Nerves trial on BeagleBone Green

## Operation Steps

### Getting Started

- First Steps
```
$ mix nerves.new nerves_bbg --target bbb 
$ cd nerves_bbg

$ export MIX_TARGET=bbb
$ mix deps.get
$ mix firmware

```

- Burn firmware image to microSD
```
# Insert microSD to host
$ mix firmware.burn

```

- Boot up Nerves Systems on BeagleBone Green
```
# Insert microSD to BBG
# Connet host and BBG with microUSB cable
# Hold down the USER/BOOT button, and power on with Power button
$ picocom /dev/tty.usbmodem14203 

iex(3)> NervesBbg.hello
:world

```

### Connect and Upload by ssh on VirtualEther

- Generate RSA key
```
$ ssh-keygen -t rsa -f ~/.ssh/nerves_bbg_id_rsa
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

# Edit config/target.exs
$ git diff config/target.exs 
diff --git a/config/target.exs b/config/target.exs
index 7fce607..8e63ff7 100644
--- a/config/target.exs
+++ b/config/target.exs
@@ -6,9 +6,7 @@ use Mix.Config
 
 keys =
   [
-    Path.join([System.user_home!(), ".ssh", "id_rsa.pub"]),
-    Path.join([System.user_home!(), ".ssh", "id_ecdsa.pub"]),
-    Path.join([System.user_home!(), ".ssh", "id_ed25519.pub"])
+    Path.join([System.user_home!(), ".ssh", "nerves_bbg_id_rsa.pub"])
   ]
   |> Enum.filter(&File.exists?/1)
 
@@ -33,7 +31,7 @@ node_name = if Mix.env() != :prod, do: "nerves_bbg"
 config :nerves_init_gadget,
   ifname: "usb0",
   address_method: :dhcpd,
-  mdns_domain: "nerves.local",
+  mdns_domain: "nerves_bbg.local",
   node_name: node_name,
   node_host: :mdns_domain
 
```

- Re-Build & Burn firm
```
$ mix firmware
# Insert microSD to host
$ mix firmware.burn
```

- Connect via ssh
```
$ ssh nerves_bbg.local 
Warning: Permanently added 'nerves_bbg.local,172.31.123.1' (RSA) to the list of known hosts.
Interactive Elixir (1.9.1) - press Ctrl+C to exit (type h() ENTER for help)
Toolshed imported. Run h(Toolshed) for more info
RingLogger is collecting log messages from Elixir and Linux. To see the
messages, either attach the current IEx session to the logger:

  RingLogger.attach

or print the next messages in the log:

  RingLogger.next

iex(nerves_bbg@nerves_bbg.local)1> NervesBbg.hello
:world
iex(nerves_bbg@nerves_bbg.local)2> uname
Nerves nerves-1509 nerves_bbg 0.1.0 (329a762e-f047-5800-ef73-a96cdcf405d9) arm

# Upload firm by ssh
$ mix firmware.gen.script
$ ./upload.sh nerves_bbg.local

```

### Blinking LEDs

- Provision to use LEDs
```
iex(1)> ls "/sys/class/leds"
beaglebone:green:usr0     beaglebone:green:usr1     beaglebone:green:usr2     beaglebone:green:usr3    

# Edit mix.exs
$ git diff mix.exs
diff --git a/mix.exs b/mix.exs
index bf46971..5be2681 100644
--- a/mix.exs
+++ b/mix.exs
@@ -47,6 +47,7 @@ defmodule NervesBbg.MixProject do
       # Dependencies for all targets except :host
       {:nerves_runtime, "~> 0.6", targets: @all_targets},
       {:nerves_init_gadget, "~> 0.4", targets: @all_targets},
+      {:nerves_leds, "~> 0.8", targets: @all_targets},

       # Dependencies for specific targets
       {:nerves_system_bbb, "~> 2.3", runtime: false, targets: :bbb},

# Edit config/target.exs
$ git diff config/target.exs 
diff --git a/config/target.exs b/config/target.exs
index 8e63ff7..aacf9ac 100644
--- a/config/target.exs
+++ b/config/target.exs
@@ -35,6 +35,17 @@ config :nerves_init_gadget,
   node_name: node_name,
   node_host: :mdns_domain
 
+# configuration for PocketBeagle on-board LEDs (target bbb)
+config :blinky, led_list: [:led0, :led1, :led2, :led3]
+
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
$ ./upload.sh nerves_bbg.local

```

- Blinking LEDs
```
$ picocom /dev/tty.usbmodem14203 

iex(3)> alias Nerves.Leds
Nerves.Leds
iex(4)> Leds.set led3: true
true
iex(5)> Leds.set led1: :heartbeat
true

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
