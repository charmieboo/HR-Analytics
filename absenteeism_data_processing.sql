SELECT * FROM work.absenteeism_at_work;

SELECT * FROM work.compensation;

SELECT * FROM work.reasons;

-- Create join table
SELECT
	*
FROM work.absenteeism_at_work a
LEFT JOIN work.compensation c
ON a.ID = c.ID
LEFT JOIN work.reasons r
ON a.reason_for_absence = r.number;

-- find the healthiest employees (maybe to reward them bonus)
SELECT * FROM work.absenteeism_at_work
WHERE Social_drinker = '0'
	AND social_smoker = '0'
    AND BMI < 25
	AND absenteeism_time_in_hours < (SELECT AVG(absenteeism_time_in_hours) FROM work.absenteeism_at_work);
    
-- compensation rate increase for non-smokers / our budget is $9831,221, so $0.68 increase per hours
-- thus yearly amount is $1414.40 more per year, for each non-smokers
SELECT
	COUNT(social_smoker) AS non_smokers
FROM work.absenteeism_at_work
WHERE social_smoker = '0';

-- optimise query
SELECT
	a.ID,
    r.reason,
    BMI,
    month_of_absence,
    CASE
		WHEN BMI < 18.5 THEN 'Underweight'
        WHEN BMI BETWEEN 18.5 AND 25 THEN 'Healthy'
        WHEN BMI BETWEEN 25 AND 30 THEN 'Overweight'
        WHEN BMI > 30 THEN 'Obese'
        ELSE 'Unknown'
	END AS BMI_Category,
    CASE
		WHEN month_of_absence IN (12,1,2) THEN 'Winter'
        WHEN month_of_absence IN (3,4,5) THEN 'Spring'
        WHEN month_of_absence IN (6,7,8) THEN 'Summer'
        WHEN month_of_absence IN (9,10,11) THEN 'Fall'
        ELSE 'Unknown'
	END AS Season_names,
    month_of_absence,
    day_of_the_week,
    Transportation_expense,
    education,
    son,
    social_drinker,
    social_smoker,
    pet,
    disciplinary_failure,
    age,
    work_load_avg_daily,
    absenteeism_time_in_hours
FROM work.absenteeism_at_work a
LEFT JOIN work.compensation c
ON a.ID = c.ID
LEFT JOIN work.reasons r
ON a.reason_for_absence = r.number;