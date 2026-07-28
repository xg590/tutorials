1. Install the RTX2060 driver

    ```sh 
    apt list | grep ^nvidia-driver
    sudo apt install -y nvidia-driver-550 # enter 12345678 as the password
    sudo reboot
    ```

2. Although ```apt install -y nvidia-driver-550``` is run but ```Driver Version: 580.159.03``` might be installed.
    ```sh
    $ nvidia-smi 
    Sun Jul 19 18:10:21 2026       
    +-----------------------------------------------------------------------------------------+
    | NVIDIA-SMI 580.159.03             Driver Version: 580.159.03     CUDA Version: 13.0     |
    +-----------------------------------------+------------------------+----------------------+
    | GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
    | Fan  Temp   Perf          Pwr:Usage/Cap |           Memory-Usage | GPU-Util  Compute M. |
    |                                         |                        |               MIG M. |
    |=========================================+========================+======================|
    |   0  NVIDIA GeForce RTX 2060        Off |   00000000:01:00.0  On |                  N/A |
    | N/A   46C    P8              7W /  115W |     102MiB /   6144MiB |      1%      Default |
    |                                         |                        |                  N/A |
    +-----------------------------------------+------------------------+----------------------+

    +-----------------------------------------------------------------------------------------+
    | Processes:                                                                              |
    |  GPU   GI   CI              PID   Type   Process name                        GPU Memory |
    |        ID   ID                                                               Usage      |
    |=========================================================================================|
    |    0   N/A  N/A            1109      G   /usr/lib/xorg/Xorg                       30MiB |
    |    0   N/A  N/A            1379      G   /usr/bin/gnome-shell                     65MiB |
    +-----------------------------------------------------------------------------------------+
    ```