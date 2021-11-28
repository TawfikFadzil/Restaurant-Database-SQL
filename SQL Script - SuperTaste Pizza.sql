DROP TABLE QIngredientHas2Order
DROP TABLE IngredientOrder
DROP TABLE QMenuIngredient
DROP TABLE Ingredient
DROP TABLE QMenuOrder 
DROP TABLE MenuItem
DROP TABLE Pickup
DROP TABLE Delivery
DROP TABLE InStoreShift
DROP TABLE DriverShift
DROP TABLE InStorePay
DROP TABLE DriverPay
DROP TABLE PhoneOrder
DROP TABLE WalkInOrder
DROP TABLE Orders
DROP TABLE OrderPayment
DROP TABLE InStoreStaff
DROP TABLE DriverStaff
DROP TABLE BankDetails
DROP TABLE CPhone
DROP TABLE Customer

CREATE TABLE Customer (
CustomerID		CHAR(10)		PRIMARY KEY,
FirstName	VARCHAR(15),
LastName		VARCHAR(15),
Street	VARCHAR(15),
City	VARCHAR(15),
PostCode	CHAR(4),
CustomerStatus VARCHAR(10) DEFAULT 'unverified',
CHECK(CustomerStatus IN ('verified', 'unverified')),
)
go

CREATE TABLE Cphone (
PhoneNo		CHAR(10)		PRIMARY KEY, 
CustomerID	CHAR(10),
FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID) ON UPDATE CASCADE ON DELETE CASCADE,
)
go

CREATE TABLE BankDetails (
BankCode	CHAR(6)	PRIMARY KEY,
BankName	VARCHAR(15),
)
go

CREATE TABLE DriverStaff (
StaffID	CHAR(10)	PRIMARY KEY,
FirstName	VARCHAR(15),
LastName	VARCHAR(15),
Street	VARCHAR(15),
City	VARCHAR(15),
Postcode	CHAR(4),
TaxFileNo	CHAR(9) NOT NULL,
BankCode	CHAR(6) NOT NULL,
AccNo	VARCHAR(10),
StaffStatus	VARCHAR(10) DEFAULT 'Driver',
PaymentRate	FLOAT,
LicenceNo CHAR(10) NOT NULL,
Description	VARCHAR(30),
FOREIGN KEY(BankCode) REFERENCES BankDetails(BankCode) ON UPDATE CASCADE ON DELETE CASCADE,
)
go


CREATE TABLE InStoreStaff (
StaffID	CHAR(10)	PRIMARY KEY,
FirstName	VARCHAR(15),
LastName	VARCHAR(15),
Street	VARCHAR(15),
City	VARCHAR(15),
Postcode	CHAR(4),
TaxFileNo	CHAR(9) NOT NULL,
BankCode	CHAR(6) NOT NULL,
AccNo	VARCHAR(10),
StaffStatus	VARCHAR(10) DEFAULT 'In-Store',
PaymentRate	FLOAT,
Description	VARCHAR(30),
FOREIGN KEY(BankCode) REFERENCES BankDetails(BankCode) ON UPDATE CASCADE ON DELETE CASCADE,
)
go

CREATE TABLE OrderPayment (
PaymentApprovalNo	CHAR(8)	PRIMARY KEY,
PaymentMethod	VARCHAR(15),
TotalAmount	FLOAT,
)
go

CREATE TABLE Orders (
OrderNo		CHAR(10)	PRIMARY KEY,
StaffID		CHAR(10)	NOT NULL,
CustomerID	CHAR(10)	NOT NULL,
OrderDateTime	DATETIME2,
OrderTaken	VARCHAR(10),
OrderType	VARCHAR(10),
PaymentApprovalNo	CHAR(8) NOT NULL,
Status		VARCHAR(10),
FOREIGN KEY(StaffID) REFERENCES InStoreStaff(StaffID) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY(PaymentApprovalNo) REFERENCES OrderPayment(PaymentApprovalNo) ON UPDATE CASCADE ON DELETE CASCADE,
)
go

CREATE TABLE WalkInOrder (
OrderNo		CHAR(10)	PRIMARY KEY,
WalkInTime	DATETIME2,
FOREIGN KEY(OrderNo) REFERENCES Orders(OrderNo) ON UPDATE CASCADE ON DELETE NO ACTION,
)
go

CREATE TABLE PhoneOrder (
OrderNo		CHAR(10)	PRIMARY KEY,
PhoneStarted DATETIME2,
PhoneEnded DATETIME2,
FOREIGN KEY(OrderNo) REFERENCES Orders(OrderNo) ON UPDATE CASCADE ON DELETE NO ACTION,
)
go

CREATE TABLE DriverPay (
SalaryID	CHAR(10)	PRIMARY KEY,
GrossSalary FLOAT,
TaxWithheld	FLOAT,
TotalSalary FLOAT,
SalaryStartDate DATE,
SalaryEndDate	DATE,
)
go

CREATE TABLE InStorePay (
SalaryID	CHAR(10)	PRIMARY KEY,
GrossSalary FLOAT,
TaxWithheld	FLOAT,
TotalSalary FLOAT,
SalaryStartDate DATE,
SalaryEndDate	DATE,
)
go

CREATE TABLE DriverShift (
ShiftID		CHAR(5)		PRIMARY KEY,
StaffID		CHAR(10) NOT NULL,
SalaryID	CHAR(10) NOT NULL,
StartDateTime	DATETIME2,
EndDateTime		DATETIME2,
ShiftType	VARCHAR(10) DEFAULT 'Full Time',
FOREIGN KEY (StaffID) REFERENCES DriverStaff(StaffID) ON UPDATE CASCADE ON DELETE NO ACTION,
FOREIGN KEY (SalaryID) REFERENCES DriverPay(SalaryID) ON UPDATE CASCADE ON DELETE NO ACTION,
)
go

CREATE TABLE InStoreShift (
ShiftID		CHAR(5)		PRIMARY KEY,
StaffID		CHAR(10),
SalaryID	CHAR(10),
StartDateTime	DATETIME2,
EndDateTime		DATETIME2,
ShiftType	VARCHAR(10) DEFAULT 'Full Time',
FOREIGN KEY (StaffID) REFERENCES InStoreStaff(StaffID) ON UPDATE CASCADE ON DELETE NO ACTION,
FOREIGN KEY (SalaryID) REFERENCES InStorePay(SalaryID) ON UPDATE CASCADE ON DELETE NO ACTION,
)
go

CREATE TABLE Delivery (
OrderNo			CHAR(10)	PRIMARY KEY,
DeliveryTime	DATETIME2,
FOREIGN KEY (OrderNo) REFERENCES PhoneOrder (OrderNo) ON UPDATE CASCADE ON DELETE NO ACTION,
)
go

CREATE TABLE Pickup (
OrderNo		CHAR(10)	PRIMARY KEY,
PickupTime	TIME,
FOREIGN KEY (OrderNo) REFERENCES PhoneOrder (OrderNo) ON UPDATE CASCADE ON DELETE NO ACTION, 
)
go

CREATE TABLE MenuItem (
ItemCode	CHAR(5)		PRIMARY KEY,
ItemName	VARCHAR(20),
ItemSize	INT,
Description VARCHAR(30),
ItemPrice	FLOAT,
)
go

CREATE TABLE QMenuOrder (
OrderNo		CHAR(10),
ItemCode	CHAR(5),
Quantity	INT,
PRIMARY KEY (OrderNo, ItemCode),
FOREIGN KEY (OrderNo) REFERENCES Orders(OrderNo) ON UPDATE CASCADE ON DELETE NO ACTION,
FOREIGN KEY (ItemCode) REFERENCES MenuItem(ItemCode) ON UPDATE CASCADE ON DELETE NO ACTION,
)
go

CREATE TABLE Ingredient (
IngCode		CHAR(10)	PRIMARY KEY,
IngName		VARCHAR(15),
IngSize		INT,
IngType		VARCHAR(10),
Description	VARCHAR(30),
StockLevel	INT, 
StockTakeDate	DATETIME2,
SuggestedStockLevel	INT,
ReorderLevel	INT,
)
go

CREATE TABLE QMenuIngredient (
ItemCode	CHAR(5), 
IngCode		CHAR(10), 
Quantity	INT,
PRIMARY KEY (ItemCode,IngCode),
FOREIGN KEY (ItemCode) REFERENCES MenuItem (ItemCode) ON UPDATE CASCADE ON DELETE NO ACTION,
FOREIGN KEY (IngCode) REFERENCES Ingredient (IngCode) ON UPDATE CASCADE ON DELETE NO ACTION,
)
go

CREATE TABLE IngredientOrder (
IngOrderNo		CHAR(10)	PRIMARY KEY,
IngOrderDate	DATE,
ReceivedDate	DATE,
TotalAmount		FLOAT,
Status			VARCHAR(10),
)
go

CREATE TABLE QIngredientHas2Order (
IngCode		CHAR(10),
IngOrderNo	CHAR(10),
Price		FLOAT,
Quantity	INT,
PRIMARY KEY (IngCode, IngOrderNo),
FOREIGN KEY (IngCode) REFERENCES Ingredient (IngCode) ON UPDATE CASCADE ON DELETE NO ACTION,
FOREIGN KEY (IngOrderNo) REFERENCES IngredientOrder (IngOrderNo) ON UPDATE CASCADE ON DELETE NO ACTION,
)
go



