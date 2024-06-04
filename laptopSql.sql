use Internship;
show tables;
describe Laptop;
alter table Laptop drop unnamed;
select * from Laptop;


#unique values in the columns
select count(distinct Company ) as unique_count from Laptop;
select count(distinct TypeName ) as unique_count from Laptop;
select count(distinct ScreenResolution ) as unique_count from Laptop;
select count(distinct Ram ) as unique_count from Laptop;
select count(distinct Memory ) as unique_count from Laptop;
select count(distinct Opsys ) as unique_count from Laptop;
select count(distinct Gpu ) as unique_count from Laptop;
select count(distinct cpu ) as unique_count from Laptop;

#count of items in each columnss
select Company , count(*) as counts from Laptop group by Company order by counts desc;
select TypeName , count(*) as counts from Laptop group by TypeName order by counts desc;
select ScreenResolution , count(*) as counts from Laptop group by Screenresolution order by counts desc;
select Ram , count(*) as counts from Laptop group by Ram order by counts desc;
select Memory , count(*) as counts from Laptop group by Memory order by counts desc;
select Opsys , count(*) as counts from Laptop group by Opsys order by counts desc;
select Gpu , count(*) as counts from Laptop group by Gpu order by counts desc;
select cpu , count(*) as counts from Laptop group by cpu order by counts desc;

#to create a new column category to label if a lap is expensive or not by calcu the avg of price 
select avg(Price) from Laptop;
#'59870.04280161766'
SET SQL_SAFE_UPDATES = 0;
Alter table Laptop
 add column Category int;
alter table Laptop modify column Category varchar(20);
update Laptop set Category ='Expensive' where Price > 59000;
update Laptop set Category ='Affordable' where Price <=58000;
select * from Laptop;

#spliting Screenresolution column
alter table Laptop 
add column TouchScreen varchar(10);
update Laptop
SET TouchScreen = CASE
    WHEN ScreenResolution like '%Touchscreen%' then 'Yes'
    else 'No'
end;
select * from Laptop;

alter table Laptop
add column IPS varchar(10);
UPDATE Laptop
SET IPS = CASE
    WHEN ScreenResolution LIKE '%IPS%' THEN 'Yes'
    ELSE 'No'
END;
select * from Laptop;

alter table Laptop 
add column Ultra_HD varchar(5);
update Laptop
set Ultra_HD = case
	when ScreenResolution like '%4K Ultra HD%' then 'Yes'
    else 'No'
end;
select * from Laptop;

#splitting Memory

UPDATE Laptop
SET Memory = REPLACE(Memory, '\.0', '');

UPDATE Laptop
SET Memory = REPLACE(Memory, 'TB', '000GB');

ALTER TABLE Laptop
add column Memory1 varchar(100),
add column Memory2 varchar(100);

-- Step 5: Update the new columns with the split parts
UPDATE Laptop
SET Memory1 = CASE
    WHEN INSTR(Memory, '+') > 0 THEN SUBSTR(Memory, 1, INSTR(Memory, '+') - 1)
    ELSE Memory
END,
Memory2 = CASE
    WHEN INSTR(Memory, '+') > 0 THEN SUBSTR(Memory, INSTR(Memory, '+') + 1)
    ELSE NULL
END;
UPDATE Laptop
SET Memory2 = 0
WHERE Memory2 IS NULL;
select * from Laptop;

#Add new columns
ALTER TABLE Laptop
ADD COLUMN HDD1 INT,
ADD COLUMN SSD1 INT,
ADD COLUMN Hybrid1 INT,
ADD COLUMN Flash_Storage1 INT;

#Update new columns
UPDATE Laptop
SET HDD1 = CASE
    WHEN Memory1 LIKE '%HDD%' THEN 1
    ELSE 0
END;

UPDATE Laptop
SET SSD1 = CASE
    WHEN Memory1 LIKE '%SSD%' THEN 1
    ELSE 0
END;

UPDATE Laptop
SET Hybrid1 = CASE
    WHEN Memory1 LIKE '%Hybrid%' THEN 1
    ELSE 0
END;

UPDATE Laptop
SET Flash_Storage1 = CASE
    WHEN Memory1 LIKE '%Flash Storage%' THEN 1
    ELSE 0
END;

ALTER TABLE Laptop
ADD COLUMN HDD2 INT,
ADD COLUMN SSD2 INT,
ADD COLUMN Hybrid2 INT,
ADD COLUMN Flash_Storage2 INT;

#Update new columns based on conditions applied to First_Memory
UPDATE Laptop
SET HDD2 = CASE
    WHEN Memory2 LIKE '%HDD%' THEN 1
    ELSE 0
END;

UPDATE Laptop
SET SSD2 = CASE
    WHEN Memory2 LIKE '%SSD%' THEN 1
    ELSE 0
END;

UPDATE Laptop
SET Hybrid2 = CASE
    WHEN Memory2 LIKE '%Hybrid%' THEN 1
    ELSE 0
END;

UPDATE Laptop
SET Flash_Storage2 = CASE
    WHEN Memory2 LIKE '%Flash Storage%' THEN 1
    ELSE 0
END;
select * from Laptop;

UPDATE Laptop
SET Memory1 = REGEXP_REPLACE(Memory1, '[^0-9]', ' ');

UPDATE Laptop
SET Memory2 = REGEXP_REPLACE(Memory2, '[^0-9]', ' ');

select * from Laptop;
alter table Laptop
modify column Memory1 int; 
alter table Laptop
modify column Memory2 int;
 
ALTER TABLE Laptop
ADD COLUMN HDD INT,
ADD COLUMN SSD INT,
ADD COLUMN Hybrid INT,
ADD COLUMN Flash_Storage INT;
UPDATE Laptop
SET HDD = (Memory1 * HDD1) + (Memory2 * HDD2),
    SSD = (Memory1 * SSD1) + (Memory2 * SSD2),
    Hybrid = (Memory1 * Hybrid1) + (Memory2 * Hybrid2),
    Flash_Storage = (Memory1 * Flash_Storage1) + (Memory2 * Flash_Storage2);
select * from Laptop;

alter table Laptop
drop Memory,
drop Memory1,
drop Memory2,
drop HDD1 ,
drop SSD1 ,
drop Hybrid1,
drop Flash_Storage1,
drop HDD2 ,
drop SSD2 ,
drop Hybrid2,
drop Flash_Storage2;

ALTER TABLE Laptop
ADD COLUMN ScreenWidth INT;
ALTER TABLE Laptop
ADD COLUMN ScreenHeight INT;

alter table Laptop
modify column ScreenWidth int; 

update Laptop
set ScreenHeight = substring_index(ScreenResolution,'x',-1) ;
update Laptop
set ScreenWidth=(REGEXP_SUBSTR(ScreenResolution,'[0-9]+'));
select * from Laptop;
alter table Laptop drop ScreenResolution;

#Cpu
alter table Laptop
add column CpuName varchar(50);

update Laptop
set  CpuName=SUBSTRING_INDEX(Cpu, ' ', 1);
alter table Laptop
add column CpuBrand varchar(50);

update Laptop
set CpuBrand=
       CASE 
           WHEN Cpu like '%Intel%' then  substring_index(Cpu,2,4)
			WHEN Cpu like '%AMD%' then  substring_index(Cpu,2,3)
end;
select * from Laptop;

alter table Laptop
add column CpuFrequency varchar(10);
update Laptop
set CpuFrequency = 
substring_index(Cpu,' ',-1);

alter table Laptop
drop Cpu;

#GPU
alter table Laptop
add column GpuBrand varchar(50);
update Laptop
set GpuBrand=
       CASE 
           WHEN Gpu like '%Intel%' then  substring_index(Gpu,2,5)
           when Gpu Like '%Graphics%' then substring_index(Gpu,2,4)
           when Gpu like '%Nvindia%' THEN 'Nvindia'
           ELSE 'AMD Processor'
end;

select Gpubrand , count(*) as counts from Laptop group by Gpubrand order by counts desc;
select * from Laptop;