# ASUS Crosshair VIII Formula - Hackintosh

This OC EFI works with BigSur and future versions of MacOS

## Machine Setup
- ASUS Crosshair VIII Formula
- AMD Ryzen 5950x
- 128GB G.Skill - Trident Z Neo (F4-4000C18D-64GTZN)
- Radeon 6900xt Saphire
- Corsair MP600 Pro 1TB
- Aorus Gen 4 GP-AG41TB 1TB (Deativated DSDT)
- Samsung 3 TB Sata 6 HD
- Samsung 3 TB Sata 6 HD

## Fixes

### Discord / Krips

Execute this commands on terminal
```bash
sudo chmod 644 ./fixes/krisp.plist && cp ./fixes/krips.plist $HOME/Library/LaunchAgents/krisp.plist
```

### Adobe

(Original)[https://gist.github.com/naveenkrdy/26760ac5135deed6d0bb8902f6ceb6bd]

1. Install needed adobe apps from adobe creative cloud.

2. Open Terminal.

3. Copy-paste the below command to your terminal and run it (enter password when asked).

```bash
files_list=(MMXCore FastCore TextModel libiomp5.dylib)
lib_dir="${HOME}/Documents/AdobeLibs"
lib1_file="${lib_dir}/libiomp5.dylib"
lib1_link="https://raw.githubusercontent.com/naveenkrdy/Misc/master/Libs/libiomp5.dylib"

for file in $files_list; do
    find /Applications/Adobe* -type f -name $file | while read -r curr_file; do
        name=$(basename $curr_file)
        sw_vers -productVersion | grep "11" >/dev/null 2>&1
        [[ $? == 0 ]] && [[ $name =~ ^(MMXCore|FastCore)$ ]] && continue
        echo "found $curr_file"
        sudo -v
        [[ ! -f ${curr_file}.back ]] && sudo cp -f $curr_file ${curr_file}.back || sudo cp -f ${curr_file}.back $curr_file
        if [[ $name == "libiomp5.dylib" ]]; then
            [[ ! -d $lib_dir ]] && mkdir $lib_dir
            [[ ! -f $lib1_file ]] && cd $lib_dir && curl -sO $lib1_link
            adobelib_dir=$(dirname "$curr_file")
            echo -n "replacing " && sudo cp -vf $lib1_file $adobelib_dir
        elif [[ $name == "TextModel" ]]; then
            echo "emptying $curr_file"
            sudo echo -n >$curr_file
        else
            echo "patching $curr_file"
            sudo perl -i -pe 's|\x90\x90\x90\x90\x56\xE8\x6A\x00|\x90\x90\x90\x90\x56\xE8\x3A\x00|sg' $curr_file
            sudo perl -i -pe 's|\x90\x90\x90\x90\x56\xE8\x4A\x00|\x90\x90\x90\x90\x56\xE8\x1A\x00|sg' $curr_file
        fi
    done
done
```

4. Now copy-paste the below command to terminal and run it (enter password if asked).

```bash
agent_dir="${HOME}/Library/LaunchAgents"
env_file="${agent_dir}/environment.plist"
lib_dir="${HOME}/Documents/AdobeLibs"
lib2_file="${lib_dir}/libfakeintel.dylib"
lib2_link="https://raw.githubusercontent.com/naveenkrdy/Misc/master/Libs/libfakeintel.dylib"

sw_vers -productVersion | grep "11" >/dev/null 2>&1
if [[ $? == 0 ]]; then
    [[ ! -d $lib_dir ]] && mkdir $lib_dir
    [[ ! -f $lib2_file ]] && cd $lib_dir && curl -sO $lib2_link
    env="launchctl setenv DYLD_INSERT_LIBRARIES $lib2_file"
else
    mkl_value=$(
        sysctl -n machdep.cpu.brand_string | grep FX >/dev/null 2>&1
        echo $(($? != 0 ? 5 : 4))
    )
    env="launchctl setenv MKL_DEBUG_CPU_TYPE $mkl_value"
fi

[[ ! -d $agent_dir ]] && mkdir $agent_dir
cat >$env_file <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
 <key>Label</key>
 <string>mkl-debug</string>
 <key>ProgramArguments</key>
 <array>
 <string>sh</string>
 <string>-c</string>
    <string>$env;</string>
 </array>
 <key>RunAtLoad</key>
 <true/>
</dict>
</plist>
EOF

launchctl load ${AGENT} >/dev/null 2>&1
launchctl start ${AGENT} >/dev/null 2>&1
```

5. Reboot macOS.

### Revert Instructions

* To revert run the following command as required.
  * To revert step-3
```bash
files_list=(MMXCore FastCore TextModel libiomp5.dylib)
for file in $files_list; do
    find /Applications/Adobe* -type f -name $file | while read -r curr_file; do
        sudo -v
        [[ -f ${curr_file}.back ]] && echo "Restoring backup $curr_file"&& sudo mv -f ${curr_file}.back $curr_file
    done
done
```
  * To revert step-4
```bash
agent_dir="${HOME}/Library/LaunchAgents"
env_file="${agent_dir}/environment.plist"
if [[ -f $env_file ]]; then
    echo "Deleting $env_file"
    launchctl unload ${env_file} >/dev/null 2>&1
    launchctl stop ${env_file} >/dev/null 2>&1
    rm -rf $env_file
fi
```
2. Reboot macOS