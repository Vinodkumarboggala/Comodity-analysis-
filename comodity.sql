--  5th quetion
-- An order is cancelled when the status of the order is either cancelled or SUSPECTED_FRAUD. 
-- Obtain the list of states by the order cancellation % and sort them in the descending order of the 
-- cancellation % Definition: Cancellation % = Cancelled order / Total Orders
select * from orders;

select * from orders where order_status = "canceled" or order_status="Suspected_fraud";
with cancelled_orders as
(
select count(order_id) as cancelled_orders,order_state from orders
where order_status = "canceled" or order_status="Suspected_fraud"
group by order_state
), total_orders as
(
select count(order_id) as total_orders,order_state
from orders group by order_state
) 
select*, round((cancelled_orders/total_orders)*100,2) as `cancellation%`
from cancelled_orders right join total_orders using(order_state)
order by `cancellation%` desc;





-- commodity case study
-- Get the common commodities between the Top 10 costliest commodities of 2019 and 2020
select * from commodities_info;
select * from price_details;
select * from region_info;
select max(Retail_Price), Commodity_Id from price_details where year(Date)=2019 
group by commodity_id order by max(Retail_Price) desc limit 10; 	 	
-- 1
with max_2019 as
(
select max(Retail_Price) as mp2019, Commodity_Id from price_details where year(Date)=2019 
group by commodity_id order by max(Retail_Price) desc limit 10
), max_2020 as
(
select max(Retail_Price) as mp2020, Commodity_Id from price_details where year(Date)=2020
group by commodity_id order by max(Retail_Price) desc limit 10
),
common_commodity as
(
select * from max_2019 inner join max_2020 using(commodity_id)
)
select cc .commodity_id ,ci.commodity from common_commodity cc inner join commodities_info ci
ON cc.commodity_id=ci.id;


-- 2nd What is the maximum difference between the prices of a commodity at 
-- one place vs the other for the month of Jun ‘2021? Which commodity was it for?

with min_max as
(
select min(Retail_Price) as min_RP, max(Retail_Price) as max_RP,Commodity_Id from price_details where year(Date)=2020 and month(Date)=6
group by Commodity_Id
), diff_RP as
( 
select *,max_RP-min_RP as difference from min_max
)
select ci.commodity, d.difference as price_difference from diff_RP 
d inner join commodities_info ci 
on d.commodity_id = ci.id 
order by price_difference desc limit 1;

-- Arrange the commodities in order based on the number of
-- varieties in which they are available, with the highest one shown
select * from commodities_info;
with variety as
(
select commodity ,count(distinct variety) as variety from commodities_info group by commodity
) select * from variety order by variety desc;

-- What is the price variation of commodities for each city from Jan 2019 to Dec 2020. 
-- Which commodity has seen the highest price variation and in which city?
with p_2019 as
(
select * from price_details where year(Date)=2019 and month(Date) = 1
), p_2020 as
(
select * from price_details where year(Date)=2020 and month(Date) = 1
) , tot_data as 
(
select p19.id,p19.region_id,p19.commodity_id,p19.date, p19.retail_price as start_price , p20.retail_price as end_price 
from p_2019 as p19 inner join p_2020 as p20 on P19.region_id= p20.region_id and p19.commodity_id=p20.commodity_id
),var_data as
( 
select *,(end_price - start_price) as abs_variation, round((end_price-start_price)/start_price*100,2) as perc_variation 
from tot_data
) 
select commodity, centre as city, start_price,end_price , abs_variation,perc_variation from var_data 
inner join region_info on var_data.region_id=region_info.id
inner join commodities_info on var_data.commodity_id = commodities_info.id 
order by perc_variation desc limit 1;

/*
Input: price_details: Id, region_id, commodity_id region_info: Id and State commodities_info: Id and
Commodity
Expected Output: commodity; Expecting only one value as output
Step 1: Join region info and price details using the Region_Id from price_details with Id from region_info
Step 2: From result of Step 1, perform aggregation – COUNT(Id), group by State;
Step 3: Sort the result based on the record count computed in Step 2 in ascending order; Filter for the top
State
Step 4: Filter for the state identified from Step 3 from the price_details table
Step 5: Aggregation – COUNT(Id), group by commodity_id; Sort in descending order of count
Step 6: Filter for top 1 value and join with commodities_info to get the commodity name
*/

-- 4th quetion
select * from price_details;
with state_data as
(
select p.*,r.centre,r.state from price_details p  left join region_info r on p.region_id=r.id 

), least_state as
(
select count(id), state 
from state_data group by state order by count(id) limit 1
), comm_dep_summ as
(
select count(id) AS COUNTID,commodity_id 
from state_data where state in(select state from least_state)
group by commodity_id order by count(id) desc
) select commodity,sum(countid) as datapoint from comm_dep_summ c left join commodities_info ci on c.commodity_id = ci.id
group by Commodity
order by datapoint desc;

