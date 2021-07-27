#!/bin/sh

agent_dir="${HOME}/Library/LaunchAgents"
env_file="${agent_dir}/environment.plist"
lib_dir="${HOME}/AdobeLibs"
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
