## Play PostgreSQL on Ubuntu 20.04
### Basics
#### 1. Installation
```shell
sudo apt-get install -y postgresql python3-dev libpq-dev python3-pip 
pip3 install psycopg2
```
#### 2. Configuration
```shell
echo $USER | xargs sudo -u postgres createuser -s     # Add current user as PostgreSQL superuser
createdb newDB                                        # Create new database
```
#### 3. Python as client
```python
import psycopg2
conn = psycopg2.connect("dbname=newDB") 
cur = conn.cursor()
cur.execute("CREATE TABLE person(name varchar(8), sex varchar(8));")
cur.execute("INSERT INTO person values('Jay','male');")
cur.execute("INSERT INTO person values('Jane','female');")
cur.execute("commit;")
cur.execute("SELECT * FROM person;") 
cur.fetchall()
```
#### 4. psql as client
```shell
$ psql newDB
newDB=# \du                                      // List users newDB=#  
newDB=# \l                                       // List database
newDB=# \d                                       // List tables
newDB=# \d person                                // List columns in table person
newDB=# COPY person FROM stdin;
>>>John[press tab key]female[press enter key]
>>>\.[press enter key]
newDB=# select * from person;                    // List all columns
newDB=# select name from person;                 // Only list column names 
newDB=# select name from person into newperson;  // Duplicate a table
newDB=# \q                                       // Quit
``` 
### Topics 
#### Run PostgreSQL on a new directory.
```shell
ps aux|grep postgres\ -D                                                                       # We need the argument after -D 
sudo -u postgres /usr/lib/postgresql/12/bin/pg_ctl -D /var/lib/postgresql/12/main stop         # Stop  default service
sudo systemctl start postgresql                                                                # Start default service (you can always do this)
sudo -u postgres mkdir /tmp/newdirectory                                                       # A new directory
sudo -u postgres /usr/lib/postgresql/12/bin/initdb -D /tmp/newdirectory                        # Initialize the directory for a new service
sudo -u postgres /usr/lib/postgresql/12/bin/pg_ctl -D /tmp/newdirectory -l /tmp/logfile start  # Start new service
``` 
#### Speedy exact match of long text
```sql
CREATE INDEX ON val_cid (CAST(md5(val) AS uuid));
SELECT   * FROM val_cid WHERE val = 'diethylumbelliferylphosphate' AND md5(val)::uuid = md5('diethylumbelliferylphosphate')::uuid;
SELECT cid FROM val_cid WHERE val = 'diethylumbelliferylphosphate';
```
#### Full-Text Search ([Credit](https://www.digitalocean.com/community/tutorials/how-to-use-full-text-search-in-postgresql-on-ubuntu-16-04)): 
Similarity Search (https://www.postgresql.org/docs/9.4/static/pgtrgm.html)
SELECT val, similarity(val, 'O-ethyl-S-[2[bis(1-methyl-ethyl)amino]ethyl]methylphosphonothioate') AS sml
  FROM val_cid
  WHERE val % 'O-ethyl-S-[2[bis(1-methyl-ethyl)amino]ethyl]methylphosphonothioate'
  ORDER BY sml DESC;

psql -c 'CREATE TABLE inchi2cid(inchi text, cid integer)' search
cat /tmp/test.csv | psql -c "COPY inchi2cid(cid, inchi) FROM STDIN DELIMITER '|'" search
psql -c 'CREATE UNIQUE INDEX inchi_idx ON inchi2cid(inchi)' search

6. More example
```
newDB=# CREATE   TABLE newtable AS SELECT * FROM compound_structures LIMIT 10000; // 
newDB=# ALTER    TABLE users ADD          email      varchar(20);                 // Add column 
newDB=# ALTER    TABLE users ALTER column email type varchar(30);                 // Change column
newDB=# ALTER    TABLE users DROP         email;                                  // Delete column  
newDB=# TRUNCATE TABLE users;                                                     // Purge table
newDB=# DROP     TABLE users;                                                     // delete table
dropdb newDB                                                                      // delete database
psql -c "ALTER USER ${USER} PASSWORD '123456'" newDB                              // Set password for database newDB  
```
9 Join
myDB=# CREATE TABLE customers (
myDB=#     customer_id serial PRIMARY KEY,
myDB=#     customer_name VARCHAR(100)
myDB=# );
myDB=#
myDB=# CREATE TABLE orders (
myDB=#     order_id serial PRIMARY KEY,
myDB=#     customer_id serial,
myDB=#     amount double precision,
myDB=#     FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
myDB=# );
myDB=#
myDB=# INSERT INTO customers (customer_id, customer_name) VALUES
myDB=# (1, 'Adam'),
myDB=# (2, 'Andy'),
myDB=# (3, 'Joe'),
myDB=# (4, 'Sandy');
myDB=#
myDB=# INSERT INTO orders (order_id, customer_id, amount) VALUES
myDB=# (1, 1, 19.99),
myDB=# (2, 1, 35.15),
myDB=# (3, 3, 17.56),
myDB=# (4, 4, 12.34);

9.1 Cross Join (table customers is joined with table orders, each row of customer is put together with all row of order)
myDB=# select * from customers cross join orders;
```


 
 

 


createdb cartridge
psql -c 'create extension rdkit' cartridge
psql -c 'create table pubmed (cid integer primary key, name text, canonical text, isomeric text, mols mol, numheavyatoms integer)' cartridge
cat compound.1000 | psql -c "copy pubmed (cid, name, canonical, isomeric) from stdin with delimiter '|'" cartridge 
psql -c 'update pubmed set mols = mol_from_smiles(canonical::cstring)' cartridge
psql -c 'update pubmed set numheavyatoms = mol_numheavyatoms(mols)' cartridge 
psql -c 'alter table pubmed drop column mols' cartridge
psql -c 'select cid from pubmed where numheavyatoms between 10 and 12 ' cartridge


psql -c 'select name from pubmed where name like 'phenol' and cid in (select cid from pubmed where numheavyatoms between 10 and 12) ' cartridge

psql -c "select * from pubmed where if cid in (select cid from pubmed where numheavyatoms between 10 and 12) name like '%phenol%' and " cartridge 
