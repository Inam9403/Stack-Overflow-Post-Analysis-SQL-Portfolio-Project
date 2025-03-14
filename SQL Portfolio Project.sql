use project ;
-- Part 1: Basics
-- 1. Loading and Exploring Data
-- ○ Explore the structure and first 10 rows of each table

describe badges ;              -- Exploring the structure of badges table 
describe comments;             -- Exploring hte structure of comments table
describe post_history;         -- Exploring the structure of post_history table
describe post_links;           -- Exploring the structure of post_links table
describe posts;                -- Exploring the structure of posts table
describe posts_answers;        -- Exploring the structure of posts_answers table
describe tags;                 -- Eploring the structure of tags table
describe users;                -- Exploring the structure of users table
describe votes;                -- Exploring the structure of votes table

select * from badges limit 10;               -- 10 rows of badges_table
select * from comments limit 10;             -- 10 rows of comments table 
select * from post_history limit 10;         -- 10 rows of post_history table
select * from post_links limit 10 ;          -- 10 rows of post_links table
select * from posts limit 10;                -- 10 rows of posts table
select * from posts_answers limit 10;        -- 10 rows of posts_answere table
select * from tags limit 10;                 -- 10 rows of tags table
select * from users limit 10;                -- 10 rows of users table
select * from votes limit 10;                -- 10 rows of votes table 

-- ○ Identify the total number of records in each table.
select count(*) from badges;                 -- badges table total number of records
select count(*) from comments;               -- comments table total number of records
select count(*) from post_history;           -- post_history total number of records
select count(*) from post_links;             -- post_links total number of records
select count(*)  from posts;                 -- posts table total number of records
select count(*) from posts_answers;          -- posts_answere total number of records
select count(*) from tags;                  -- tage table total number of records
select count(*) from users;                 -- users table total number of records
select count(*) from votes;                 -- votes table total number of records

-- 2. Filtering and Sorting
-- ○ Find all posts with a view_count greater than 100
select view_count from posts                -- selecting the view_count column from posts table
where view_count >100                       -- filtering the column that have view_count greater than 100
order by view_count desc;                   -- ordering the result in descending order

--  Display comments made in 2005, sorted by creation_date (comments table).
select creation_date , `text` from comments   -- selecting the creation_date and text column from comments table
where creation_date= 2005                     -- Filtering the creation_date column
order by creation_date desc;                  -- showing the result in descending order

-- 3. Simple Aggregations
-- ○ Count the total number of badges (badges table).

select count(id) as total_number_badges 
from badges ;                              -- Counting the total number of records in badges table

-- Calculate the average score of posts grouped by post_type_id (posts_answer table)

select post_type_id , avg(score) as average_score from posts_answers    -- Selecting the post_type_id and average of score column from posts_answers table
group by post_type_id                                                   -- Group the rows of post_type_id column that have same values
order by post_type_id asc;                                              -- showing the result in ascending order

-- Part 2: Joins
-- 1. Basic Joins
--  Combine the post_history and posts tables to display the title of
--  posts and the corresponding changes made in the post history.

select p.title , ph.`text` ,ph.creation_date from posts p  -- selecting the title , text , creation_date column from posts and post_history table
join post_history ph on p.id = ph.post_id                  -- join the posts and post_history table through post_id
order by creation_date desc;                               -- ordering the result in descending order

-- Join the users table with badges to find the total badges earned by each user
select u.display_name , u.reputation as total_badges, b.`name`  from badges b   -- selecting display_name and reputation column from users table and name from badges table   
join users u on b.user_id = u.id                                                -- join the user and badges through user_id
order by reputation desc;                                                       -- ordering the result through descending order

-- 2. Multi-Table Joins
-- ○ Fetch the titles of posts (posts), their comments (comments), and the
-- users who made those comments (users).

select u.display_name as customer_name, p.title as post_title, c.`text` as comment_text  -- Fetching the customer name from users , title from post_title and comments from comments table
from users u                         
join comments c on  u.id = c.user_id                                                     -- join comments and user through user_id
join posts p on c.post_id = p.id                                                         -- join comments and posts through post_id
order by p.id;                                                                           -- order the result through post_id

 -- ○ Combine post_links with posts to list related questions.
 select p.id as post_id,p.title as post_title , p_related.title as related_post_title,   -- Fetching post_id, post_title , related post id and related post title from posts table 
 pl.related_post_id 
 from posts p join post_links pl on                                                      -- join the posts and post_links tables through post_id
 p.id = pl.post_id  
 join posts p_related on pl.related_post_id= p_related.id                                -- join post_links through related_post_id with posts table on post_id
 order by p.id;

 -- Join the users, badges, and comments tables to find the users who have
-- earned badges and made comments.

select distinct u.id as user_id, u.display_name ,b.name as badges_name, c.`text` as comment_text,    -- fetching unique identifier for each user , its name from users table , badges name from badges table 
c.creation_date as comment_date                                                                      -- and their comments , creation date from comments table
 from users u 
join badges b on u.id = b.user_id                                                                    -- join users and badges based on user id
join comments c on u.id = c.user_id                                                                  -- join comments and users based on user id 
order by u.id,                                                                                       -- ordering result first by uder_id
b.name,                                                                                              -- then , alphabatically by badge name
c.creation_date ;                                                                                    -- finally , sort by comment creation date 

-- Part 3: Subqueries
-- 1. Single-Row Subqueries
-- ○ Find the user with the highest reputation (users table).
select * from users;                                   -- Retrieving all records from users table
 -- Finnding users with highest reputation
select id, display_name ,reputation                    -- Fetching user_id , user_name and reputation score from user table
from  users where reputation =                         -- Filter users where their reputation matches the highest reputation
(select max(reputation) from users)                    -- Find the maximum reputation value in the users table
;

-- ○ Retrieve posts with the highest score in each post_type_id (posts table).
select id , title , post_type_id ,score                -- select post_id, post title, score and post_type_id from posts table
from posts where score in                              -- Filter posts where thier score matches the highest score
(select max(score) from posts                          -- Find the maximum score value in posts table
group by post_type_id );                               -- To get the highest score per post type

-- 2. Correlated Subqueries
-- ○ For each post, fetch the number of related posts from post_links. 

select distinct 
p.post_id,                              -- select distinct posts id from post links 
 ( select count(*) from post_links pl   -- Subquery : Count how many times this post appears as a related post
 where 
 pl.related_post_id = p.post_id ) as related_post_count     -- count of related post
 from post_links p;                                         -- Mian query selecting posts from posts links table


-- Part 4: Common Table Expressions (CTEs)
-- 1. Non-Recursive CTE
-- ○ Create a CTE to calculate the average score of posts by each user and use it to:
-- ■ List users with an average score above 50.
-- ■ Rank users based on their average post score.

-- create a CTE to calculate average score per user
with avg_scores as (
 select  owner_user_id,                                  -- User who created the post
 avg(score) as average_score                             -- Calculte average score for each user
 from posts  group by owner_user_id                      -- Group by user_id to calculate average per user
 
)

-- Select user details along with their average post score
 select u.id as user_id, u.display_name as user_name ,a_s.average_score 
 from avg_scores a_s  join users u on                   -- Select user details along with their average post score 
 a_s.owner_user_id = u.id -1000                        
 where a_s.average_score >50                           -- Filtern users who have average score greater than 50
 ;
  
  -- Create CTE to rank users based on their average score post
 with rankuser as ( 
 select owner_user_id ,                                        -- User who create the post
 avg(score) as avg_score ,                                     -- Calculate average post score post per user 
rank () over (order by   avg(score) desc) as rank_user         -- Rank users by highest average score
  from posts
  group by owner_user_id                                       -- Group by user id to compute ranking 
 )
 
 select u.id , u.display_name , r.avg_score , r.rank_user      -- User details along with their average sacore and rank 
 from users u join rankuser r on 
 r.owner_user_id= u.id-1000
 order by r.avg_score desc ;                                   -- Ordeer by highest average score first
 
-- 2. Recursive CTE 
-- ○ Simulate a hierarchy of linked posts using the post_links table.
WITH RECURSIVE PostHierarchy AS (
    -- Base case: Start the hierarchy from post_id = 2001
    SELECT 
        post_id, 
        related_post_id, 
        link_type_id, 
        1 AS depth                 -- Initialize depth at level 1
    FROM post_links
    WHERE post_id = 2001            -- Define the starting post

    UNION ALL

    -- Recursive case: 
    SELECT 
        pl.post_id, 
        pl.related_post_id, 
        pl.link_type_id, 
        ph.depth + 1  -- Increase depth level for each recursion step
    FROM post_links pl
    INNER JOIN PostHierarchy ph 
        ON pl.post_id = ph.related_post_id  -- Follow the relationship chain
    WHERE ph.depth < 10  -- Limit recursion depth to prevent excessive processing
)
-- Retrieve the hierarchical structure of linked posts
SELECT * FROM PostHierarchy;


-- Part 5: Advanced Queries
-- 1. Window Functions
-- ○ Rank posts based on their score within each year (posts table).

 -- select relavent columns from the posts table
 select id as post_id , title , score,                                                           -- Fetching Post id , post title , post score  from posts table
 year(creation_date) as post_year,                                                               -- Extract the year from the creation_date column 
 rank() over ( partition by year(creation_date) order by score desc ) as rank_in_year            -- Assign ranking to each post within its respective year based on score 
 from posts order by post_year , rank_in_year;                                                   -- order result first by year then by ranking within that year
 
-- ○ Calculate the running total of badges earned by users (badges table).

select id , `name` , `date` ,                                                                   -- select id , name , date from badges table 
count(*) over (partition by id  order by `date`  ) as running_total_badges                      -- Calculate the running total of badges for each id over time  
from badges order by id , `date`;                                                               -- Results are sorted first by id then date  

-- New Insights and Questions
-- ● Which users have contributed the most in terms of comments, edits, and votes?

select u.id, u.display_name,                                                                              -- User id and name from users table 
ifnull(c.total_comments , 0)  as total_comments ,                                                         -- Count total number of comments made by each user if null set to 0
ifnull(e.total_edits , 0) as total_edits ,                                                                -- Count total number of edits made by each user in post_history if null set to 0                                 
ifnull(v.total_votes , 0) as total_votes ,                                                                -- Count total number of votes recieved by each user if null set to 0
(ifnull(c.total_comments,0) +ifnull(e.total_edits,0) +ifnull(v.total_votes,0)) as total_contribution      -- Calculate total contributation by summing comments , edits and votes 

from users u left join (select user_id , count(*) as total_comments from                                  -- join with a subquery that counts the number of comments made by each user
comments group by user_id  ) c on u.id=c.user_id 
left join (                                                                                               -- join with a subquery that count the total number of edits made by each user in post history table 
 select user_id, count(*) as total_edits from post_history
 group by user_id ) e on u.id=e.user_id
 left join 
 ( select p.owner_user_id as user_id, count(*) as total_votes from votes                                 -- join with subquery that count total number of votes recieved by each user
 join posts p on votes.post_id = p.id group by p.owner_user_id ) v on u.id=v.user_id
 order by total_contribution desc                                                                        -- order the user by their total contribution in descending order 
 limit 10;
 
 -- What types of badges are most commonly earned, and which users are the top
-- earners?
-- finding the most commnly earned badges 

select `name` as badges_name ,                -- Select the badge name and rename it as badges_name
count(*) as total_earned                      -- Count how many times each badges has been earned 
from badges 
group by `name`                              -- Group result by badge name to count occurences 
order by total_earned desc                   -- Shwoing the result by the highest number of times earned 
limit 10; 

-- identifying the users who earned the most badges 
select u.id, u.display_name ,               -- select the user id and name from user table 
count(b.id) as total_badges                 -- Count the total number of badges earned by each user
from users u join badges b on               -- Join users with badges based on user_id
u.id=b.user_id 
group by u.id , u.display_name             -- Group by user_id and name to count badges per user 
order by total_badges desc                 -- Sort the highest number of badges earned 
limit 10;

-- Which tags are associated with the highest-scoring posts
SELECT 
    p.title, 
    GROUP_CONCAT(t.tag_name) AS tags,                       -- Combine multiple tags into a single column
    p.score
FROM posts p
JOIN tags t 
    ON p.title LIKE CONCAT('%', t.tag_name, '%')           -- Match title with multiple tag names
WHERE p.score > (SELECT AVG(score) FROM posts)             -- Get only posts with above-average scores
GROUP BY p.title, p.score                                  -- Group by post to avoid duplicate rows
ORDER BY p.score DESC;                                     -- Sort by highest score


-- ● How often are related questions linked, and what does this say about knowledge
-- sharing?

-- Total number of related questions linked 
SELECT COUNT(*) AS total_related_links
FROM post_links;

-- To see how frequently each questions linked we need to calculate the average links per post
select  count(*) / (count(distinct post_id) ) as avg_links_per_question
from post_links;
-- Many posts are linked, showing strong knowledge sharing because average is 2 
-- if average was less than 1 then Few psots were linked and it would be less structured knowledge sharing
-- Efficient probleming solving
-- Better knowledge discovery

-- To find the most frequently linked question
SELECT post_id, COUNT(*) AS link_count
FROM post_links
GROUP BY post_id
ORDER BY link_count DESC
LIMIT 10;

 
