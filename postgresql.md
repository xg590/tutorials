## Full-Text Search in PostgreSQL on Ubuntu 16.04 : https://www.digitalocean.com/community/tutorials/how-to-use-full-text-search-in-postgresql-on-ubuntu-16-04

Search One Column (ExactlyMatch)
CREATE INDEX ON val_cid (CAST(md5(val) AS uuid));
SELECT * FROM val_cid WHERE val = 'diethylumbelliferylphosphate' AND md5(val)::uuid = md5('diethylumbelliferylphosphate')::uuid;
select cid from val_cid where val = 'diethylumbelliferylphosphate';

Similarity Search (https://www.postgresql.org/docs/9.4/static/pgtrgm.html)
SELECT val, similarity(val, 'O-ethyl-S-[2[bis(1-methyl-ethyl)amino]ethyl]methylphosphonothioate') AS sml
  FROM val_cid
  WHERE val % 'O-ethyl-S-[2[bis(1-methyl-ethyl)amino]ethyl]methylphosphonothioate'
  ORDER BY sml DESC;

psql -c 'CREATE TABLE inchi2cid(inchi text, cid integer)' search
cat /tmp/test.csv | psql -c "COPY inchi2cid(cid, inchi) FROM STDIN DELIMITER '|'" search
psql -c 'CREATE UNIQUE INDEX inchi_idx ON inchi2cid(inchi)' search


module purge
module load anaconda3/4.3.1
conda create -n rdkit -c rdkit python=2.7 rdkit rdkit-postgresql95
source activate rdkit
mkdir rdkit-postgresql
initdb -D rdkit-cartridge
vim rdkit-cartridge/postgresql.conf
 synchronous_commit = off     
 full_page_writes = off        
 shared_buffers = 75GB
 work_mem = 1024MB           
pg_ctl start -D rdkit-cartridge



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


1. Installation of both server and client
$ sudo apt-get install postgresql

2. Initialize a new Directory and run PostgreSQL Service
$ sudo su - postgresql
$ ps aux|grep pg_ctl // In this way, the directory for running DB can be located
$ /usr/lib/postgresql/9.5/bin/pg_ctl -D /var/lib/postgresql/9.5/main stop // Stop current service
$ /usr/lib/postgresql/9.5/bin/initdb -D /newdirectory // initialize a new directory for new service
$ /usr/lib/postgresql/9.5/bin/pg_ctl -D newdirectory -l logfile start

2. Add current user as PostgreSQL superuser
$ echo $USER | xargs sudo -u postgres createuser -s
$ echo $USER | xargs sudo usermod -aG postgres

3. Create new DataBase and list existed DataBase
$ createdb newDB
$ psql -l 

4. Explorer newDB
$ psql newDB
newDB=# \du // List users newDB=# create table person(name varchar(8), sex varchar(8));
newDB=# insert into person values('Jay','male'); // fill table by insertion
newDB=# \l // List database
newDB=# \d // List tables
newDB=# \d person // List columns in table person
newDB=# copy person from stdin;
>>>Joe[press tab key]female[press enter key]
>>>\.[press enter key]
newDB=# select * from person; // List all columns
newDB=# select name from person; // Only list column names 
newDB=# select name from person into newperson; // duplicate person as new person
newDB=# \q // Quit

5. Set password for database newDB
$ psql newDB
newDB=# \password USERNAME
newDB=# \q

6. psycopg2 example
import psycopg2
conn = psycopg2.connect("dbname=newDatabase user=user_name")
cur = conn.cursor()
cur.execute("SELECT * FROM person;")
cur.fetchall()

7
newDB=# create table newtable as select * from compound_structures limit 10000;


8.
create database
$ createdb myDB
show database
$ psql -l
delete database
$ dropdb myDB
connect database
$ psql myDB
create table (in database when connected)
myDB=# create table users (id int primary key, username varchar(10));
show table
myDB=# \d
show details of a specific table
myDB=# \d users
delete table
myDB=# drop table users
modify table (add)
myDB=# alter table users add email varchar(20);
modify table (delete column)
myDB=# alter table users drop email;
modify table (change column)
myDB=# alter table users alter column email type varchar(30) ;
purge table 
myDB=# truncate table users;

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





sudo apt-get install postgresql -y
sudo su - postgres
ps aux|grep /usr/lib/postgresql
/usr/lib/postgresql/10/bin/pg_ctl -D /var/lib/postgresql/10/main/ stop
mkdir /tmp/newDirectory
/usr/lib/postgresql/10/bin/initdb -D /tmp/newDirectory
/usr/lib/postgresql/10/bin/pg_ctl -D /tmp/newDirectory start
exit
echo $USER | xargs sudo -u postgres createuser -s
createdb newDB

wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
mkdir ~/software
bash Miniconda3-latest-Linux-x86_64.sh -b -f -p ~/software/miniconda3/
~/software/miniconda3/bin/conda create -n envNameYouLike python=3.6 -y
source ~/software/miniconda3/bin/activate envNameYouLike
pip install jupyter psycopg2

mkdir ~/.jupyter/
cat << EOF > ~/.jupyter/jupyter_notebook_config.py
c.NotebookApp.ip = '192.168.56.100'
c.NotebookApp.password = 'sha1:ffed18eb1683:ee67a85ceb6baa34b3283f8f8735af6e2e2f9b55'
EOF
nohup jupyter notebook 1>/dev/null 2>&1 &

import psycopg2
conn = psycopg2.connect("dbname='newDB' user='a'")
cur = conn.cursor()
cur.execute("""SELECT datname from pg_database""")
cur.fetchall()













