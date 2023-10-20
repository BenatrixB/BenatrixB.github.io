use hrcompany;

-- 1 Pasirinkite visus darbuotojus: parašykite SQL užklausą, kuri gautų visus darbuotojų įrašus iš Employees lentelės.
Select * from employees;

-- 2 Pasirinkite tam tikrus stulpelius: parodykite visus vardus ir pavardes iš Employees lentelės.
SELECT FirstName, LastName FROM employees;

-- 3 Filtruokite pagal skyrius: gaukite darbuotojų sąrašą, kurie dirba HR skyriuje (department lentelė).
SELECT * FROM departments;
-- HR departaments id = 1
SELECT *
FROM employees as em
LEFT JOIN departments as dp
ON em.DepartmentID = dp.DepartmentID
WHERE DepartmentName = "HR";

-- 4 Surikiuokite darbuotojus: gaukite darbuotojų sąrašą, surikiuotą pagal jų įdarbinimo datą didėjimo tvarka.
SELECT *
FROM employees
Order by HireDate ASC;

-- 5 Suskaičiuokite darbuotojus: raskite kiek iš viso įmonėje dirba darbuotojų.
SELECT Count(*) as "Darbuotojų skaičius įmonėje"
FROM employees;

-- 6 Sujunkite darbuotojus su skyriais: išveskite bendrą darbuotojų sąrašą, 
-- šalia kiekvieno darbuotojo nurodant skyrių kuriame dirba.
SELECT * FROM departments;
SELECT FirstName,
LastName,
DateOfBirth, 
Gender, 
Email, 
Phone, 
Address, 
HireDate, 
DepartmentName as "skyrius"
FROM employees as em
LEFT JOIN departments as dp
ON em.DepartmentID = dp.DepartmentID;

-- 7 Apskaičiuokite vidutinį atlyginimą: suraskite koks yra vidutinis atlyginimas įmonėje tarp visų darbuotojų.
SELECT Round(avg(SalaryAmount)) as "Visu darbuotojų atlyginimų metinis vidurkis" FROM salaries;

-- 8 Išfiltruokite ir suskaičiuokite: raskite kiek darbuotojų dirba IT skyriuje.
SELECT 
count(d.DepartmentID) AS 'Dirba IT skyriuje'
FROM departments AS d
INNER JOIN employees as e
    ON d.departmentid = e.departmentid
WHERE departmentname = 'IT';

-- 9 Išrinkite unikalias reikšmes: gaukite unikalių siūlomų darbo pozicijų sąrašą iš jobpositions lentelės.
select * from jobpositions;
-- 10 Išrinkite pagal datos rėžį: gaukite darbuotojus, kurie buvo nusamdyti tarp 2020-02-01 ir 2020-11-01.
select * from employees;

select * from employees
where HireDate between "2020-02-01" AND "2020-11-01";

-- 11 Darbuotojų amžius: gaukite kiekvieno darbuotojo amžių pagal tai kada jie yra gimę.
SELECT FirstName, LastName, DateOfBirth,
       DATEDIFF(CURDATE(), DateOfBirth) / 365 AS 'Amžius'
FROM employees;

-- 12 Darbuotojų el. pašto adresų sąrašas: gaukite visų darbuotojų el. pašto adresų sąrašą abėcėline tvarka.
select email 
from employees
order by email ASC; 

-- 13 Darbuotojų skaičius pagal skyrių: suraskite kiek kiekviename skyriuje dirba darbuotojų.
SELECT 
DepartmentName,
count(*) AS 'Darbuotoju sk.'
FROM departments AS d
INNER JOIN employees as e
    ON d.departmentid = e.departmentid
Group by DepartmentName;

-- 14 Darbštus darbuotojas: išrinkite visus darbuotojus, kurie turi daugiau nei 3 įgūdžius (skills).
Select * from employeeskills;
Select * from skills;

select 
FirstName,
count(SkillID) as "igudziu kiekis"
from employeeskills as es
left join employees as em
on es.EmployeeID= em.EmployeeID
-- where Count(SkillID) like "3"
group by FirstName;


-- 15 Vidutinė papildomos naudos kaina: apskaičiuokite vidutines papildomų naudų išmokų (benefits lentelė) išlaidas darbuotojams.
SELECT round(avg(Cost), 1) FROM benefits;

-- 16 Jaunausias ir vyriausias darbuotojai: suraskite jaunausią ir vyriausią darbuotoją įmonėje.

SELECT 
FirstName,
LastName,
DateOfBirth,
CASE
WHEN (SELECT MIN(DateOfBirth) FROM employees) = DateOfBirth THEN 'vyriausias'
WHEN (SELECT MAX(DateOfBirth) FROM employees) = DateOfBirth THEN 'jauniausias'
END AS amžius
FROM employees
GROUP BY FirstName,
LastName,
DateOfBirth
Having amžius LIKE ('vyriausias') OR amžius LIKE ('jauniausias');

-- 17 Skyrius su daugiausiai darbuotojų: suraskite kuriame skyriuje dirba daugiausiai darbuotojų.
-- Cia reikia departaments ir employee join daryti bei max rasti, kuriame daugiauaisia depatmente dirba
SELECT d.DepartmentName, COUNT(e.EmployeeID) AS 'Darbuotojų skaičius'
FROM departments d
LEFT JOIN employees e
ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
ORDER BY COUNT(e.EmployeeID) DESC
LIMIT 1;
-- Šiaip jau visuose po 2  darbuotojus dirba, tai limit 1 naudojant 1 rezultatą išveda.

-- 18 Tekstinė paieška: suraskite visus darbuotojus su žodžiu “excellent” jų darbo atsiliepime (performancereviews lentelė).*/
-- sujungti employees ir performancereviews ir where ReviewText like "excellent"
-- (padariau klaidą pradžioje, nes sumaišiau when su where, rookie mistake. :D 

SELECT em.FirstName, em.LastName, pr.ReviewText
FROM employees as em
JOIN performancereviews as pr
ON em.EmployeeID = pr.EmployeeID
WHERE ReviewText like "Excellent%";

-- 19 Darbuotojų telefono numeriai: išveskite visų darbuotojų ID su jų telefono numeriais.
SELECT EmployeeID, Phone FROM employees;

-- 20 Darbuotojų samdymo mėnesis: suraskite kurį mėnesį buvo nusamdyta daugiausiai darbuotojų.
-- extract naudot reikės 
SELECT
EXTRACT(MONTH FROM HireDate) AS 'Mėnuo', 
COUNT(*) AS 'Nauji darbuotojai'
FROM employees
GROUP BY EXTRACT(MONTH FROM HireDate)
ORDER BY COUNT(*) DESC
LIMIT 1;

-- 21 Darbuotojų įgūdžiai: išveskite visus darbuotojus, kurie turi įgūdį “Communication”.
-- Čia daug su daug jungimas turėtų būti. Ir reikės where  SkillName panaudoti su "Communication".
SELECT e.FirstName, e.LastName, s.SkillName
FROM employees as e
JOIN employeeskills as es
	ON e.EmployeeID = es.EmployeeID
JOIN skills as s 
	ON es.SkillID = s.SkillID
WHERE s.SkillName = 'Communication';

-- 22 Sub-užklausos: suraskite kuris darbuotojas įmonėje uždirba daugiausiai ir išveskite visą jo informaciją.
-- Reikia pirma sujungti Employee ir Salaries lenteles ir tada per When naudot subquery rasti max salary. 
select FirstName, LastName, SalaryAmount 
from salaries as s
join employees as em
on s.EmployeeID = em.EmployeeID
where SalaryAmount = (select MAX(SalaryAmount) from salaries)
limit 1;

-- 23 Grupavimas ir agregacija: apskaičiuokite visas įmonės išmokų (benefits lentelė) išlaidas.
SELECT sum(Cost)
FROM benefits;

-- 24 Įrašų atnaujinimas: atnaujinkite telefono numerį darbuotojo, kurio id yra 1.
UPDATE `hrcompany`.`employees` SET `Phone` = '555-555-5955' WHERE (`EmployeeID` = '1');

-- 25 Atostogų užklausos: išveskite sąrašą atostogų prašymų (leaverequests), kurie laukia patvirtinimo.
Select * from leaverequests
where Status = "Pending"; 

-- 26 Darbo atsiliepimas: išveskite darbuotojus, kurie darbo atsiliepime yra gavę 5 balus.
select FirstName, rating from performancereviews as pr
join employees as em
on pr.ReviewID = em.EmployeeID
where rating = 5
Group by FirstName; 

-- 27 Papildomų naudų registracijos: išveskite visus darbuotojus, 
-- kurie yra užsiregistravę į “Health Insurance” papildomą naudą (benefits lentelė).
-- daug su daug jungimą daryti ir išvesti health insurace su where.
select * from benefits;
select * from employeebenefits;
Select * from employees;

SELECT em.FirstName, em.LastName, BenefitName
FROM employees as em
JOIN employeebenefits as eb 
ON em.EmployeeID = eb.EmployeeID
JOIN benefits as bn 
	ON bn.BenefitID = eb.BenefitID
WHERE bn.BenefitName = 'Health Insurance';

-- 28 Atlyginimų pakėlimas: parodykite kaip atrodytų atlyginimai darbuotojų, dirbančių “Finance” skyriuje, jeigu jų atlyginimus pakeltume 10 %.
select * from salaries ORDER BY SalaryStartDate;
SELECT e.FirstName, e.LastName, d.DepartmentName, s.SalaryStartDate, s.SalaryEndDate, s.SalaryAmount, 
s.SalaryAmount * 1.1 as "Metinė alga su 10% pakėlimu"
FROM employees as e
JOIN departments as d
	ON e.DepartmentID = d.DepartmentID
JOIN salaries as s
	ON e.EmployeeID = s.EmployeeID
WHERE DepartmentName = 'Finance';


-- 29 Efektyviausi darbuotojai: raskite 5 darbuotojus, kurie turi didžiausią darbo vertinimo (performance lentelė) reitingą.
SELECT  em.FirstName, em.LastName, pr.Rating
FROM employees as em
join performancereviews as pr
on em.EmployeeID = pr.EmployeeID
where pr.Rating = 5
-- arba order by pr.Rating DESC 
limit 5;

-- 30 Darbuotojo darbo stažas: suskaičiuokite vidutinį darbuotojo išdirbtą laiką įmonėje metais, išgrupuotą pagal skyrius.
-- Reikia apjungti departaments ir employees ir dar reikia paskaičiuoti avg išdirbtą laiką, reikia tą išdirbtą laiką pagal skyrius išvesti.
SELECT dp.DepartmentName, 
Round(AVG(DATEDIFF(CURDATE(), em.HireDate) / 365)) AS 'Vidutinė stažo trukmė (metais)'
FROM departments as dp
JOIN employees as em
ON dp.DepartmentID = em.DepartmentID
GROUP BY dp.DepartmentName;

-- 31 Atostogų užklausų istorija: gaukite visą atostogų užklausų istoriją (leaverequests lentelė) darbuotojo, kurio id yra 1.
-- reikia employees sujungti su leaverequests ir išvesti employee id 1 visą istoriją užklausų 
-- Sujungimo galima ir nenaudoti, nors norint išivesti daugiau informacijos apie darbuotoją galima palikti sujungimą tarp lentelių. 
Select em.EmployeeID, em.FirstName,
lr.EmployeeID, lr.LeaveStartDate, 
lr.LeaveEndDate, lr.LeaveType, lr.Status
from employees as em
join leaverequests as lr
on lr.EmployeeID = em.EmployeeID
where em.EmployeeID = 1;

-- pasitikrinimui. Kadangi Employee id yra 1 tai galima per jį ieškoti.
select * from leaverequests
where EmployeeID = 1;


-- 32 Atlyginimų diapozono analizė: nustatykite atlyginimo diapazoną (minimalų ir maksimalų) kiekvienai darbo pozicijai.

SELECT
    d.DepartmentName,
    Round(MIN(s.SalaryAmount)) AS "Minimalus Metinis Atlyginimas",
    Round(MAX(s.SalaryAmount)) AS "Maksimalus Metinis Atlyginimas",
	ROUND(MAX(s.SalaryAmount) - MIN(s.SalaryAmount)) AS "Atlyginimų diapozono skirtumai"
FROM
    employees AS e
JOIN
    departments AS d ON e.DepartmentID = d.DepartmentID
JOIN
    salaries AS s ON e.EmployeeID = s.EmployeeID
GROUP BY
    d.DepartmentName;



-- 33 Papildomų naudų registracijos laikotarpis: raskite vidutinį visų papildomų naudų išmokų (benefits lentelė) registracijos laikotarpį (mėnesiais).
SELECT bn.BenefitName, eb.EnrollmentDate,
round(AVG(DATEDIFF(CURDATE(), eb.EnrollmentDate) / 30)) AS 'Vidutinis laikotarpis (mėnesiais)'
FROM employeebenefits as eb
JOIN benefits as bn 
	ON bn.BenefitID = eb.BenefitID
    Group by bn.BenefitName, eb.EnrollmentDate;
    
-- arba dar papildomai prijungti ir employees lentelę, tada galima ir pagal darbuotojus matyti, kas yra kiek enrolled į benefitus.
SELECT em.FirstName, em.LastName, bn.BenefitName, eb.EnrollmentDate,
round(AVG(DATEDIFF(CURDATE(), eb.EnrollmentDate) / 30)) AS 'Vidutinis laikotarpis (mėnesiais)'
FROM employees as em
JOIN employeebenefits as eb 
ON em.EmployeeID = eb.EmployeeID
JOIN benefits as bn 
	ON bn.BenefitID = eb.BenefitID
Group by em.FirstName, em.LastName, bn.BenefitName, eb.EnrollmentDate;

-- 34 Darbo atsiliepimo istorija: gaukite visą istoriją apie darbo atsiliepimus (performancereviews lentelė), darbuotojo, kurio id yra 2.
Select em.EmployeeID, FirstName, LastName, reviewText, rating 
from employees as em
Join performancereviews as pr
on em.EmployeeID = pr.EmployeeID
where em.EmployeeID = 2;
-- order by rating DESC;  

-- 35 Papildomos naudos kaina vienam darbuotojui: apskaičiuokite bendras papildomų naudų išmokų išlaidas vienam darbuotojui (benefits lentelė).
SELECT em.FirstName, em.LastName, bn.BenefitName,
Round(SUM(bn.cost) / COUNT(DISTINCT eb.EmployeeID)) as "Papildomų naudų išlaidos vienam darbuotojui"
FROM employees as em
JOIN employeebenefits as eb 
ON em.EmployeeID = eb.EmployeeID
JOIN benefits as bn 
	ON bn.BenefitID = eb.BenefitID
Group by em.FirstName, em.LastName, bn.BenefitName;

-- 36 Geriausi įgūdžiai pagal skyrių: išvardykite dažniausiai pasitaikančius įgūdžius kiekviename skyriuje.
SELECT d.DepartmentName, s.SkillName, COUNT(*) AS 'Pasitaikymų skaičius'
FROM employees AS e
JOIN departments AS d 
ON e.DepartmentID = d.DepartmentID
JOIN employeeskills AS es 
ON e.EmployeeID = es.EmployeeID
JOIN skills AS s 
ON es.SkillID = s.SkillID
GROUP BY d.DepartmentName, s.SkillName 
ORDER BY d.DepartmentName, COUNT(*) DESC;

-- 37 Atlyginimo augimas: apskaičiuokite procentinį atlyginimo padidėjimą kiekvienam darbuotojui, lyginant su praėjusiais metais.
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    s.SalaryAmount AS 'Dabartinis atlyginimas',
    p.SalaryAmount AS 'Praėjusio meto atlyginimas',
    s.SalaryAmount - p.SalaryAmount AS 'Atlyginimo padidėjimas',
    ROUND(((s.SalaryAmount - p.SalaryAmount) / p.SalaryAmount) * 100, 2) AS 'Procentinis padidėjimas (%)'
FROM
    employees AS e
JOIN
    salaries AS s ON e.EmployeeID = s.EmployeeID 
LEFT JOIN
    salaries AS p ON e.EmployeeID = p.EmployeeID 
    WHERE
    YEAR(s.SalaryStartDate) = YEAR(CURDATE())
    AND (YEAR(p.SalaryEndDate) = YEAR(CURDATE()) - 1 OR p.SalaryEndDate IS NULL);
    
-- 38 Darbuotojų išlaikymas: raskite darbuotojus, kurie įmonėje dirba daugiau nei 5 metai ir kuriems per tą laiką nebuvo pakeltas atlyginimas.
SELECT
    e.EmployeeID,
    FirstName,
    LastName,
    HireDate,
    SalaryAmount AS 'Dabartinis atlyginimas'
FROM
    employees as e
    JOIN
    salaries AS s ON e.EmployeeID = s.EmployeeID
WHERE
    DATEDIFF(CURDATE(), HireDate) > 1825 -- 5 metų (365 dienos * 5 metai)
    AND SalaryAmount = (
        SELECT
            MIN(SalaryAmount)
        FROM
            employees AS e
        WHERE
            e.EmployeeID = e.EmployeeID
    );
    
-- 39 Darbuotojų atlyginimų analizė: suraskite kiekvieno darbuotojo atlygį (atlyginimas (salaries lentelė) + išmokos už papildomas naudas (benefits lentelė)) ir surikiuokite darbuotojus pagal bendrą atlyginimą mažėjimo tvarka.
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    s.SalaryStartDate,
    Round(s.SalaryAmount) AS 'Atlyginimas',
    Round(SUM(b.Cost)) AS 'Išmokos už papildomas naudas',
    Round((s.SalaryAmount + COALESCE(SUM(b.Cost), 0))) AS 'Bendras atlyginimas'
FROM
    employees AS e
JOIN
    salaries AS s ON e.EmployeeID = s.EmployeeID
JOIN
    employeebenefits AS eb ON e.EmployeeID = eb.EmployeeID
JOIN
    benefits AS b ON eb.BenefitID = b.BenefitID
GROUP BY
    e.EmployeeID, e.FirstName, e.LastName, s.SalaryStartDate, s.SalaryAmount
ORDER BY
    'Bendras atlyginimas' DESC;
    
-- 40 Darbuotojų darbo atsiliepimų tendencijos: išveskite kiekvieno darbuotojo vardą ir pavardę, nurodant ar jo darbo atsiliepimas (performancereviews lentelė) pagerėjo ar sumažėjo. */
SELECT
    e.FirstName as "Vardas",
    e.LastName as "Pavardė", 
    pr.Rating as "Senas įvertinimas",
    pr2.Rating as "Naujasis įvertinimas",
    CASE
        WHEN pr.Rating < pr2.Rating THEN 'Atsiliepimas pagerėjo'
        WHEN pr.Rating > pr2.Rating THEN 'Atsiliepimas sumažėjo'
        ELSE 'Atsiliepimas nepakito'
    END AS 'Tendencija'
FROM
    employees AS e
-- LEFT -- 
JOIN
    performancereviews AS pr ON e.EmployeeID = pr.EmployeeID
-- LEFT --     
JOIN
    performancereviews AS pr2 ON e.EmployeeID = pr2.EmployeeID 
    AND pr.ReviewDate > pr2.ReviewDate
ORDER BY pr2.Rating DESC;
-- Galima ir LEFT JOIN naudoti. Tada išveda visas reikšmes kur pr.2 Rating yra NULL, nors pr.Rating yra kažkoks skaičius.