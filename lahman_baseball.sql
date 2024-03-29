--1. Find all players in the database who played at Vanderbilt University.
--Create a list showing each player's first and last names as well as the total salary they
--earned in the major leagues. Sort this list in descending order by the total salary earned. 
--Which Vanderbilt player earned the most money in the majors?
WITH vandyplayers AS (SELECT collegeplaying.playerid AS playerid, collegeplaying.schoolid AS schoolid, people.namefirst AS firstname, people.namelast AS lastname
FROM collegeplaying
LEFT JOIN people
USING (playerid)
WHERE collegeplaying.schoolid = 'vandy'
GROUP BY playerid, schoolid, people.namefirst, people.namelast)
SELECT playerid, firstname, lastname, schoolid, SUM(salary) as salary
FROM vandyplayers
INNER JOIN salaries
USING (playerid)
GROUP BY playerid, firstname, lastname, schoolid
ORDER BY salary DESC;
--Answer: David Price, $81,851,296

--2. Using the fielding table, group players into three groups based on their position: 
--label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" 
--as "Infield", and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.
SELECT CASE WHEN pos = 'OF' THEN 'Outfield'
		 WHEN pos IN('SS', '1B', '2B', '3B') THEN 'Infield'
	 	 WHEN pos IN('P', 'C') THEN 'Battery'
	 	 END AS position_groups,
	SUM(po) AS putouts
	FROM fielding
	GROUP BY position_groups;
--Answer: Outfield- 2,731,506, Infield- 6,101,378, Battery- 2,575,499
--3. Find the average number of strikeouts per game by decade since 1920. Round the numbers you
--report to 2 decimal places. Do the same for home runs per game. Do you see any trends? 
--(Hint: For this question, you might find it helpful to look at the **generate_series** function (https://www.postgresql.org/docs/9.1/functions-srf.html). 
--If you want to see an example of this in action, check out this DataCamp video: https://campus.datacamp.com/courses/exploratory-data-analysis-in-sql/summarizing-and-aggregating-numeric-data?ex=6)
WITH annual AS (SELECT yearID AS year, ROUND(SUM(SO), 2) AS annual_SO, ROUND(SUM(G)/2.0, 2) AS annual_G
FROM teams
GROUP BY year
ORDER BY year),
decades AS (SELECT CONCAT(
        FLOOR(year / 10) * 10, 
        '-', 
        (CEIL(year / 10) * 10) + 9
    ) as decade, ROUND(SUM(annual_SO), 2) AS decade_SO, ROUND(SUM(annual_G), 2) AS decade_G
FROM annual
WHERE year >= 1920
GROUP BY
    CONCAT(
        FLOOR(year / 10) * 10,
        '-', 
        (CEIL(year / 10) * 10) + 9
    )
				)
SELECT decade, ROUND(decade_SO/decade_g, 2) AS SO_per_game
FROM decades
ORDER BY decade;

WITH annual AS (SELECT yearID AS year, ROUND(SUM(HR), 2) AS annual_HR, ROUND(SUM(G)/2.0, 2) AS annual_G
FROM teams
GROUP BY year
ORDER BY year),
decades AS (SELECT CONCAT(
        FLOOR(year / 10) * 10, 
        '-', 
        (CEIL(year / 10) * 10) + 9
    ) as decade, ROUND(SUM(annual_HR), 2) AS decade_HR, ROUND(SUM(annual_G), 2) AS decade_G
FROM annual
WHERE year >= 1920
GROUP BY
    CONCAT(
        FLOOR(year / 10) * 10,
        '-', 
        (CEIL(year / 10) * 10) + 9
    )
				)
SELECT decade, ROUND(decade_HR/decade_g, 2) AS HR_per_game
FROM decades
ORDER BY decade;
--Answer: The overall trend for both metrics has been to slowly increase over time.

--4. Find the player who had the most success stealing bases in 2016, where __success__ is measured 
--as the percentage of stolen base attempts which are successful. (A stolen base attempt results 
--either in a stolen base or being caught stealing.) Consider only players who attempted
--_at least_ 20 stolen bases. Report the players' names, number of stolen bases, number of attempts, 
--and stolen base percentage.

--Answer:
--5. From 1970 to 2016, what is the largest number of wins for a team that did not win the world series? What is the smallest number of wins for a team that did win the world series? Doing this will probably result in an unusually small number of wins for a world series champion; determine why this is the case. Then redo your query, excluding the problem year. How often from 1970 to 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?

--Answer:
--6. Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? Give their full name and the teams that they were managing when they won the award.

--Answer:
--7. Which pitcher was the least efficient in 2016 in terms of salary / strikeouts? Only consider pitchers who started at least 10 games (across all teams). Note that pitchers often play for more than one team in a season, so be sure that you are counting all stats for each player.

--Answer:
--8. Find all players who have had at least 3000 career hits. Report those players' names, total number of hits, and the year they were inducted into the hall of fame (If they were not inducted into the hall of fame, put a null in that column.) Note that a player being inducted into the hall of fame is indicated by a 'Y' in the **inducted** column of the halloffame table.

--Answer:
--9. Find all players who had at least 1,000 hits for two different teams. Report those players' full names.

--Answer:
--10. Find all players who hit their career highest number of home runs in 2016. Consider only players who have played in the league for at least 10 years, and who hit at least one home run in 2016. Report the players' first and last names and the number of home runs they hit in 2016.

--Answer:
--After finishing the above questions, here are some open-ended questions to consider.
--**Open-ended questions**

--11. Is there any correlation between number of wins and team salary? Use data from 2000 and later to answer this question. As you do this analysis, keep in mind that salaries across the whole league tend to increase together, so you may want to look on a year-by-year basis.

--Answer:
--12. In this question, you will explore the connection between number of wins and attendance.

    --12a. Does there appear to be any correlation between attendance at home games and number of wins? 
	
	--Answer:
    --12b. Do teams that win the world series see a boost in attendance the following year? What about teams that made the playoffs? Making the playoffs means either being a division winner or a wild card winner.
	
	--Answer:

--13. It is thought that since left-handed pitchers are more rare, causing batters to face them less often, that they are more effective. Investigate this claim and present evidence to either support or dispute this claim. First, determine just how rare left-handed pitchers are compared with right-handed pitchers. Are left-handed pitchers more likely to win the Cy Young Award? Are they more likely to make it into the hall of fame?