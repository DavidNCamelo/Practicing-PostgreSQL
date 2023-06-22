--In this assignment, you will create a table of documents and then produce a GIN-based text[] reverse index for those documents that identifies each document which contains a particular word using SQL.

--FYI: In contrast with the provided sample SQL, you will map all the words in the GIN index to lower case (i.e. Python, PYTHON, and python should all end up as "python" in the GIN index).

--The goal of this assignment is to run these queries:

SELECT id, doc FROM docs03 WHERE '{unconditionally}' <@ string_to_array(lower(doc), ' ');
EXPLAIN SELECT id, doc FROM docs03 WHERE '{unconditionally}' <@ string_to_array(lower(doc), ' ');
--and (a) get the correct document(s) and (b) use the GIN index (i.e. not use a sequential scan).
CREATE TABLE docs03 (id SERIAL, doc TEXT, PRIMARY KEY(id));

CREATE INDEX array03 ON docs03 USING gin(...);
--If you get an operator class error on your CREATE INDEX check the instructions below for the solution.

--Here are the one-line documents that you are to insert into docs03:

INSERT INTO docs03 (doc) VALUES
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

--You should also insert a number of filler rows into the table to make sure PostgreSQL uses its index:

INSERT INTO docs03 (doc) SELECT 'Neon ' || generate_series(10000,20000);
--It might take from a few seconds to a minute or two before PostgreSQL catches up with its indexing. 
--The autograder won't work if the index is incomplete. If the EXPLAIN command says that it is using Seq Scan - the index has not completed yet.
--Run the above EXPLAIN multiple times if necessary until you verify that PostgreSQL has finished making the index:

--Action
DROP INDEX array03;
CREATE INDEX array03 ON docs03 USING gin(string_to_array(LOWER(doc) , ' ') array_ops);

