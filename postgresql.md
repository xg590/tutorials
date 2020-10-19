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
