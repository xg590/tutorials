# Sun Grid Engine (SGE)
### Installation Preparation
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
Answers to any question by using <b>ENTER</b> key <b>EXCEPT</b>:  <br>
* Install SGE under an user id other than >root< (y/n) [y] >> n  <br>
* How do you want to configure the Grid Engine communication ports? >shell environment< or >/etc/service<, >NIS/NIS+< (default: 2) >> 2  <br>
The above question will be asked twice, first for the communication of the program <b><i>sge_qmaster</i></b>, second for the program <b><i>sge_execd</i></b>  <br> 
* Do you want to enable the JMX MBean server (y/n) [y] >> n  <br> 
* Do you want to add your shadow host(s) now? (y/n) [y] >> n 

### Interactive Installation of execd
```
source /home/sge/default/common/settings.sh
cd $SGE_ROOT
./install_execd
```
Answers to any question by using <b>ENTER</b> key <br>
### Start / Stop Grid Engine
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

### Submit A Test Interactive Job
```
qlogin -l h[ostname]=master # Run job on a host whose name is master. -l option is to list the requested resource
``` 
### Configuration
#### Turn on scheduler info 
Otherwise, see "scheduling info: (Collecting of scheduler job information is turned off)" when use qstat -j job_id
```
qconf -msconf # Modify scheduler configuration
``` 
schedd_job_info: false -> true 
#### Create a Parallel Environment (PE) profile
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
### MPI Job Submission (testing the installation) 
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
### Suspend / Resume Job
```
qmod -sj | -usf (suspend | unsuspend)  
```
