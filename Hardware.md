### Use eGPU on Windows 10
* Material List
  * Razor Core X 
  * RTX 3060 Ti
  * Intel NUC
* Connection
  * Thunderbolt 3 PCIe x4 connection (rear connector only) is supported according to Intel NUC [datasheet](https://www.intel.com/content/dam/support/us/en/documents/intel-nuc/NUC10i357FN_TechProdSpec.pdf). 
  * Use rear end USB Type-C port.  
* Windows 10 High Performance Mode: Powershell in Admin Privilege [[Credit](https://community.intel.com/t5/Intel-NUCs/RTX-3060Ti-not-working-with-NUC-and-eGPU-Razer-Core-X-Chroma/m-p/1253473)] 
```
powercfg -duplicatescheme 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg -setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
```
* Install Nvidia Driver  
* Disconnect eGPU: Do it in GPU control panel before cut the power
#### GPU-accelerated Transcoding
* [Ref](https://docs.nvidia.com/video-technologies/video-codec-sdk/ffmpeg-with-nvidia-gpu/)
* \# Prereq
```
sudo apt-get install build-essential nasm yasm cmake libtool libc6 libc6-dev unzip wget libnuma1 libnuma-dev
```
* \# Install ffnvcodec
```
git clone https://github.com/FFmpeg/nv-codec-headers.git
cd nv-codec-headers && sudo make install 
```
* \# Compile x264 codec lib
```
wget https://code.videolan.org/videolan/x264/-/archive/master/x264-master.tar.bz2
tar jxvf x264-master.tar.bz2
cd x264-master/
./configure --enable-static --disable-opencl
sudo make install
``` 
* \# Install x265 codec lib (instead of compilation)
```
sudo apt install libx265-dev
```
* \# Install FFmpeg
```
git clone https://github.com/FFmpeg/FFmpeg
cd FFmpeg 
./configure --enable-nonfree --enable-cuda-nvcc --enable-libnpp --enable-static --disable-shared \
            --enable-gpl --enable-libx264 --enable-libx265 \
            --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 
make -j 4
```
### ChromeBox
1. Unscrew four bottom screws
2. Unscrew write-only protect screw
3. Upgrade RAM only at this moment and leave SSD alone
4. Poke the recovery hole while press power button
5. Press ctrl+d to turn off OS verification
6. Poke the recovery hole again so ChromeBox enters development mode
7. Connect to WiFi but do not agree OS legal terms
8. Press ctrl+alt+F2
9. Login with chronos (no password required) and flash ChromeBox with a new firmware
```
curl -L -O https://mrchromebox.tech/setup-kodi.sh && sudo bash setup-kodi.sh
```
10. Regular reboot and install Ubuntu
