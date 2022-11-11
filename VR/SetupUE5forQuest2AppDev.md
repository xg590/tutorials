1. Install softwares 
<table> 
  <tr> 
    <th>Name</th>
    <th>Function</th>
    <th>Note</th>
  </tr>
  <tr> 
    <td><a href="https://www.nvidia.com/Download/index.aspx">Game Ready Driver</a></th>
    <td>Nvidia 3060Ti driver</th>
    <td></td>
  </tr>
  <tr> 
    <td><a href="https://www.meta.com/quest/setup/">Oculus App</a></td>
    <td>Quest 2 driver</td>
    <td></td>
  </tr>
  <tr> 
    <td><a href="https://developer.android.com/studio">Android Studio</a></td>
    <td>Build-Tools for Quest App</td>
    <td>Don't custom installation path</td>
  </tr>
  <tr> 
    <td><a href="https://store.epicgames.com/en-US/download">Epic Games Launcher</a></td>
    <td>Install Ureal Engine 5.0.3</td>
    <td></td>
  </tr>
  <tr> 
    <td><a href="https://visualstudio.microsoft.com/vs/">Visual Studio Community 2022</a></td>
    <td>C++ Coding IDE</td>
    <td></td>
  </tr>
</table>  

2. [Set up Android SDK for UE](https://docs.unrealengine.com/5.0/en-US/how-to-set-up-android-sdk-and-ndk-for-your-unreal-engine-development-environment/)

    2.1 Install Android SDK Command-line Tools (latest)

    2.2 Run SetupAndroid.bat 
3. [Set up Visual Studio for UE](https://docs.unrealengine.com/5.0/en-US/setting-up-visual-studio-development-environment-for-cplusplus-projects-in-unreal-engine/)
4. Enable Developer Mode on Quest 2
5. Fire up UE5
### Troubleshooting
1. Install [.NET Core 3.1 SDK](https://dotnet.microsoft.com/en-us/download/dotnet/3.1) to fix hostfxr.dll problem.
2. Install [.NET SDK 4.6+](https://dotnet.microsoft.com/en-us/download) to fix Cannot find .NetFxSDK problem
3. Cannot preview in Unreal Engine 
    * Restart VR headset and enable Oculus Link
    * Then launch Unreal Engine Editor 
4. Cannot [Attempt to construct staged filesystem reference from absolute path](https://www.pizzolab.com/attempt-to-construct-staged-filesystem-reference-from-absolute-path/)
```
   cmd > adb shell
   cmd > cd sdcard
   cmd > rm -r UE4Game/
   exit
```
### Ref
1. How to make a Quest 2 Game : Unreal Engine 4 [(youtube)](https://www.youtube.com/watch?v=Nqg3qlJdCCM) 