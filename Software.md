### GitHub
#### Basics
* Push a new local repo to GitHub
```
echo "# test" >> README.md
git init
git add README.md
git commit -m "first commit"                         # record changes 
git branch -M main                                   # name current branch called main
git remote add origin git@github.com:xg590/test.git  # give the remote depo git@github.com:xg590/test.git a shorter REMOTENAME "origin"
git push -u origin main                              # push current branch to origin
```
* Other 
```
git branch -l                                        # what is current branch name
git remote -v                                        # what is remote (what does origin stand for)
```
#### Create a Depository
0. Prepare a pair of key on local machine
```shell
ssh-keygen -t rsa -b 4096 -N '' -f ~/.ssh/github
``` 
1. Sign up an account on github.com
2. In the setting of your GitHub account, paste the public key.
3. In terminal, Add new entry in local ~/.ssh/config.
```shell
cat << EOF >> ~/.ssh/config 
host github.com
    user git 
    port 22
    identityfile ~/.ssh/github
EOF
``` 
4. In terminal, test a password-free connection to the github.com
```shell
ssh -T github.com
```
you will get the response "Hi xxx! You've successfully authenticated, but GitHub does not provide shell access."

5. Install git in terminal
```shell
sudo apt-get/apt-cyg/yum install git
```
6. Configure your local git
```shell
git config --global user.name  "your_name"   # This info is nothing to do with GitHub
git config --global user.email "your_email"  # This info is nothing to do with GitHub
```
7. Initialize the directory containing to-be-uploaded files
```shell
git init
```
8. Make a test file
```shell
echo "success" > test.txt
```
9. Add the test file to index 
```shell
git add test.txt
```
10. Add the indexed file to HEAD 
```shell
git commit -m "comment to this time of action"
```
11. Create a new repository on Github 
```shell
curl -u 'AccountName' https://api.github.com/user/repos -d '{"name":"NewRepoName"}'
```
* Enter you password
12. Specify the upload destination
```shell
git remote add just_a_placeholder git@github.com:yourName/NewRepoName.git
```
13. Upload
```shell
git push just_a_placeholder master
```
~Done

#### Rename a remote directory
* Only if you can ssh github.com without password, this shall work.
```shell
git clone git@github.com:AccountName/RepoName.git
cd RepoName
git mv path_name new_path_name
git commit -m "Problematic Name in Windows"
git push origin master
```
#### Manual Change
```
git add -u . 
git add *
git status 
git commit -m 'LoRa'
git push  
``` 
### Q_emulator?
#### Emu X86/AMD64
* Install
```
sudo apt-get update && \
sudo apt-get install -y qemu-kvm
```
* Create a 20GB qcow2-format virtual disk
```
qemu-img create -f qcow2 ubuntu.qcow 20G
```
* Boot from cdrom, in which a iso file is loaded. The VM uses ubuntu.qcow as harddisk and has 4096MB RAM. 
```
qemu-system-x86_64 -cpu host -enable-kvm -m 4G -hda ubuntu.qcow     -boot d -cdrom ubuntu-20.04.3-desktop-amd64.iso
```
* Restart after installation
``` 
qemu-system-x86_64 -cpu host -enable-kvm -m 4G -hda ubuntu.qcow
```
* Now we have a Ubuntu OS as Guest OS with a NAT network (10.0.2.0/24).
* By default, the NAT is a "user" type networking. 
* Let's change network range
```
qemu-system-x86_64 -cpu host -enable-kvm -m 4G -hda ubuntu.qcow \
                   -device e1000,netdev=net123456 \
                   -netdev user,id=net123456,net=192.168.123.0/24,dhcpstart=192.168.123.9
```
* Let's forward guest OS's port 22 to host OS's 4321 (so we can ssh into virtual machine)
```
qemu-system-x86_64 -cpu host -enable-kvm -m 4G -hda ubuntu.qcow \
                   -device e1000,netdev=net123456 \
                   -netdev user,id=net123456,hostfwd=tcp:127.0.0.1:4321-:22
```
### Cygwin
* Install on Windows
```shell
set CYGWIN_ROOT=C:\cygwin
# Download installer (x86)
httpget.exe http://yzlab3.chem.nyu.edu/software/cygwin-x86.exe 
httpget.exe http://yzlab3.chem.nyu.edu/software/apt-cyg %CYGWIN_ROOT%\bin\apt-cyg
cygwin-x86.exe --quiet-mode --root %CYGWIN_ROOT% --site http://cygwin.mirror.constant.com --packages "wget" 
setup-x86_64.exe --quiet-mode --root %CYGWIN_ROOT% --site https://mirrors.tuna.tsinghua.edu.cn/cygwin/ --packages "wget" 
```
* Start
```shell
set CYGWIN_ROOT=C:\cygwin
%CYGWIN_ROOT%\Cygwin.bat
```
* Play
  * No need to umount before dd
  * Commands like fdisk are under /sbin/, we have to use abs path 
```
df -h
/sbin/fdisk.exe -l /dev/sdb
apt-cyg install pv
dd if=2021-05-07-raspios-buster-armhf-lite.img | pv | dd of=/dev/sdb
```
### Useful Chrome Extension:
1. [Anything to QRcode](https://chrome.google.com/webstore/detail/anything-to-qrcode/calkaljlpglgogjfcidhlmmlgjnpmnmf)
2. [HTTP Trace](https://chrome.google.com/webstore/detail/http-trace/idladlllljmbcnfninpljlkaoklggknp)
3. [Google Input](https://chrome.google.com/webstore/detail/google-input-tools/mclkkofklkfljcocdinagocijmpgbhab)
### Jupyter
* Prepare a hashed password of notebook server 
```
from notebook.auth import passwd
passwd()
```
* Create a config file
```
mkdir ~/.jupyter
cat << EOF > ~/.jupyter/jupyter_notebook_config.py 
c.NotebookApp.ip = '*'
c.NotebookApp.port = 8888 
c.NotebookApp.open_browser = False
c.NotebookApp.password = u'sha1:ffed18eb1683:ee67a85ceb6baa34b3283f8f8735af6e2e2f9b55' 
#c.NotebookApp.keyfile = u'/absolute/path/to/your/certificate/privkey.pem' 
#c.NotebookApp.certfile = u'/absolute/path/to/your/certificate/fullchain.pem'
EOF
```
* Install jupyter
```
sudo apt update && sudo apt install python3-pip python3-venv
python3 -m venv jupyter
source jupyter/bin/activate
pip install jupyter jupyter_contrib_nbextensions
jupyter contrib nbextension install --user
```
* Install more python backend for jupyter 
```
python3 -m pip install ipykernel
python3 -m ipykernel install --user --name myenv --display-name "Python (myenv)"
```
* Uninstall backend/kernel
```
jupyter kernelspec list  
jupyter kernelspec uninstall unwanted-kernel
``` 
### Conda 
#### Problem
* Sometime we may works with multiple conda installations. For example, I manage three different conda, on NYU HPC, my Windows laptop, and a online Linux webserver.
* When the development period is long, the new installation on webserver would be set up with the latest version of everything and it created a compatible problem.
* How to ensure the same conda environment across multiple installations? 
#### Solution: Create a conda environment recipe
1. Choose one conda installation as the source installation
2. Fire up the environment that is needed to be transferred on destination conda installation.
```
me@hpc:~$ source software/miniconda3/bin/activate rdkit_on_hpc
(rdkit_on_hpc) me@hpc:~$
```
3. Export an environment recipe
```
(rdkit_on_hpc) me@hpc:~$ ./software/miniconda3/bin/conda-env export > environment.yml
```
4. On another machine, for the destination conda, create the same environment with recipe.
```
me@webserver:~$ ./software/miniconda3/bin/conda-env create -f environment.yml
```
5. Now we have the same conda environment with the same name
```
me@webserver:~$ source software/miniconda3/bin/activate rdkit_on_hpc
(rdkit_on_hpc) me@webserver:~$
``` 
### Wireshark
* Install  
```
sudo apt install wireshark ### Allow non-root user to capture packet.
sudo usermod -a -G wireshark $USER 
```
* Remote capture
```shell 
wireshark -k -i <(ssh piMachine "sudo tcpdump -i eth1 -nn -w - src 192.168.4.100")
```  
### VirtualBox
* [Manual](https://www.virtualbox.org/manual/ch08.html)
* List virtual machines
```
vboxmanage list vms
```
* List medium 
```
vboxmanage list hdds
```
* Show the current configuration
```
vboxmanage showvminfo <vmname>
```
* RDP configuration
```
vboxmanage modifyvm <vmname> --vrde on
vboxmanage modifyvm <vmname> --vrdeaddress 127.0.0.1 --vrdeport 12345
```
* Start a machine headlessly
```
vboxmanage startvm <vmname> --type headless
```
* List running machines
```
vboxmanage list runningvms
```
* Delete a virtual machine
```
vboxmanage unregistervm <vmname> --delete
```
* Delete a medium
``` 
vboxmanage closemedium disk 7dcc971c-6266-46d5-8668-0c7a4d1f6132 --delete
```
* Create hostonly adapter [vboxnet0]
```
vboxmanage hostonlyif create 
vboxmanage hostonlyif ipconfig vboxnet0 --ip 192.168.56.1
vboxmanage dhcpserver add --ifname vboxnet0 --ip 192.168.56.1 --netmask 255.255.255.0 --lowerip 192.168.56.100 --upperip 192.168.56.200
vboxmanage dhcpserver modify --ifname vboxnet0 --enable
```
* Use hostonly adapter
```
vboxmanage modifyvm <vmname> --nic2 hostonly --hostonlyadapter2 vboxnet0
```
* Copy a file to Guest
```
vboxmanage guestcontrol <vmname> copyto --username ??? --password=??? --target-directory "c:\\Users\\???\\Desktop\\"  ???
```
* Add more cpu cores
```
vboxmanage modifyvm <vmname> --cpuhotplug on # 
vboxmanage modifyvm <vmname> --cpus 3        # 3 cpu cores at most
vboxmanage modifyvm <vmname> --plugcpu 1     # Add core 1. Core 0 is the default one.
vboxmanage modifyvm <vmname> --plugcpu 2     # Add core 2
```
* Add VBoxGuestAdditions.iso
```
vboxmanage storageattach <vmname> --storagectl SATA --port 1 --device 0 --type dvddrive --medium /usr/share/virtualbox/VBoxGuestAdditions.iso
vboxmanage storageattach <vmname> --storagectl SATA --port 1 --device 0 --type dvddrive --medium emptydrive
```
* Install extpack 
```
vboxmanage extpack install xxx.vbox-extpack
```
* Register an old VM
```
vboxmanager registervm xxx.vbox
```
#### Install a Ubuntu20.04.1 Guest OS
1. Create a profile (yyy is virtual machine name, xxx is sub-folder)
```
vboxmanage createvm --name yyy --basefolder ~/xxx --ostype Ubuntu_64 --register 
```
2. RAM
```
vboxmanage modifyvm yyy --memory 8000 
```
3. Set video card ram 256MB, turn on remote desktop env.
```
vboxmanage modifyvm yyy --accelerate3d on --vram 256 --audio alsa --audiocontroller ac97 --vrde on
```
4. Set up two controllers (IDE and SATA)
```
vboxmanage storagectl yyy --name SATA --add sata --controller IntelAhci --bootable on
vboxmanage storagectl yyy --name IDE  --add ide  --controller PIIX4     --bootable on
```
5. Create a virtual disk 
```
vboxmanage createmedium disk --filename ~/xxx/yyy/yyy.vdi --format VDI --size 10240
```
6. Attache virtual disk and Ubuntu Installation CD
```
vboxmanage storageattach yyy --storagectl SATA --port 0 --device 0 --type hdd      --medium ~/xxx/yyy/yyy.vdi 
vboxmanage storageattach yyy --storagectl IDE  --port 0 --device 0 --type dvddrive --medium ~/ubuntu-20.04.1-desktop-amd64.iso 
```
If you need eject dvd 
```
vboxmanage storageattach yyy --storagectl IDE  --port 0 --device 0 --type dvddrive --medium emptydrive
```
7. Configure Networking
```
vboxmanage modifyvm yyy --nic1 nat --nictype1 82540EM --cableconnected1 on
```
#### Troubleshooting
* In case of "No USB devices available" on linux host, set proper group id for current user (credit to [csorig](https://superuser.com/a/957636))
```
sudo usermod -aG vboxusers $USER
```
* "Failed to attach the USB device xxx to the virtual machine xxxx"
  * It may because VBox extenstion package is not installed or the USB device need a higher version of controller. 
  * Enable USB controller in Virtual Machine Settings 
  * Choose 3.0 Controller

### Singularity
* Install Dependencies
```
sudo apt-get update && sudo apt-get install -y build-essential uuid-dev libgpgme-dev squashfs-tools libseccomp-dev wget pkg-config git cryptsetup-bin
```
* Install Go 1.14.12
```
export VERSION=1.14.12 OS=linux ARCH=amd64 && wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz && sudo tar -C /usr/local -xzvf go$VERSION.$OS-$ARCH.tar.gz && rm go$VERSION.$OS-$ARCH.tar.gz
echo 'export PATH=/usr/local/go/bin:$PATH' >> ~/.bashrc && source ~/.bashrc
```
* Download Singularity 3.7.0
```
export VERSION=3.7.0 && wget https://github.com/hpcng/singularity/releases/download/v${VERSION}/singularity-${VERSION}.tar.gz && tar -xzf singularity-${VERSION}.tar.gz 
```
* Build Singularity
```
cd singularity && ./mconfig && make -C ./builddir && sudo make -C ./builddir install
```
Source bash completion file
```
. /usr/local/etc/bash_completion.d/singularity
```
Testing & Checking the Build Configuration
```
singularity exec library://alpine cat /etc/alpine-release
``` 
* Play on NYU HPC GREENE
```
cp /scratch/work/public/overlay-fs-ext3/overlay-5GB-200K.ext3.gz /scratch/${USER}/
gzip -d overlay-5GB-200K.ext3.gz
singularity exec --overlay overlay-5GB-200K.ext3 /scratch/work/public/singularity/ubuntu-20.04.1.sif /bin/bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh 
bash Miniconda3-latest-Linux-x86_64.sh -b -f -p /ext3/miniconda3/
wget https://yzlab3.chem.nyu.edu/share/rdkit_on_hpc.yml
/ext3/miniconda3/bin/conda-env create -f rdkit_on_hpc.yml 
source /ext3/miniconda3/bin/activate rdkit_on_hpc 
/ext3/miniconda3/envs/rdkit_on_hpc/bin/jupyter contrib nbextension install --user
mkdir ~/.jupyter
# from notebook.auth import passwd
cat << EOF >> ~/.jupyter/jupyter_notebook_config.py
c.NotebookApp.ip = '0.0.0.0' 
c.NotebookApp.password = 'sha1:ffed18eb1683:ee67a85ceb6baa34b3283f8f8735af6e2e2f9b55'
EOF
cat <<EOF > ~/bin/jupyter.sh
#!/bin/bash
source /ext3/miniconda3/bin/activate rdkit_on_hpc
XDG_RUNTIME_DIR=/scratch/xg590
port=\$(shuf -i 10000-19999 -n 1) 
jupyter notebook --no-browser --port \$port --notebook-dir=`pwd` &
/usr/bin/ssh -N -R 39073:localhost:\$port iMac
EOF
chmod 700 ~/bin/jupyter.sh
```
* Run
```
singularity exec --overlay overlay-5GB-200K.ext3 /scratch/work/public/singularity/ubuntu-20.04.1.sif ~/bin/jupyter.sh
``` 
### HTTP Basic Authentication
```
import base64, requests 
encoded = base64.b64encode(b'username:password') 
r = requests.get('https://host/dav_dir/', headers={'Authorization': f'Basic {encoded.decode()}'})
r.text
```
## Sun Grid Engine (SGE)
#### Installation Preparation
Needed packages: sge-6_2u4-bin-linux24-x64.tar.gz sge-6_2u4-common.tar.gz
```
sudo su # Change to root
export SGE_ROOT=/some_directory
mkdir $SGE_ROOT
tar zxf sge-6_2u4-bin-linux24-x64.tar.gz -C $SGE_ROOT
tar zxf sge-6_2u4-bin-linux24-x64.tar.gz -C $SGE_ROOT
```
#### Interactive Installation of qmaster
```
cd $SGE_ROOT
./util/setfileperm.sh $SGE_ROOT
./install_qmaster
```
Answers to any question by using <b>ENTER</b> key <b>EXCEPT</b>:  <br>
* Install SGE under an user id other than >root< (y/n) [y] >> n  <br>
* How do you want to configure the Grid Engine communication ports? >shell environment< or >/etc/service<, >NIS/NIS+< (default: 2) >> 2  <br>
The above question will be asked twice, first for the communication of the program <b><i>sge_qmaster</i></b>, second for the program <b><i>sge_execd</i></b>  <br> 
* Do you want to enable the JMX MBean server (y/n) [y] >> n  <br> 
* Do you want to add your shadow host(s) now? (y/n) [y] >> n 

#### Interactive Installation of execd
```
source /home/sge/default/common/settings.sh
cd $SGE_ROOT
./install_execd
```
Answers to any question by using <b>ENTER</b> key <br>
#### Start / Stop Grid Engine
List services
```
chkconfig --list|grep sge
sgeexecd.cluster_name_is_not_important  0:off   1:off   2:off   3:on    4:off   5:on    6:off
sgemaster.cluster_name_is_not_important 0:off   1:off   2:off   3:on    4:off   5:on    6:off
```
Start service once
```
/etc/init.d/sgemaster.cluster_name_is_not_important start       # One way
service sgemaster.cluster_name_is_not_important start           # or another 
```
Start service permanently
```
chkconfig --level 35 sgeexecd.cluster_name_is_not_important on
```

#### Submit A Test Interactive Job
```
qlogin -l h[ostname]=master # Run job on a host whose name is master. -l option is to list the requested resource
``` 
#### Configuration
#### Turn on scheduler info 
Otherwise, see "scheduling info: (Collecting of scheduler job information is turned off)" when use qstat -j job_id
```
qconf -msconf # Modify scheduler configuration
``` 
schedd_job_info: false -> true 
##### Create a Parallel Environment (PE) profile
###### Glossary 
* <b>Logical CPU Core</b>: Abstract executing unit of the running code. <br>
* <b>Physical CPU Core</b>: Electronic Logic circuit that runs the code. Due to hyperthreading (HT) tech, one physical core might consists of two logcial cores. <br>
* <b>CPU Socket</b>: Socket to place the multi-core CPU chip on the motherboard. Server motherboard tends to have more sockets. <br>
* <b>MPI Process</b>: Running code featuring the information change with other copies.  <br>
* <b>Slot</b>: Abstract executing unit of a MPI process. Number of Slot is better not larger than the number of physical cpu cores when the MPI task is cpu-bound (computationally intensive). <br> 
```
qconf -ap new_pe_profile
```
See the help page <i>man sge_pe</i> for detail
#### MPI Job Submission (testing the installation) 
Create a MPI program
```
cat << EOF > pi.mpi.c
#include<stdio.h>
#include<mpi.h>
#include<math.h>

int main(int argc,char *argv[]){
	int my_rank,num_procs;
	int i,n=0;
	double sum,width,local,mypi,pi;
	double start=0.0,stop=0.0;
	int proc_len;
	char processor_name[MPI_MAX_PROCESSOR_NAME];

	MPI_Init(&argc,&argv);
	MPI_Comm_size(MPI_COMM_WORLD,&num_procs);
	MPI_Comm_rank(MPI_COMM_WORLD,&my_rank);
	//MPI_Get_processor_name(processor_name,&proc_len);

	if(my_rank==0)
	{
		n=2000000000;
		start=MPI_Wtime();
	}

	printf("Processor %d of %d on %s\n",my_rank,num_procs,processor_name);
	MPI_Bcast(&n,1,MPI_INT,0,MPI_COMM_WORLD);
	width=1.0/n;
	sum=0.0;
	for(i=my_rank;i<n;i+=num_procs)
	{
		local=width*((double)i+0.5);
		sum+=4.0/(1.0+local*local);
	}
	mypi=width*sum;
	MPI_Reduce(&mypi,&pi,1,MPI_DOUBLE,MPI_SUM,0,MPI_COMM_WORLD);
	if(my_rank==0)
	{
		printf("PI is %.20f, error is %.20f\n", pi, fabs(pi-3.141592653589793238462643));
		stop=MPI_Wtime();
		printf("Time: %f\n",stop-start);
		fflush(stdout);
	}
	MPI_Finalize();
	return 0;
}
EOF
export OPENMPI_ROOT=/somewhere/openmpi
export PATH=$PATH:$OPENMPI_ROOT/bin 
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$OPENMPI_ROOT/lib
mpicc pi.mpi.c -o pi.mpi 
```
If a new PE profile is created and used, it should be added to the queue configuration first.
```
qconf -mattr queue pe_list new_pe_profile all.q
```
Submit a test non-interactive/batch job that specified pe profile
```
cat << EOF > test_pe.sh
#!/bin/bash
echo "NSLOTS          \$NSLOTS        "  >> test_mpi.log 
echo "SGE_O_WORKDIR   \$SGE_O_WORKDIR "  >> test_mpi.log
echo "SGE_TASK_ID     \$SGE_TASK_ID   "  >> test_mpi.log
echo "ENVIRONMENT     \$ENVIRONMENT   "  >> test_mpi.log
echo "JOB_ID          \$JOB_ID        "  >> test_mpi.log
echo "PE_HOSTFILE     \$PE_HOSTFILE   "  >> test_mpi.log
echo "________________________________"  >> test_mpi.log
cat \$PE_HOSTFILE                        >> test_mpi.log
export OPENMPI_ROOT=/somewhere/openmpi
export PATH=\$PATH:\$OPENMPI_ROOT/bin 
export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$OPENMPI_ROOT/lib
EOF
qsub -pe new_pe_profile 4 test_pe.sh
```
Now a new bash is gained in executive host (exec_host)
```
#!/bin/sh 
#$ -N test_mpi 
#$ -cwd 
#$ -j y 
#$ -pe new_pe_profile 4  
#$ -S /bin/bash  
cd $SGE_O_WORKDIR
export OPENMPI_ROOT=/somewhere/openmpi/
export PATH=$PATH:$OPENMPI_ROOT/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$OPENMPI_ROOT/lib
awk '{print $1 " slots="$2}' $PE_HOSTFILE > .hostfile
/home/openmpi/bin/mpirun -np $NSLOTS -machinefile .hostfile pi.mpi > pi.mpi.log 
```
#### Suspend / Resume Job
```
qmod -sj | -usf (suspend | unsuspend)  
```
### Win32-OpenSSH
##### # Download OpenSSH-Win32 and plink (Win7_x86)
```shell
<<<<<<< HEAD
wget http://192.168.0.22/software/Win32-OpenSSH/OpenSSH-Win32.zip 
unzip OpenSSH-Win32.zip 
mv OpenSSH-Win32 OpenSSH
wget http://192.168.0.22/software/Win32-OpenSSH/plink.exe -O OpenSSH/plink.exe 
``` 
##### #  Download OpenSSH-Win32 and plink (Win7_x64)
```shell
wget http://192.168.0.22/software/Win32-OpenSSH/OpenSSH-Win64.zip 
unzip OpenSSH-Win64.zip 
mv OpenSSH-Win64 OpenSSH
wget http://192.168.0.22/software/Win32-OpenSSH/plink.exe -O OpenSSH/plink.exe 
```
##### # HttpGet
```
wget http://192.168.0.22/software/Win32-OpenSSH/httpget.exe -O OpenSSH/httpget.exe  
=======
wget https://github.com/PowerShell/Win32-OpenSSH/releases/download/V8.6.0.0p1-Beta/OpenSSH-Win32.zip 
unzip OpenSSH-Win32.zip 
mv OpenSSH-Win32 OpenSSH
wget https://the.earth.li/~sgtatham/putty/latest/w32/plink.exe -O OpenSSH/plink.exe 
``` 
##### #  Download OpenSSH-Win32 and plink (Win7_x64)
```shell
wget https://github.com/PowerShell/Win32-OpenSSH/releases/download/V8.6.0.0p1-Beta/OpenSSH-Win64.zip 
unzip OpenSSH-Win64.zip 
mv OpenSSH-Win64 OpenSSH
wget https://the.earth.li/~sgtatham/putty/latest/w64/plink.exe -O OpenSSH/plink.exe 
```
##### # HttpGet
```
wget https://github.com/xg590/miscellaneous/raw/master/httpget.exe -O OpenSSH/httpget.exe  
>>>>>>> b748ca4ecb1a2681d6f670449500976d21b712d3
```
##### # Generate identity files: 
```
suffix=$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 6 | head -n 1)
ssh-keygen -t rsa -b 4096 -N '' -C "${suffix}" -f OpenSSH/id_rsa 
sudo apt install putty-tools
puttygen OpenSSH/id_rsa -o OpenSSH/id_rsa.ppk 
``` 
##### # Generate more files:
```
cat << EOF > OpenSSH/sshd_config_default
ListenAddress 127.0.0.1
ListenAddress ::1
Port 2222

PermitEmptyPasswords no
PasswordAuthentication no
PubkeyAuthentication yes
AllowTcpForwarding yes
Subsystem sftp sftp-server.exe
EOF
```
```
CR=$'\r'
cat << EOF > OpenSSH/ssh.bat
timeout 30$CR
cd "%USERPROFILE%\.ssh"$CR
echo yes | plink.exe -i id_rsa.ppk -N -R 22222:localhost:2222 win7@guoxiaokang.com 
EOF
```
```
cat << EOF > OpenSSH/ssh.vbs
Set WshShell = CreateObject("WScript.Shell")$CR
WshShell.Run chr(34) & "%USERPROFILE%\Desktop\ssh.bat" & Chr(34), 0$CR
Set WshShell = Nothing$CR
EOF
```
```
cat << EOF > install.bat
cd "%~dp0"$CR
mkdir "%USERPROFILE%\.ssh"$CR
move OpenSSH\httpget.exe "%USERPROFILE%"\.ssh$CR
move OpenSSH\plink.exe   "%USERPROFILE%"\.ssh$CR
move OpenSSH\id_rsa.ppk  "%USERPROFILE%"\.ssh$CR
move OpenSSH\id_rsa.pub  "%USERPROFILE%"\.ssh\authorized_keys$CR
move OpenSSH\ssh.bat     "%USERPROFILE%\Desktop"$CR
WSCript OpenSSH\ssh.vbs$CR
move OpenSSH\ssh.vbs "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\"$CR
$CR
move OpenSSH "%PROGRAMFILES%\"$CR
cd "%PROGRAMFILES%"$CR
icacls OpenSSH /grant Users:(OI)(CI)(F)$CR
powershell -ExecutionPolicy Bypass -File OpenSSH\install-sshd.ps1$CR
powershell Start-Service -Name "sshd"$CR
powershell Start-Service -Name "ssh-agent"$CR
powershell Set-Service -Name "sshd" -StartupType Automatic$CR
powershell Set-Service -Name "ssh-agent" -StartupType Automatic$CR
cd "%~dp0"$CR
del OpenSSH.exe install.bat$CR
EOF
```
##### # Packup
```
echo yes | zip -r OpenSSH.zip OpenSSH install.bat
scp OpenSSH/id_rsa.pub com:/home/win7/.ssh/id_rsa_${suffix}.pub
scp OpenSSH/id_rsa com:/home/win7/.ssh/id_rsa_${suffix}
scp OpenSSH.zip nuc:/var/www/html/OpenSSH.zip
ssh com << EOF 1>/dev/null 2>&1
cat /home/win7/.ssh/id_rsa_${suffix}.pub >> /home/win7/.ssh/authorized_keys
chown win7:win7 /home/win7/.ssh/id_rsa*
chmod 600 /home/win7/.ssh/id_rsa*
EOF
``` 
##### # SFX
``` 
;The comment below contains SFX script commands

Silent=1
Overwrite=1
```
##### # Test
```shell
ssh -o "StrictHostKeyChecking=no" -i .ssh/id_rsa -p 22222 -NfD 18888 a@localhost
curl -x socks5h://localhost:18888 http://www.google.com/
```