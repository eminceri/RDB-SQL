
-----------Assignment-3  -------------- 12 March 2022 ----------


CREATE TABLE [advertisment_data](
	[Visitor_ID] INT NOT NULL,
	[Adv_Type] VARCHAR (20) NOT NULL,
	[Action] VARCHAR (20) NOT NULL );


INSERT INTO [advertisment_data] (Visitor_ID, Adv_Type, [Action]) VALUES (1, 'A', 'Left')

INSERT INTO [advertisment_data] (Visitor_ID, Adv_Type, [Action]) VALUES (2, 'A', 'Order')

INSERT INTO [advertisment_data] (Visitor_ID, Adv_Type, [Action]) VALUES (3, 'B', 'Left')

INSERT INTO [advertisment_data] (Visitor_ID, Adv_Type, [Action]) VALUES (4, 'A', 'Order')

INSERT INTO [advertisment_data] (Visitor_ID, Adv_Type, [Action]) VALUES (5, 'A', 'Review')

INSERT INTO [advertisment_data] (Visitor_ID, Adv_Type, [Action]) VALUES (6, 'A', 'Left')

INSERT INTO [advertisment_data] (Visitor_ID, Adv_Type, [Action]) VALUES (7, 'B', 'Left')

INSERT INTO [advertisment_data] (Visitor_ID, Adv_Type, [Action]) VALUES (8, 'B', 'Order')

INSERT INTO [advertisment_data] (Visitor_ID, Adv_Type, [Action]) VALUES (9, 'B', 'Review')

INSERT INTO [advertisment_data] (Visitor_ID, Adv_Type, [Action]) VALUES (10, 'A', 'Review')

SELECT * 
FROM [advertisment_data] 



WITH A1 AS (
SELECT Adv_Type, COUNT(*) AS Counted_ad_type
FROM [advertisment_data]
GROUP BY Adv_Type
),
A2 AS (
SELECT Adv_Type, COUNT([Action]) Counted_Order
FROM [advertisment_data]
WHERE [Action] = 'Order'
GROUP BY Adv_Type
)
SELECT A1.Adv_Type AS Adv_Type,
 CONVERT (DECIMAL(5,2), ( Counted_Order*1.0) / (Counted_ad_type))AS Conversion_Rate
FROM A1
INNER JOIN A2
ON A1.Adv_Type = A2.Adv_Type;

