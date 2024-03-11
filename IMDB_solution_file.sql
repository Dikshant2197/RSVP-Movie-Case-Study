USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Explore the columns and data available in imdb schema Tables:
SELECT * FROM director_mapping;
SELECT * FROM genre;
SELECT * FROM movie;
SELECT * FROM names;
SELECT * FROM ratings;
SELECT * FROM role_mapping;



-- Segment 1:



-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT COUNT(*) FROM director_mapping;
# O/P :- Total Rows in director_mapping table = 3867

SELECT COUNT(*) FROM genre;
# O/P :- Total Rows in genre table = 14662

SELECT COUNT(*) FROM movie;
# O/P :- Total Rows in movie table = 7997

SELECT COUNT(*) FROM names;
# O/P :- Total Rows in names table = 25735

SELECT COUNT(*) FROM ratings;
# O/P :- Total Rows in ratings table = 7997

SELECT COUNT(*) FROM role_mapping;
# O/P :- Total Rows in role_mapping table = 15615



-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT
	SUM(
		CASE
			WHEN id IS NULL THEN 1
            ELSE 0
		END) AS id_null_count,
    SUM(
		CASE
			WHEN title IS NULL THEN 1
			ELSE 0
		END) AS title_null_count,
    SUM(
		CASE
			WHEN year IS NULL THEN 1
			ELSE 0
		END) AS year_null_count,
    SUM(
		CASE
			WHEN date_published IS NULL THEN 1
            ELSE 0
		END) AS date_published_null_count,
    SUM(
		CASE
			WHEN duration IS NULL THEN 1
			ELSE 0
		END) AS duration_null_count,
    SUM(
		CASE
			WHEN country IS NULL THEN 1
			ELSE 0
		END) AS country_null_count,
    SUM(
		CASE
			WHEN worlwide_gross_income IS NULL THEN 1
			ELSE 0
		END) AS worlwide_gross_income_null_count,
    SUM(
		CASE
			WHEN languages IS NULL THEN 1
			ELSE 0
		END) AS languages_null_count,
    SUM(
		CASE
			WHEN production_company IS NULL THEN 1
            ELSE 0
		END) AS production_company_null_count
FROM
	movie;
# O/P :- There are 4 columns with missing data country(20), worlwide_gross_income(3724), languages(194), production_company(528)



-- Now as you can see four columns of the movie table has null values. Let's look at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+

Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

# First Part of question
SELECT
	year,
    COUNT(id) AS number_of_movies
FROM
	movie
GROUP BY
	year
ORDER BY
	year;
# O/P :- In 2017 - 3052 movies released, In 2018 - 2944 movies released and in 2019 - 2001 movies released

# Second Part of the question
SELECT
	MONTH(date_published) AS month_num,
    COUNT(id) AS number_of_movies
FROM
	movie
GROUP BY
	MONTH(date_published)
ORDER BY
	month_num;
# O/P :- 1-804, 2-640, 3-824, 4-680, 5-625, 6-580, 7-493, 8-678, 9-809, 10-801, 11-625, 12-438 (month - movie_released)



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
-- Check for the country names present in the dataset

SELECT
	DISTINCT country
FROM
	movie;

-- From above code's o/p it is clear that country names are also in substrings.
SELECT 
    COUNT(*) AS number_of_movies_USA_INDIA
FROM
    movie
WHERE
    year = 2019
        AND (country LIKE '%USA%'
        OR country LIKE '%India%');
# O/P :- 1059




/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT
	DISTINCT genre AS Genre_Names
FROM
	genre;
# O/P :- Drama, Fantasy, Thriller, Comedy, Horror, Family, Romance, Adventure, Action, Sci-Fi, Crime, Mystery, Others



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT
	genre,
	COUNT(id) AS no_of_movies
FROM
	movie as m
INNER JOIN
	genre as g
    ON m.id = g.movie_id
GROUP BY
	genre
ORDER BY
	no_of_movies DESC
LIMIT 1;
# O/P :- Drama-4285



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
WITH unique_genre_movies AS
(
	SELECT
		movie_id
	FROM
		genre
	GROUP BY
		movie_id
	HAVING
		COUNT(DISTINCT genre) = 1
)
SELECT
	COUNT(*) AS num_of_unique_genre_movies
FROM
	unique_genre_movies;
# O/P :- 3289



/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT
	genre,
	ROUND(AVG(duration), 2) AS avg_time_in_min
FROM
	movie as m
INNER JOIN
	genre as g
    ON m.id = g.movie_id
GROUP BY
	genre
ORDER BY
	avg_time_in_min DESC;
/* # O/P :- 
+------------+----------------+
| genre      | avg_time_in_min|
+------------+----------------+
| Action	 | 112.88		  |
| Romance	 | 109.53		  |
| Drama	     | 107.05		  |
| Crime	     | 106.77		  |
| Fantasy	 | 105.14		  |
| Comedy     | 102.62		  |
| Thriller   | 101.87		  |
| Mystery	 | 101.58		  |
| Family     | 100.97		  |
| Others	 | 100.16		  |
| Sci-Fi	 | 97.94		  |
| Horror	 | 92.72		  |
+-----------+-----------------+*/



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT
	genre,
    COUNT(movie_id) AS movie_count,
	DENSE_RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS genre_rank
FROM
	genre
GROUP BY
	genre;
/* # O/P :-
+-----------+-------------+------------+
| genre     | movie_count | genre_rank |
+-----------+-------------+------------+
| Drama     |    4285     |     1      |
| Comedy    |    2412     |     2      |
| Thriller  |    1484     |     3      |
| Action    |    1289     |     4      |
| Horror    |    1208     |     5      |
| Romance   |    906      |     6      |
| Crime	    |    813      |     7      |
| Adventure |    591      |     8      |
| Mystery   |    555      |     9      |
| Sci-Fi    |    375      |     10     |
| Fantasy   |    342      |     11     |
| Family    |    302      |     12     |
| Others    |    100      |     13     |
+-----------+-------------+------------+*/



/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/



-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT
	MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS min_median_rating
FROM
	ratings;
/* # O/P :- 
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		1.0		|		10.0		|	       100		  |	   725138	   		 |		1	       |	10			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/



/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
SELECT 
	title,
	avg_rating,
    movie_rank
FROM
	(SELECT
		title,
		avg_rating,
		DENSE_RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank
	FROM
		movie AS m
	INNER JOIN
		ratings AS r
		ON m.id = r.movie_id
	) AS ranked_movies
WHERE
	movie_rank <= 10;



/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT
	median_rating,
    COUNT(movie_id) AS movie_count
FROM
	ratings
GROUP BY
	median_rating
ORDER BY
	movie_count DESC;
/* O/P :- 
+---------------+-------------+
| median_rating | movie_count |
+---------------+-------------+
|       7       |     2257    |
|       6       |     1975    |
|       8       |     1030    |
|       5       |     985     |
|       4       |	  479     |
|       9       |	  429     |
|       10      |	  346     |
|       2       |	  119     |
|       1       |	  94      |
+---------------+-------------+*/



/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT
	production_company,
    movie_count,
    prod_company_rank
FROM
	(SELECT
		production_company,
		COUNT(id) as movie_count,
		DENSE_RANK() OVER(ORDER BY COUNT(id) DESC) AS prod_company_rank
	FROM
		movie AS m
	INNER JOIN
		ratings AS r
		ON m.id = r.movie_id
	WHERE
		avg_rating > 8
			AND production_company IS NOT NULL
	GROUP BY
		production_company
    ) AS production_house
WHERE
	prod_company_rank = 1;
/* # O/P :-
+------------------------+-------------+-------------------+
|   production_company   | movie_count | prod_company_rank |
+------------------------+-------------+-------------------+
| Dream Warrior Pictures |     3	   |        1	       |
| National Theatre Live  |     3       |        1          |
+------------------------+-------------+-------------------+*/



-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT
	g.genre,
	COUNT(g.movie_id) AS movie_count
FROM
	movie AS m
INNER JOIN
	genre AS g
    ON m.id = g.movie_id
	INNER JOIN 
		ratings AS r
		USING(movie_id)
WHERE
	m.year = 2017
		AND m.country LIKE '%USA%'
        AND r.total_votes>1000
GROUP BY
	g.genre
ORDER BY
	movie_count DESC;
/* O/P :- 
+-----------+-------------+
|   genre   | movie_count |
|-----------+-------------+
| Drama     |     263     |
| Comedy    |     139     |
| Thriller  |     116     |
| Horror    |     113     |
| Action    |     109     |
| Crime     |     79      |
| Adventure |     66      |
| Romance   |     54      |
| Mystery   |     53      |
| Sci-Fi    |     38      |
| Fantasy   |     28      |
| Family    |     8       |
| Others    |     1       |
+-----------+-------------+*/



-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT
	title,
    avg_rating,
    genre
FROM
	movie AS m
INNER JOIN
	genre AS g
    ON m.id = g.movie_id
    INNER JOIN
		ratings
        USING(movie_id)
WHERE
	title LIKE 'The%'
		AND avg_rating > 8
ORDER BY
	avg_rating DESC;
/* O/P :-
+--------------------------------------+------------+----------+
| title                                | avg_rating |   genre  |
+--------------------------------------+------------+----------+
| The Brighton Miracle                 |    9.5     | Drama    |
| The Colour of Darkness               |    9.1     | Drama    |
| The Blue Elephant 2                  |    8.8     | Drama    |
| The Blue Elephant 2                  |    8.8     | Horror   |
| The Blue Elephant 2                  |    8.8     | Mystery  |
| The Irishman                         |    8.7     | Crime    |
| The Irishman                         |    8.7	    | Drama    |
| The Mystery of Godliness: The Sequel |    8.5     | Drama    |
| The Gambinos                         |    8.4     | Crime    |
| The Gambinos                         |    8.4     | Drama    |
| Theeran Adhigaaram Ondru             |    8.3     | Action   |
| Theeran Adhigaaram Ondru             |    8.3     | Crime    |
| Theeran Adhigaaram Ondru             |    8.3     | Thriller |
| The King and I                       |    8.2     | Drama    |
| The King and I                       |    8.2     | Romance  |
+--------------------------------------+------------+----------+*/



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT
	COUNT(id) AS movie_count
FROM
	movie AS m
INNER JOIN
	ratings AS r
	ON m.id = r.movie_id
WHERE
	date_published BETWEEN '2018-04-01' AND '2019-04-01'
		AND median_rating = 8;
# O/P :- 361



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
WITH language_votes AS
(
	SELECT
		CASE
			WHEN languages LIKE '%German%' THEN 'German'
			WHEN languages LIKE '%Italian%' THEN 'Italian'
		END AS language,
		total_votes
	FROM
		movie AS m
	INNER JOIN
		ratings AS r
		ON m.id = r.movie_id
	WHERE
		languages LIKE '%German%'
			OR languages LIKE '%Italian%'
)
SELECT
	language,
    SUM(total_votes) AS total_votes
FROM
	language_votes
GROUP BY
	language
ORDER BY
	total_votes DESC;
# O/P :- German-4421525, Italian-2003623
	
-- Answer is Yes




/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT
	SUM(CASE
			WHEN name IS NULL THEN 1
            ELSE 0
		END) AS name_nulls,
	SUM(CASE
			WHEN height IS NULL THEN 1
            ELSE 0
		END) AS height_nulls,
	SUM(CASE
			WHEN date_of_birth IS NULL THEN 1
            ELSE 0
		END) AS date_of_birth_nulls,
	SUM(CASE
			WHEN known_for_movies IS NULL THEN 1
            ELSE 0
		END) AS known_for_movies_nulls
FROM
	names;
/* # O/P :- 
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|		17335		|	      13431		  |	   15226	    	 |
+---------------+-------------------+---------------------+----------------------+*/



/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH TopGenre AS
(
	SELECT
		genre,
		COUNT(*) AS movie_count
	FROM
		genre as g
	INNER JOIN
		ratings AS r
		USING (movie_id)
	WHERE
		avg_rating > 8
	GROUP BY
		genre
	ORDER BY
		movie_count DESC
	LIMIT 3
),
TopDirector AS
(
	SELECT
		n.name AS director_name,
		COUNT(d.movie_id) AS movie_count,
        DENSE_RANK() OVER(ORDER BY COUNT(d.movie_id) DESC) AS movie_rank
	FROM
		names AS n
	INNER JOIN
		director_mapping AS d
		ON n.id = d.name_id
	INNER JOIN
		ratings AS r
		USING (movie_id)
	INNER JOIN
		genre AS g
        USING (movie_id)
	WHERE
		r.avg_rating >8
        AND g.genre IN (SELECT genre FROM TopGenre)
	GROUP BY
		n.name
	ORDER BY
		movie_count DESC
)
SELECT
	director_name,
    movie_count
FROM TopDirector
WHERE movie_rank <= 3;
# O/P :- James Mangold	4

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT
	n.name AS actor_name,
    COUNT(movie_id) AS movie_count
FROM
	names AS n
INNER JOIN
	role_mapping AS rm
	ON n.id = rm.name_id
INNER JOIN
	ratings as r
    USING(movie_id)
WHERE
	category = 'actor'
    AND r.median_rating >= 8
GROUP BY
	n.name
ORDER BY
	movie_count DESC
LIMIT 2;
# O/P :- Mammootty-8, Mohanlal-5



/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT
    production_company,
    SUM(total_votes) AS vote_count,
    DENSE_RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM
    movie AS m
INNER JOIN
    ratings AS r
    ON m.id = r.movie_id
GROUP BY
    production_company
ORDER BY
    vote_count DESC
LIMIT 3;
/* O/P :-
+-----------------------+------------+----------------+
|  production_company   | vote_count | prod_comp_rank |
+-----------------------+------------+----------------+
| Marvel Studio		    |  2656967   |		1	  	  |
| Twentieth Century Fox	|  2411163	 |		2	      |
|Warner Bros            |  2396057	 |		3	      |
+-----------------------+------------+----------------+*/



/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT
	name AS actor_name,
    SUM(total_votes) AS total_votes,
    COUNT(rm.movie_id) AS movie_count,
    Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actor_avg_rating,
    DENSE_RANK() OVER(ORDER BY Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) DESC) AS actor_rank
FROM
	names AS n
INNER JOIN
	role_mapping AS rm
	ON n.id = rm.name_id
INNER JOIN
	movie AS m
	ON rm.movie_id = m.id
INNER JOIN
	ratings AS r
    ON m.id = r.movie_id
WHERE country LIKE '%India%'
	AND category = 'actor'
GROUP BY name_id, name
HAVING Count(DISTINCT rm.movie_id) >= 5
ORDER BY actor_avg_rating DESC;

-- Top actor is Vijay Sethupathi



-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT
	name AS actress_name,
    SUM(total_votes) AS total_votes,
    COUNT(rm.movie_id) AS movie_count,
    Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actress_avg_rating,
    DENSE_RANK() OVER(ORDER BY Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) DESC) AS actress_rank
FROM
	names AS n
INNER JOIN
	role_mapping AS rm
	ON n.id = rm.name_id
INNER JOIN
	movie AS m
	ON rm.movie_id = m.id
INNER JOIN
	ratings AS r
    ON m.id = r.movie_id
WHERE country LIKE '%India%'
	AND category = 'actress'
    AND m.languages LIKE '%Hindi%'
GROUP BY name_id, name
HAVING Count(DISTINCT rm.movie_id) >= 3
ORDER BY actress_avg_rating DESC
LIMIT 5;



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT
	title AS movie_name,
    genre,
    avg_rating,
    CASE
		WHEN avg_rating > 8 THEN 'Superhit'
        WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit'
        WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-Time-Watch'
        ELSE 'Flop'
	END AS movie_status
FROM
	movie AS m
INNER JOIN
	genre AS g
    ON m.id = g.movie_id
INNER JOIN
	ratings AS r
    On g.movie_id = r.movie_id
WHERE genre = 'Thriller';



/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT
    genre,
    ROUND(AVG(duration), 2) AS avg_duration,
    SUM(ROUND(AVG(duration), 2)) OVER (ORDER BY genre) AS running_total_duration,
    ROUND(AVG(ROUND(AVG(duration), 2)) OVER (ORDER BY genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS moving_avg_duration
FROM
    movie AS m
INNER JOIN
    genre AS g
    ON m.id = g.movie_id
GROUP BY
    genre
ORDER BY
    genre;


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT *
FROM movie
WHERE worlwide_gross_income LIKE '%INR%';

-- There are Three Rows with INR Values
UPDATE movie
SET worlwide_gross_income = NULLIF(
                                CASE
                                    WHEN worlwide_gross_income LIKE '%INR%' 
                                         AND REPLACE(worlwide_gross_income, 'INR', '') REGEXP '^[0-9]+[.]?[0-9]*$'
                                         THEN CAST(REPLACE(worlwide_gross_income, 'INR', '') AS DECIMAL(10,2)) / 70
                                    ELSE NULL
                                END,
                                '')
WHERE worlwide_gross_income LIKE '%INR%';

-- Now we need to fix the column from VARCHAR to INT
# Remove the $ Symbol
UPDATE movie
SET worlwide_gross_income = REPLACE(worlwide_gross_income, '$', '');

# Change it to INT
ALTER TABLE movie MODIFY COLUMN worlwide_gross_income BIGINT;

-- Top 3 Genres based on most number of movies
WITH TopGenre AS
(
	SELECT
		genre,
		COUNT(*) AS movie_count
	FROM
		genre
	GROUP BY
		genre
	ORDER BY
		movie_count DESC
	LIMIT 3
),
-- Select the top five movies from each of the top three genres for each year based on worldwide gross income.
Final_list AS
(
	SELECT
		genre,
		year,
		title AS movie_name,
		worlwide_gross_income,
		ROW_NUMBER() OVER(PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
	FROM
		movie as m
	INNER JOIN
		genre as g
		ON m.id = g.movie_id
	WHERE
		genre IN (SELECT genre FROM TopGenre)
	ORDER BY year ASC, worlwide_gross_income DESC
)
SELECT *
FROM
	Final_list
WHERE
	movie_rank <= 5;



-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT
    production_company,
    COUNT(id) AS movie_count,
    ROW_NUMBER() OVER(ORDER BY COUNT(id) DESC) AS prod_comp_rank
FROM
    movie m
INNER JOIN
    ratings r
    ON m.id = r.movie_id
WHERE
    median_rating >= 8
    AND production_company IS NOT NULL
    AND POSITION(',' IN languages) > 0
GROUP BY
    production_company
ORDER BY
    movie_count DESC
LIMIT 2;



-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT
	name AS actress_name,
    SUM(total_votes) AS total_votes,
    COUNT(rm.movie_id) AS movie_count,
    Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actress_avg_rating,
    ROW_NUMBER() OVER(ORDER BY COUNT(rm.movie_id) DESC) AS actress_rank
FROM
	names AS n
INNER JOIN
	role_mapping AS rm
	ON n.id = rm.name_id
INNER JOIN
	movie AS m
	ON rm.movie_id = m.id
INNER JOIN
	ratings AS r
    ON m.id = r.movie_id
INNER JOIN
	genre AS g
    ON r.movie_id = g.movie_id
WHERE
	category = 'actress'
    AND avg_rating>8
    AND genre = 'Drama'
GROUP BY name
ORDER BY movie_count DESC
LIMIT 3;



/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH days_difference AS
(
	SELECT
		n.id AS director_id,
		m.id AS movie_id,
		m.date_published AS date_published,
		LEAD(m.date_published, 1) OVER (PARTITION BY n.id ORDER BY m.date_published) AS next_date,
		DATEDIFF(LEAD(m.date_published, 1) OVER (PARTITION BY n.id ORDER BY m.date_published), m.date_published) AS difference
	FROM
		names AS n
	INNER JOIN
		director_mapping AS d ON n.id = d.name_id
	INNER JOIN
		movie AS m ON d.movie_id = m.id
)
SELECT
		n.id AS director_id,
		n.name AS director_name,
		COUNT(DISTINCT d.movie_id) AS number_of_movies,
        ROUND(AVG(difference), 2) AS avg_inter_movie_days,
		ROUND(AVG(r.avg_rating), 2) AS avg_rating,
		SUM(r.total_votes) AS total_votes,
		MIN(r.avg_rating) AS min_rating,
		MAX(r.avg_rating) AS max_rating,
		SUM(m.duration) AS total_duration
	FROM
		names AS n
	INNER JOIN
		director_mapping AS d ON n.id = d.name_id
	INNER JOIN
		ratings AS r ON d.movie_id = r.movie_id
	INNER JOIN
		movie AS m ON d.movie_id = m.id
	INNER JOIN
		days_difference AS dd
        ON n.id = dd.director_id
	GROUP BY
		n.id, n.name
	ORDER BY
		number_of_movies DESC, avg_inter_movie_days DESC;