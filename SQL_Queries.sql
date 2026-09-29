-- Database name 
create database screen_time ; 

-- current database used 
use screen_time ; 

-- Rename Table name 
select * from `indian kids screentime 2025` ;
rename table `indian kids screentime 2025` to 
			kids_screentime; 
            
-- Quick Stats of the table             
            
-- Information from the table 
select * from kids_screentime ;

-- Total records / rows of the table 
select count(*) from kids_screentime  ;

-- Total field(No. of Column headings)  of the table 
select count(*) as Total_column
from INFORMATION_SCHEMA.COLUMNS
where table_schema = "screen_time"
		and table_name = "kids_screentime" ; 

-- Information about filed(Column headings) of the  table 
show columns from  kids_screentime ;
-- or 
describe kids_screentime ;

-- Avg Age 
select round(avg(age))
from kids_screentime ; 

-- Male & Female %
with ahn as (
select count(case when Gender = "Male" then 1 end) as M ,
	count(case when Gender = "Female" then 1 end) as F,
    count(gender) as Total_Gender
from kids_screentime ) 
select round(M * 100.0 / Total_Gender,2) as MalePercent, 
		round(F * 100.0 / Total_Gender,2) as FemalePercent
from ahn  ; 

-- Avg screen time 
select round(avg(Avg_Daily_Screen_Time_hr),2)
from kids_screentime ;


-- Objective (What do we want to discover?)
/*
1.To analyze screen usage patterns among Indian kids across age, 
gender, and location

2.To distinguish between educational vs. recreational screen 
habits

3.To identify who exceeds healthy screen time limits

4.To uncover the prevalence of health impacts related to 
screen overuse

5.To provide data-backed recommendations for improving 
digital health among children */

-- Analysis 

/* 1.Total number of records (kids): */
select count(*)
from kids_screentime ; 
-- Ans: 9712

/*2.Average screen time by gender and age:*/ 
select Age, Gender, round(Avg(Avg_Daily_Screen_Time_hr),2) as AvgScreenTime
from kids_screentime
group by Age, Gender 
order by Age ; 

-- Change Layout or orientation of Output Table 
select Age, 
		round(Avg(case when Gender = "Male" then 
        Avg_Daily_Screen_Time_hr end ),2) as M,
		round(Avg(case when Gender = "Female" 
        then Avg_Daily_Screen_Time_hr end ),2) as F
from kids_screentime
group by Age
order by Age ;

/*3.Which device is used most often? */ 
select Primary_Device, count(*) as TotalUser 
from kids_screentime
group by  Primary_Device
order by TotalUser desc  ; 

/*4.Percentage of kids exceeding the recommended limit:
This Question solved by 3 methods */
select 
round(count(case when Exceeded_Recommended_Limit = "True" 
	then 1 end)*100.0/
count(*),2) as ExceedPercent 
from kids_screentime ; 

-- Using CTE
with ahn as (select count(*) as excedcount
from kids_screentime
where Exceeded_Recommended_Limit = "true"
)
select round(ahn.excedcount * 100 / 
		(select count(*) from kids_screentime),2)    
from ahn ; 

 -- or using User Define Variable
select count(*) into @exceededuser
from  kids_screentime
where Exceeded_Recommended_Limit = "True"  ;
select round(@exceededuser *100 / count(*),2)
from kids_screentime ; 

/*5.Educational vs. Recreational Ratio by Age:*/
select Age, Gender, Educational_to_Recreational_Ratio
from kids_screentime ;
group by Age , Gender
Order by Age ; 

-- Chnage layout or orientation of output table 
select age,
round(avg(case when Gender = "male" 
	then Educational_to_Recreational_Ratio end),2)as M ,
round(avg(case when Gender = "Female" 
	then Educational_to_Recreational_Ratio end),2) as F,
    round(avg(Educational_to_Recreational_Ratio),2) as TotalTimespent
from kids_screentime
group by age
order by age ; 

/*6.Urban vs Rural: Average screen time*/
select Urban_or_Rural, round(avg(Avg_Daily_Screen_Time_hr),2) as AvgScreenTime
from kids_screentime
group by Urban_or_Rural ;
 
/*7.Health Impacts frequency */
select Health_Impacts, count(*) as TotalAffectedPerson
from kids_screentime
group by  Health_Impacts
order by TotalAffectedPerson desc ;


