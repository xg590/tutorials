### Test Run
1. Get SDK (机器视觉工业相机SDK Runtime组件包) and MVS (机器视觉工业相机客户端MVS) from HIKROBOT (海康机器人)
2. Unzip MvCamCtrlSDK_STD_V4.1.2_231011.zip and MVS_STD_GML_V2.1.2_231011.zip
3. Get MvCamCtrlSDK_Runtime-4.1.2_aarch64_20231011.deb and install it.
4. Get Sample code (RawDataFormatConvert) in Python
  * MVS_STD_GML_V2.1.2_231011.zip 
    * MVS-2.1.2_aarch64_20231011.tar.gz
      * MVS.tar.gz
        * Samples/aarch64/Python/RawDataFormatConvert
5. Run
    ```
    ping 169.254.183.217 # IP of Cam
    pip install opencv-python
    sudo ip addr add 169.254.111.222/16 dev eth0
    python RawDataFormatConvert.py
    ```
* Note: Configure any fixed address for your network adapter in the automatic IP address range (169.254.0.1 to 169.254.255.254) with a subnet mask of 255.255.0.0. [ref](https://docs.baslerweb.com/network-configuration-(gige-cameras))  