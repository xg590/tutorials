### Set up Dev Env [u2b tutorial](https://www.youtube.com/watch?v=Nqg3qlJdCCM)
#### Android Studio Config
* Goto File->Settings->Appearance & Behavior->System Settings->Android SDK->tab SDK tools->check Android SDK Command-line Tools (latest)
* Modify Path_to\UE_4.27\Engine\Extras\Android\SetupAndroid.bat
  * From
    * set SDKMANAGER=%STUDIO_SDK_PATH%\tools\bin\sdkmanager.bat
  * to 
    * set SDKMANAGER=%STUDIO_SDK_PATH%\cmdline-tools\latest\bin\sdkmanager.bat
* Debug. Build-tool should be 