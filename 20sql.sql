use upgrad;
select * from course;
select * from student;
select * from students;
CREATE TABLE scores ( 
id INTEGER auto_increment PRIMARY KEY, 
player_name TEXT NOT NULL,
score INTEGER NOT NULL );
INSERT INTO scores (player_name, score) VALUES ('Alice', 100), 
('Bob', 90), 
('Charlie', 80), 
('Dave', 80), 
('Eve', 80),
 ('Frank', 50),
 ('Gloria', 40),
 ('Henry', 30), 
 ('Igor', 20),
 ('Jane', 10);
 select * from scores;
  select *, rank() over(order by score desc) from scores limit 5;
 select  *, dense_rank() over(order by score desc) from scores limit 5;
 with cte as
 (
   select *, rank() over(order by score desc) as rnk from scores
   ) select player_name, rnk from cte where player_name='bob';
select * from
(
 select  *, dense_rank() over(order by score desc) as drnk from scores
 ) as sq 
 where drnk <=3;
 
 -- window function 
 
 select *, rank()  over w1 as rnk, dense_rank() over w1 as drnk,
 row_number() over w1 as rno
 from scores
 window w1 as (order by score desc);
 -- lead() 
 -- lag() functions in mysql are used to get preceding and succeeding value of any row within its partition
 -- these 
 use practicedb;
 -- Fetch next station time using lead()
 select * from trains;
 with cte as
 (
 select *, lead(time,1,"NA") over (partition by Train_id order by time) as nextsation
 from trains
 ) select * from cte;
 -- add duration column that finds the diff in time
 -- timestampdiff 
with cte as
(
select *,lead(time,1)
over(partition by train_id order by Time) as lead_st_time 
from trains)
 select *,timestampdiff(Minute,time,lead_st_time)as time_taken from cte;
 
 -- fetch previos time
 
 select *, lag(time) over (partition by Train_id order by time)
 as previos from trains;

 -- rows and range 
  use upgrad;
  create table sales(
  sale_id int auto_increment primary key,
  sale_date DATE,
  amount DECIMAL(10, 2));
  drop table sales;
  INSERT INTO sales (sale_date, amount) VALUES 
  ('2024-03-01', 100), 
  ('2024-03-02', 150), 
  ('2024-03-03', 200), 
  ('2024-03-03', 100),
  ('2024-03-04', 75), 
  ('2024-03-05', 300), 
  ('2024-03-06', 125), 
  ('2024-03-07', 180), 
  ('2024-03-08', 250);
  
  select * from sales;
  -- moving_sum
  select *, sum(amount) over(order by sale_date rows between 1 preceding and 1 following) as moving_sum
  from sales;
 -- moving_avg
 select *, sum(amount) over(order by sale_date rows between 1 preceding and 1 following) as moving_sum,
 round(avg(amount) over(order by sale_date rows between 1 preceding and 1 following),2) as moving_avg
from sales;
 -- running total calculation 
 select *, sum(amount) over(order by sale_date rows between unbounded preceding and current row) as runningtotal
 from sales;
 -- range specification 
 
select *, sum(amount) over(order by sale_date rows between 1 preceding and 1 following) as moving_sum,
sum(amount) over(order by sale_date range between interval 1 DAY preceding and interval 1 day following) as msumrange
from sales;


-- using row specs, calculate the 5 days moving avg( current row and 4 previous rows)
select * from sales;
 select *, avg(amount) over(order by sale_date rows between 4 preceding and current row) as mvsum
 from sales;
 
 
 -- Sort market_fact table in chronological order of order_dates, and display the days difference in a next column 'Gap_Days' 
 -- Hint : market_fact and orders_dimen tables need a join.
 select * from market_fact_full;
 select * from orders_dimen;
 select * from market_fact_full m join orders_dimen o on m.ord_id=o.ord_id;
 -- fetch ord id, sales, order_quantity, order_date 
 select m.ord_id,m.sales,m.order_quantity, o.order_date,lead(order_date) over(order by order_date) as next_order_date,
timestampdiff(DAY, order_date,lead(order_date) over(order by order_date)) as "gap_days" from market_fact_full m
 join orders_dimen o  on m.ord_id=o.ord_id
 order by order_date;
 -- 2. fetch market_fact_id, ord_id,id.prod,ship_id,cust_id,sum of sales for each customer from market_fact_full
 select Market_fact_id,Ord_id,Prod_id,Ship_id,Cust_id,
 round(sum(sales) over(partition by Cust_id) ,2) as total_cust
 from market_fact_full;
 -- 3. Fetch Market_fact_id,Ord_id,prod_id, ship_id, cust_id, sum of sales for 
 -- the current row and the two following rows for each customer ordered by market_fact_id, from marketfactfull
 select Market_fact_id,Ord_id,Prod_id,Ship_id,Cust_id,round(sales,2),
 round(sum(sales) over(partition by Cust_id order by market_fact_id  rows between current row and  2 following),2) as total_cust
 from market_fact_full;
 select * from market_fact_full join shipping_dimen using(ship_id);
 
 select m.ship_id, m.market_fact_id, ship_date,m.shipping_cost,
 sum(m.shipping_cost) over w1 as runtot,
 avg(m.shipping_cost) over w2 as mavg
from market_fact_full m join shipping_dimen s using (ship_id)
window w1 as (partition by ship_id order by ship_date rows between unbounded preceding and current row),
 w2 as (order by ship_date rows between 6 preceding and current row);
 
 
 select * from market_fact_full;
 select*, case  when profit <-500 then "Huge Loss"
					  when profit between -500 and 0 then "Bearable loss"
                      when profit between -0 and 500 then "Decent Profit"
                      else "Greate Profit"
                      end as " Profit type"
                      from market_fact_full;
 
 
 
 
 
 
 
 
 