#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

sudo date

if [ ! -d  "ChangesTX2J140_Kernel_r28.1" ]; then
  wget https://auvidea.com/download/firmware/TX2/v1.2/ChangesTX2J140_Kernel_r28.1.tar.gz
  tar zxvf ChangesTX2J140_Kernel_r28.1.tar.gz
fi

if [ -e .jetpack_path.txt ]; then
  path="$(cat .jetpack_path.txt)"
  read -e -p "Enter path to JetPack binary (JetPack-L4T-X.X-linux-x64.run): " -i $path jetpack_runfile
else
  read -e -p "Enter path to JetPack binary (JetPack-L4T-X.X-linux-x64.run): " jetpack_runfile
fi

jetpack_runfile="${jetpack_runfile/#\~/$HOME}"

# sha1sum ./JetPack-L4T-3.1-linux-x64.run
# d4ef1492b980a3e7a3fead65f63c14cd16394366  ./JetPack-L4T-3.1-linux-x64.run
if [[ $(sha1sum "$jetpack_runfile") != d4ef1492b980a3e7a3fead65f63c14cd16394366* ]]; then
  echo -e "${RED}ERROR: Invalid JetPack (check the version)${NC}"
  exit 1
fi

echo ${jetpack_runfile} > .jetpack_path.txt

parentdir="$(dirname "${jetpack_runfile}")"
workdir=$parentdir"/64_TX2/Linux_for_Tegra_tx2/"
echo $workdir

cp -v ChangesTX2J140_Kernel_r28.1/BCT/tegra186-mb1-bct-pmic-quill-p3310-1000-c03.cfg $workdir"/bootloader/t186ref/BCT"
cp -v ChangesTX2J140_Kernel_r28.1/BCT/tegra186-mb1-bct-pmic-quill-p3310-1000-c04.cfg $workdir"/bootloader/t186ref/BCT"

cp -v ChangesTX2J140_Kernel_r28.1/dtb/tegra186-quill-p3310-1000-a00-00-base.dtb $workdir"/kernel/dtb"
cp -v ChangesTX2J140_Kernel_r28.1/dtb/tegra186-quill-p3310-1000-c03-00-base.dtb $workdir"/kernel/dtb"
cp -v ChangesTX2J140_Kernel_r28.1/dtb/tegra186-quill-p3310-1000-c03-00-dsi-hdmi-dp.dtb $workdir"/kernel/dtb"

cp -v ChangesTX2J140_Kernel_r28.1/kernel/Image $workdir"/kernel/dtb"
sudo cp -v -R ChangesTX2J140_Kernel_r28.1/kernel/lib $workdir"/rootfs/lib"

echo -e "${GREEN}Put Jetson TX2 Dev Kit into Force Recovery mode.${NC}"
echo -e "${GREEN}(While holding REC button, press RST button)${NC}"
echo -e "${GREEN}When ready, press [ENTER]:${NC}"
read

cd $workdir
sudo ./flash.sh jetson-tx2 mmcblk0p1

cd "$OLDPWD"
