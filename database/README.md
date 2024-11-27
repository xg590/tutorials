### Connect Pandas DataFrame with MySQL
* User root create a database and grant access to user
```shell
mysqladmin create db_name
mysql db_name << EOF 
GRANT ALL ON db_name.* TO 'user'@'localhost' IDENTIFIED BY 'password' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF
```
* Connect to MySQL and test i/o with dataframe
```python
from sqlalchemy import create_engine
sqlEngine = create_engine('mysql+pymysql://user:password@127.0.0.1:3306/db_name')  
conn      = sqlEngine.raw_connection() 
cursor    = conn.cursor() 

import pandas as pd
df = pd.DataFrame([{'col1':1,'col2':2},{'col1':3,'col2':4}])

cursor.execute('CREATE TABLE table1(col1 INTEGER, col2 INTEGER)')
df.to_sql('table1', sqlEngine, index=False, if_exists='append') 
pd.read_sql('SELECT * FROM table1', sqlEngine)
```
* phpmyadmin
```
apt -y update && apt install -y mariadb-server phpmyadmin # configure apache2 automatically
```
### SQLite
* Delete duplicated rows
```sql 
CREATE TABLE sifts_1 (pdb_accessionid TEXT,
                      pdb_chainid     TEXT,
                      pdb_resnum      TEXT,
                      pdb_resname     TEXT, 
                      idx             INTEGER); 

INSERT INTO sifts_1 SELECT *, ROW_NUMBER() OVER(PARTITION BY pdb_accessionid, pdb_chainid, pdb_resnum) AS idx FROM sifts 
DELETE FROM sifts_1 WHERE idx>1 
VACUUM
```
* SELECT every other 20 rows
```sql
SELECT * FROM (
  SELECT *, ROW_NUMBER() OVER(ORDER BY timestamp) AS col_bar FROM log
) table_foo WHERE table_foo.col_bar % 20 = 0 
``` 
