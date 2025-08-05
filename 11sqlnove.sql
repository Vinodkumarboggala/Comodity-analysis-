-- Create a function CalculateAge that takes a date of birth as input and returns the current age.
use practicedb;
delimiter &&
create function caleage(dob date)
returns int
deterministic
begin
declare age int;
set age=timestampdiff(year,dob,curdate());
return age;
end &&
delimiter ;
-- Write a stored procedure AddPerson that inserts a new person into person table with fields for id,fname, lname
select * from person;
delimiter &&
create procedure addperson(in id int, in firname varchar(100), in lstname varchar(50))
Begin
insert into person values(id,firname,lstname);
end &&
delimiter ;
call addperson(8,'vinod','kumar');

 -- Create a SP that takes dep_id and calculates the avg salary and stores this avg salary value in a O/P variable
 delimiter &&
 create procedure avg_dep_sal(in depid int,	out avgsal float)
 begin
  select avg(salary) as avgs into avgsal from myemp where dep_id = depid;
 end &&
delimiter ;
call avg_dep_sal(90,@avgsal);
SELECT @avgsal;

CREATE TABLE title(worker_ref_id INT,worker_title VARCHAR(50),affected_from DATETIME);

INSERT INTO title(worker_ref_id, worker_title, affected_from) VALUES(1, 'Engineer', '2020-01-15'),
(2, 'Marketing Manager', '2019-03-10'),
(3, 'Sales Manager', '2021-06-21'),
(4, 'Junior Engineer', '2018-04-30'),
(5, 'Senior Salesperson', '2021-01-15');



CREATE TABLE worker(worker_id INT PRIMARY KEY,first_name VARCHAR(50),last_name VARCHAR(50),salary INT,joining_date DATETIME,department VARCHAR(50));
INSERT INTO worker(worker_id, first_name, last_name, salary, joining_date, department) VALUES
(1, 'John', 'Doe', 80000, '2020-01-15', 'Engineering'),
(2, 'Jane', 'Smith', 120000, '2019-03-10', 'Marketing'),
(3, 'Alice', 'Brown', 120000, '2021-06-21', 'Sales'),
(4, 'Bob', 'Davis', 75000, '2018-04-30', 'Engineering'),
(5, 'Charlie', 'Miller', 95000, '2021-01-15', 'Sales');

select *, max(salary) as maxsal from worker group by worker_id;
select * from title;
select * from worker;
select * from worker join title on worker_id = worker_ref_id;
with cte as
(
select * from worker join title on worker_id = worker_ref_id
)
select worker_title from cte where salary = (select max(salary) from worker);


Create table If Not Exists Emple (id int, name varchar(255), department varchar(255), managerId int);

insert into Emple  (id, name, department, managerId) values ('101', 'John', 'A', NULL);
insert into Emple  (id, name, department, managerId) values ('102', 'Dan', 'A', '101');
insert into Emple  (id, name, department, managerId) values ('103', 'James', 'A', '101');
insert into Emple  (id, name, department, managerId) values ('104', 'Amy', 'A', '101');
insert into Emple  (id, name, department, managerId) values ('105', 'Anne', 'A', '101');
insert into Emple  (id, name, department, managerId) values ('106', 'Ron', 'B', '101');
with cte as
(
select e.*,m.name as managername from Emple e left join Emple m on e.managerid=m.id
),
noofemp as
(
select count(id) as cnt,managername
from cte
group by managername
)
select managername as name from noofemp where cnt>=5;




 