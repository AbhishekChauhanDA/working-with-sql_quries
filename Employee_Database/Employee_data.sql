create database employee_data;
-- List all employees with their full name and hire date.
select emp_id,concat(first_name," ", last_name)as full_name, hire_date from employees;

-- Show each employee's department name.
select e.first_name , e.last_name,d.dept_name from employees as e join dept_emp as de 
on e.emp_id = de.emp_id join departments as d on d.dept_id = de.dept_id;

-- Find all employees earning more than ₹90,000.
select e.first_name, e.last_name, s.salary from employees e join salaries s on e.emp_id= s.emp_id
where s.salary>90000
order by salary;

-- Count the number of employees in each department.
SELECT 
    d.dept_name,
    COUNT(e.emp_id) AS employee_count
FROM 
    departments AS d
JOIN 
    dept_emp AS de ON d.dept_id = de.dept_id
JOIN 
    employees AS e ON e.emp_id = de.emp_id
GROUP BY 
    d.dept_name;
    
    -- Show the average salary per department.
    select dept_name, Round(avg(salary),2)as Avg_salary from
    (SELECT 
    d.dept_name,
    s.salary
FROM 
    departments AS d
JOIN 
    dept_emp AS de ON d.dept_id = de.dept_id
JOIN 
    salaries s ON s.emp_id = de.emp_id) as sls
    group by dept_name;
    
    -- List employees hired after 2015 and their salary.
    select e.first_name, e.last_name , s.salary , e.hire_date from employees e join salaries s
    on e.emp_id = s.emp_id where year(e.hire_date) > 2015;
    
    -- Find the top 5 highest paid employees and their departments.

    select e.first_name,e.last_name ,d.dept_name,s.salary from employees e join salaries s
    on e.emp_id = s.emp_id join dept_emp de on s.emp_id = de.emp_id join departments as d 
    on de.dept_id = d.dept_id 
    order by s.salary desc limit 5;
 
-- List departments with more than 15 employees.
select d.dept_name , count(e.emp_id) as Emp_count from departments d join dept_emp de 
on d.dept_id = de.dept_id join employees e on de.emp_id = e.emp_id 
group by d.dept_name 
having emp_count>15;

-- Find employees whose salary is above the average salary of their department (use subqueries).
SELECT 
    e.first_name,
    e.last_name,
    d.dept_name,
    s.salary
FROM 
    employees e
JOIN 
    salaries s ON e.emp_id = s.emp_id
JOIN 
    dept_emp de ON e.emp_id = de.emp_id
JOIN 
    departments d ON de.dept_id = d.dept_id
JOIN (
    SELECT 
        d.dept_id,
        ROUND(AVG(s.salary), 2) AS avg_salary
    FROM 
        departments d
    JOIN 
        dept_emp de ON d.dept_id = de.dept_id
    JOIN 
        salaries s ON de.emp_id = s.emp_id
    GROUP BY 
        d.dept_id
) AS dept_avg ON dept_avg.dept_id = d.dept_id
WHERE 
    s.salary > dept_avg.avg_salary;
    
    -- Show departments and their total payroll (sum of salaries).
    SELECT 
    d.dept_name,
    SUM(s.salary) AS total_payroll
FROM 
    departments d
JOIN 
    dept_emp de ON d.dept_id = de.dept_id
JOIN 
    salaries s ON de.emp_id = s.emp_id
GROUP BY 
    d.dept_name
ORDER BY 
    total_payroll DESC;
    
    -- Get each department's highest paid employee using RANK() or ROW_NUMBER() 
    
    SELECT 
    first_name,
    last_name,
    dept_name,
    salary
FROM (
    SELECT 
        e.first_name,
        e.last_name,
        d.dept_name,
        s.salary,
        ROW_NUMBER() OVER (
            PARTITION BY d.dept_name 
            ORDER BY s.salary DESC
        ) AS rn
    FROM 
        employees e
    JOIN 
        salaries s ON e.emp_id = s.emp_id
    JOIN 
        dept_emp de ON e.emp_id = de.emp_id
    JOIN 
        departments d ON de.dept_id = d.dept_id
) AS ranked
WHERE 
    rn = 1
ORDER BY 
    dept_name;

