### Set up Dev Env [u2b tutorial](https://www.youtube.com/watch?v=Nqg3qlJdCCM)
### Known Problems
* Android SDK Build-Tools may not be compatible with Unreal Engine. For example, UE4.27 needs a <30.0.x buildtool because dx.bat has gone since 32.0.0. 
  * Goto File->Settings->Appearance & Behavior->System Settings->Android SDK->tab SDK tools->check Show Package Details and Android SDK Build-Tools 30.0.3 and uncheck higher version. 
* Android Studio Config
  * Goto File->Settings->Appearance & Behavior->System Settings->Android SDK->tab SDK tools->check Android SDK Command-line Tools (latest)
  * Modify Path_to\UE_4.27\Engine\Extras\Android\SetupAndroid.bat
    * From
      * set SDKMANAGER=%STUDIO_SDK_PATH%\tools\bin\sdkmanager.bat
    * to 
      * set SDKMANAGER=%STUDIO_SDK_PATH%\cmdline-tools\latest\bin\sdkmanager.bat 
