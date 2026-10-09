ALTER TABLE dbo.FactSales
ADD CONSTRAINT FK_Sales_Date
FOREIGN Key(DateKey)
REFERENCES dbo.DimDate(DateKey);
GO

ALTER TABLE dbo.FactSales
ADD CONSTRAINT FK_Sales_Product
FOREIGN Key(ProductID)
REFERENCES dbo.DimProduct(ProductID);
GO

ALTER TABLE dbo.FactSales
ADD CONSTRAINT FK_Sales_Retailer
FOREIGN Key(RetailerID)
REFERENCES dbo.DimCustomer(CustomerID);
GO

ALTER TABLE dbo.FactSales
ADD CONSTRAINT FK_Sales_Customer
FOREIGN Key(CustomerID)
REFERENCES dbo.DimcUSTOMER(CustomerID);
GO

ALTER TABLE dbo.FactPromotions
ADD CONSTRAINT FK_Promo_Date
FOREIGN Key(DateKey)
REFERENCES dbo.DimDate(DateKey);
GO

ALTER TABLE dbo.FactPromotions
ADD CONSTRAINT FK_Promo_Product
FOREIGN Key(ProductID)
REFERENCES dbo.DimProduct(ProductID);
GO

ALTER TABLE dbo.FactPromotions
ADD CONSTRAINT FK_Promo_Retailer
FOREIGN Key(RetailerID)
REFERENCES dbo.DimRetailer(RetailerID);
GO

ALTER TABLE dbo.FactMarketShare
ADD CONSTRAINT FK_MarketShare_Date
FOREIGN Key(DateKey)
REFERENCES dbo.DimDate(DateKey);
GO

ALTER TABLE dbo.FactMarketShare
ADD CONSTRAINT FK_MarketShare_Retailer
FOREIGN Key(RetailerID)
REFERENCES dbo.DimRetailer(RetailerID);
GO