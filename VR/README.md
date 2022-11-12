### Content
1. Setup Up the VR Development 
    
    * [Meta Quest 2 and Unreal Engine 4.27](Unreal/SetupUE4forQuest2AppDev.md)
    * I strongly recommond not to use UE5 at this moment. 
2. Develop first VR Game for Quest 2

    * [C++ Hello World](Unreal/CPP_Hello_World.md)

### Troubleshooting
1. Cannot [Attempt to construct staged filesystem reference from absolute path](https://www.pizzolab.com/attempt-to-construct-staged-filesystem-reference-from-absolute-path/)
```
   cmd > adb shell
   cmd > cd sdcard
   cmd > rm -r UE4Game/
   exit
```