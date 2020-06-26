### Preparation
Needed packages: sge-6_2u4-bin-linux24-x64.tar.gz sge-6_2u4-common.tar.gz
```
sudo su # Change to root
export SGE_ROOT=/some_directory
mkdir $SGE_ROOT
tar zxf sge-6_2u4-bin-linux24-x64.tar.gz -C $SGE_ROOT
tar zxf sge-6_2u4-bin-linux24-x64.tar.gz -C $SGE_ROOT
```
### Interactive Installation of qmaster
```
cd $SGE_ROOT
./util/setfileperm.sh $SGE_ROOT
./install_qmaster
```
Answers to the following questions: 
Install SGE under an user id other than >root< (y/n) [y] >> n  <br>
How do you want to configure the Grid Engine communication ports? >shell environment< or >/etc/service<, >NIS/NIS+< (default: 2) >> 2  <br>
The above question will be asked twice, first for the communication of the program <b><i>sge_qmaster</i></b>, second for the program <b><i>sge_execd</i></b>  <br> 
Do you want to enable the JMX MBean server (y/n) [y] >> n  <br> 
Do you want to add your shadow host(s) now? (y/n) [y] >> n  <br> 
Answers to any other question: <b>using ENTER key</b>
### Interactive Installation of execd
```
export SGE_ROOT=/some_directory
cd $SGE_ROOT
./install_execd
```
Answers to any question: <b>using ENTER key</b>
### Queue configuration
