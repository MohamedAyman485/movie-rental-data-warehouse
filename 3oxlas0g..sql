-- 1 Display all customers.
select * 
from DimCustomer

-- 2 Display all movies released after 2015.
select *
from DimMovie
where ReleaseYear > 2015

-- 3 Display customer name and city only.
select CustomerName , CustomerCity
from DimCustomer

-- 4 Show the first 20 rentals.
select top 20 *
from FactRentals

-- 5 Display movies sorted by rental price descending.
select *
from DimMovie
order by RentalPrice desc;
 
-- 6 Find customers from Cairo.
select *
from DimCustomer
where CustomerCity = 'cairo'

-- 7 Find Action movies.
select *
from DimMovie
where Genre = 'Action'

-- 8 Find rentals longer than 5 days.
select *
from FactRentals
where RentalDays > 5

-- 9. Find movies priced between 5 and 10.
select *
from DimMovie
where RentalPrice between 5 and 10 

-- 10. Find customers whose membership type is Gold.
select *
from DimCustomer
where MembershipType = 'Gold'

-- 11. Count total customers.
select count(*) as TotalCustomers
from DimCustomer

-- 12. Count total rentals.
select count(*) as TotalRentals
from FactRentals

-- 13. Calculate total revenue.
select sum(Revenue) as TotalRevenue
from FactRentals

-- 14. Calculate average movie rental price.
select avg(RentalPrice) as AvgMovieRentalPrice
from DimMovie

-- 15. Find the highest movie rental price.
select max(RentalPrice) as HighestMovieRental
from DimMovie

-- 16. Total revenue by genre.
select M.Genre ,sum(Revenue) as TotalRevnue
from FactRentals F
join DimMovie M
on F.MovieID = M.MovieID
group by M.Genre

-- 17. Number of customers by city.
select CustomerCity , count(CustomerID) as NumberOfCustomers
from DimCustomer
group by CustomerCity

-- 18. Average rental days by store.
select S.StoreName , avg(RentalDays) as AvgRentalDays
from FactRentals F
join DimStore S
on F.StoreID = S.StoreID
group by S.StoreName

-- 19. Number of rentals per month.
select D.Month ,D.MonthName , count(RentalID) as numberofrentals
from FactRentals F
join DimDate D
on F.DateID = D.DateID
group by D.Month ,D.MonthName 
order by D.Month

-- 20 Revenue by membership type.
select C.MembershipType , sum(Revenue) as RevenueForMembership
from FactRentals F
join DimCustomer C
on F.CustomerID = C.CustomerID
group by C.MembershipType

-- 21. Genres with revenue greater than 50,000.
select M.Genre , sum(Revenue) as TotalRevenueGenre
From FactRentals F
join DimMovie M 
on F.MovieID = M.MovieID
group by M.Genre
having sum(F.Revenue) > 50000

-- 22. Cities with more than 500 customers.
select CustomerCity , count(*) as NumberOfCustomer 
from DimCustomer
group by CustomerCity
having count(*) > 500

-- 23. Create a CTE containing total revenue per customer and display customers whose revenue exceeds the average customer revenue.
with CustomerRevenue as
(
select
   CustomerID,
   SUM(Revenue) as TotalRevenue
from FactRentals
group by CustomerID
)
select
    CustomerID,
    TotalRevenue
from CustomerRevenue
where TotalRevenue >
(
select avg(TotalRevenue)
from CustomerRevenue
);

-- 24. Create a view showing RentalID, CustomerName, MovieTitle, Revenue, and Rental Date.
create view RentalDetails as
select F.RentalID , C.CustomerName , M.MovieTitle , F.Revenue , D.Date
from FactRentals F
join DimCustomer C
on F.CustomerID = C.CustomerID
join DimMovie M
on F.MovieID = M.MovieID
join DimDate D
on F.DateID = D.DateID

select *
from RentalDetails

-- 25. Create a stored procedure that accepts a Genre and returns all movies belonging to that genre.
create procedure MovieByGenre
@genre varchar(40)
as
begin 
select Genre, MovieTitle ,MovieID
from DimMovie
where Genre = @genre
end

exec MovieByGenre 'Action';



