/* Products */
CREATE TABLE DimProduct(
ProductID INT IDENTITY(1,1) PRIMARY KEY,
ProductName VARCHAR(100),
Brand VARCHAR(100),
Category VARCHAR(100),
SubCategory VARCHAR(100),
LaunchDate DATE,
UnitCost DECIMAL(10,2));

/* Retailers */
CREATE TABLE DimRetailer(
RetailerID INT IDENTITY(1,1) PRIMARY KEY,
RetailerName VARCHAR(100),
Region VARCHAR(50),
StoreCount INT,
RetailFormat VARCHAR(50));

/* Customers */
CREATE TABLE DimCustomer(
CustomerID INT IDENTITY(1,1) PRIMARY KEY,
AgeGroup VARCHAR(20),
IncomeBand VARCHAR(30),
HouseholdType VARCHAR(50),
LoyaltySegment VARCHAR(50));

/* Dates */
CREATE TABLE DimDate(
DATEKEY INT PRIMARY KEY,
FullDate DATE,
CalendarYear INT,
MonthNumber INT,
MonthName VARCHAR(10),
WeekNumber INT,
DayName VARCHAR(10));

/* Sales */
CREATE TABLE FactSales(
SalesID BIGINT IDENTITY(1,1) PRIMARY KEY,
DateKey INT,
ProductID INT,
RetailerID INT,
CustomerID INT,
UnitsSold INT,
SellingPrice DECIMAL(10,2),
Cost DECIMAL(10,2),
Revenue DECIMAL(18,2),
Profit DECIMAL(18,2));

/* Promotions */
CREATE TABLE FactPromotions(
PromotionID BIGINT IDENTITY(1,1) PRIMARY KEY,
DateKey INT,
ProductID INT,
RetailerID INT,
PromotionType VARCHAR(50),
DiscountPercent DECIMAL(5,2),
PromoSpend DECIMAL(18,2),
IncrementalSales DECIMAL(18,2));

/* Market Share */
CREATE TABLE FactMarketShare(
MarketShareID BIGINT IDENTITY(1,1) PRIMARY KEY,
DateKey INT,
RetailerID INT,
Category VARCHAR(100),
CategorySales DECIMAL(18,2),
MarketSales DECIMAL(18,2),
MarketSharePercent DECIMAL(8,2));