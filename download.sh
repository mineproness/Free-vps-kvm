 cd
echo "Checking for saved parts on WebDAV..."
URL_API=$(curl -s $URL)
PARTS=$(curl -s -u admin:admin -H "ngrok-skip-browser-warning: yes" $URL_API/webdav | grep -o 'ubuntu_part_[a-z][a-z]' | sort | uniq)
if [ -z "$PARTS" ]; then
   echo "⚠️ No saved parts found — fresh VM will be created."
else
   echo "Found parts: $PARTS"
 for p in $PARTS; do
    echo "Downloading $p ..."
    curl -u admin:admin -H "ngrok-skip-browser-warning: yes"  -O "$URL_API/$p"
done
echo "Rebuilding ubuntu.img..."
cat ubuntu_part_* > ubuntu.zip
rm -rf ubuntu_part_*
unzip ubuntu.zip
rm -rf ubuntu.zip
fi
