-- amazon data
Select * 
From OrderHistory

Select *
from OrdersReturned


--total spending through out the years
select SUM(TotalOwed) as TotalSpending
From OrderHistory
-- Total Order Created
Select Count (Distinct OrderID)
From OrderHistory
--Most expensive Order on amazon
Select OrderID, Max(TotalOwed) as MaxSpend
From OrderHistory
Group by OrderID
Order by MaxSpend Desc
--most expensive single item on amazon
Select ASIN, MAX(TotalOwed) as MaxSpend
From OrderHistory
Group by ASIN
Order by MaxSpend Desc

--spending on each Card
Select PaymentInstrumentType, SUM(TotalOwed) as TotalSpending
From OrderHistory
Group by PaymentInstrumentType
Order by TotalSpending DESC



--Break OrderDate to Years,Months and Dates
Select OrderDate
From OrderHistory

Select 
PARSENAME(REPLACE(OrderDate, ' ', '.') , 3) as OrderDate2
,PARSENAME(REPLACE(OrderDate, ' ', '.') , 2) 
From OrderHistory

Alter Table OrderHistory
Add OrderDatesplit Date,
	Ordertime Time

Update OrderHistory
Set OrderDatesplit = PARSENAME(REPLACE(OrderDate, ' ', '.') , 3)

Update OrderHistory
Set OrderTime = PARSENAME(REPLACE(OrderDate, ' ', '.') , 3)

Select 
PARSENAME(REPLACE(Orderdatesplit, '-', '.') , 3) as 'Year'
,PARSENAME(REPLACE(Orderdatesplit, '-', '.') , 2) as 'Month'
,PARSENAME(REPLACE(Orderdatesplit, '-', '.') , 1) as 'Day'
From OrderHistory


Alter Table OrderHistory
ADD Years Int,
	Months Int, 
	Days Int

Update OrderHistory
Set Years = PARSENAME(REPLACE(Orderdatesplit, '-', '.') , 3)

Update OrderHistory
Set Months = PARSENAME(REPLACE(Orderdatesplit, '-', '.') , 2)
Update OrderHistory
Set Days = PARSENAME(REPLACE(Orderdatesplit, '-', '.') , 1)

--
	



--spendings break down by years
Select Years, SUM(TotalOwed) as TotalSpending
from OrderHistory
Group By Years
Order By TotalSpending DESC

--avg spendings of each month
Select Months, AVG(TotalOwed) as TotalSpending
from OrderHistory
Group By Months
Order By TotalSpending DESC




-- t