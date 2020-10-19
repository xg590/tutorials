### SIFTS provides a mapping between PDB and UniProt DB
* It stores the mapping in .xml file per pdb_id.  
* Unlike PDB, this database revise the .xml file quite often so that you cannot know if the mapping changed by comparing md5sum of new version with that of old version. 
* In terms of PDB, you know one PDB structre is revised if its .pdb file changed. 
* To determine if the mapping changed in terms of one particular pdb_id, one can check the <i>database entry version</i> in .xml file
* Here is a python version checking function
```python
>>> import re, subprocess
>>> dbver = re.compile('(?<=dbEntryVersion=").*?(?=")')
>>> def pdb_id_and_sifts_entry_version(pdb_id):
...     cmd = 'curl -sr 0-1000 ftp://ftp.ebi.ac.uk/pub/databases/msd/sifts/xml/{}.xml.gz | zcat 2>/dev/null - | head -n 2'.format(pdb_id)
...     ps = subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE)
...     output = ps.communicate()[0]
...     s = output.decode().split('\n')[1]
...     return re.search(dbver, s).group(0)
...
>>> pdb_id_and_sifts_entry_version('1pwc')
'2011-07-13' # As of Oct 18 2020, the mapping per '1pwc' is unchanged since Jul 13 2011. 
```
