### ACL
* The grid engine system has the following four categories of users:
  * Manager: Total control of the SGE
  * Operator: Same as managers, except for managing queues.
  * Owner: of the queue
  * User: No responsibility in SGE management
* Add new user
  * adduser and copy shadow to other nodes
    ```
    cat /etc/hosts|grep node|cut -d " " -f2
    scp /etc/passwd /etc/shadow $i:/etc/ 
    #scp /etc/group $i:/etc/
    #scp /root/.ssh/authorized_keys node$i:/root/.ssh/
    #scp /etc/hosts node$i:/etc/
    echo node$i 
    ```
### Job Management
* Suspend / Resume Job
```
qmod -sj | -usf (suspend | unsuspend)  
```
### System Config
* Modify scheduler configuration
```
qconf -msconf
```


node84 node94 node95 node96 node97 node100 node105 node109


node75 node77    

Fair share policy
There are two types of fair shares: share tree versus functional.

Make 2 changes in the main SGE configuration ('qconf -mconf'): * enforce_user auto * auto_user_fshare 100

Make 1 change in the SGE scheduler configuration ('qconf -msconf'): * weight_tickets_functional 10000

