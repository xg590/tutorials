## Neo4j 4.1
### Installation ([Credit](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-neo4j-on-ubuntu-20-04))
```
sudo apt update && sudo apt install apt-transport-https ca-certificates curl software-properties-common 
curl -fsSL https://debian.neo4j.com/neotechnology.gpg.key | sudo apt-key add -  
sudo add-apt-repository "deb https://debian.neo4j.com stable 4.1"
sudo apt install neo4j
sudo systemctl enable neo4j.service  
sudo systemctl status neo4j.service 
```
or go and download [openjdk-11](https://jdk.java.net/archive/) and [neo4j community server](https://neo4j.com/download-center/#community) 
### Make the server public
```
sudo bash -c 'cat >> /etc/neo4j/neo4j.conf' << EOF 
dbms.default_listen_address=0.0.0.0
EOF
sudo systemctl restart neo4j.service
```
### Connection
Use default neo4j/neo4j as username/password 
CLI: 
```python
cypher-shell 
```
Browser:
```
visit http://localhost:7474/
```
Python ([manual.4.1.pdf](https://neo4j.com/docs/pdf/neo4j-driver-manual-4.1-python.pdf))
```python
pip install neo4j
from neo4j import GraphDatabase, WRITE_ACCESS 
with GraphDatabase.driver("neo4j://192.168.56.101:7687", auth=("neo4j", "a")) as driver:
    with driver.session(default_access_mode=WRITE_ACCESS) as session: 
        session.run("CREATE (p1:Person { name: $foo })", foo='john')  # add a new node 
```
### Cypher Query Syntax
#### Create John loves Jane
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
#### Investigate what we have put into the graph.
  1. return three object
``` 
MATCH (p1:Person)-[r:LOVES]->(p2:Person) RETURN p1, r, p2
```
  2. return one object
``` 
MATCH path = (:Person)-[:LOVES]->(:Person) RETURN path
```
#### Aggregates
  1. Create a new lover for John
```
MATCH (p1:Person { name: "John" }) CREATE (p1)-[r:LOVES]->(p2:Person { name: "Catherine" })
```
  2. How many lovers does john have
```
MATCH (p)-[:LOVES]->(:Person) WHERE p.name='John' RETURN p.name, count(*) as number_of_lovers
```
#### Merge
  1. Match and set. No match, then create and set. 
```
MERGE (p:Person {name: 'David'}) SET p.age=24 RETURN p
```
  2. No match, no set. It would not create David. 
```
MATCH (p:Person {name: 'David'}) SET p.age=24 RETURN p
```
#### Constraint (requires Neo4j Enterprise Edition)
```
CREATE CONSTRAINT ON (p:Person) ASSERT EXISTS(p.name)
```
#### Index
```
CREATE INDEX FOR (p:Person) ON (p.name)
```
#### Delete relationship and node
```
MATCH ()-[r:LOVES]-() DELETE r; MATCH (n:Person) DELETE n
```
#### Create/Delete new database (requires Neo4j Enterprise/Desktop Edition)
```
CREATE/DROP DATABASE test
```
#### Stop/Start database (requires Neo4j Enterprise/Desktop Edition)
After stop, database becomes "unavailable" and its status becomes "offline".
```
STOP/START DATABASE customers
``` 
### Import CSV
Guide query: 
```
:play http://guides.neo4j.com/fundamentals/import.html
```
```
LOAD CSV WITH HEADERS
FROM 'https://raw.githubusercontent.com/xg590/tutorials/master/database/person.csv'
AS row123
CREATE (:Person { name: row123.name, age: toInteger(row123.age)}); 
```
### Dump and load (Make it work for community edition)
Dump (Stop neo4j first)
```
neo4j-admin dump --database=neo4j --to=/path/of/dump.file
```
Load 
```
neo4j-admin load --database=graph.db --from=/path/of/dump.file 
```
Additional work ([Credit](https://community.neo4j.com/t/create-multiple-databases-in-community-version/5025/2))
```
cd neo4j-community-4.1.3/
cat << EOF >> conf/neo4j.conf
dbms.active_database=graph.db
EOF
```
## Migrate from Neo4j 3.5 to 4.x ([Video](https://www.youtube.com/watch?v=GcaJ-aVLzr4))
