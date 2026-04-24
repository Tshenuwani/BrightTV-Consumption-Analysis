--------------------------------------
--EDA
--------------------------------------
--Viewing the user table
SELECT *
FROM workspace.brighttv2.up;
--Checking the viwership table
SELECT *
FROM workspace.brighttv2.v;

--Checkking the date range
SELECT MIN(DATE(FROM_UTC_TIMESTAMP(RecordDate2, 'Africa/Johannesburg'))), 
       MAX(DATE(FROM_UTC_TIMESTAMP(RecordDate2, 'Africa/Johannesburg')))
FROM workspace.brighttv2.v;

--Checking for null value in v table(:::::No NULL values)
SELECT UserID0,
       Channel2,
       RecordDate2,
       `Duration 2`,
       userid4
FROM workspace.brighttv2.v
WHERE UserID0 IS NULL OR
      Channel2 IS NULL OR 
      RecordDate2 IS NULL OR
      `Duration 2` IS NULL OR
      userid4 IS NULL;

--Checking for null value in up table (:::::No NULL values)
SELECT UserID,
       Name,
       Surname,
       Email,
       Gender,
       Race,
       Age,
       Province,
       `Social Media Handle`
FROM workspace.brighttv2.up
WHERE Age IS NULL OR
      UserID IS NULL OR 
      Name IS NULL OR
      Surname IS NULL OR
      Email IS NULL OR
      Gender IS NULL OR 
      Race IS NULL OR
      Age IS NULL OR 
      Province IS NULL OR
      `Social Media Handle` IS NULL;

------------------------------------------------------------------------
--Selecting the columns and creating new columns 
------------------------------------------------------------------------
SELECT 
       Channel2 AS channel,
--Counting the IDs
       COUNT(DISTINCT UserID0) AS viewers, 
--Extracting the date
       DATE(FROM_UTC_TIMESTAMP(RecordDate2, 'Africa/Johannesburg')) AS record_date,
--Extracting the day
       DAYNAME(RecordDate2) AS day,
--Extracting the month
       MONTHNAME(RecordDate2) AS month,
-- Changing the date format and converted the UTC time to SA time(UTC+2) to create the time of day clumn
       CASE
          WHEN date_format(FROM_UTC_TIMESTAMP(RecordDate2, 'Africa/Johannesburg'),'HH:MM a' ) BETWEEN  '06:00 AM' AND '11:59 AM' THEN 'morning'
          WHEN date_format(FROM_UTC_TIMESTAMP(RecordDate2, 'Africa/Johannesburg'),'HH:MM a' ) BETWEEN '12:00 PM' AND '17:59 PM' THEN 'afternoon'
          WHEN date_format(FROM_UTC_TIMESTAMP(RecordDate2, 'Africa/Johannesburg'),'HH:MM a' ) BETWEEN '18:00 PM' AND '23:59 PM' THEN 'evening'
          ELSE 'night' 
          END AS time_of_day,
--Changing the date format and converted the UTC time to SA time(UTC+2) to create the record_time column
       date_format(FROM_UTC_TIMESTAMP(RecordDate2, 'Africa/Johannesburg'),'HH:MM a' ) AS record_time, 
--Changing the date format
       date_format(`Duration 2`,'HH:MM:SS') AS duration,
--Changing the values to lower date in the column
       LOWER(race) AS race,
       age,
--Segmenting the ages using the age values to create the age_group column
       CASE
          WHEN age BETWEEN  0 AND 12 THEN 'kids'
          WHEN age BETWEEN 13 AND 17 THEN 'teens'
          WHEN age BETWEEN 18 AND 24 THEN 'students'
          WHEN age BETWEEN 25 AND 34 THEN 'young professionals'
          WHEN age BETWEEN 35 AND 44 THEN 'adults'
          ELSE 'older'
          END AS age_group,
--Changing the province values to lower case
       LOWER(province) AS province,
--Checking if the user has a social media handle
       CASE
          WHEN `Social Media Handle`='None' THEN  'no'
          ELSE 'yes' 
          END AS social_media
-- Left Joining the two tables(v table and up table)
FROM workspace.brighttv2.v
LEFT JOIN workspace.brighttv2.up
ON v.UserID0=up.UserID
--Grouping the unaggregated columns
GROUP BY DATE(RecordDate2) , 
       DAYNAME(RecordDate2) ,
       MONTHNAME(RecordDate2),
       record_time,
       duration,
       race,
       age,
       province,
       channel,
       social_media,
       RecordDate2,
       age_group,
       time_of_day
--Ordering the columns by date
ORDER BY record_date;
