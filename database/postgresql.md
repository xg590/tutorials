### Basics (Ubuntu 20.04)

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
cur.execute("CREATE TABLE person(name VARCHAR(8), sex VARCHAR(8));")
cur.execute("INSERT INTO  person VALUES('Jay','male');")
cur.execute("INSERT INTO  person VALUES('Jane','female');")
cur.execute("commit;")
cur.execute("SELECT * FROM person;") 
cur.fetchall()
```
#### 4. psql as client
```sql
$ psql newDB
newDB=# CREATE TABLE news (
   id SERIAL PRIMARY KEY,
   title TEXT NOT NULL,
   content TEXT NOT NULL,
   author TEXT NOT NULL
); 
newDB=# INSERT INTO news (id, title, content, author) VALUES 
    (1, 'Pacific Northwest high-speed rail line', 'Currently there are only a few options for traveling the 140 miles between Seattle and Vancouver and none of them are ideal.', 'Greg'),
    (2, 'Hitting the beach was voted the best part of life in the region', 'Exploring tracks and trails was second most popular, followed by visiting the shops and then checking out local parks.', 'Ethan'),
    (3, 'Machine Learning from scratch', 'Bare bones implementations of some of the foundational models and algorithms.', 'Jo'); 
```
#### 5. Restart the server
``` 
sudo -u postgres /usr/lib/postgresql/12/bin/pg_ctl -D /var/lib/postgresql/12/main stop # Stop  default service 
sudo -u postgres /usr/lib/postgresql/12/bin/pg_ctl -D /home/xxx/postgresql/       start
pg_dump dbname > db.bak
```

### Topics 
#### Meta-Command
```sql
postgres=# \list              list database
postgres=# \connect           change database
postgres=# \dn                list schemas
postgres=# \dt                list table \dt schemas.*
postgres=# \d                 list column
```
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
CREATE INDEX ON table_name (CAST(md5(index_name) AS uuid));
SELECT   * FROM table_name WHERE index_name = 'diethylumbelliferylphosphate' AND md5(index_name)::uuid = md5('diethylumbelliferylphosphate')::uuid;
SELECT cid FROM table_name WHERE index_name = 'diethylumbelliferylphosphate';
```
#### Full-Text Search ([Official Doc](https://www.postgresql.org/docs/12/textsearch.html)): 
1. Document preprocessing -- Tokenization</br>
Preprocessed document is stored as tsvector (data type)
```sql
newDB=# SELECT $$the lexeme 'Joe''s' contains a quote$$::tsvector;
                    tsvector
------------------------------------------------
 'Joe''s' 'a' 'contains' 'lexeme' 'quote' 'the'
```
2. Query preprocessing</br> 
Query is converted to tsquery
```sql
newDB=# SELECT 'fat & rat'::tsquery;
    tsquery
---------------
 'fat' & 'rat'
```
3. Matching
```sql
SELECT 'a fat cat sat on a mat and ate a fat rat'::tsvector @@ 'cat & rat'::tsquery; // & is AND
 ?column?
----------
 t(rue)

SELECT 'fat & cow'::tsquery @@ 'a fat cat sat on a mat and ate a fat rat'::tsvector; // tsquery-tsvector order is not important 
 ?column?
----------
 f(alse)
```
4. Normalization
```sql
SELECT 'a fat cats sat on a mat and ate a fat rat'::tsvector @@ 'cat & rat'::tsquery; // cats is not normalized so no match
 ?column?
----------
 f(alse)

SELECT to_tsvector('a fat cats sat on a mat and ate a fat rat') @@ 'cat & rat'::tsquery; // normalization is proformed 
 ?column?
----------
 t(rue)
```
5. Phrase
```sql
SELECT to_tsvector('fatal error') @@ to_tsquery('fatal <-> error'); // equals ... @@ phraseto_tsquery('fatal error')
 ?column? 
----------
 t 
```
6. Use table <i>news</i> for experiment
```sql
newDB=# SELECT id FROM news WHERE to_tsvector(content) @@ to_tsquery('models & algorithms'); // return id where content has model and algorithm in it. 
 id
----
  3 
```
7. Create index 
```sql
CREATE INDEX foo_idx ON news USING GIN (to_tsvector('content));
```
* An Alternative<br> 
```sql
ALTER TABLE news // Add a dedicated column to store index 
    ADD COLUMN vectorized_content tsvector
               GENERATED ALWAYS AS (to_tsvector('english', content)) STORED; 
CREATE INDEX foo_idx ON news USING GIN (vectorized_content); // Create index on the dedicated column
``` 
8. Headline
```
SELECT ts_headline('english', 'The most common type of search is to find all documents containing given query terms and return them in order of their similarity to the query.', to_tsquery('query & similarity'));
```
#### Explain
```
explain (analyze,buffers) select * from t1 where c1 like '%存储过程%';
```
#### JOIN
```sql
SELECT table1.column1, table2.column1 FROM table1 JOIN table2 ON table1.column2=table2.column2;
``` 
