--1. Netflix Content Growth Trend (2008-2021)
--Analyze the growth trend of Netflix content over the years (2008-2021)"

select extract(year from to_date(date_added, 'Month DD, YYYY')) as year, types,count(*)
from netflix
group by 1,2
order by 1,2 

--2.Find the top countries with the most content on Netflix and visualize their global distribution
SELECT country_name, COUNT(*) AS total_content
FROM (
    SELECT TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) AS country_name
    FROM netflix
    WHERE country IS NOT NULL
) AS country_split
GROUP BY country_name
ORDER BY total_content DESC;

--3.Count the number of content items in each genre and visualize their proportional distribution
SELECT 
    TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))) AS genre, 
    COUNT(show_id) AS content_count
FROM netflix
GROUP BY genre
ORDER BY content_count DESC


--4.Analyze the distribution of content ratings across Netflix, comparing movies vs. TV shows
    SELECT 
        types, 
        rating, 
        COUNT(*) AS count
    FROM netflix
    GROUP BY 1,2



