--For an in-office staff with id number STAFF00600, print his/her first name, last name and hourly payment rate.
SELECT	FirstName, LastName, PaymentRate
FROM	InStoreStaff
WHERE	StaffID = 'STAFF00600';

--List all the ingredient details of a menu item named pizza.
SELECT	I.*
FROM	Ingredient I, MenuItem M, QMenuIngredient QMI
WHERE	I.IngCode = QMI.IngCode AND
		M.ItemCode = QMI.ItemCode AND
		M.ItemName = 'Pizza';
		
--List all the shift details of a delivery staff with first name Mir and last name Danish between date 01/02/2021 and 28/02/2021.
SELECT	DS.* 
FROM	DriverShift DS, DriverStaff D
WHERE	DS.StaffID = D.StaffID AND
		D.FirstName = 'Mir' AND
		D.LastName = 'Danish' AND
		DS.StartDateTime BETWEEN '2021-02-01' AND '2021-02-28';
			   
--List all the order details of the orders that are made by a walk-in customer with first name Michael and last name Stuart between date 01/01/2021 and 31/01/2021.
SELECT	O.*, W.WalkInTime
FROM	Orders O, Customer C, WalkinOrder W
WHERE	O.OrderNo = W.OrderNo AND
		O.CustomerID = C.CustomerID AND
		c.FirstName = 'Michael'AND
		c.LastName = 'Stuart' AND
		W.WalkInTime BETWEEN '2021-02-01' AND '2021-02-28'; 
			   		
--List all the order details of the orders that are taken by an in-office staff with first name Michelle and last name Humberson between date 01/02/2021 and 28/02/2021.
SELECT	O.*
FROM	Orders O, InStoreStaff I
WHERE	O.StaffID = I.StaffID AND
		I.FirstName = 'Michelle' AND
		I.LastName = 'Humberson' AND 
		O.OrderDateTime BETWEEN '2021-02-01' AND '2021-02-28';
							


--Print the salary paid to a delivery staff with first name Liam and last name Stanley in current month. Note the current month is the current that is decided by the system.
SELECT	S.GrossSalary
FROM	DriverStaff D, DriverShift DS, DriverPay S
WHERE	S.SalaryID = DS.SalaryID AND
		DS.StaffID = D.StaffID AND
		D.FirstName = 'Liam' AND
		D.LastName = 'Stanley' AND
		DATEPART(MONTH, (S.SalaryEndDate)) = MONTH(GETDATE());


--List the name of the menu item that is mostly ordered in current year. 
SELECT	m.ItemCode, m.ItemName, SUM(QMO.quantity) AS timesOrdered
FROM	MenuItem m, QMenuOrder QMO, Orders o
WHERE	m.ItemCode = QMO.ItemCode AND
		o.OrderNo = QMO.OrderNo AND
		DATEPART(YEAR, (o.OrderDateTime)) = YEAR(GETDATE())
GROUP BY	m.ItemCode, m.ItemName
HAVING	SUM(QMO.quantity) >= ALL
			(SELECT	SUM(QMO2.quantity)
			 FROM	MenuItem m2, QMenuOrder QMO2, Orders o2
			 WHERE	m2.ItemCode = QMO2.ItemCode AND
					o2.OrderNo = QMO2.OrderNo AND
					DATEPART(YEAR, (o2.OrderDateTime)) = YEAR(GETDATE())
			GROUP BY	m2.ItemCode, m2.ItemName
			);
			
		



