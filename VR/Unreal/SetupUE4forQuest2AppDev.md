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
    <td><a href="https://developer.android.com/studio/archive">Android Studio</a></td>
    <td>Build-Tools for Quest App</td>
    <td>Don't custom installation path</td>
  </tr>
  <tr> 
    <td><a href="https://visualstudio.microsoft.com/vs/">Visual Studio Community 2022</a></td>
    <td>C++ Coding IDE</td>
    <td></td>
  </tr>
  <tr> 
    <td><a href="https://store.epicgames.com/en-US/download">Epic Games Launcher</a></td>
    <td>Install Unreal Engine 4.27</td>
    <td>I strongly recommend 4.27</td>
  </tr>
</table>

2. Set up Android Studio for UE 4.27 

    2.0 Any version of Android Studio is OK.

    2.1 For SDK Platforms: Delete the Android API 33 and replace it with API 32. 

    2.2 For SDK Tools: 
    ```
    Delete "Android SDK Build-Tools 33.0.0" and install "29.0.2"  
    Install "NDK (Side by side) 21.4.xxx"
    Install "Android SDK Command-line Tools (latest)".
    ```
    2.3 Edit "Epic Games\UE_4.27\Engine\Extras\Android\SetupAndroid.bat" and run it.
    ```
    Before: set SDKMANAGER=%STUDIO_SDK_PATH%\tools\bin\sdkmanager.bat
    After : set SDKMANAGER=%STUDIO_SDK_PATH%\cmdline-tools\latest\bin\sdkmanager.bat
    ```
3. [Set up Visual Studio for UE](https://docs.unrealengine.com/5.0/en-US/setting-up-visual-studio-development-environment-for-cplusplus-projects-in-unreal-engine/)
4. Enable Developer Mode on Quest 2
5. Fire up Unreal Engine 4.27
6. Try to launch this ["Hello World"](https://github.com/xg590/UE4_helloWorld) on Meta Quest 2
### Troubleshooting
1. Install [.NET Core 3.1 SDK](https://dotnet.microsoft.com/en-us/download/dotnet/3.1) to fix hostfxr.dll problem.
2. Install [.NET SDK 4.6+](https://dotnet.microsoft.com/en-us/download) to fix Cannot find .NetFxSDK problem
### Ref
1. How to make a Quest 2 Game : Unreal Engine 4 [(youtube)](https://www.youtube.com/watch?v=Nqg3qlJdCCM) 