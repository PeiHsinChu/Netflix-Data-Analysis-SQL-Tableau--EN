-- create table
CREATE TABLE netflix (
    show_id VARCHAR(10),
    type VARCHAR(10),
    title VARCHAR(150),
    director VARCHAR(208),
    cast VARCHAR(1000),
    country VARCHAR(150),
    date_added VARCHAR(50),
    release_year INTEGER,
    rating VARCHAR(10),
    duration VARCHAR(15),
    listed_in VARCHAR(100),
    description VARCHAR(250)
);


--Q1：Count the number of movies and the number of TV shows
SELECT 
    types, 
    COUNT(*) AS total_content
FROM netflix
GROUP BY type;

-- Q2：Find the most common rating for the movies and the TV shows
WITH rating_counts AS (
    SELECT 
        types, 
        rating, 
        COUNT(*) AS count,
        RANK() OVER (PARTITION BY types ORDER BY COUNT(*) DESC) AS ranking
    FROM Netflix
    GROUP BY types, rating
)
SELECT types, rating
FROM rating_counts
WHERE ranking = 1;

--Q3：List all movies released in a specific year (2022)
SELECT *
FROM netflix
WHERE types = 'Movie'
AND release_year = 2022;

-- Q4：Find the top five countries with the most content on Netflix

    SELECT 
        TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) AS country_name,
        COUNT(*) AS total_content
    FROM netflix
    GROUP BY country_name
	order by 2 desc
    LIMIT 5;

-- Q5：Identify the longest movie
SELECT *
FROM netflix
WHERE types = 'Movie'
AND duration = (
    SELECT MAX(duration)
    FROM netflix
    WHERE types = 'Movie'
);

-- Q6：Find the content that added in the last five years
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

-- Q7：Find all the movies TV shows by director called Rajiv Chilaka

SELECT *
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';

-- Q8：List all TV shows with more than five season
SELECT *
FROM netflix
WHERE types = 'TV Show'
AND CAST(SPLIT_PART(duration, ' ', 1) AS NUMERIC) > 5;

-- Q9：Count the number of content item in each genre
SELECT 
    TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))) AS genre, 
    COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC;

-- Q10：Find each year and the average number of content released by India on Netflix. 
-- Return the top five years with the highest average release

SELECT 
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
    COUNT(show_id) AS content_count,
    ROUND(
        (COUNT(show_id)::NUMERIC / (SELECT COUNT(*) FROM Netflix WHERE country ILIKE '%India%')::NUMERIC) * 100,
        2
    ) AS percentage
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY 3 DESC
LIMIT 5;

-- Q11：List all the movies that are documentaries
SELECT *
FROM netflix
WHERE listed_in ILIKE '%Documentaries%';

-- Q12：Find all the content without a director
SELECT *
FROM netflix
WHERE director IS NULL;

-- Q13：Find how many movies actor Salman Khan appeared in last 10 years
SELECT *
FROM netflix
WHERE casts ilike '%Salman Khan%'
AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

-- Q14：Find the top 10 actors who appeared in the highest number of movies produced in India
    SELECT 
        TRIM(UNNEST(STRING_TO_ARRAY(casts, ','))) AS actor,
        COUNT(*) AS total_content
    FROM Netflix
    WHERE country ILIKE '%India%'
    GROUP BY 1
    ORDER BY total_content DESC
    LIMIT 10;

-- Q15：Categorize the content based on the presence of keywords like "kill", "violence" in the description field. Label the content containing these keywords as "bad" and all other content as "good". 
--  Count how many items fall into each catego
SELECT 
    category,
    COUNT(*) AS content_count
	FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;


     
 
