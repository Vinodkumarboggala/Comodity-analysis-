-- Create a stored function that calculates the sales tax for a given price:
delimiter //
create function sales_tax (price decimal(6,2), taxrate decimal(5,2))
returns decimal(6,2)
Deterministic 
begin
declare taxamt decimal(6,2);
set taxamt=price*taxrate/100;
return taxamt;
end //
delimiter ;
drop table sales_tax;
select sales_tax(200,5);

-- 2 create a function timestamoedmessage this concatinates text with current time and date
delimiter $$
create  function timestampedmesaage( message varchar(50))
returns varchar(100)
Deterministic 
begin
declare op varchar(100);
set op= concat(message, "-", now());
return op;
end $$
delimiter ;
set global log_bin_trust_function_creators = 0;
select timestampedmesaage("Class at") as timestamp;
-- create a 'sqrofnumber' function 
delimiter ##
create function sqrof(number int)
returns int
deterministic
begin
declare a int;
set a=number*number;
return a;
end ##
delimiter ;
select sqrof(7);
-- 4 create a function " Experience" that calculates  years employeed given the hired date
select * from myemp;

delimiter **
create function Experience(hiredate date)
returns int
deterministic
begin
declare yardiff int;
set yardiff=timestampdiff(year,hiredate,now());
return yardiff;
end **
delimiter ;
select Experience("2004-06-03") as exp;
select*, experience(Hire_Date) as expyrs from myemp;
select count(emp_id) from myemp;

delimiter &&
create function profittype(profit int signed)
returns varchar(50) 
deterministic
begin
declare message varchar(50);
set message= case when profit < -500 then " Huge loss"
                  when profit between -500 and 0 then "Bearable Loss"
                  when profit between 0 and 500 then "decent Profit"
                  else " Greate Profit" end;
return message;
end && 
delimiter ;

select * from market_fact_full;
select *, practicedb.profittype(profit) as profit from market_fact_full;
-- 4
-- Defines a user-defined function named OrderType that categorizes orders based on 
-- their quantity into different types: "Bulk order,"(>30) "Medium order,"(Between 10 to 30)
-- "Low order,"(Between 0 and 10) or "Null" if the quantity falls outside the specified ranges. 
-- The function takes an integer parameter Order_quantity and returns a varchar message indicating the order type.
select * from market_fact_full;
delimiter **
create function Ordertype(orders int)
returns varchar(100)
deterministic
begin
declare msg varchar(50);
set msg= case when orders >30 then "Bulk Order"
              when orders between 10 and 30 then "Medium order"
              when orders between 0 and 10 then "Low Order"
              else "Null" end;
return msg;
end **
delimiter ;
select *, ordertype(Order_Quantity) as orders from market_fact_full;

-- create a stored procedure that reads data of myemp
delimiter \\
create procedure myempread()
begin
select * from myemp;
end \\
delimiter ;
call myempread();

-- create a sp(IN) that takes dep_id value as input and reads the data belonging to that specific dept
delimiter &&
create procedure emp_info(IN depid int)
begin
select * from myemp where dep_id=depid;
end &&
delimiter ;
call practicedb.emp_info(20);
-- create a sp (emp_analysis) that calculates min_sal, max_sal, countofemp and avg_sal for a 
-- specific dep_id that user inputs
delimiter &&
create procedure emp_analysis(in deptid int)
begin
select min(salary),max(salary),count(dep_id),avg(salary) from myemp where dep_id=deptid;
end &&
delimiter ;
call emp_analysis(45);
-- create a sp countofemp that takes dep_id and salary as inputs and counts the employees in that dep 
-- with salary higher than given salary
delimiter &&
create procedure count_emp(in depid int, salary_in int)
begin
select count(emp_id) from myemp where dep_id=depid and salary>salary_in;
end &&
delimiter ;
call count_emp(90,40000);
-- create a procedure get_ship_status which should accept the shipmode 
-- value from user and show the number of shipments for each year for that status.
select * from shipping_dimen;
select distinct ship_mode from shipping_dimen;


delimiter &&
create procedure dep(in modename varchar(100))
begin
select count(Ship_id) as tot, year(ship_date) as `year` from shipping_dimen where Ship_mode=modename group by `year` order by `year`;
end &&
delimiter ;
call dep('DELIVERY TRUCK');


-- TCL commands
create table account( 
acct_id int primary key auto_increment,
acct_name varchar(100),
balance decimal(10,2));
select * from account;
insert into account (acct_name,balance) values ("hari",1000),
("bhagya",500);

start transaction; -- auto_commmit is turn off
-- debit 500 from hari
update account set balance =balance-500 where acct_id=1;
select * from account;
-- credit failed
rollback;

start transaction;
update account set balance=balance-300 where acct_id =1;
-- credit successfull done
update account set balance=balance+300 where acct_id =2;
commit;

-- savepoint

