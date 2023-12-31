--Here is the structure of the tables you will need for this assignment:

DROP TABLE unesco_raw;
CREATE TABLE unesco_raw
 (name TEXT, description TEXT, justification TEXT, year INTEGER,
    longitude FLOAT, latitude FLOAT, area_hectares FLOAT,
    category TEXT, category_id INTEGER, state TEXT, state_id INTEGER,
    region TEXT, region_id INTEGER, iso TEXT, iso_id INTEGER);

CREATE TABLE category (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);

-- More tables needed
--To load the CSV data for this assignment use the following copy command. Adding HEADER causes the CSV loader to skip the first line in the CSV file. The \copy command must be one long line.
\copy unesco_raw(name,description,justification,year,longitude,latitude,area_hectares,category,state,region,iso) FROM 'whc-sites-2018-small.csv' WITH DELIMITER ',' CSV HEADER;


--Normalize the data in the unesco_raw table by adding the entries to each of the lookup tables (category, etc.) 
--and then adding the foreign key columns to the unesco_raw table. Then make a new table called unesco that removes all of the un-normalized redundant text columns like category.
--If you run the program multiple times in testing or with different files, make sure to empty out the data before each run.

--The autograder will look at the unesco table.

T--o grade this assignment, the program will run a query like this on your database and look for the data it expects to see:

SELECT unesco.name, year, category.name, state.name, region.name, iso.name
  FROM unesco
  JOIN category ON unesco.category_id = category.id
  JOIN iso ON unesco.iso_id = iso.id
  JOIN state ON unesco.state_id = state.id
  JOIN region ON unesco.region_id = region.id
  ORDER BY iso.name, unesco.name
  LIMIT 3;


--All of this is resolved in a command interface
--Resolving
--First step inserting data and normalizing this. All data comes from unesco_raw and
--is necessary to export that data in each corresponding table

--Action
INSERT INTO category (name) SELECT DISTINCT category FROM unesco_raw;
	-- Result
	SELECT * FROM category;
-- id |   name   
------+----------
--  1 | Mixed
--  2 | Natural
--  3 | Cultural

--Action
CREATE TABLE iso (
	id SERIAL,
	name VARCHAR (128) UNIQUE,
	PRIMARY KEY (id)
);

INSERT INTO iso (name) SELECT DISTINCT iso FROM unesco_raw;
--Result
	SELECT * FROM iso;
--id  | name 
-------+------
--   1 | sm
--   2 | fj
--   3 | bd
--   4 | np
--   5 | vu
--   6 | fr
--   7 | bh
--   8 | sk
--   9 | pa
--  10 | 
--  11 | ke
--  12 | me
--  13 | bz
--  14 | nz
--  15 | bg
--  16 | ru
--  17 | mg
--  18 | ni
--  19 | pe
--  20 | sg
--  21 | hr
--  22 | cn
--  23 | al
--  24 | sd
--  25 | cr
--  26 | mu
--  27 | ee
--  28 | cv
--  29 | ec
--  30 | jm
--  31 | vn
--  32 | sa
--  33 | mm
--  34 | kh
--  35 | mw
--  36 | hn

--Action
CREATE TABLE state (
	id SERIAL,
	name VARCHAR (128) UNIQUE,
	PRIMARY KEY (id)
);

INSERT INTO state (name) SELECT DISTINCT state FROM unesco_raw;

--Result
INSERT 0 163
SELECT * FROM state LIMIT 5;
-- id |                name                 
------+-------------------------------------
--  1 | Indonesia
--  2 | Bangladesh
--  3 | Jerusalem (Site proposed by Jordan)
--  4 | Iran (Islamic Republic of)
--  5 | Kiribat

--Action
CREATE TABLE region (
	id SERIAL,
	name VARCHAR (128) UNIQUE,
	PRIMARY KEY (id)
);

INSERT INTO region (name) SELECT DISTINCT region FROM unesco_raw;

--Result
INSERT 0 5
SELECT * FROM region;
-- id |              name               
------+---------------------------------
--  1 | Asia and the Pacific
--  2 | Arab States
--  3 | Africa
--  4 | Latin America and the Caribbean
--  5 | Europe and North America

--Action
UPDATE unesco_raw SET category_id = (SELECT category.id FROM category WHERE category.name = unesco_raw.category);
UPDATE unesco_raw SET iso_id = (SELECT iso.id FROM iso WHERE iso.name = unesco_raw.iso);
UPDATE unesco_raw SET state_id = (SELECT state.id FROM state WHERE state.name = unesco_raw.state);
UPDATE unesco_raw SET region_id = (SELECT region.id FROM region WHERE region.name = unesco_raw.region);

ALTER TABLE unesco_raw RENAME TO unesco;

ALTER TABLE unesco
DROP COLUMN category,
DROP COLUMN state,
DROP COLUMN region,
DROP COLUMN iso;



SELECT unesco.name, unesco.year, category.name, state.name, region.name, iso.name
  FROM unesco
  JOIN category ON unesco.category_id = category.id
  JOIN iso ON unesco.iso_id = iso.id
  JOIN state ON unesco.state_id = state.id
  JOIN region ON unesco.region_id = region.id
  ORDER BY iso.name, unesco.name
  LIMIT 3;

--Result
--                                  name                                   | year |   name   |         name         |           name           | name 
---------------------------------------------------------------------------+------+----------+----------------------+--------------------------+------
-- Madriu-Perafita-Claror Valley                                           | 2004 | Cultural | Andorra              | Europe and North America | ad
-- Cultural Sites of Al Ain (Hafit, Hili, Bidaa Bint Saud and Oases Areas) | 2011 | Cultural | United Arab Emirates | Arab States              | ae
-- Cultural Landscape and Archaeological Remains of the Bamiyan Valley     | 2003 | Cultural | Afghanistan          | Asia and the Pacific     | af



