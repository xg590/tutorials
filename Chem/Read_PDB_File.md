```python
import pandas as pd
pd.read_fwf(path_ligand, names=['group','atom_sn','atom_name','alt_loc','res_name',
                                'pdbx_strand_id','seq_id','pdb_ins_code','x','y','z',
                                'occupancy','temp_factor','element','charge'], 
                         colspecs=[( 0, 6), (6,11),  (12,16), (16,17),    
                                   (17,20), (21,22), (22,26), (26,27), 
                                   (30,38), (38,46), (46,54), (54,60), 
                                   (60,66), (76,78), (78,80)         ])
```                                
