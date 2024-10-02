
## Sun Grid Engine (SGE)
#### Installation Preparation
* Needed packages: sge-6_2u4-bin-linux24-x64.tar.gz sge-6_2u4-common.tar.gz
  ```
  sudo su # Change to root
  export SGE_ROOT=/some_directory
  mkdir $SGE_ROOT
  tar zxf sge-6_2u4-bin-linux24-x64.tar.gz -C $SGE_ROOT
  tar zxf sge-6_2u4-bin-linux24-x64.tar.gz -C $SGE_ROOT
  ```
* Configure hostname in /etc/hostname and /etc/hosts
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