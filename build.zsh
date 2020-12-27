#!/usr/bin/env zsh

OUTPUT_FOLDER="${HOME}/Sync"
RELEASE_KEY="${HOME}/Documents/markor-release-key.jks"
export JAVA_HOME=/usr/lib/jvm/java-14-openjdk
export ANDROID_SDK_ROOT="$HOME/android-sdk"

#-------------------------------------------- EDIT ABOVE THIS LINE --------------------------------------------#

function _red {
  printf "\n\e[31m$@\e[0m\n"
}
function _green {
  printf "\n\e[32m$@\e[0m\n"
}
function _yellow {
  printf "\n\e[33m$@\e[0m"
}

repeat $COLUMNS;do printf "=";done
export ANDROID_SDK_ROOT="$HOME/android-sdk"

if [[ ! -d ${ANDROID_SDK_ROOT}]]; then
    curl https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip > sdk-tools.zip 
    unzip -qq -n sdk-tools.zip -d $HOME/android-sdk
fi


if [[ ! -d ${ANDROID_SDK_ROOT} ]]; then
    _red "ERROR: Cannot find android SDK at ${ANDROID_SDK_ROOT}. Starting download"
    curl https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip > sdk-tools.zip 
    unzip -qq -n sdk-tools.zip -d $HOME/android-sdk
    echo y | ${ANDROID_SDK_ROOT}/tools/bin/sdkmanager 'tools'
    echo y | ${ANDROID_SDK_ROOT}/tools/bin/sdkmanager 'platform-tools' 
    echo y | ${ANDROID_SDK_ROOT}/tools/bin/sdkmanager 'build-tools;29.0.3' 
    echo y | ${ANDROID_SDK_ROOT}/tools/bin/sdkmanager 'platforms;android-29' 
    echo y | ${ANDROID_SDK_ROOT}/tools/bin/sdkmanager 'extras;google;m2repository' 
    ${ANDROID_SDK_ROOT}/tools/bin/sdkmanager --licenses
fi

if [[ ! -d ${JAVA_HOME} ]]; then
    _red "ERROR: Cannot find JAVA_HOME at ${JAVA_HOME}"
    exit 1
fi

win=("${(@f)$(wmctrl -lx | rg -v "xfce4-panel|xfce4-terminal|Xfdesktop" | cut -f1 -d' ')}") 

_yellow "\n\nBuilding android app is a resource heavy ordeal. Would you like to close all windows so that system won't hang? (y/N) "
echo
read -rs -k 1 ans

case "${ans}" in
y|Y|$'\n')
    for i in "${win[@]}"; do wmctrl -ic $i; done
    ;;
*) 
	_yellow "\nRemember that you chose to ignore a sensible advice. You are on your own, you demented turtle."
esac


make clean all
cd app/build/outputs/apk/flavorAtest/release/ 
${ANDROID_SDK_ROOT}/build-tools/29.0.3/zipalign -v -p 4 net.gsantner.markor-v121-2.5.0-flavorAtest-release-unsigned.apk markor-unsign-aligned.apk

if [[ ! -f "${RELEASE_KEY}" ]]; then
	_red "\n\n\nCannot find a release key. Creating a new one\n\n"
   	keytool -genkey -v -keystore ${RELEASE_KEY} -keyalg RSA -keysize 2048 -validity 10000 -alias markor-build-key
fi

${ANDROID_SDK_ROOT}/build-tools/29.0.3/apksigner sign --ks ${RELEASE_KEY} --out markor-signed-aligned.apk markor-unsign-aligned.apk
mv markor-signed-aligned.apk ${OUTPUT_FOLDER}/markor-$(date +%d-%H%M).apk
RESULT=$?
if [ $RESULT -eq 0 ]; then
  	_green "Congratulations, you have managed to accomplish one task in your life"
	exit 0
else
 	_red "You there! You give stiff competition in the domain of IQ to a potato!."
	exit 1
fi


