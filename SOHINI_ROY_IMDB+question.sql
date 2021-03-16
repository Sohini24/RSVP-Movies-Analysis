USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT COUNT(*)
FROM director_mapping;
-- 3867 rows in director_mapping table.

SELECT COUNT(*)
FROM genre;
-- 14662 rows in genre table.

SELECT COUNT(*)
FROM movie;
-- 7997 rows in movie table.

SELECT COUNT(*)
FROM names;
-- 25735 rows in names table.

SELECT COUNT(*)
FROM ratings;
-- 7997 rows in ratings table.


SELECT COUNT(*)
FROM role_mapping;
-- 15615 rows in role_mapping table.
 

-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT
		SUM(CASE WHEN id IS NULL then 1 else 0 end) AS id_nulls,
        SUM(CASE WHEN title IS NULL then 1 else 0 end) AS title_nulls,
        SUM(CASE WHEN year IS NULL then 1 else 0 end) AS year_nulls,
        SUM(CASE WHEN date_published IS NULL then 1 else 0 end) AS date_published_nulls,
		SUM(CASE WHEN duration IS NULL then 1 else 0 end) AS duration_nulls,
        SUM(CASE WHEN country IS NULL then 1 else 0 end) AS country_nulls,
        SUM(CASE WHEN worlwide_gross_income IS NULL then 1 else 0 end) AS worlwide_gross_income_nulls,
        SUM(CASE WHEN languages IS NULL then 1 else 0 end) AS languages_nulls,
        SUM(CASE WHEN production_company IS NULL then 1 else 0 end) AS production_company_nulls
FROM movie;


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
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
-- FIRST PART
SELECT year AS Year,
		COUNT(id) AS number_of_movies
FROM movie
GROUP BY year
ORDER BY year;

-- SECOND PART
SELECT MONTH(date_published) AS month_num,
		COUNT(id) AS number_of_movies
FROM movie
GROUP BY MONTH(date_published)
ORDER BY COUNT(id) DESC;
-- So, we can see that the highest number of movies is produced in the month of MARCH.



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT COUNT(title) AS number_of_movies
FROM movie
WHERE (country like '%USA%'
OR country like '%India%') and (year= '2019');


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT  DISTINCT genre
FROM genre;
-- DISTINCT gives the unique list.


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
USE imdb;

SELECT DISTINCT g.genre,
		year,
		COUNT(m.title) AS movie_count
FROM genre AS g
INNER JOIN movie AS m
ON g.movie_id=m.id
WHERE year= 2019
GROUP BY g.genre
ORDER BY COUNT(m.title) DESC;



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:


SELECT COUNT(genre_summary.movie_id) AS number_of_movies_in_one_genre
FROM
(SELECT 
	movie_id,
    COUNT(genre) AS genre_count
FROM genre
GROUP BY movie_id
HAVING genre_count= 1) AS genre_summary;

-- Number of movies having only one genrea ssociated with them is 3289



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
	g.genre,
	ROUND(AVG(m.duration),2) AS avg_duration
FROM movie AS m
INNER JOIN genre AS g
ON g.movie_id=m.id
GROUP BY g.genre;


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
	g.genre,
	COUNT(m.id) AS movie_count,
	RANK() OVER(ORDER BY COUNT(m.id) DESC) AS genre_rank
FROM movie AS m
INNER JOIN genre AS g
ON m.id=g.movie_id
GROUP BY genre;

		

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
	MAX(median_rating) AS max_median_rating
FROM ratings;


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

-- Ranking movies based on average rating
WITH rating_info AS
(
SELECT m.title,
		r.avg_rating,
        DENSE_RANK() OVER(ORDER BY r.avg_rating DESC) AS movie_rank
FROM movie AS m
INNER JOIN ratings AS r
ON m.id=r.movie_id
)
-- Getting Top 10 movies from the above table
SELECT *
FROM rating_info
WHERE movie_rank<=10;




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
FROM ratings AS r
GROUP BY median_rating
ORDER BY COUNT(movie_id) DESC;


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

-- fetching the Hit movies having avg rating >8
WITH hit_movies AS
(
SELECT r.movie_id,
		r.avg_rating
FROM ratings AS r
WHERE avg_rating>8
)
-- Getting the ranks of Production company based on no. of movies produced

SELECT m.production_company,
		COUNT(h.movie_id) AS movie_count,
		DENSE_RANK() OVER(ORDER BY COUNT(h.movie_id)DESC) AS prod_company_rank
FROM movie AS m
INNER JOIN hit_movies AS h
ON m.id=h.movie_id
WHERE production_company is not null 
GROUP BY production_company;

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
	COUNT(m.id) AS movie_count
FROM genre AS g
INNER JOIN movie As m
ON m.id=g.movie_id
INNER JOIN ratings AS r
ON m.id=r.movie_id
WHERE m.year= 2017 and MONTH(m.date_published)=3 AND m.country LIKE '%USA%' AND r.total_votes>1000
GROUP BY genre
ORDER BY COUNT(m.id) DESC;

        
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
		m.title,
		r.avg_rating,
        g.genre
FROM movie AS m
INNER JOIN ratings AS r
ON m.id=r.movie_id
INNER JOIN genre AS g
ON m.id=g.movie_id
WHERE m.title LIKE 'The%' AND r.avg_rating>8
ORDER BY avg_rating DESC;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


SELECT 
	COUNT(m.id) AS movie_count
FROM movie AS m
INNER JOIN ratings As r
ON m.id=r.movie_id
WHERE (m.date_published BETWEEN '2018-04-01' AND '2019-04-01') AND (r.median_rating=8);


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

-- Calculating German movie counts
WITH 
German_movies AS
(
SELECT 
		SUM(r.total_votes) As German_total_votes
FROM movie AS m
INNER JOIN ratings As r
ON m.id=r.movie_id
WHERE m.languages LIKE '%German%' 
) ,
-- Italian movie counts
Italian_movies AS
(
SELECT 
		SUM(r.total_votes) As Italian_total_votes
FROM movie AS m
INNER JOIN ratings As r
ON m.id=r.movie_id
WHERE languages LIKE '%Italian%' 
) 

-- If German movie counts > Italian movie counts then Yes
SELECT 
	(SELECT German_total_votes FROM German_movies)>(SELECT Italian_total_votes FROM Italian_movies)
    AS 'Yes';

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
		SUM(CASE WHEN name IS NULL then 1 else 0 end) AS name_nulls,
        SUM(CASE WHEN height IS NULL then 1 else 0 end) AS height_nulls,
        SUM(CASE WHEN date_of_birth IS NULL then 1 else 0 end) AS date_of_birth_nulls,
        SUM(CASE WHEN known_for_movies IS NULL then 1 else 0 end) AS known_for_movies_nulls
FROM names;


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

-- Fetching Top 3 directors in top genres

-- Checking the Top 3 genres
WITH top_genres AS
(
SELECT g.genre,
		COUNT(g.movie_id) AS movie_count,
        RANK() OVER(ORDER BY COUNT(g.movie_id) DESC) AS genre_rank
FROM genre As g
INNER JOIN ratings AS r
ON g.movie_id=r.movie_id
WHERE avg_rating>8 
GROUP BY genre
)
-- top 3 Directors in Top 3 genres
SELECT 
	n.name AS director_name, 
    Count(g.movie_id) AS movie_count
FROM names AS n
INNER JOIN director_mapping AS dm
ON n.id=dm.name_id
INNER JOIN movie AS m
ON dm.movie_id=m.id
INNER JOIN genre AS g
ON dm.movie_id=g.movie_id
INNER JOIN ratings AS r
ON m.id=r.movie_id
WHERE avg_rating>8
and genre in (SELECT genre 
				FROM top_genres
                WHERE genre_rank between 1 and 3)
group by Director_name
order by movie_count DESC
LIMIT 3;

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

SELECT n.name as actor_name , 
		COUNT(r.movie_id) as movie_count
FROM names as n
INNER JOIN role_mapping as rm 
ON n.id = rm.name_id
INNER JOIN movie as m 
ON m.id = rm.movie_id
INNER JOIN ratings as r 
ON m.id = r.movie_id
WHERE r.median_rating >= 8 
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2;

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

SELECT m.production_company,
		SUM(r.total_votes) AS vote_count,
        RANK() OVER(ORDER BY SUM(r.total_votes) DESC) AS prod_comp_rank
FROM movie AS m
INNER JOIN ratings AS r
ON m.id=r.movie_id
GROUP BY m.production_company
LIMIT 3;
		

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

WITH actor_ratings AS
(
SELECT n.name AS actor_name,
		SUM(r.total_votes) AS total_votes,
        COUNT(m.id) AS movie_count,
        ROUND(SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes),2) As actor_avg_rating
FROM names As n
INNER JOIN role_mapping AS a
ON n.id=a.name_id
INNER JOIN movie AS m
ON a.movie_id=m.id
INNER JOIN ratings AS r
ON m.id=r.movie_id
WHERE category='actor' AND LOWER(country) LIKE '%india%'
GROUP BY actor_name
)
SELECT *,
		RANK() OVER(ORDER BY actor_avg_rating DESC,total_votes DESC) AS actor_rank
FROM actor_ratings
WHERE movie_count>=5;

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
WITH actress_ratings AS
(
SELECT n.name AS actress_name,
		SUM(r.total_votes) AS total_votes,
        COUNT(m.id) AS movie_count,
        ROUND(SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes),2) As actress_avg_rating
FROM names As n
INNER JOIN role_mapping AS a
ON n.id=a.name_id
INNER JOIN movie AS m
ON a.movie_id=m.id
INNER JOIN ratings AS r
ON m.id=r.movie_id
WHERE category='actress' AND LOWER(country) LIKE '%india%' AND languages LIKE '%hindi%'
GROUP BY actress_name
)
SELECT *,
		RANK() OVER(ORDER BY actress_avg_rating DESC,total_votes DESC) AS actress_rank
FROM actress_ratings
WHERE movie_count>=3;

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT g.genre,
		r.avg_rating,
		CASE
        WHEN avg_rating > 8 then 'Superhit movies'
		WHEN avg_rating between 7 and 8 then 'Hit movies'
		WHEN avg_rating between 5 and 7 then 'One-time-watch movies'
		ELSE 'Flop movies'
END AS thriller_movie_category
FROM genre AS g
INNER JOIN ratings AS r
ON g.movie_id=r.movie_id
WHERE genre LIKE '%thriller%'
ORDER BY avg_rating DESC;

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
WITH movie_duration_summary AS
(
SELECT g.genre,
		ROUND(AVG(m.duration),2) AS avg_duration
FROM genre AS g
INNER JOIN movie AS m
ON g.movie_id=m.id
GROUP BY genre
)
SELECT *,
SUM(avg_duration) OVER w1 AS running_total_duration,
AVG(avg_duration) OVER w2 AS moving_avg_duration
FROM movie_duration_summary 
WINDOW w1 AS (ORDER BY avg_duration ROWS UNBOUNDED PRECEDING),
w2 AS (ORDER BY avg_duration ROWS UNBOUNDED PRECEDING);

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

-- Top 3 Genres based on most number of movies

WITH finalresult
     AS (WITH summary
              AS (SELECT g.genre,
                         m.year,
                         m.title AS movie_name,
                         m.worlwide_gross_income,
                         CASE
                           WHEN m.worlwide_gross_income LIKE ( 'INR%' ) THEN (
                           Round(
                           Substring(m.worlwide_gross_income, 4) / 72.69) )
                           ELSE Substring(worlwide_gross_income, 2)
                         END     AS gross_income_dollar
                  FROM   genre g
                         JOIN movie m
                           ON g.movie_id = m.id
                  WHERE  g.genre IN(WITH genre_summary
                                         AS (SELECT g.genre,
                                                    Row_number()
                                                      OVER(
                                                        ORDER BY Count(*) DESC)
                                                    AS
                                                    genre_rank
                                             FROM   genre g
                                                    JOIN movie m
                                                      ON g.movie_id = m.id
                                             GROUP  BY g.genre)
                                    SELECT genre
                                     FROM   genre_summary
                                     WHERE  genre_rank <= 3))
         SELECT genre,
                year,
                movie_name,
                CONVERT(GROSS_INCOME_DOLLAR, signed)                    AS
                worlwide_gross_income,
                Row_number()
                  OVER(
                    partition BY m.year
                    ORDER BY CONVERT(GROSS_INCOME_DOLLAR, signed) DESC) AS
                movierank
          FROM   summary)
SELECT genre,
       year,
       movie_name,
       Concat("$", worlwide_gross_income) AS worldwide_gross_income,
       movierank
FROM   finalresult
WHERE  movierank < 6;



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


SELECT production_company,COUNT(id) AS movie_count,
		DENSE_RANK() OVER(ORDER BY COUNT(id) DESC) AS prod_comp_rank
FROM(
SELECT *
FROM movie AS m
INNER JOIN ratings AS r
ON m.id=r.movie_id
WHERE (languages LIKE '%,%') AND (r.median_rating>=8)
) AS multilingual_movies
WHERE production_company is not null
GROUP BY production_company
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

SELECT name,
		SUM(total_votes) AS total_votes,
        COUNT(movie_id) AS movie_count,
        ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) As actress_avg_rating,
        DENSE_RANK() OVER(PARTITION BY name ORDER BY COUNT(movie_id) DESC) AS actress_rank
FROM
(
SELECT g.movie_id,g.genre,
		r.avg_rating,r.total_votes,
        rm.name_id,rm.category,
        n.name
FROM genre AS g
INNER JOIN ratings AS r
ON g.movie_id=r.movie_id
INNER JOIN role_mapping AS rm
ON rm.movie_id=g.movie_id
INNER JOIN names AS n
ON n.id=rm.name_id
WHERE g.genre = 'drama' AND r.avg_rating>8 AND rm.category='actress') AS superhit_drama_movies
GROUP BY name
ORDER BY COUNT(movie_id) DESC
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


SELECT name_id AS director_id,
		name AS director_name,
        COUNT(movie_id) AS number_of_movies,
        ROUND(AVG(DATEDIFF(next_movie_date , date_published)),2) AS avg_inter_movie_days,
        AVG(avg_rating) AS avg_rating,
        SUM(total_votes) AS total_votes,
        MIN(avg_rating) AS min_rating,
        MAX(avg_rating) AS max_rating,
        SUM(duration) AS total_duration
FROM
(
SELECT dm.name_id,
		n.name,
        dm.movie_id,
        m.date_published,
		LEAD (m.date_published,1) OVER(PARTITION BY dm.name_id ORDER BY m.date_published) AS next_movie_date,
        r.avg_rating,
        r.total_votes,
        m.duration
FROM director_mapping AS dm
INNER JOIN names AS n
ON dm.name_id=n.id
INNER JOIN movie AS m
ON dm.movie_id=m.id
INNER JOIN ratings AS r
ON dm.movie_id=r.movie_id
ORDER BY name,date_published) AS director_details_table
GROUP BY name
ORDER BY number_of_movies DESC
LIMIT 9;


