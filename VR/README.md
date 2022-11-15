### Content
1. Setup Up the VR Development 
    
    * [Meta Quest 2 and Unreal Engine 4.27](Unreal/SetupUE4forQuest2AppDev.md)
    * I strongly recommond not to use UE5 at this moment. 
2. Develop first VR Game for Quest 2

    * [C++ Hello World](Unreal/CPP_Hello_World.md)

### Troubleshooting
1. Cannot [Attempt to construct staged filesystem reference from absolute path](https://www.pizzolab.com/attempt-to-construct-staged-filesystem-reference-from-absolute-path/)
```
   C:\Users\xg590>adb shell
   hollywood:/ $ rm -rf sdcard/UE4Game/
   hollywood:/ $ exit
```
2. Found thousands of Error? 
   
   2.1 Try "Generate Visual Studio project files"
3. Want to delete a C++ class

   3.1 Close UE and VS
   
   3.2 Delete foo.h and foo.cpp in the src folder and delete the binary folder

   3.3 Reopen UE and the project will rebuild
4. Cannot preview in Unreal Engine 

   4.1 Enable plugin Oculus VR if you see a greyed VR Preview

   4.2 Restart VR headset and enable Oculus Link

   4.3 Then relaunch Unreal Engine Editor 