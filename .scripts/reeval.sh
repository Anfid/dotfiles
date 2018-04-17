#!/bin/bash

# Forgive me JetBrains for this. I'm just too poor for license

echo "removeing evaluation key"
rm  -rf ~/.CLion*/config/eval

rm -rf ~/.java/.userPrefs/jetbrains/clion

echo "resetting evalsprt in options.xml"
sed -i '/evlsprt/d' ~/.CLion*/config/options/options.xml

echo "resetting evalsprt in prefs.xml"
sed -i '/evlsprt/d' ~/.java/.userPrefs/prefs.xml


echo "changing flie dates"
find ~/.CLion* -type d -exec touch -t $(date +"%Y%m%d%H%M") {} +;
find ~/.CLion* -type f -exec touch -t $(date +"%Y%m%d%H%M") {} +;
