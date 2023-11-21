* GenICam
  * GenTL
  * GenAPI
<table>
  <tr>
    <th colspan="2"> Terminology </th> 
  </tr>
  <tr>
    <th> Term </th> <th> Note </th>
  </tr>
  <tr>
    <td> GenICam </td> <td> Generic Interface for Cameras is a generic programming interface for machine vision industrial cameras. </td>
  </tr>
  <tr>
    <td> GenTL </td> <td> This is the transport layer interface. </td> 
  </tr>
  <tr>
    <td> GenAPI </td> <td> Using an XML description file, this is used to configure the camera and details how to access and control cameras; </td>
  </tr>
</table>
   https://www.hikrobotics.com/en/machinevision/service/download?module=0
   Machine Vision Industrial Camera SDK V4.1.2 （Linux）
* Installing a GenTL Producer (mvGenTL_Acquire)
  * Download a .sh and a .tgz, put them in the same dir
    ```
    wget https://static.matrix-vision.com/mvIMPACT_Acquire/3.0.0/    install_mvGenTL_Acquire_ARM.sh
    wget https://static.matrix-vision.com/mvIMPACT_Acquire/3.0.0/    mvGenTL_Acquire-ARM64_gnu-3.0.0.tgz
    ```
  * Run install_mvGenTL_Acquire_ARM.sh
    ```
    sh install_mvGenTL_Acquire_ARM.sh
    ```
  * dddd
    ``` 
    ip addr add 169.254.204.84/24 dev eth0 
    pip install harvesters
    ```


    $ curl -F ‘data=@path/to/local/file’ UPLOAD_ADDRESS