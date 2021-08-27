# ASUS Crosshair VIII Formula - Hackintosh

This OC EFI works with BigSur and future versions of MacOS

## Machine Setup

```md
[CPU][amd ryzen 9 5950x 3.4 ghz 16-core processor]

[Motherboard][asus rog crosshair viii formula atx am4 motherboard]

[Memory][g.skill trident z rgb 64 gb (2 x 32 gb) ddr4-3600 cl18 memory]
[Memory][g.skill trident z rgb 64 gb (2 x 32 gb) ddr4-3600 cl18 memory]

[Storage][seagate barracuda 3 tb 3.5" 7200rpm internal hard drive]
[Storage][seagate barracuda 3 tb 3.5" 7200rpm internal hard drive]
[Storage][gigabyte aorus gen4 1 tb m.2-2280 nvme solid state drive]
[Storage][corsair mp600 pro 1 tb m.2-2280 nvme solid state drive]

[Video Card][sapphire radeon rx 6900 xt 16 gb nitro+ se video card]

[Power Supply][corsair hxi 1000 w 80+ platinum certified fully modular atx power supply]

[Case][lian li pc-o11 dynamic atx full tower case]

[Custom][custom watercooler loop (cpu + gpu + o11 distro plate)]

[Operating System][microsoft windows 10 pro oem 64-bit]
[Operating System][apple big sur]

[Monitor][samsung odyssey g9 49.0" 5120x1440 240 hz monitor]

[Headphones][steelseries arctis 9 wireless headset]
[Headphones][apple air pods max]
[Headphones][apple air pods pro]

[Mouse][logitech mx master 2]
[Mouse][razer deathadder pro wireless]

[Keyboard][razer blackwidow v2]
[Keyboard][custom mechanical keyboard (holy panda, domikey sa, 65% alu case)]
```

## Fixes

### Discord

```bash
cd /Applications/Discord.app/Contents/MacOS

echo "MKL_DEBUG_CPU_TYPE=5 ./Discord" > discord_
```

Open `/Applications/Discord.app/Contents/Info.plist` and find the `CFBundleExecutable` property and change the value of it to `discord_`

```xml
<key>CFBundleExecutable</key>
<string>discord_</string>
```

### Krisp

To launch Krisp

```bash
launchctl setenv MKL_DEBUG_CPU_TYPE 5 & open -n /Applications/krisp.app
```

### Adobe

Is not working properly with Krisp and Discord. I prefer the Krisp Fix
(Original)[https://gist.github.com/naveenkrdy/26760ac5135deed6d0bb8902f6ceb6bd]
