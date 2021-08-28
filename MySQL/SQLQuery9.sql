USE Group_16;


insert into MedicalTreatment (DrugID, ItemID, Quantity) values (2,null,20)

insert into Drug (DrugName) values ('GG')

SELECT MedicalTreatmentID FROM MedicalTreatment


SELECT* FROM DRUG

SELECT* FROM MedicalTreatment

insert into MedicalTreatment (DrugID, ItemID, Quantity) values (2,null,5)
SELECT* FROM MedicalTreatment
SELECT* FROM DRUG



SELECT*FROM ConsumableItem

SELECT* FROM MedicalTreatment

insert into MedicalTreatment (DrugID, ItemID, Quantity) values (null,2,10)

SELECT* FROM MedicalTreatment
SELECT*FROM ConsumableItem

Update  ConsumableItem set ItemQuantity=20 where ItemID=1

SELECT*FROM ConsumableItem
SELECT* FROM MedicalTreatment

Update MedicalTreatment set Quantity=40 where MedicalTreatmentID=110

SELECT*FROM ConsumableItem
SELECT* FROM MedicalTreatment

SELECT*FROM ConsumableItem

SELECT* FROM MedicalTreatment
Update MedicalTreatment set Quantity=100 where  MedicalTreatmentID=110

Update MedicalTreatment set Quantity=100 where MedicalTreatmentID=42

SELECT* FROM DRUG


Update MedicalTreatment set DrugID=1 where MedicalTreatmentID=42



SELECT *FROM Procurement
SELECT*FROM ConsumableItem
SELECT*FROM FinancialEvent
insert into Procurement(EmployeeID,ItemID, DrugID, Quantity) values (12,1, null,20)
SELECT *FROM Procurement
SELECT*FROM ConsumableItem



SELECT *FROM Procurement
SELECT*FROM Drug
insert into Procurement(EmployeeID,ItemID, DrugID, Quantity) values (11,null, 2,20)
SELECT *FROM Procurement
SELECT*FROM Drug



SELECT *FROM Procurement
SELECT*FROM Drug
Update Procurement set quantity=10 where procurementID =70
SELECT *FROM Procurement
SELECT*FROM Drug


SELECT*FROM FinancialEvent
Update Procurement set quantity=10 where procurementID =70

SELECT*FROM FinancialEvent