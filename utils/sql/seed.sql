-- COUNTRIES

INSERT INTO COUNTRY(ID, NAME)
VALUES(CNTRY_SEQ.NEXTVAL, 'Bangladesh');

INSERT INTO COUNTRY(ID, NAME)
VALUES(CNTRY_SEQ.NEXTVAL, 'USA');

INSERT INTO COUNTRY(ID, NAME)
VALUES(CNTRY_SEQ.NEXTVAL, 'Russia');

INSERT INTO COUNTRY(ID, NAME)
VALUES(CNTRY_SEQ.NEXTVAL, 'India');

INSERT INTO COUNTRY(ID, NAME)
VALUES(CNTRY_SEQ.NEXTVAL, 'China');

-- CITIES

INSERT INTO CITY(ID, COUNTRY_ID, NAME)
SELECT CITY_SEQ.NEXTVAL, ID, 'Dhaka'
FROM COUNTRY
WHERE NAME = 'Bangladesh';

INSERT INTO CITY(ID, COUNTRY_ID, NAME)
SELECT CITY_SEQ.NEXTVAL, ID, 'Chittagong'
FROM COUNTRY
WHERE NAME = 'Bangladesh';

INSERT INTO CITY(ID, COUNTRY_ID, NAME)
SELECT CITY_SEQ.NEXTVAL, ID, 'Sylhet'
FROM COUNTRY
WHERE NAME = 'Bangladesh';

INSERT INTO CITY(ID, COUNTRY_ID, NAME)
SELECT CITY_SEQ.NEXTVAL, ID, 'Khulna'
FROM COUNTRY
WHERE NAME = 'Bangladesh';

INSERT INTO CITY(ID, COUNTRY_ID, NAME)
SELECT CITY_SEQ.NEXTVAL, ID, 'Delhi'
FROM COUNTRY
WHERE NAME = 'India';

INSERT INTO CITY(ID, COUNTRY_ID, NAME)
SELECT CITY_SEQ.NEXTVAL, ID, 'Mumbai'
FROM COUNTRY
WHERE NAME = 'India';

INSERT INTO CITY(ID, COUNTRY_ID, NAME)
SELECT CITY_SEQ.NEXTVAL, ID, 'New York'
FROM COUNTRY
WHERE NAME = 'USA';

INSERT INTO CITY(ID, COUNTRY_ID, NAME)
SELECT CITY_SEQ.NEXTVAL, ID, 'Washington'
FROM COUNTRY
WHERE NAME = 'USA';

INSERT INTO CITY(ID, COUNTRY_ID, NAME)
SELECT CITY_SEQ.NEXTVAL, ID, 'Boston'
FROM COUNTRY
WHERE NAME = 'USA';

INSERT INTO CITY(ID, COUNTRY_ID, NAME)
SELECT CITY_SEQ.NEXTVAL, ID, 'Beijing'
FROM COUNTRY
WHERE NAME = 'China';

INSERT INTO CITY(ID, COUNTRY_ID, NAME)
SELECT CITY_SEQ.NEXTVAL, ID, 'Shanghai'
FROM COUNTRY
WHERE NAME = 'China';

INSERT INTO CITY(ID, COUNTRY_ID, NAME)
SELECT CITY_SEQ.NEXTVAL, ID, 'Moscow'
FROM COUNTRY
WHERE NAME = 'Russia';

INSERT INTO CITY(ID, COUNTRY_ID, NAME)
SELECT CITY_SEQ.NEXTVAL, ID, 'Saint Petersburg'
FROM COUNTRY
WHERE NAME = 'Russia';

-- LANGUAGE

INSERT INTO LANGUAGE(ID, NAME, COMMAND)
VALUES(LANG_SEQ.NEXTVAL, 'GNU C++ 14', 'g++.exe -static -DONLINE_JUDGE -lm -s -x c++ -Wl,--stack=268435456 -O2 -std=c++11 -D__USE_MINGW_ANSI_STDIO=0 -o {filename}.exe {file}');

INSERT INTO LANGUAGE(ID, NAME, COMMAND)
VALUES(LANG_SEQ.NEXTVAL, 'JAVA 8', 'javac -cp ".;*" {file} & java.exe -Xmx512M -Xss64M -DONLINE_JUDGE=true -Duser.language=en -Duser.region=US -Duser.variant=US -jar %s');

INSERT INTO LANGUAGE(ID, NAME, COMMAND)
VALUES(LANG_SEQ.NEXTVAL, 'PYTHON 3', 'python.exe %s');

-- RANKS

INSERT INTO RANK(ID, NAME, COLOR, MIN_RATING, MAX_RATING)
VALUES(RANK_SEQ.NEXTVAL, 'Headquarters', 'black', NULL, NULL);

INSERT INTO RANK(ID, NAME, COLOR, MIN_RATING, MAX_RATING)
VALUES(RANK_SEQ.NEXTVAL, 'Unrated', 'black', 0, 0);

INSERT INTO RANK(ID, NAME, COLOR, MIN_RATING, MAX_RATING)
VALUES(RANK_SEQ.NEXTVAL, 'Newbie', 'gray', 1, 1199);

INSERT INTO RANK(ID, NAME, COLOR, MIN_RATING, MAX_RATING)
VALUES(RANK_SEQ.NEXTVAL, 'Pupil', 'green', 1200, 1399);

INSERT INTO RANK(ID, NAME, COLOR, MIN_RATING, MAX_RATING)
VALUES(RANK_SEQ.NEXTVAL, 'Specialist', 'cyan', 1400, 1599);

INSERT INTO RANK(ID, NAME, COLOR, MIN_RATING, MAX_RATING)
VALUES(RANK_SEQ.NEXTVAL, 'Expert', 'blue', 1600, 1899);

INSERT INTO RANK(ID, NAME, COLOR, MIN_RATING, MAX_RATING)
VALUES(RANK_SEQ.NEXTVAL, 'Candidate Master', 'violet', 1900, 2199);

INSERT INTO RANK(ID, NAME, COLOR, MIN_RATING, MAX_RATING)
VALUES(RANK_SEQ.NEXTVAL, 'Master', 'orange', 2200, 2299);

INSERT INTO RANK(ID, NAME, COLOR, MIN_RATING, MAX_RATING)
VALUES(RANK_SEQ.NEXTVAL, 'International Master', 'orange', 2300, 2399);

INSERT INTO RANK(ID, NAME, COLOR, MIN_RATING, MAX_RATING)
VALUES(RANK_SEQ.NEXTVAL, 'Grandmaster', 'red', 2400, 2599);

INSERT INTO RANK(ID, NAME, COLOR, MIN_RATING, MAX_RATING)
VALUES(RANK_SEQ.NEXTVAL, 'International Grandmaster', 'red', 2600, 2899);

INSERT INTO RANK(ID, NAME, COLOR, MIN_RATING, MAX_RATING)
VALUES(RANK_SEQ.NEXTVAL, 'Legendary Grandmaster', 'red', 2900, 9999);