#!/bin/sh

files_list=(MMXCore FastCore TextModel libiomp5.dylib)
lib_dir="${HOME}/AdobeLibs"
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
