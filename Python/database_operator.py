def func(): 
    while True: 
        foo = q_in.get()  # 1 (get nothing, get blocked)          
        bar = False       # 4   
        print(foo)
        q_out.put(bar)    # 5    
        q_out.join()      # 7 
        q_in.task_done()  #      

def operator(foo): 
    q_in.join()        # 2 (nothing to get so not blocked)         
    q_in.put(foo)      # 3 (put something, q_in.get() succeed)        
    bar = q_out.get()  # 6         
    q_out.task_done()  #           
    return bar         #   

import queue, threading
q_in, q_out = queue.Queue(), queue.Queue() 
threading.Thread(target=func, name='thread-1', daemon=True).start()