# XOSP functions that extend build/envsetup.sh

function xosp_device_combos() {
    T="$(gettop)"
    list_file="${T}/vendor/xosp/xosp.devices"
    variant="userdebug"

    if [[ $1 ]]
    then
        if [[ $2 ]]
        then
            list_file="$1"
            variant="$2"
        else
            if [[ ${VARIANT_CHOICES[@]} =~ (^| )$1($| ) ]]
            then
                variant="$1"
            else
                list_file="$1"
            fi
        fi
    fi

    if [[ ! -f "${list_file}" ]]
    then
        echo "unable to find device list: ${list_file}"
        list_file="${T}/vendor/xosp/xosp.devices"
        echo "defaulting device list file to: ${list_file}"
    fi

    while IFS= read -r device
    do
        add_lunch_combo "xosp_${device}-${variant}"
    done < "${list_file}"
}

function build_xospapps()
{
    
    cd xosp_apps
    mkdir out
    cd out
    mkdir system 
    cd ..
    
    ARCHTARGET=$(get_build_var TARGET_ARCH)
    DEVICETARGET=$(get_build_var TARGET_DEVICE)
    PRODUCT_OUT=$(get_build_var PRODUCT_OUT)
    DATE=` date +%d-%m-%Y`
    XOSPATH=$PRODUCT_OUT/install/xospapps
    mkdir -p $XOSPATH
    
    cp -avr Script/META-INF out >&/dev/null
    cp -avr Sources/system out >&/dev/null
    cd out
    UPDATERPATH=META-INF/com/google/android
    
    sed -i '8 a TARGET_DEVICE='$DEVICETARGET'' $UPDATERPATH/update-binary
    zip -r "XOSPApps".zip META-INF system >&/dev/null
    mv "XOSPApps.zip" $XOSPATH
    rm -rf META-INF
    rm -rf system
    cd ..
    rm -rf out
    cd ..
}
