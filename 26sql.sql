-- First_value and last_nale and nthname
select *, first_value(First_name) over(partition by dep_id order by salary desc rows between  unbounded preceding and unbounded following) as hspm
from myemp order by emp_id;
-- lowest salaried person
select *, last_value(First_name) over(partition by dep_id order by salary desc rows between  unbounded preceding and unbounded following) as lspm
from myemp order by emp_id;
-- fetch the 2nd highest salaried person in each department
select *, nth_value(first_name,2) over (partition by dep_id order by salary desc rows between unbounded preceding and unbounded following) as sndhght
from myemp order by emp_id;
-- simple case 
select *, case dep_id when 90 then "10%"
                      when 60 then "15%"
                      else"8%"
                      end as "% Hike"
                      from myemp;
-- search based 
select*, case when dep_id = 90 then "10%" 
			  when job_id = "IT-Prog" then "15%"
              when salary > 3000 then "5%"
              else "5%"
              end as"%Hike"
              from myemp;
              
					