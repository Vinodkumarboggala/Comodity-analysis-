select * from customer_info;
select * from branch_details;
select * from sales_1;
select * from product_info;
select * from sales_fact;
select * from order_product;
-- find the number of transaction done by each gender in each year;
select count(s.order_id) as cuntoftran, c.gender, year(s.order_date) as `year`
from sales_1 s join customer_info c on s.customer_id =c.customer_id
group by gender;

-- How many customers have placed an order from more than one store?
select * from sales_1 join 	branch_details using(store_id);
select count(b.store_id) as str, c.customer_id from branch_details b join customer_info c on b.store_id=c.customer_id group by customer_id;
select count(store_id) , store_name from branch_details group by store_name;
