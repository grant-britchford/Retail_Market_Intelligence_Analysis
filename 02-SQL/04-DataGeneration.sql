;WITH DateSeries as(
SELECT CAST('2022-01-01' AS DATE) AS FullDate
UNION ALL
SELECT DATEADD(DAY,1,FullDate) FROM DateSeries WHERE FullDate < '2024-12-31')
INSERT INTO dbo.DimDate(
DateKey,
FullDate,
CalendarYear,
CalendarQuarter,
MonthNumber,
MonthName,
WeekNumber,
DayName)
SELECT
CONVERT(INT,CONVERT(VARCHAR(10),FullDate,112)),
FullDate,
Year(FullDate),
DATEPART(QUARTER,FullDate),
MONTH(FullDate),
DATENAME(MONTH,FullDate),
DATEPART(WEEK,FullDate),
DATENAME(WEEKDAY,FullDate)
FROM DateSeries
OPTION (MAXRECURSION 0);
GO

;WITH Numbers AS(
SELECT TOP (2000)
ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
FROM sys.all_objects a CROSS JOIN sys.all_objects b)
INSERT INTO dbo.Dimproduct(
ProductName,
Brand,
Category,
SubCategory,
LaunchDate,
UnitCost)
SELECT
CONCAT('Product ', N),
CONCAT('Brand ', ((N-1)%20)+1),
CASE ((N-1)%8)
WHEN 0 THEN 'Beverages'
WHEN 1 THEN 'Snacks'
WHEN 2 THEN 'Frozen'
WHEN 3 THEN 'Bakery'
WHEN 4 THEN 'Dairy'
WHEN 5 THEN 'Personal Care'
WHEN 6 THEN 'Household'
ELSE 'Health'
END,
CONCAT('SubCategory ', ((N-1)%25)+1),
DATEADD(DAY,-N,GETDATE()),
CAST((RAND(CHECKSUM(NEWID()))*15+1) AS DECIMAL(10,2))
FROM Numbers;
GO

;WITH Numbers AS(
SELECT TOP (100)
ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
FROM sys.all_Objects)
INSERT INTO dbo.DimRetailer(
RetailerName,
Region,
StoreCount,
RetailFormat)
SELECT
CONCAT('Retailer ',N),
CASE N % 5
WHEN 0 THEN 'North'
WHEN 1 THEN 'South'
WHEN 2 THEN 'East'
WHEN 3 THEN 'West'
ELSE 'National'
END,
ABS(CHECKSUM(NEWID())) % 400 + 50,
CASE N % 4
WHEN 0 THEN 'Supermarket'
WHEN 1 THEN 'Convenience'
WHEN 2 THEN 'Online'
ELSE 'Hypermarket'
END
FROM Numbers;
GO

;WITH Numbers AS(
SELECT TOP (50000)
ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
FROM sys.all_objects a
CROSS JOIN sys.all_objects b)
INSERT INTO dbo.DimCustomer(
AgeGroup,
IncomeBand,
HouseholdType,
LoyaltySegment)
SELECT
CASE N % 5 
WHEN 0 THEN '18-24'
WHEN 1 THEN '25-34'
WHEN 2 THEN '35-44'
WHEN 3 THEN '45-54'
ELSE '55+'
END,
CASE N % 4
WHEN 0 THEN 'Low'
WHEN 1 THEN 'Medium'
WHEN 2 THEN 'High'
ELSE 'Premium'
END,
CASE N % 4 
WHEN 0 THEN 'Single'
WHEN 1 THEN 'Couple'
WHEN 2 THEN 'Family'
ELSE 'Retired'
END,
CASE N % 3
WHEN 0 THEN 'Bronze'
WHEN 1 THEN 'Silver'
ELSE 'Gold'
END
FROM Numbers;
GO

;WITH Numbers AS(
SELECT TOP (1000000)
ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
FROM sys.all_objects a
CROSS JOIN sys.all_objects b)
INSERT INTO dbo.FactSales(
DateKey,
ProductID,
RetailerID,
CustomerID,
UnitsSold,
SellingPrice,
Cost,
Revenue,
Profit)
SELECT
d.DateKey,
p.ProductID,
r.RetailerID,
c.CustomerID,
ABS(CHECKSUM(NEWID())) % 20 + 1,
PriceData.SellingPrice,
PriceData.Cost,
PriceData.Revenue,
PriceData.Profit
FROM Numbers N
CROSS APPLY(SELECT TOP 1 * FROM dbo.DimDate ORDER BY NEWID())d
CROSS APPLY(SELECT TOP 1 * FROM dbo.DimProduct ORDER BY NEWID())p
CROSS APPLY(SELECT TOP 1 * FROM dbo.DimRetailer ORDER BY NEWID())r
CROSS APPLY(SELECT TOP 1 * FROM dbo.DimCustomer ORDER BY NEWID())c
CROSS APPLY(SELECT CAST((RAND(CHECKSUM(NEWID()))*45)+5 AS DECIMAL (10,2)) AS SellingPrice)Price
CROSS APPLY(SELECT
Price.SellingPrice,
Price.SellingPrice * 10 AS Revenue,
Price.SellingPrice * 6.5 AS Cost,
Price.SellingPrice * 3.5 AS Profit)PriceData;
GO

;WITH Numbers AS( 
SELECT TOP (25000)
ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
FROM sys.all_objects a
CROSS JOIN sys.all_objects b)
INSERT INTO dbo.FactPromotions(
DateKey,
ProductID,
RetailerID,
PromotionType,
DiscountPercent,
PromoSpend,
IncrementalSales)
SELECT
d.DateKey,
p.ProductID,
r.RetailerID,
CASE N % 4
WHEN 0 THEN 'BOGOF'
WHEN 1 THEN 'Discount'
WHEN 2 THEN 'Bundle'
ELSE 'Multi-Buy'
END,
ABS(CHECKSUM(NEWID())) % 40 + 5,
ABS(CHECKSUM(NEWID())) % 10000 + 500,
ABS(CHECKSUM(NEWID())) % 35000 + 1000
FROM Numbers
CROSS APPLY(SELECT TOP 1 * FROM dbo.DimDate ORDER BY NEWID())d
CROSS APPLY(SELECT TOP 1 * FROM dbo.DimProduct ORDER BY NEWID())P
CROSS APPLY(SELECT TOP 1 * FROM dbo.DimRetailer ORDER BY NEWID())r;
GO

;WITH Numbers AS(
SELECT TOP (50000)
ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N
FROM sys.all_objects a
CROSS JOIN sys.all_objects b)
INSERT INTO dbo.FactMarketShare(
DateKey,
RetailerID,
Category,
CategorySales,
MarketSales,
MarketSharePercent)
SELECT
d.DateKey,
r.RetailerID,
CASE N % 8
WHEN 0 THEN 'Beverages'
WHEN 1 THEN 'Snacks'
WHEN 2 THEN 'Frozen'
WHEN 3 THEN 'Bakery'
WHEN 4 THEN 'Dairy'
WHEN 5 THEN 'Health'
WHEN 6 THEN 'Personal Care'
ELSE 'Household'
END,
MarketData.CategorySales,
MarketData.MarketSales,
ROUND((MarketData.CategorySales * 100.0) / MarketData.MarketSales,2)
FROM Numbers
CROSS APPLY(SELECT TOP 1 * FROM dbo.DimDate ORDER BY NEWID())d
CROSS APPLY(SELECT TOP 1 * FROM dbo.DimRetailer ORDER BY NEWID())r
CROSS APPLY(SELECT CAST(ABS(CHECKSUM(NEWID())) % 500000 + 10000 AS DECIMAL(18,2)) AS CategorySales,
CAST(ABS(CHECKSUM(NEWID())) %1000000 + 200000 AS DECIMAL(18,2)) AS MarketSales)MarketData;
GO