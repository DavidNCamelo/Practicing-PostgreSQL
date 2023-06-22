--In this assignment, you will create a table of documents and then produce a reverse index for those documents that identifies each document which contains a particular word using SQL.

--FYI: In contrast with the provided sample SQL, you will map all the words in the reverse index --to lower case (i.e. Python, PYTHON, and python should all end up as "python" in the inverted index).


CREATE TABLE docs01 (id SERIAL, doc TEXT, PRIMARY KEY(id));

CREATE TABLE invert01 (
  keyword TEXT,
  doc_id INTEGER REFERENCES docs01(id) ON DELETE CASCADE
);
--Here are the one-line documents that you are to insert into docs01:
INSERT INTO docs01 (doc) VALUES
('There is little to be gained by arguing with Python It is just a tool'),
('It has no emotions and it is happy and ready to serve you whenever you'),
('need it Its error messages sound harsh but they are just Pythons call'),
('for help It has looked at what you typed and it simply cannot'),
('understand what you have entered'),
('Python is much more like a dog loving you unconditionally having a few'),
('key words that it understands looking you with a sweet look on its face'),
('understands When Python says SyntaxError invalid syntax it is'),
('simply wagging its tail and saying You seemed to say something but I'),
('just dont understand what you meant but please keep talking to me');
--Here is a sample for the first few expected rows of your reverse index:

SELECT keyword, doc_id FROM invert01 ORDER BY keyword, doc_id LIMIT 10;

--keyword    |  doc_id
-------------+--------
--a          |    1    
--a          |    6    
--a          |    7    
--and        |    2    
--and        |    4    
--and        |    9    
--are        |    3    
--arguing    |    1    
--at         |    4    
--be         |    1


--Action
SELECT DISTINCT id, s.keyword AS keyword
FROM docs01 AS D, unnest(string_to_array(D.doc, ' ')) s(keyword)
ORDER BY id;

SELECT * FROM docs01 LIMIT 3;

DELETE FROM invert01;
INSERT INTO invert01 (doc_id, keyword)
SELECT DISTINCT id, LOWER(s.keyword) AS keyword
FROM docs01 AS D, unnest(string_to_array(D.doc, ' ')) s(keyword)
ORDER BY id;

SELECT * FROM invert01 ORDER BY keyword LIMIT 10;