### Arduino CLI
```
wget https://github.com/arduino/arduino-cli/releases/download/0.28.0/arduino-cli_0.28.0_Linux_64bit.tar.gz

singularity build --sandbox  arduino_cli library://ubuntu
sudo singularity shell --writable arduino_cli
export LC_ALL="C"
apt update && apt install wget python
exit

singularity shell --writable arduino_cli
mv arduino-cli /usr/local/bin
exit

mkdir -p tmp_123/upper tmp_123/work
dd if=/dev/zero of=arduino_cli.img bs=1M count=6000
mkfs.ext3 -d tmp_123 arduino_cli.img
rm -rf tmp_123

singularity shell --overlay arduino_cli.img arduino_cli
export ARDUINO_DIRECTORIES_USER=/opt/arduino15
export ARDUINO_DIRECTORIES_DATA=/opt/arduino15

arduino-cli core install arduino:avr

arduino-cli compile . --fqbn esp32:esp32:esp32 && arduino-cli upload . --fqbn esp32:esp32:esp32 -p

```