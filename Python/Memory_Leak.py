import resource, os, subprocess
def ram(): 
    print("RAM usage: %s Megabytes" % subprocess.run('ps u -p '+ os.getpid().__str__() + "| awk '{sum=sum+$6}; END {print sum/1024}';", stdout=subprocess.PIPE, shell=True).stdout[:-1].decode())
print('# How many memory is the python program using')
ram()                               
print('\n# We are going to waste 1 Gigabyte memory by storing 2.5E7 4-byte integers in a list.') 
b = [i for i in range(int(2.5e7))]  
print('# How many memory is the python program using')
ram()                           
print('\n# Deleting the list will release memory')      
del b                   
print('# How many memory is the python program using')              
ram()                               

class A(object):
    b = [i for i in range(int(2.5e7))]      
print('\n# Create an object')
a = A()                           
print('# How many memory is the python program using')  
ram()                   
print('\n# self referencing')        
a.obj = a                       
print('# delete the obj')                    
del a                      
ram()                             
print('\n# No memory released! Memory leaked') 

print('\n# Repeat memory leaking code')   
class A(object):
    b = [i for i in range(int(2.5e7))]   
a = A()                               
a.obj = a                               
del a                      
ram()                        
