
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
#### Explain
```
explain (analyze,buffers) select * from t1 where c1 like '%存储过程%';
```
#### JOIN
```sql
SELECT table1.column1, table2.column1 FROM table1 JOIN table2 ON table1.column2=table2.column2;
```

## Neo4j
### Basics 
#### Installation ([Credit](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-neo4j-on-ubuntu-20-04))
```
sudo apt update && sudo apt install apt-transport-https ca-certificates curl software-properties-common 
curl -fsSL https://debian.neo4j.com/neotechnology.gpg.key | sudo apt-key add -  
sudo add-apt-repository "deb https://debian.neo4j.com stable 4.1"
sudo apt install neo4j
sudo systemctl enable neo4j.service  
sudo systemctl status neo4j.service 
```
#### Make the server public
```
sudo bash -c 'cat >> /etc/neo4j/neo4j.conf' << EOF 
dbms.default_listen_address=0.0.0.0
EOF
sudo systemctl restart neo4j.service
```
#### Connection
Use default neo4j/neo4j as username/password 
CLI: 
```python
cypher-shell 
```
Browser:
```
visit 
http://localhost:7474/
```
Python ([manual.4.1.pdf](https://neo4j.com/docs/pdf/neo4j-driver-manual-4.1-python.pdf))
```python
pip install neo4j
from neo4j import GraphDatabase, WRITE_ACCESS 
with GraphDatabase.driver("neo4j://192.168.56.101:7687", auth=("neo4j", "a")) as driver:
    with driver.session(default_access_mode=WRITE_ACCESS) as session: 
        session.run("CREATE (p1:Person { name: $foo })", foo='john')  # add a new node 
```
#### Cypher Query Syntax
##### Create John loves Jane
  1. Create two nodes. p1/p2 are varibles, Person is label and name is property and John/Jane are values. 
``` 
CREATE (p1:Person { name: 'John' }) 
CREATE (p2:Person { name: 'Jane' })
```
  2. Create a relationship. LOVES (use UPPERCASE as a ritual ) is the type.
```
MATCH  (p3:Person { name: 'John' })
MATCH  (p4:Person { name: 'Jane' })
CREATE (p3)-[:LOVES]->(p4)
```
  3. Combine 1&2 together
```
CREATE (p1:Person { name: "John" })-[r:LOVES]->(p2:Person { name: "Jane" })
```
##### Investigate what we have put into the graph.
  1. return three object
``` 
MATCH (p1:Person)-[r:LOVES]->(p2:Person) RETURN p1, r, p2
```
  2. return one object
``` 
MATCH path = (:Person)-[:LOVES]->(:Person) RETURN path
```
##### Aggregates
  1. Create a new lover for John
```
MATCH (p1:Person { name: "John" }) CREATE (p1)-[r:LOVES]->(p2:Person { name: "Catherine" })
```
  2. How many lovers does john have
```
MATCH (p)-[:LOVES]->(:Person) WHERE p.name='John' RETURN p.name, count(*) as number_of_lovers
```
##### Merge
  1. Match and set. No match, then create and set. 
```
MERGE (p:Person {name: 'David'}) SET p.age=24 RETURN p
```
  2. No match, no set. It would not create David. 
```
MATCH (p:Person {name: 'David'}) SET p.age=24 RETURN p
```
##### Constraint (requires Neo4j Enterprise Edition)
```
CREATE CONSTRAINT ON (p:Person) ASSERT EXISTS(p.name)
```
##### Index
```
CREATE INDEX FOR (p:Person) ON (p.name)
```
##### DELETE relationship and node
```
MATCH ()-[r:LOVES]-() DELETE r; MATCH (n:Person) DELETE n
```
