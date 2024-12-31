select * from trips;

select * from trips_details;

select * from loc;

select * from duration;

select * from payment;


---------total trips

select count(distinct tripid) from trips_details; 



----------check for duplicate values if it's present in tripe details or not (is it primary key or not)

select tripid,COUNT(tripid) cnt from trips_details
group by tripid
having count (tripid)>1;



-------------- total drivers

select count(distinct driverid) from trips;



---------------total earnings

select * from trips;

select sum(fare) fare from trips;



----------------total completed trips

select COUNT(distinct tripid) from trips;



----------------total searches
select * from trips_details;

select sum(searches)searches from  trips_details;



-----------------total searches that got estimate

select sum(searches_got_estimate) searches_got_estimate from trips_details;



-----------------total searches for quotes

select sum(searches_for_quotes)searches_for_quotes from trips_details;



-----------------total searches which got quotes

select sum(searches_got_quotes)searches_got_quotes from trips_details;



-----------------total driver cancelled

select count(*) -sum(driver_not_cancelled)driver_not_cancelled from trips_details;



-----------------total otp entered

select sum(otp_entered)otp_entered from trips_details;



-----------------total end rides

select sum(end_ride)end_ride from trips_details;




------------------avarage distance per trip

select avg(distance) from trips;




------------------avarage fare per trip

select avg(fare) from trips;



--------------------distance travelled

select sum(distance) from trips;



--------------------most used payment method----- subquery

select a.method from payment a inner join

(select top 1 faremethod , COUNT(distinct tripid) cnt from trips
group by faremethod
order by COUNT( distinct tripid ) desc) b 
on a.id=b.faremethod
;




-------------the highest payment was made through which instrument----- subquery

select a.method from payment a inner join 

(select top 1 * from trips
order by fare desc ) b

on a.id=b.faremethod; 


select faremethod,SUM(fare) from trips
group by faremethod
order by  sum(fare) desc;





-----------------which two location had the most trips  ----- subquery used

select * from
(select * , dense_rank() over(order by  trip desc) rnk
from
(select  loc_from,loc_to,COUNT(distinct tripid) trip from trips
group by loc_from,loc_to
)a)b
where rnk=1;




------------------top 5 earnings drivers

select * from  trips;


select * from
(select * , dense_rank() over(order by  fare desc) rnk
from
(select driverid , SUM(fare) fare from trips
group by driverid)b)c
where rnk<6;





---------------------which duration had more trips

select * from trips;

select * from
(select * , rank() over (order by  cnt desc) rnk
from
(select duration,COUNT(distinct tripid) cnt from trips
group by duration)b)c
where rnk=1;




-----------------------which driver , customer pair had more orders

select * from
(select * , rank() over (order by  cnt desc) rnk
from
(select driverid,custid,COUNT(distinct tripid) cnt from trips
group by driverid,custid)c)d
where rnk=1;




-----------------------search to estimate rate
select * from trips_details;
select * from trips;

select SUM(searches_got_estimate)/SUM(searches)*100.0 from trips_details;




-------------------------estimate to search for quote rate

-------------------------estimate to search acceptance rate

-------------------------estimate to search for booking rate

-------------------------booking cancellation rate

-------------------------conversion rate

-------------------------which area got highest number of  trips in which duration

select * from
(select * , rank() over(partition by duration order by cnt desc) rnk 
from
(select duration,loc_from,COUNT(distinct tripid) cnt from trips
group by duration,loc_from)a)b
where rnk=1
;




-------------------------which duration got highest number of  trips in each of the location present

select * from
(select * , rank() over(partition by loc_from order by cnt desc) rnk 
from
(select duration,loc_from,COUNT(distinct tripid) cnt from trips
group by duration,loc_from)a)b
where rnk=1
;




-------------------------which area got the highest fares , cancellation trips

select * from trips;
select * from trips_details;

select * from
(select * , rank() over(order by fare desc) rnk 
from
(select loc_from,sum(fare) fare from trips
group by loc_from)b)c
where rnk=1;



select * from(select * , rank() over(order by can desc) rnk 
from
(
select loc_from, count(*) -sum(customer_not_cancelled) can from trips_details
group by loc_from)b)c
where rnk=1;




-------------------------which area got the trips

select * from
(select * , rank() over(order by ti desc) rnk 
from
(select duration,sum(distinct tripid) ti from trips
group by duration)b)c
where rnk=1;