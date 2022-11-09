### Singularity Definition File.
* Ref [BootStrap](https://docs.sylabs.io/guides/3.0/user-guide/definition_files.html?highlight=bootstrap#header)
* Ref [%post](https://docs.sylabs.io/guides/3.0/user-guide/quick_start.html#singularity-definition-files) 
```
cat << EOF > esp_idf_442.def
BootStrap: library
From: ubuntu:22.04

%post
    apt-get -y update
    apt-get -y install git wget flex bison gperf python3 python3-pip python3-setuptools cmake ninja-build ccache libffi-dev libssl-dev dfu-util libusb-1.0-0
    git clone -b v4.4.2 --recursive https://github.com/espressif/esp-idf.git /opt/esp_dev/esp_idf_442
    export IDF_TOOLS_PATH=/opt/esp_dev/idf_tools # specify install path
    /opt/esp_dev/esp_idf_442/install.sh esp32

%environment
    export PATH=~/bin:\$PATH
    export LC_ALL="C"
    export IDF_TOOLS_PATH=/opt/esp_dev/idf_tools 

%labels
    Author xg590
EOF
singularity build --fakeroot esp_idf_442.sif esp_idf_442.def
singularity shell esp_idf_442.sif
Singularity> . /opt/esp_dev/esp_idf_442/export.sh
```
* Hello World
```
singularity shell /var/www/html/esp_idf_442.sif
. /opt/esp_dev/esp_idf_442/export.sh
cp -r $IDF_PATH/examples/get-started/hello_world /tmp
idf.py set-target esp32 
idf.py menuconfig
[AP example](https://github.com/espressif/esp-idf/tree/master/examples/wifi/getting_started/softAP)
ESP32 Wi-Fi AP mode
```