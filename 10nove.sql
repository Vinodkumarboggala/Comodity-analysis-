use practicedb;
select * from payments;
desc payments;
alter table payments add constraint pk_id primary key (client_id);

insert into payments values(1,10000);
insert into payments values(2,5000);
insert into payments values(3,7800);
insert into payments values(4,9877);
-- error handling with continue

delimiter &&
drop procedure insert_eh;
create procedure insert_eh(in cid int,	in amt int)
begin
declare continue handler for 1062
begin
select " transaction is fraud" as msg ;
insert into fraud (client_id , message, tot)  values (cid,"fraud",now());
end ; 
declare continue handler for 1048
begin
select "amount can't be null" as msg;
end;
insert into payments values (cid, amt);
select "End of Transaction" as msg;
end&&
delimiter ;


call insert_eh(4,Null);

select * from fraud;

-- error handling with exit 
delimiter &&
create procedure insert_e(in cid int,	in amt int)
begin
declare exit handler for 1062
begin
select " transaction is fraud" as msg ;
insert into fraud (client_id , message, tot)  values (cid,"fraud",now());
end ; 
declare exit handler for 1048
begin
select "amount can't be null" as msg;
end;
insert into payments values (cid, amt);
select "End of Transaction" as msg;
end&&
delimiter ;
call insert_eh(7,-80000);
-- another table trigger example 
select * from books;
select * from book_sales;
-- creating a duplicate books table
create table books_dup like books;
insert into books_dup select * from books;
select * from books_dup;

alter table books_dup add tot_sales int;
update books_dup set tot_sales=0;
set sql_safe_updates=0;
update books_dup set tot_sales=tot_sales+1 where bookid=1;
update books_dup set tot_sales=tot_sales+3 where bookid=1;
-- 
update books_dup set tot_sales=tot_sales+5 where bookid=2;	

-- Create a EH_myemp that reads the employees having salary higher than given salary by user
-- and handles unknown column errors by displaying message
select * from myemp;
delimiter &&
create procedure EH_myemp(in empid int, in sala int)
begin
select " This number is wrong" as msg;
select * from myemp where salary>sala;
end&&
delimiter ;



-- suplly db case study quetion
-- display all the tables in the supply_db

show tables;

select * from orders;
-- step 1
select * from orders where order_city not in("Sangli","Srinagar");

select * from orders
where order_city not in("Sangali","Srinagar")
and order_status <> "suspected_fraud";

-- aggregate and sort

select count(order_id) , type from orders 
where order_city not in("Sangali","Srinagar")
and order_status <> "suspected_fraud"
group by type
order by count(order_id) desc;

select * from ordered_items;
select * from Customer_info;
select c.order_id ,o.Order_Item_Id  from orders c join  ordered_items o on c.order_id=o.Order_Item_Id;
-- 3rd quetion
with ol_summary as
(
select order_id, customer_id, Sales, Order_status from orders 
join ordered_items using(order_id) where order_status="complete"
), classummary as
(
select * from customer_info c join ol_summary o on c.id =o.customer_id
) select customer_id,First_name, city,state ,count(order_id) as tot_orders,sum(Sales) as tot_sales
from classummary group by customer_id, first_name,city,state order by tot_orders desc,tot_sales desc;

-- 3rd quetion
select * from product_info;
select * from department;
with cte as
(
select o.order_id, o.shipping_mode,d.name as departmentname from orders o
join ordered_items oi using(order_id)
join product_info p on oi.item_id=p.product_id 
join department d on p.department_id =d.id
where order_status in ("Complete","Closed")
),dep40 as
(
 select count(distinct order_id) as tot_order,departmentname from cte group by departmentname having tot_order >40
 ) select count(distinct order_id ) as totorder,shipping_mode, departmentname from cte where departmentname in(select departmentname from dep40)
 group by shipping_mode, departmentname;

