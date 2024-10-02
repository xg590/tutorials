
### Parallel Environment (PE) 
#### Glossary 
* <b>Logical CPU Core</b>: Abstract executing unit of the running code. <br>
* <b>Physical CPU Core</b>: Electronic Logic circuit that runs the code. Due to hyperthreading (HT) tech, one physical core might consists of two logcial cores. <br>
* <b>CPU Socket</b>: Socket to place the multi-core CPU chip on the motherboard. Server motherboard tends to have more sockets. <br>
* <b>MPI Process</b>: Running code featuring the information change with other copies.  <br>
* <b>Slot</b>: Abstract executing unit of a MPI process. Number of Slot is better not larger than the number of physical cpu cores when the MPI task is cpu-bound (computationally intensive). <br> 
#### Create a Parallel Environment (PE) profile
```
qconf -ap new_pe_profile
```
See the help page <i>man sge_pe</i> for detail
#### MPI Job Submission (testing the installation) 
* Create a MPI program
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
  
  	printf("Processor %d of %d on %s\n",my_rank,num_procs,       processor_name);
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
  	  printf("PI is %.20f, error is %.20f\n", pi, fabs(pi-3.       141592653589793238462643));
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

* If a new PE profile is created and used, it should be added to the queue configuration first.
  ```
  qconf -mattr queue pe_list new_pe_profile all.q
  ```
* Submit a test non-interactive/batch job that specified pe profile
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
  export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$OPENMPI_ROOT/  lib
  EOF
  qsub -pe new_pe_profile 4 test_pe.sh
  ```
* Now a new bash is gained in executive host (exec_host)
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