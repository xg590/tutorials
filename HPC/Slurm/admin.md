### SLURM
#### How to prioritize jobs on nodes
* Without IGNORE_JOBS, reservation will fail if node-35 is running jobs.
  ```sh
  # scontrol create reservation reservation=test1 starttime=now duration=4:00:00 nodes=node-35 users=a 
  Error creating the reservation: Requested nodes are busy
  ```
* Reserve the node if jobs are running on the node? 
  ```sh
  scontrol create reservation ReservationName=test2 starttime=now duration=3-00:00:00 nodes=node-11 flags=IGNORE_JOBS users=a 
  ```
* Use the reservation
  ```sh
  sbatch --reservation=test3
  ```
* Change the reserv
  ```sh
  scontrol update ReservationName=<name> <field>=<value> ...
  ``` 
#### 
  ```
    scontrol update nodename=node-2 state=idle
    
    srun --nodelist=node-3 --chdir /tmp --pty /bin/bash
  ```
#### Maintainence
```
scontrol update nodename=node-37 state=idle && sleep 10 && scontrol update nodename=node-37 state=drain reason="maintenance"
```
#### Expand hostlist
```sh
scontrol show hostnames node-[2,6-7,11,17-18]
```