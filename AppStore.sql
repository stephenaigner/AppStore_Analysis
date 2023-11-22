**Exploratory Analysis**

--Combing data sets
CREATE TABLE apple_store_description AS
SELECT * FROM appleStore_description1 
UNION ALL
SELECT * FROM appleStore_description2
UNION ALL
SELECT * FROM appleStore_description3
UNION ALL
SELECT * FROM appleStore_description4;

--Check number of unique apps in both tables
SELECT COUNT(DISTINCT id) AS UniqueID FROM AppleStore

SELECT COUNT(DISTINCT id) AS UniqueID FROM apple_store_description

--Check for any missing values in the key fields
SELECT COUNT(*) AS missingvalues
FROM AppleStore
WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL

SELECT COUNT(*) AS missingvalues
FROM apple_store_description
WHERE app_desc IS NULL

--Find out number of apps per genre
SELECT prime_genre, COUNT(*) AS num_apps
FROM AppleStore
GROUP BY prime_genre
ORDER BY num_apps DESC;

--Find minimum, maximum, and average app rating
SELECT MIN(user_rating) AS min_rating, 
MAX(user_rating) AS max_rating, 
ROUND(AVG(user_rating),2) AS avg_rating
FROM AppleStore


**Data Analysis**

--Determine if paid apps have higher ratings than free apps
SELECT CASE WHEN price > 0 THEN 'Paid App' ELSE 'Free App' END AS App_Type,
round(avg(user_rating),2) AS avg_rating
FROM AppleStore
GROUP BY App_Type;

--Do apps with more supported languages have higher ratings?
SELECT CASE WHEN lang_num < 10 THEN 'Under 10 languages'
WHEN lang_num BETWEEN 10 AND 30 THEN 'Between 10 and 30 languages'
ELSE 'More than 30 languages' 
END AS App_Languages,
round(avg(user_rating),2) AS avg_rating
FROM AppleStore
GROUP BY App_Languages;

--Do apps with more supported devices have higher ratings?
SELECT CASE WHEN sup_devices_num < 30 THEN 'Under 30 devices'
WHEN sup_devices_num BETWEEN 30 AND 35 THEN 'Between 30 and 35 devices'
WHEN sup_devices_num BETWEEN 35 AND 40 THEN 'Between 35 and 40 devices'
ELSE 'More than 40 devices' 
END AS App_Devices,
round(avg(user_rating),2) AS avg_rating
FROM AppleStore
GROUP BY App_Devices;

--Check genres with low ratings
SELECT prime_genre, round(avg(user_rating), 2) as avg_rating
FROM AppleStore
GROUP BY prime_genre
ORDER BY avg_rating ASC
LIMIT 10;

--Check genres with high ratings
SELECT prime_genre, round(avg(user_rating), 2) as avg_rating
FROM AppleStore
GROUP BY prime_genre
ORDER BY avg_rating DESC
LIMIT 10;

--Is there correlation between app description length and user rating?
SELECT CASE WHEN length(b.app_desc) < 500 THEN 'Short'
			WHEN length(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
            ELSE 'Long'
            END AS description_length,
round(avg(a.user_rating),2) AS average_rating
FROM AppleStore AS A
JOIN apple_store_description AS B ON A.id = B.id
GROUP BY description_length
ORDER BY average_rating DESC;

--Find top rated apps for each genre
SELECT prime_genre, track_name, user_rating
FROM (SELECT prime_genre, track_name, user_rating, RANK() OVER(PARTITION BY prime_genre
      ORDER BY user_rating DESC, rating_count_tot DESC) AS rank FROM AppleStore) AS a
WHERE a.rank = 1;
  
