create table employees(
	emp_no int not null,
	emp_title_id varchar(6),
	birth_date date,
	first_name varchar(20),
	last_name varchar(20),
	sex varchar(5),
	hire_date date,
		primary key (emp_no),
		foreign key (emp_title_id) references titles(title_id)
);
	
create table dept_emp (
	emp_no int not null,
	dept_no varchar(4) not null,
		primary key (emp_no, dept_no),
		foreign key (emp_no) references employees(emp_no),
		foreign key (dept_no) references departments(dept_no)
);

create table dept_manager(
	dept_no varchar(4),
	emp_no int,
		primary key (dept_no, emp_no),
		foreign key (dept_no) references departments(dept_no),
		foreign key (emp_no) references employees(emp_no)
);

create table salaries(
	emp_no int,
	salary int,
		primary key (emp_no),
		foreign key (emp_no) references employees(emp_no)
);

create table titles(
	title_id varchar(6),
	title varchar (30),
		primary key (title_id)
);

create table departments(
	dept_no varchar(4),
	dept_name varchar(50),
	primary key(dept_no)
);

--List the employee number, last name, first name, sex, and salary of each employee.
SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees as e
JOIN salaries as s ON s.emp_no = e.emp_no;

--List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT first_name, last_name, hire_date
FROM employees
WHERE EXTRACT(year FROM hire_date) = 1986;

--List the manager of each department along with their department number, department name, employee number, last name, and first name.
SELECT d.dept_no, d.dept_name, e.emp_no, e.last_name, e.first_name
FROM departments as d
JOIN dept_manager as dm ON dm.dept_no = d.dept_no
JOIN employees as e ON e.emp_no = dm.emp_no
Where emp_title_id='m0001';

--List the department number for each employee along with that employee’s employee number, last name, first name, and department name.
SELECT d.dept_no, e.emp_no, e.last_name, e.first_name, d.dept_name
FROM departments as d
JOIN dept_emp as de ON de.dept_no = d.dept_no
JOIN employees as e ON e.emp_no = de.emp_no

--List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%';

--List each employee in the Sales department, including their employee number, last name, and first name.
SELECT e.emp_no, e.last_name, e.first_name
FROM employees as e
JOIN dept_emp as de ON de.emp_no=e.emp_no
JOIN departments as d ON d.dept_no=de.dept_no
WHERE d.dept_no = (SELECT dept_no FROM departments WHERE dept_name = 'Sales');

--List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees as e
JOIN dept_emp as de ON de.emp_no=e.emp_no
JOIN departments as d ON d.dept_no=de.dept_no
WHERE d.dept_no IN (SELECT dept_no FROM departments WHERE dept_name IN ('Sales', 'Development'));

--List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).
SELECT last_name, COUNT(*) AS frequency
FROM employees
GROUP BY last_name
ORDER BY frequency DESC;
