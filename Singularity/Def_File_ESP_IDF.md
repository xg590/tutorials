### Singularity Definition File.
* Ref [BootStrap](https://docs.sylabs.io/guides/3.0/user-guide/definition_files.html?highlight=bootstrap#header)
* Ref [%post](https://docs.sylabs.io/guides/3.0/user-guide/quick_start.html#singularity-definition-files) 
```
cat << EOF > ubuntu_esp_idf_5.def
BootStrap: library
From: ubuntu:22.04
%post
    apt-get -y update
    apt-get -y install git wget flex bison gperf python3 python3-pip python3.10-venv python3-setuptools cmake ninja-build ccache libffi-dev libssl-dev dfu-util libusb-1.0-0
    apt clean

%environment
    export PATH=~/bin:\$PATH
    export LC_ALL="C"
    export IDF_TOOLS_PATH=/esp/idf_tools

%runscript
    /bin/bash -c ". /esp/idf/export.sh; idf.py set-target esp32; idf.py build"

%labels
    Author xg590
EOF
singularity build --fakeroot ubuntu_esp_idf_5.sif ubuntu_esp_idf_5.def

mkdir -p tmp_123/upper tmp_123/work
dd if=/dev/zero of=esp_idf_5.img bs=1M count=2000
mkfs.ext3 -d tmp_123 esp_idf_5.img
rm -rf tmp_123

singularity shell --overlay esp_idf_5.img ubuntu_esp_idf_5.sif << EOF
git clone -b v5.0 --recursive https://github.com/espressif/esp-idf.git /esp/idf
export IDF_TOOLS_PATH=/esp/idf_tools
/esp/idf/install.sh esp32
EOF
```
* Example of "idf.py build" 
```
cd ~
git clone https://github.com/xg590/ESP32_Beacon.git
cd ESP32_Beacon
singularity run --overlay esp_idf_5.img ubuntu_esp_idf_5.sif # This will got ESP32_Beacon built
```
* Hello World
```
singularity shell --overlay esp_idf_5.img ubuntu_esp_idf_5.sif 
. /esp/idf/export.sh
cp -r $IDF_PATH/examples/get-started/hello_world /tmp
cd /tmp/hello_world
idf.py set-target esp32 
idf.py menuconfig
idf.py build
[AP example](https://github.com/espressif/esp-idf/tree/master/examples/wifi/getting_started/softAP)
ESP32 Wi-Fi AP mode
```