### 提取别人boot.wim里添加过的Driver并添加到自己的boot.wim里
* 提取Driver
```powershell

# 挂载 install.swm 的 Index 1（Windows 11 家庭版）

dism /Get-WimInfo /wimfile:I:\sources\install.swm
# /SWMFile:I:\sources\install*.swm 不能替换成 /SourceImageFile:I:\sources\install.swm /SWMFile:I:\sources\install*.swm
dism /Export-Image /SourceImageFile:I:\sources\install.swm /SWMFile:I:\sources\install*.swm /SourceIndex:1 /DestinationImageFile:D:\install.wim

dism /Get-WimInfo /wimfile:D:\install.wim
# 新建挂载目录
mkdir D:\InstallWimWithoutDrivers 
dism /Mount-Wim /WimFile:D:\install.wim /Index:1 /MountDir:D:\InstallWimWithoutDrivers

# 添加驱动包
PS D:\> dism /Image:D:\InstallWimWithoutDrivers /Add-Driver /Driver:D:\GPD_AMD_Drivers-V4.1.0\Drivers /Recurse

部署映像服务和管理工具
版本: 10.0.26100.1150

映像版本: 10.0.26100.4349

正在搜索要安装的驱动程序包...
找到 84 个要安装的驱动程序包。
正在安装第 1 个，共有 84 个 - D:\GPD_AMD_Drivers-V4.1.0\Drivers\AMD_DRTM_Boot_Driver_1.0.18.1_Release_WHQL\amddrtm.inf: 驱动程序包已成功安装。
正在安装第 2 个，共有 84 个 - D:\GPD_AMD_Drivers-V4.1.0\Drivers\AMDNPUMCDM\WT64A\kipudrv.inf: 驱动程序包已成功安装。
正在安装第 3 个，共有 84 个 - D:\GPD_AMD_Drivers-V4.1.0\Drivers\AMDNPUWDF\WT64A\kipudrv.inf: 驱动程序包已成功安装。
正在安装第 4 个，共有 84 个 - D:\GPD_AMD_Drivers-V4.1.0\Drivers\Audio Processing Objects (APOs)\realtekapo.inf_amd64_e2792d23df953eb3\RealtekAPO.inf: 驱动程序包已成 功安装。
... ...

# Commit
dism /unmount-wim /mountdir:D:\InstallWimWithoutDrivers /commit

# 扫尾
Dism.exe /Cleanup-MountPoints

# 
dism /Split-Image /ImageFile:D:\install.wim /SWMFile:Z:\install.swm /FileSize:3800

dism /Split-Image /ImageFile:D:\install.wim /Index:1 /SWMFile:C:\test\install.swm /FileSize:3800


dism /Split-Image /ImageFile:C:\fixed.wim /SWMFile:C:\test\install.swm /FileSize:3800


 Split-WindowsImage -ImagePath "D:\install.wim" -SplitImagePath "Z:\install.swm" -FileSize 3800 -CheckIntegrity


dism /mount-wim   /wimfile:H:\Images\install.wim /index:1 /readonly /mountdir:D:\InstallWimWithDrivers
dism /Get-MountedWimInfo

# 提取Driver
dism /Export-Driver /Imageh:D:\BootWimWithDrivers /Destination:D:\ExtractedDrivers


# 卸载并放弃更改
dism /unmount-wim /mountdir:D:\BootWimWithDrivers /discard
```


dism /unmount-wim /mountdir:D:\bootwim /commit


# 添加驱动（/recurse 会递归子目录）
dism /image:D:\bootwim /add-driver /driver:D:\drivers /recurse



D:\GPD_AMD_Drivers-V4.1.0\Drivers


