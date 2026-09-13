   ------ 1. create branches table ----------
CREATE TABLE Branches (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    manager_name VARCHAR(100),
    phone VARCHAR(20)
);

------- 2. create agent table ------------
CREATE TABLE Agents (
    agent_id INT PRIMARY KEY,
    agent_name VARCHAR(100) NOT NULL,
    branch_id INT NOT NULL,
    joining_date DATE,
    experience_years INT,
    commission_rate DECIMAL(5,2),
    status VARCHAR(20),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

------- 3. create table employees -------
CREATE TABLE Employee (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    branch_id INT NOT NULL,
    designation VARCHAR(60),
    joining_date DATE,
    salary DECIMAL(12,2),
    status VARCHAR(20),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

------- 4. create customers table -----------
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    gender VARCHAR(10),
    date_of_birth DATE,
    marital_status VARCHAR(20),
    occupation VARCHAR(80),
    annual_income float,
    city VARCHAR(50),
    state VARCHAR(50)
);

---------- 5. create customer_addresses table --------------
CREATE TABLE Customer_Addresses (
    address_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    address_type VARCHAR(20),
    address_line VARCHAR(200),
    city VARCHAR(50),
    state VARCHAR(50),
    pincode VARCHAR(10),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-------- 6. create customer_contacts table --------------
CREATE TABLE Customer_Contacts (
    contact_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    mobile VARCHAR(20),
    email VARCHAR(120),
    preferred_contact VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);


------- 7. create nominees table ---------- 
CREATE TABLE Nominees (
    nominee_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    nominee_name VARCHAR(100),
    relationship VARCHAR(30),
    date_of_birth DATE,
    share_percent DECIMAL(5,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

------- 8. create insurance_products table 
CREATE TABLE Insurance_Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    product_category VARCHAR(50),
    minimum_sum_assured DECIMAL(14,2),
    maximum_sum_assured DECIMAL(14,2),
    minimum_term_years INT,
    maximum_term_years INT,
    base_premium_rate DECIMAL(6,3)
);

------ 9. create policy table --------
CREATE TABLE Policy_Types (
    policy_type_id INT PRIMARY KEY,
    policy_type_name VARCHAR(60),
    description VARCHAR(255)
);

------- 10. create policies table -----------
CREATE TABLE Policies (
    policy_id INT PRIMARY KEY,
    policy_number VARCHAR(30) UNIQUE NOT NULL,
    customer_id INT NOT NULL,
    agent_id INT NOT NULL,
    product_id INT NOT NULL,
    policy_type_id INT NOT NULL,
    branch_id INT NOT NULL,
    issue_date DATE,
    start_date DATE,
    maturity_date DATE,
    sum_assured DECIMAL(14,2),
    premium_amount DECIMAL(12,2),
    premium_frequency VARCHAR(20),
    policy_term_years INT,
    status VARCHAR(30),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (agent_id) REFERENCES Agents(agent_id),
    FOREIGN KEY (product_id) REFERENCES Insurance_Products(product_id),
    FOREIGN KEY (policy_type_id) REFERENCES Policy_Types(policy_type_id),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

--------- 11. create policy_holders table ----------
CREATE TABLE Policy_Holders (
    policy_holder_id INT PRIMARY KEY,
    policy_id INT NOT NULL,
    customer_id INT NOT NULL,
    holder_type VARCHAR(20),
    ownership_percent DECIMAL(5,2),
    effective_date DATE,
    FOREIGN KEY (policy_id) REFERENCES Policies(policy_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-------- 12. create policy_nominees table ---------
CREATE TABLE Policy_Nominees (
    policy_nominee_id INT PRIMARY KEY,
    policy_id INT NOT NULL,
    nominee_id INT NOT NULL,
    nominee_share_percent DECIMAL(5,2),
    nomination_date DATE,
    FOREIGN KEY (policy_id) REFERENCES Policies(policy_id),
    FOREIGN KEY (nominee_id) REFERENCES Nominees(nominee_id)
);

-------- 13. create payment_methods table ---------
CREATE TABLE Payment_Methods (
    payment_method_id INT PRIMARY KEY,
    method_name VARCHAR(40),
    channel VARCHAR(40),
    status VARCHAR(20)
);

-------- 14. create premiun_plans ----------
CREATE TABLE Premium_Plans (
    premium_plan_id INT PRIMARY KEY,
    policy_id INT NOT NULL,
    due_frequency VARCHAR(20),
    premium_due_amount DECIMAL(12,2),
    grace_period_days INT,
    next_due_date DATE,
    plan_status VARCHAR(20),
    FOREIGN KEY (policy_id) REFERENCES Policies(policy_id)
);

------ 15. create premium_payments table -----
CREATE TABLE Premium_Payments (
    payment_id INT PRIMARY KEY,
    policy_id INT NOT NULL,
    payment_method_id INT NOT NULL,
    due_date DATE,
    payment_date DATE,
    amount_paid DECIMAL(12,2),
    payment_status VARCHAR(20),
    transaction_reference VARCHAR(40),
    FOREIGN KEY (policy_id) REFERENCES Policies(policy_id),
    FOREIGN KEY (payment_method_id) REFERENCES Payment_Methods(payment_method_id)
);

------ 16. create policy_renewals table ---------
CREATE TABLE Policy_Renewals (
    renewal_id INT PRIMARY KEY,
    policy_id INT NOT NULL,
    renewal_date DATE,
    previous_expiry_date DATE,
    new_expiry_date DATE,
    renewal_premium DECIMAL(12,2),
    renewal_status VARCHAR(20),
    FOREIGN KEY (policy_id) REFERENCES Policies(policy_id)
);

------ 17. create claim_types table --------
CREATE TABLE Claim_Types (
    claim_type_id INT PRIMARY KEY,
    claim_type_name VARCHAR(60),
    description VARCHAR(200)
);

------- 18. create claims table -----------
CREATE TABLE Claims (
    claim_id INT PRIMARY KEY,
    claim_number VARCHAR(30) UNIQUE NOT NULL,
    policy_id INT NOT NULL,
    claim_type_id INT NOT NULL,
    nominee_id INT,
    claim_date DATE,
    claimed_amount DECIMAL(14,2),
    claim_status VARCHAR(30),
    intimation_channel VARCHAR(30),
    FOREIGN KEY (policy_id) REFERENCES Policies(policy_id),
    FOREIGN KEY (claim_type_id) REFERENCES Claim_Types(claim_type_id),
    FOREIGN KEY (nominee_id) REFERENCES Nominees(nominee_id)
);

------ 19. create claim_documents table ----------
CREATE TABLE Claim_Documents (
    document_id INT PRIMARY KEY,
    claim_id INT NOT NULL,
    document_type VARCHAR(80),
    submitted_date DATE,
    verification_status VARCHAR(30),
    verified_by INT,
    FOREIGN KEY (claim_id) REFERENCES Claims(claim_id),
    FOREIGN KEY (verified_by) REFERENCES Employee(employee_id)
);

------- 20. create claim_assessments table -----------
CREATE TABLE Claim_Assessments (
    assessment_id INT PRIMARY KEY,
    claim_id INT NOT NULL,
    assessor_employee_id INT NOT NULL,
    assessment_date DATE,
    approved_amount DECIMAL(14,2),
    assessment_result VARCHAR(30),
    remarks VARCHAR(255),
    FOREIGN KEY (claim_id) REFERENCES Claims(claim_id),
    FOREIGN KEY (assessor_employee_id) REFERENCES Employee(employee_id)
);


------- 21. create claim_payments table -------------
CREATE TABLE Claim_Payments (
    claim_payment_id INT PRIMARY KEY,
    claim_id INT NOT NULL,
    payment_date DATE,
    payment_amount DECIMAL(14,2),
    payment_method_id INT NOT NULL,
    payment_status VARCHAR(30),
    transaction_reference VARCHAR(40),
    FOREIGN KEY (claim_id) REFERENCES Claims(claim_id),
    FOREIGN KEY (payment_method_id) REFERENCES Payment_Methods(payment_method_id)
);

------- 22. create medical_examinations table -----------
CREATE TABLE Medical_Examinations (
    examination_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    policy_id INT NOT NULL,
    examination_date DATE,
    medical_center VARCHAR(120),
    bmi DECIMAL(5,2),
    smoker_status VARCHAR(20),
    medical_risk VARCHAR(30),
    result VARCHAR(30),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (policy_id) REFERENCES Policies(policy_id)
);

--------- 23. create underwriting table ----------- 
CREATE TABLE Underwriting (
    underwriting_id INT PRIMARY KEY,
    policy_id INT NOT NULL,
    underwriter_employee_id INT NOT NULL,
    assessment_date DATE,
    risk_score INT,
    risk_category VARCHAR(30),
    decision VARCHAR(30),
    loading_percent DECIMAL(6,2),
    remarks VARCHAR(255),
    FOREIGN KEY (policy_id) REFERENCES Policies(policy_id),
    FOREIGN KEY (underwriter_employee_id) REFERENCES Employee(employee_id)
);

------ 24. create beneficiaries table ----------
CREATE TABLE Beneficiaries (
    beneficiary_id INT PRIMARY KEY,
    policy_id INT NOT NULL,
    beneficiary_name VARCHAR(100),
    relationship VARCHAR(30),
    date_of_birth DATE,
    share_percent DECIMAL(5,2),
    contact_number VARCHAR(20),
    FOREIGN KEY (policy_id) REFERENCES Policies(policy_id)
);


------ 25. create policy_status_history table ------------- 
CREATE TABLE Policy_Status_History (
    history_id INT PRIMARY KEY,
    policy_id INT NOT NULL,
    old_status VARCHAR(30),
    new_status VARCHAR(30),
    changed_date DATE,
    changed_by INT NOT NULL,
    change_reason VARCHAR(150),
    FOREIGN KEY (policy_id) REFERENCES Policies(policy_id),
    FOREIGN KEY (changed_by) REFERENCES Employee(employee_id)
);

INSERT INTO Branches
(branch_id, branch_name, city, state, manager_name, phone)
VALUES
(1, 'Pune Central', 'Pune', 'Maharashtra', 'Amit Sharma', '9876543210'),
(2, 'Mumbai Main', 'Mumbai', 'Maharashtra', 'Rahul Patil', '9876543211'),
(3, 'Nashik Branch', 'Nashik', 'Maharashtra', 'Suresh Joshi', '9876543212'),
(4, 'Nagpur Branch', 'Nagpur', 'Maharashtra', 'Vikas Deshmukh', '9876543213'),
(5, 'Thane Branch', 'Thane', 'Maharashtra', 'Priya Kulkarni', '9876543214'),
(6, 'Kolhapur Branch', 'Kolhapur', 'Maharashtra', 'Rohit Jadhav', '9876543215'),
(7, 'Aurangabad Branch', 'Aurangabad', 'Maharashtra', 'Neha Pawar', '9876543216'),
(8, 'Delhi Central', 'New Delhi', 'Delhi', 'Anil Verma', '9876543217'),
(9, 'Bangalore Branch', 'Bangalore', 'Karnataka', 'Kiran Rao', '9876543218'),
(10, 'Chennai Branch', 'Chennai', 'Tamil Nadu', 'Arun Kumar', '9876543219'),
(11, 'Hyderabad Branch', 'Hyderabad', 'Telangana', 'Meena Reddy', '9876543220'),
(12, 'Ahmedabad Branch', 'Ahmedabad', 'Gujarat', 'Nitin Shah', '9876543221'),
(13, 'Surat Branch', 'Surat', 'Gujarat', 'Raj Mehta', '9876543222'),
(14, 'Jaipur Branch', 'Jaipur', 'Rajasthan', 'Deepak Singh', '9876543223'),
(15, 'Indore Branch', 'Indore', 'Madhya Pradesh', 'Pooja Jain', '9876543224'),
(16, 'Bhopal Branch', 'Bhopal', 'Madhya Pradesh', 'Manish Gupta', '9876543225'),
(17, 'Kolkata Branch', 'Kolkata', 'West Bengal', 'Sanjay Roy', '9876543226'),
(18, 'Lucknow Branch', 'Lucknow', 'Uttar Pradesh', 'Rakesh Mishra', '9876543227'),
(19, 'Chandigarh Branch', 'Chandigarh', 'Chandigarh', 'Simran Kaur', '9876543228'),
(20, 'Patna Branch', 'Patna', 'Bihar', 'Vijay Kumar', '9876543229'),
(21, 'Goa Branch', 'Panaji', 'Goa', 'Sameer Naik', '9876543230'),
(22, 'Kochi Branch', 'Kochi', 'Kerala', 'Anita Nair', '9876543231'),
(23, 'Bhubaneswar Branch', 'Bhubaneswar', 'Odisha', 'Prakash Das', '9876543232'),
(24, 'Coimbatore Branch', 'Coimbatore', 'Tamil Nadu', 'Mohan Raj', '9876543233'),
(25, 'Visakhapatnam Branch', 'Visakhapatnam', 'Andhra Pradesh', 'Ravi Kumar', '9876543234');

INSERT INTO Agents
(agent_id, agent_name, branch_id, joining_date, experience_years, commission_rate, status)
VALUES
(1, 'Aarav Mehta', 1, '2021-01-15', 5, 5.50, 'Active'),
(2, 'Sneha Patil', 2, '2020-03-10', 6, 6.00, 'Active'),
(3, 'Rohan Joshi', 3, '2022-06-18', 4, 5.00, 'Active'),
(4, 'Priyanka Deshmukh', 4, '2019-08-12', 7, 6.50, 'Active'),
(5, 'Akshay Kulkarni', 5, '2021-11-20', 5, 5.75, 'Active'),
(6, 'Neha Jadhav', 6, '2023-02-14', 3, 4.50, 'Active'),
(7, 'Vishal Pawar', 7, '2018-05-25', 8, 7.00, 'Active'),
(8, 'Pooja Verma', 8, '2022-01-10', 4, 5.25, 'Active'),
(9, 'Karan Rao', 9, '2020-09-05', 6, 6.00, 'Active'),
(10, 'Anjali Kumar', 10, '2021-04-22', 5, 5.50, 'Active'),
(11, 'Ramesh Reddy', 11, '2019-12-16', 7, 6.75, 'Active'),
(12, 'Isha Shah', 12, '2023-07-01', 3, 4.75, 'Active'),
(13, 'Manish Mehta', 13, '2020-02-19', 6, 6.25, 'Active'),
(14, 'Kavita Singh', 14, '2018-10-11', 8, 7.00, 'Active'),
(15, 'Rahul Jain', 15, '2022-03-28', 4, 5.00, 'Active'),
(16, 'Nisha Gupta', 16, '2021-06-15', 5, 5.50, 'Active'),
(17, 'Sourabh Roy', 17, '2019-04-08', 7, 6.50, 'Active'),
(18, 'Aditi Mishra', 18, '2023-01-12', 3, 4.50, 'Active'),
(19, 'Harpreet Kaur', 19, '2020-07-20', 6, 6.00, 'Active'),
(20, 'Vivek Kumar', 20, '2021-09-14', 5, 5.75, 'Active'),
(21, 'Rohit Naik', 21, '2022-11-05', 4, 5.25, 'Active'),
(22, 'Divya Nair', 22, '2019-06-17', 7, 6.50, 'Active'),
(23, 'Sanjay Das', 23, '2020-12-01', 6, 6.25, 'Active'),
(24, 'Megha Raj', 24, '2023-05-09', 3, 4.75, 'Active'),
(25, 'Nitin Kumar', 25, '2018-02-26', 8, 7.00, 'Active');

INSERT INTO Employee
(employee_id, employee_name, branch_id, designation, joining_date, salary, status)
VALUES
(1, 'Aditya Sharma', 1, 'Branch Manager', '2019-01-10', 65000.00, 'Active'),
(2, 'Swati Patil', 2, 'Insurance Executive', '2020-04-15', 45000.00, 'Active'),
(3, 'Nikhil Joshi', 3, 'Senior Executive', '2018-07-20', 52000.00, 'Active'),
(4, 'Komal Deshmukh', 4, 'Branch Manager', '2017-09-12', 68000.00, 'Active'),
(5, 'Tejas Kulkarni', 5, 'Insurance Executive', '2021-02-18', 43000.00, 'Active'),
(6, 'Riya Jadhav', 6, 'Claims Executive', '2022-06-10', 48000.00, 'Active'),
(7, 'Amol Pawar', 7, 'Underwriter', '2019-11-05', 60000.00, 'Active'),
(8, 'Shreya Verma', 8, 'Insurance Executive', '2020-08-22', 44000.00, 'Active'),
(9, 'Vivek Rao', 9, 'Branch Manager', '2018-03-14', 67000.00, 'Active'),
(10, 'Kajal Kumar', 10, 'Claims Executive', '2021-05-19', 47000.00, 'Active'),
(11, 'Ramesh Reddy', 11, 'Underwriter', '2019-02-11', 61000.00, 'Active'),
(12, 'Ishita Shah', 12, 'Insurance Executive', '2022-09-01', 42000.00, 'Active'),
(13, 'Mihir Mehta', 13, 'Senior Executive', '2020-01-25', 53000.00, 'Active'),
(14, 'Kavya Singh', 14, 'Branch Manager', '2017-06-16', 69000.00, 'Active'),
(15, 'Rohan Jain', 15, 'Claims Executive', '2021-10-08', 46000.00, 'Active'),
(16, 'Pallavi Gupta', 16, 'Insurance Executive', '2020-12-14', 44000.00, 'Active'),
(17, 'Siddharth Roy', 17, 'Underwriter', '2018-04-20', 62000.00, 'Active'),
(18, 'Ananya Mishra', 18, 'Claims Executive', '2022-03-11', 47500.00, 'Active'),
(19, 'Gurpreet Kaur', 19, 'Senior Executive', '2019-07-15', 54000.00, 'Active'),
(20, 'Vikas Kumar', 20, 'Insurance Executive', '2021-08-09', 43000.00, 'Active'),
(21, 'Sahil Naik', 21, 'Branch Manager', '2018-12-03', 66000.00, 'Active'),
(22, 'Anu Nair', 22, 'Claims Executive', '2020-06-25', 46500.00, 'Active'),
(23, 'Pranav Das', 23, 'Underwriter', '2019-10-17', 60500.00, 'Active'),
(24, 'Mansi Raj', 24, 'Insurance Executive', '2023-01-09', 41000.00, 'Active'),
(25, 'Ravi Kumar', 25, 'Senior Executive', '2018-05-28', 55000.00, 'Active');

INSERT INTO Customers
(customer_id, customer_name, gender, date_of_birth, marital_status, occupation, annual_income, city, state)
VALUES
(1, 'Aarav Sharma', 'Male', '1990-05-12', 'Married', 'Software Engineer', 850000, 'Pune', 'Maharashtra'),
(2, 'Sneha Patil', 'Female', '1992-08-20', 'Single', 'Teacher', 600000, 'Mumbai', 'Maharashtra'),
(3, 'Rohan Joshi', 'Male', '1988-03-15', 'Married', 'Businessman', 1200000, 'Nashik', 'Maharashtra'),
(4, 'Priya Deshmukh', 'Female', '1995-11-10', 'Single', 'Doctor', 1500000, 'Nagpur', 'Maharashtra'),
(5, 'Akshay Kulkarni', 'Male', '1987-07-25', 'Married', 'Accountant', 750000, 'Thane', 'Maharashtra'),
(6, 'Neha Jadhav', 'Female', '1993-01-18', 'Married', 'HR Manager', 900000, 'Kolhapur', 'Maharashtra'),
(7, 'Vishal Pawar', 'Male', '1985-09-05', 'Married', 'Entrepreneur', 1800000, 'Aurangabad', 'Maharashtra'),
(8, 'Pooja Verma', 'Female', '1996-04-22', 'Single', 'Software Developer', 800000, 'New Delhi', 'Delhi'),
(9, 'Karan Rao', 'Male', '1991-06-14', 'Married', 'Bank Manager', 1100000, 'Bangalore', 'Karnataka'),
(10, 'Anjali Kumar', 'Female', '1989-12-08', 'Married', 'Lawyer', 1300000, 'Chennai', 'Tamil Nadu'),
(11, 'Ramesh Reddy', 'Male', '1986-02-17', 'Married', 'Business Owner', 1600000, 'Hyderabad', 'Telangana'),
(12, 'Isha Shah', 'Female','1993-07-16', 'Married', 'Pharmacist', 700000, 'Bhopal', 'Madhya Pradesh'),
(13, 'Manish Mehta','Male','1983-05-19','Married','Civil Engineer',950000,'Surat','Gujarat'),
(14, 'Kavita Singh','Female','1987-08-11','Married','Professor',1000000,'Jaipur','Rajasthan'),
(15, 'Rahul Jain','Male','1990-01-27','Single','Data Analyst',900000,'Indore','Madhya Pradesh'),
(16, 'Nisha Gupta','Female','1993-07-16','Married','Pharmacist',700000,'Bhopal','Madhya Pradesh'),
(17, 'Sourabh Roy', 'Male', '1984-11-23', 'Married', 'Businessman', 1400000, 'Kolkata', 'West Bengal'),
(18, 'Aditi Mishra', 'Female', '1997-03-09', 'Single', 'Designer', 550000, 'Lucknow', 'Uttar Pradesh'),
(19, 'Harpreet Kaur', 'Female', '1988-06-21', 'Married', 'Government Employee', 850000, 'Chandigarh', 'Chandigarh'),
(20, 'Vivek Kumar', 'Male', '1991-09-13', 'Married', 'Sales Manager', 780000, 'Patna', 'Bihar'),
(21, 'Rohit Naik', 'Male', '1989-04-06', 'Single', 'Tourism Manager', 720000, 'Panaji', 'Goa'),
(22, 'Divya Nair', 'Female', '1992-12-19', 'Married', 'Nurse', 580000, 'Kochi', 'Kerala'),
(23, 'Sanjay Das', 'Male', '1985-10-15', 'Married', 'Business Owner', 1250000, 'Bhubaneswar', 'Odisha'),
(24, 'Megha Raj', 'Female', '1996-05-28', 'Single', 'Software Engineer', 820000, 'Coimbatore', 'Tamil Nadu'),
(25, 'Nitin Kumar', 'Male', '1982-02-10', 'Married', 'Consultant', 1350000, 'Visakhapatnam', 'Andhra Pradesh');

INSERT INTO Customer_Addresses
(address_id, customer_id, address_type, address_line, city, state, pincode)
VALUES
(1, 1, 'Home', '12 FC Road', 'Pune', 'Maharashtra', '411004'),
(2, 2, 'Home', '25 Andheri East', 'Mumbai', 'Maharashtra', '400069'),
(3, 3, 'Home', '18 College Road', 'Nashik', 'Maharashtra', '422005'),
(4, 4, 'Home', '45 Civil Lines', 'Nagpur', 'Maharashtra', '440001'),
(5, 5, 'Home', '32 Ghodbunder Road', 'Thane', 'Maharashtra', '400607'),
(6, 6, 'Home', '16 Station Road', 'Kolhapur', 'Maharashtra', '416001'),
(7, 7, 'Home', '28 CIDCO Road', 'Aurangabad', 'Maharashtra', '431003'),
(8, 8, 'Home', '56 Rohini Sector 8', 'New Delhi', 'Delhi', '110085'),
(9, 9, 'Home', '21 Indiranagar Main Road', 'Bangalore', 'Karnataka', '560038'),
(10, 10, 'Home', '14 Anna Nagar', 'Chennai', 'Tamil Nadu', '600040'),
(11, 11, 'Home', '33 Banjara Hills', 'Hyderabad', 'Telangana', '500034'),
(12, 12, 'Home', '17 Navrangpura', 'Ahmedabad', 'Gujarat', '380009'),
(13, 13, 'Home', '41 Adajan Road', 'Surat', 'Gujarat', '395009'),
(14, 14, 'Home', '22 Vaishali Nagar', 'Jaipur', 'Rajasthan', '302021'),
(15, 15, 'Home', '19 Vijay Nagar', 'Indore', 'Madhya Pradesh', '452010'),
(16, 16, 'Home', '35 Arera Colony', 'Bhopal', 'Madhya Pradesh', '462016'),
(17, 17, 'Home', '27 Salt Lake City', 'Kolkata', 'West Bengal', '700091'),
(18, 18, 'Home', '13 Gomti Nagar', 'Lucknow', 'Uttar Pradesh', '226010'),
(19, 19, 'Home', '24 Sector 17', 'Chandigarh', 'Chandigarh', '160017'),
(20, 20, 'Home', '31 Boring Road', 'Patna', 'Bihar', '800001'),
(21, 21, 'Home', '11 Panaji Market Road', 'Panaji', 'Goa', '403001'),
(22, 22, 'Home', '42 MG Road', 'Kochi', 'Kerala', '682016'),
(23, 23, 'Home', '29 Saheed Nagar', 'Bhubaneswar', 'Odisha', '751007'),
(24, 24, 'Home', '15 RS Puram', 'Coimbatore', 'Tamil Nadu', '641002'),
(25, 25, 'Home', '38 MVP Colony', 'Visakhapatnam', 'Andhra Pradesh', '530017');

INSERT INTO Customer_Contacts
(contact_id, customer_id, mobile, email, preferred_contact)
VALUES
(1, 1, '9876500001', 'aarav.sharma@gmail.com', 'Mobile'),
(2, 2, '9876500002', 'sneha.patil@gmail.com', 'Email'),
(3, 3, '9876500003', 'rohan.joshi@gmail.com', 'Mobile'),
(4, 4, '9876500004', 'priya.deshmukh@gmail.com', 'Email'),
(5, 5, '9876500005', 'akshay.kulkarni@gmail.com', 'Mobile'),
(6, 6, '9876500006', 'neha.jadhav@gmail.com', 'Mobile'),
(7, 7, '9876500007', 'vishal.pawar@gmail.com', 'Email'),
(8, 8, '9876500008', 'pooja.verma@gmail.com', 'Mobile'),
(9, 9, '9876500009', 'karan.rao@gmail.com', 'Email'),
(10, 10, '9876500010', 'anjali.kumar@gmail.com', 'Mobile'),
(11, 11, '9876500011', 'ramesh.reddy@gmail.com', 'Mobile'),
(12, 12, '9876500012', 'isha.shah@gmail.com', 'Email'),
(13, 13, '9876500013', 'manish.mehta@gmail.com', 'Mobile'),
(14, 14, '9876500014', 'kavita.singh@gmail.com', 'Email'),
(15, 15, '9876500015', 'rahul.jain@gmail.com', 'Mobile'),
(16, 16, '9876500016', 'nisha.gupta@gmail.com', 'Mobile'),
(17, 17, '9876500017', 'sourabh.roy@gmail.com', 'Email'),
(18, 18, '9876500018', 'aditi.mishra@gmail.com', 'Mobile'),
(19, 19, '9876500019', 'harpreet.kaur@gmail.com', 'Email'),
(20, 20, '9876500020', 'vivek.kumar@gmail.com', 'Mobile'),
(21, 21, '9876500021', 'rohit.naik@gmail.com', 'Email'),
(22, 22, '9876500022', 'divya.nair@gmail.com', 'Mobile'),
(23, 23, '9876500023', 'sanjay.das@gmail.com', 'Email'),
(24, 24, '9876500024', 'megha.raj@gmail.com', 'Mobile'),
(25, 25, '9876500025', 'nitin.kumar@gmail.com', 'Email');

INSERT INTO Nominees
(nominee_id, customer_id, nominee_name, relationship, date_of_birth, share_percent)
VALUES
(1, 1, 'Kavya Sharma', 'Wife', '1992-03-15', 100.00),
(2, 2, 'Ramesh Patil', 'Father', '1965-07-20', 100.00),
(3, 3, 'Anita Joshi', 'Wife', '1990-05-11', 100.00),
(4, 4, 'Amit Deshmukh', 'Husband', '1993-02-18', 100.00),
(5, 5, 'Snehal Kulkarni', 'Wife', '1989-09-25', 100.00),
(6, 6, 'Raj Jadhav', 'Husband', '1991-06-14', 100.00),
(7, 7, 'Pooja Pawar', 'Wife', '1987-12-05', 100.00),
(8, 8, 'Neeraj Verma', 'Father', '1968-04-22', 100.00),
(9, 9, 'Meera Rao', 'Wife', '1993-08-17', 100.00),
(10, 10, 'Vijay Kumar', 'Husband', '1988-11-10', 100.00),
(11, 11, 'Lakshmi Reddy', 'Wife', '1989-01-26', 100.00),
(12, 12, 'Mahesh Shah', 'Father', '1966-09-18', 100.00),
(13, 13, 'Rina Mehta', 'Wife', '1986-03-12', 100.00),
(14, 14, 'Raj Singh', 'Husband', '1985-07-30', 100.00),
(15, 15, 'Neha Jain', 'Sister', '1994-10-08', 100.00),
(16, 16, 'Amit Gupta', 'Husband', '1991-02-16', 100.00),
(17, 17, 'Madhuri Roy', 'Wife', '1987-06-21', 100.00),
(18, 18, 'Suresh Mishra', 'Father', '1965-12-14', 100.00),
(19, 19, 'Gurmeet Singh', 'Husband', '1986-05-19', 100.00),
(20, 20, 'Sunita Kumar', 'Wife', '1992-09-07', 100.00),
(21, 21, 'Anjali Naik', 'Sister', '1991-04-25', 100.00),
(22, 22, 'Mohan Nair', 'Husband', '1989-11-16', 100.00),
(23, 23, 'Sushma Das', 'Wife', '1987-08-13', 100.00),
(24, 24, 'Arjun Raj', 'Brother', '1993-01-29', 100.00),
(25, 25, 'Priya Kumar', 'Wife', '1985-06-17', 100.00);

INSERT INTO Insurance_Products
(product_id, product_name, product_category, minimum_sum_assured, maximum_sum_assured, minimum_term_years, maximum_term_years, base_premium_rate)
VALUES
(1, 'Life Secure Plan', 'Term Life', 500000, 5000000, 10, 30, 2.500),
(2, 'Family Protection Plan', 'Term Life', 1000000, 10000000, 10, 30, 2.800),
(3, 'Child Future Plan', 'Child Insurance', 300000, 3000000, 10, 25, 2.200),
(4, 'Retirement Plus', 'Retirement', 500000, 5000000, 10, 25, 3.000),
(5, 'Whole Life Secure', 'Whole Life', 500000, 10000000, 20, 40, 3.200),
(6, 'Money Back Plan', 'Money Back', 300000, 5000000, 15, 25, 3.500),
(7, 'Endowment Savings', 'Endowment', 500000, 7500000, 15, 30, 3.100),
(8, 'Senior Citizen Care', 'Senior Citizen', 200000, 3000000, 5, 15, 4.000),
(9, 'Income Protection Plan', 'Income Protection', 500000, 5000000, 10, 30, 2.700),
(10, 'Secure Future Plan', 'Savings', 400000, 6000000, 10, 25, 2.900),
(11, 'Life Advantage Plan', 'Term Life', 750000, 8000000, 10, 30, 2.600),
(12, 'Family Income Plan', 'Family Protection', 500000, 7000000, 15, 30, 3.000),
(13, 'Education Secure Plan', 'Child Insurance', 300000, 4000000, 10, 20, 2.400),
(14, 'Pension Secure Plan', 'Retirement', 500000, 6000000, 15, 30, 3.200),
(15, 'Lifetime Protection', 'Whole Life', 1000000, 12000000, 20, 40, 3.400),
(16, 'Guaranteed Return Plan', 'Endowment', 500000, 8000000, 15, 30, 3.300),
(17, 'Future Wealth Plan', 'Savings', 400000, 7000000, 10, 25, 3.000),
(18, 'Secure Income Plan', 'Income Protection', 500000, 6000000, 10, 30, 2.800),
(19, 'Golden Years Plan', 'Senior Citizen', 300000, 3500000, 5, 15, 4.200),
(20, 'Smart Life Plan', 'Term Life', 500000, 9000000, 10, 30, 2.700),
(21, 'Family Wealth Plan', 'Family Protection', 750000, 10000000, 15, 30, 3.100),
(22, 'Child Education Plus', 'Child Insurance', 300000, 5000000, 10, 25, 2.500),
(23, 'Retirement Income Plus', 'Retirement', 500000, 7500000, 15, 30, 3.300),
(24, 'Complete Life Cover', 'Whole Life', 1000000, 15000000, 20, 40, 3.500),
(25, 'Life Savings Plus', 'Savings', 500000, 8000000, 10, 25, 3.100);

INSERT INTO Policy_Types
(policy_type_id, policy_type_name, description)
VALUES
(1, 'Term Insurance', 'Provides life coverage for a fixed period.'),
(2, 'Whole Life Insurance', 'Provides life coverage for the entire lifetime.'),
(3, 'Endowment Plan', 'Provides insurance coverage with savings benefits.'),
(4, 'Money Back Plan', 'Provides periodic survival benefits during the policy term.'),
(5, 'Child Insurance', 'Provides financial protection for a childs future.'),
(6, 'Retirement Plan', 'Provides financial support after retirement.'),
(7, 'Pension Plan', 'Provides regular income after retirement.'),
(8, 'Savings Plan', 'Combines life insurance with savings benefits.'),
(9, 'Family Protection Plan', 'Provides financial protection to the family.'),
(10, 'Income Protection Plan', 'Provides financial support to the policyholder or family.'),
(11, 'Senior Citizen Plan', 'Life insurance plan designed for senior citizens.'),
(12, 'Education Plan', 'Helps provide funds for childrens education.'),
(13, 'Guaranteed Return Plan', 'Provides guaranteed benefits according to policy terms.'),
(14, 'Investment Plan', 'Combines life insurance with investment benefits.'),
(15, 'Life Protection Plan', 'Provides financial protection against loss of life.'),
(16, 'Future Secure Plan', 'Helps secure future financial requirements.'),
(17, 'Family Income Plan', 'Provides regular financial support to the family.'),
(18, 'Wealth Creation Plan', 'Helps create long-term financial savings.'),
(19, 'Lifetime Protection Plan', 'Provides long-term life protection.'),
(20, 'Smart Life Plan', 'Provides flexible life insurance coverage.'),
(21, 'Secure Savings Plan', 'Provides insurance coverage along with savings.'),
(22, 'Retirement Income Plan', 'Provides income after retirement.'),
(23, 'Child Future Plan', 'Helps secure financial needs of children.'),
(24, 'Complete Life Cover', 'Provides comprehensive life insurance coverage.'),
(25, 'Family Wealth Plan', 'Provides life protection and long-term wealth benefits.');

INSERT INTO Policies
(policy_id, policy_number, customer_id, agent_id, product_id, policy_type_id, branch_id,
 issue_date, start_date, maturity_date, sum_assured, premium_amount,
 premium_frequency, policy_term_years, status)
VALUES
(1, 'LIC100001', 1, 1, 1, 1, 1, '2024-01-10', '2024-01-15', '2044-01-15', 1000000, 25000, 'Yearly', 20, 'Active'),
(2, 'LIC100002', 2, 2, 2, 1, 2, '2024-02-12', '2024-02-15', '2044-02-15', 1500000, 36000, 'Yearly', 20, 'Active'),
(3, 'LIC100003', 3, 3, 3, 5, 3, '2024-03-05', '2024-03-10', '2039-03-10', 800000, 17600, 'Yearly', 15, 'Active'),
(4, 'LIC100004', 4, 4, 4, 4, 4, '2024-03-18', '2024-03-20', '2039-03-20', 1200000, 42000, 'Half-Yearly', 15, 'Active'),
(5, 'LIC100005', 5, 5, 5, 2, 5, '2024-04-08', '2024-04-10', '2044-04-10', 2000000, 64000, 'Yearly', 20, 'Active'),
(6, 'LIC100006', 6, 6, 6, 4, 6, '2024-04-20', '2024-04-25', '2039-04-25', 1000000, 35000, 'Yearly', 15, 'Active'),
(7, 'LIC100007', 7, 7, 7, 3, 7, '2024-05-11', '2024-05-15', '2044-05-15', 1800000, 55800, 'Yearly', 20, 'Active'),
(8, 'LIC100008', 8, 8, 8, 6, 8, '2024-05-22', '2024-05-25', '2039-05-25', 900000, 36000, 'Monthly', 15, 'Active'),
(9, 'LIC100009', 9, 9, 9, 10, 9, '2024-06-03', '2024-06-05', '2044-06-05', 1500000, 40500, 'Yearly', 20, 'Active'),
(10, 'LIC100010', 10, 10, 10, 8, 10, '2024-06-15', '2024-06-20', '2039-06-20', 1000000, 29000, 'Yearly', 15, 'Active'),
(11, 'LIC100011', 11, 11, 11, 1, 11, '2024-07-01', '2024-07-05', '2044-07-05', 2000000, 52000, 'Yearly', 20, 'Active'),
(12, 'LIC100012', 12, 12, 12, 9, 12, '2024-07-14', '2024-07-18', '2039-07-18', 1200000, 36000, 'Yearly', 15, 'Active'),
(13, 'LIC100013', 13, 13, 13, 12, 13, '2024-08-05', '2024-08-10', '2039-08-10', 700000, 16800, 'Half-Yearly', 15, 'Active'),
(14, 'LIC100014', 14, 14, 14, 6, 14, '2024-08-20', '2024-08-25', '2044-08-25', 1600000, 51200, 'Yearly', 20, 'Active'),
(15, 'LIC100015', 15, 15, 15, 2, 15, '2024-09-02', '2024-09-05', '2044-09-05', 2500000, 85000, 'Yearly', 20, 'Active'),
(16, 'LIC100016', 16, 16, 16, 3, 16, '2024-09-15', '2024-09-20', '2044-09-20', 1800000, 59400, 'Yearly', 20, 'Active'),
(17, 'LIC100017', 17, 17, 17, 8, 17, '2024-10-01', '2024-10-05', '2039-10-05', 1000000, 30000, 'Monthly', 15, 'Active'),
(18, 'LIC100018', 18, 18, 18, 10, 18, '2024-10-12', '2024-10-15', '2044-10-15', 1200000, 33600, 'Yearly', 20, 'Active'),
(19, 'LIC100019', 19, 19, 19, 11, 19, '2024-10-25', '2024-10-30', '2034-10-30', 600000, 25200, 'Yearly', 10, 'Active'),
(20, 'LIC100020', 20, 20, 20, 1, 20, '2024-11-05', '2024-11-10', '2044-11-10', 1500000, 40500, 'Yearly', 20, 'Active'),
(21, 'LIC100021', 21, 21, 21, 9, 21, '2024-11-18', '2024-11-20', '2044-11-20', 1800000, 55800, 'Yearly', 20, 'Active'),
(22, 'LIC100022', 22, 22, 22, 23, 22, '2024-12-02', '2024-12-05', '2039-12-05', 800000, 20000, 'Half-Yearly', 15, 'Active'),
(23, 'LIC100023', 23, 23, 23, 7, 23, '2024-12-10', '2024-12-15', '2044-12-15', 1600000, 52800, 'Yearly', 20, 'Active'),
(24, 'LIC100024', 24, 24, 24, 19, 24, '2025-01-05', '2025-01-10', '2045-01-10', 2500000, 87500, 'Yearly', 20, 'Active'),
(25, 'LIC100025', 25, 25, 25, 25, 25, '2025-01-15', '2025-01-20', '2040-01-20', 1400000, 43400, 'Yearly', 15, 'Active');

INSERT INTO Policy_Holders
(policy_holder_id, policy_id, customer_id, holder_type, ownership_percent, effective_date)
VALUES
(1, 1, 1, 'Primary', 100.00, '2024-01-15'),
(2, 2, 2, 'Primary', 100.00, '2024-02-15'),
(3, 3, 3, 'Primary', 100.00, '2024-03-10'),
(4, 4, 4, 'Primary', 100.00, '2024-03-20'),
(5, 5, 5, 'Primary', 100.00, '2024-04-10'),
(6, 6, 6, 'Primary', 100.00, '2024-04-25'),
(7, 7, 7, 'Primary', 100.00, '2024-05-15'),
(8, 8, 8, 'Primary', 100.00, '2024-05-25'),
(9, 9, 9, 'Primary', 100.00, '2024-06-05'),
(10, 10, 10, 'Primary', 100.00, '2024-06-20'),
(11, 11, 11, 'Primary', 100.00, '2024-07-05'),
(12, 12, 12, 'Primary', 100.00, '2024-07-18'),
(13, 13, 13, 'Primary', 100.00, '2024-08-10'),
(14, 14, 14, 'Primary', 100.00, '2024-08-25'),
(15, 15, 15, 'Primary', 100.00, '2024-09-05'),
(16, 16, 16, 'Primary', 100.00, '2024-09-20'),
(17, 17, 17, 'Primary', 100.00, '2024-10-05'),
(18, 18, 18, 'Primary', 100.00, '2024-10-15'),
(19, 19, 19, 'Primary', 100.00, '2024-10-30'),
(20, 20, 20, 'Primary', 100.00, '2024-11-10'),
(21, 21, 21, 'Primary', 100.00, '2024-11-20'),
(22, 22, 22, 'Primary', 100.00, '2024-12-05'),
(23, 23, 23, 'Primary', 100.00, '2024-12-15'),
(24, 24, 24, 'Primary', 100.00, '2025-01-10'),
(25, 25, 25, 'Primary', 100.00, '2025-01-20');

INSERT INTO Policy_Nominees
(policy_nominee_id, policy_id, nominee_id, nominee_share_percent, nomination_date)
VALUES
(1, 1, 1, 100.00, '2024-01-15'),
(2, 2, 2, 100.00, '2024-02-15'),
(3, 3, 3, 100.00, '2024-03-10'),
(4, 4, 4, 100.00, '2024-03-20'),
(5, 5, 5, 100.00, '2024-04-10'),
(6, 6, 6, 100.00, '2024-04-25'),
(7, 7, 7, 100.00, '2024-05-15'),
(8, 8, 8, 100.00, '2024-05-25'),
(9, 9, 9, 100.00, '2024-06-05'),
(10, 10, 10, 100.00, '2024-06-20'),
(11, 11, 11, 100.00, '2024-07-05'),
(12, 12, 12, 100.00, '2024-07-18'),
(13, 13, 13, 100.00, '2024-08-10'),
(14, 14, 14, 100.00, '2024-08-25'),
(15, 15, 15, 100.00, '2024-09-05'),
(16, 16, 16, 100.00, '2024-09-20'),
(17, 17, 17, 100.00, '2024-10-05'),
(18, 18, 18, 100.00, '2024-10-15'),
(19, 19, 19, 100.00, '2024-10-30'),
(20, 20, 20, 100.00, '2024-11-10'),
(21, 21, 21, 100.00, '2024-11-20'),
(22, 22, 22, 100.00, '2024-12-05'),
(23, 23, 23, 100.00, '2024-12-15'),
(24, 24, 24, 100.00, '2025-01-10'),
(25, 25, 25, 100.00, '2025-01-20');

INSERT INTO Payment_Methods
(payment_method_id, method_name, channel, status)
VALUES
(1, 'Cash', 'Offline', 'Active'),
(2, 'Cheque', 'Offline', 'Active'),
(3, 'Debit Card', 'Online', 'Active'),
(4, 'Credit Card', 'Online', 'Active'),
(5, 'Net Banking', 'Online', 'Active'),
(6, 'UPI', 'Online', 'Active'),
(7, 'NEFT', 'Online', 'Active'),
(8, 'RTGS', 'Online', 'Active'),
(9, 'Mobile Banking', 'Online', 'Active'),
(10, 'Auto Debit', 'Online', 'Active'),
(11, 'Bank Transfer', 'Online', 'Active'),
(12, 'Demand Draft', 'Offline', 'Active'),
(13, 'UPI', 'Online', 'Active'),
(14, 'Credit Card', 'Online', 'Active'),
(15, 'Debit Card', 'Online', 'Active'),
(16, 'Net Banking', 'Online', 'Active'),
(17, 'Cheque', 'Offline', 'Active'),
(18, 'Cash', 'Offline', 'Active'),
(19, 'NEFT', 'Online', 'Active'),
(20, 'RTGS', 'Online', 'Active'),
(21, 'Mobile Banking', 'Online', 'Active'),
(22, 'Auto Debit', 'Online', 'Active'),
(23, 'Bank Transfer', 'Online', 'Active'),
(24, 'UPI', 'Online', 'Active'),
(25, 'Debit Card', 'Online', 'Active');

INSERT INTO Premium_Payments
(payment_id, policy_id, payment_method_id, due_date, payment_date, amount_paid, payment_status, transaction_reference)
VALUES
(1, 1, 6, '2025-01-15', '2025-01-12', 25000.00, 'Paid', 'TXN100001'),
(2, 2, 3, '2025-02-15', '2025-02-14', 36000.00, 'Paid', 'TXN100002'),
(3, 3, 5, '2025-03-10', '2025-03-08', 17600.00, 'Paid', 'TXN100003'),
(4, 4, 4, '2025-03-20', '2025-03-18', 21000.00, 'Paid', 'TXN100004'),
(5, 5, 10, '2025-04-10', '2025-04-08', 64000.00, 'Paid', 'TXN100005'),
(6, 6, 6, '2025-04-25', '2025-04-22', 35000.00, 'Paid', 'TXN100006'),
(7, 7, 7, '2025-05-15', '2025-05-14', 55800.00, 'Paid', 'TXN100007'),
(8, 8, 9, '2025-05-25', NULL, 0.00, 'Pending', 'TXN100008'),
(9, 9, 5, '2025-06-05', '2025-06-03', 40500.00, 'Paid', 'TXN100009'),
(10, 10, 3, '2025-06-20', '2025-06-19', 29000.00, 'Paid', 'TXN100010'),
(11, 11, 6, '2025-07-05', '2025-07-04', 52000.00, 'Paid', 'TXN100011'),
(12, 12, 4, '2025-07-18', NULL, 0.00, 'Pending', 'TXN100012'),
(13, 13, 5, '2025-08-10', '2025-08-08', 8400.00, 'Paid', 'TXN100013'),
(14, 14, 10, '2025-08-25', '2025-08-23', 51200.00, 'Paid', 'TXN100014'),
(15, 15, 6, '2025-09-05', NULL, 0.00, 'Pending', 'TXN100015'),
(16, 16, 7, '2025-09-20', '2025-09-18', 59400.00, 'Paid', 'TXN100016'),
(17, 17, 9, '2025-10-05', NULL, 0.00, 'Pending', 'TXN100017'),
(18, 18, 5, '2025-10-15', '2025-10-14', 33600.00, 'Paid', 'TXN100018'),
(19, 19, 3, '2025-10-30', '2025-10-28', 25200.00, 'Paid', 'TXN100019'),
(20, 20, 6, '2025-11-10', NULL, 0.00, 'Pending', 'TXN100020'),
(21, 21, 10, '2025-11-20', '2025-11-18', 55800.00, 'Paid', 'TXN100021'),
(22, 22, 4, '2025-12-05', '2025-12-03', 10000.00, 'Paid', 'TXN100022'),
(23, 23, 7, '2025-12-15', NULL, 0.00, 'Pending', 'TXN100023'),
(24, 24, 6, '2026-01-10', '2026-01-08', 87500.00, 'Paid', 'TXN100024'),
(25, 25, 5, '2026-01-20', '2026-01-18', 43400.00, 'Paid', 'TXN100025');

INSERT INTO Policy_Renewals
(renewal_id, policy_id, renewal_date, previous_expiry_date, new_expiry_date, renewal_premium, renewal_status)
VALUES
(1, 1, '2025-01-15', '2025-01-14', '2026-01-14', 25000.00, 'Renewed'),
(2, 2, '2025-02-15', '2025-02-14', '2026-02-14', 36000.00, 'Renewed'),
(3, 3, '2025-03-10', '2025-03-09', '2026-03-09', 17600.00, 'Renewed'),
(4, 4, '2025-03-20', '2025-03-19', '2026-03-19', 21000.00, 'Renewed'),
(5, 5, '2025-04-10', '2025-04-09', '2026-04-09', 64000.00, 'Renewed'),
(6, 6, '2025-04-25', '2025-04-24', '2026-04-24', 35000.00, 'Renewed'),
(7, 7, '2025-05-15', '2025-05-14', '2026-05-14', 55800.00, 'Renewed'),
(8, 8, '2025-05-25', '2025-05-24', '2026-05-24', 36000.00, 'Pending'),
(9, 9, '2025-06-05', '2025-06-04', '2026-06-04', 40500.00, 'Renewed'),
(10, 10, '2025-06-20', '2025-06-19', '2026-06-19', 29000.00, 'Renewed'),
(11, 11, '2025-07-05', '2025-07-04', '2026-07-04', 52000.00, 'Renewed'),
(12, 12, '2025-07-18', '2025-07-17', '2026-07-17', 36000.00, 'Pending'),
(13, 13, '2025-08-10', '2025-08-09', '2026-08-09', 16800.00, 'Renewed'),
(14, 14, '2025-08-25', '2025-08-24', '2026-08-24', 51200.00, 'Renewed'),
(15, 15, '2025-09-05', '2025-09-04', '2026-09-04', 85000.00, 'Pending'),
(16, 16, '2025-09-20', '2025-09-19', '2026-09-19', 59400.00, 'Renewed'),
(17, 17, '2025-10-05', '2025-10-04', '2026-10-04', 30000.00, 'Pending'),
(18, 18, '2025-10-15', '2025-10-14', '2026-10-14', 33600.00, 'Renewed'),
(19, 19, '2025-10-30', '2025-10-29', '2026-10-29', 25200.00, 'Renewed'),
(20, 20, '2025-11-10', '2025-11-09', '2026-11-09', 40500.00, 'Pending'),
(21, 21, '2025-11-20', '2025-11-19', '2026-11-19', 55800.00, 'Renewed'),
(22, 22, '2025-12-05', '2025-12-04', '2026-12-04', 20000.00, 'Renewed'),
(23, 23, '2025-12-15', '2025-12-14', '2026-12-14', 52800.00, 'Pending'),
(24, 24, '2026-01-10', '2026-01-09', '2027-01-09', 87500.00, 'Renewed'),
(25, 25, '2026-01-20', '2026-01-19', '2027-01-19', 43400.00, 'Renewed');

INSERT INTO Claim_Types
(claim_type_id, claim_type_name, description)
VALUES
(1, 'Death Claim', 'Claim made after the death of the policyholder.'),
(2, 'Maturity Claim', 'Claim made when the policy reaches maturity.'),
(3, 'Accidental Death', 'Claim resulting from accidental death.'),
(4, 'Natural Death', 'Claim resulting from natural death.'),
(5, 'Critical Illness', 'Claim related to covered critical illness.'),
(6, 'Disability Claim', 'Claim related to permanent disability.'),
(7, 'Partial Disability', 'Claim related to partial disability.'),
(8, 'Terminal Illness', 'Claim related to terminal illness.'),
(9, 'Hospitalization', 'Claim related to eligible hospitalization expenses.'),
(10, 'Survival Benefit', 'Claim for survival benefit under the policy.'),
(11, 'Income Benefit', 'Claim for eligible income benefits.'),
(12, 'Education Benefit', 'Claim related to child education benefits.'),
(13, 'Retirement Benefit', 'Claim related to retirement benefits.'),
(14, 'Pension Benefit', 'Claim for pension-related benefits.'),
(15, 'Money Back Benefit', 'Claim for scheduled money-back benefits.'),
(16, 'Endowment Benefit', 'Claim for endowment policy benefits.'),
(17, 'Surrender Claim', 'Claim made when a policy is surrendered.'),
(18, 'Rider Claim', 'Claim made under an additional policy rider.'),
(19, 'Accidental Disability', 'Claim for disability caused by an accident.'),
(20, 'Health Benefit', 'Claim for eligible health-related benefits.'),
(21, 'Family Income Benefit', 'Claim for family income benefits.'),
(22, 'Guaranteed Benefit', 'Claim for guaranteed policy benefits.'),
(23, 'Loyalty Benefit', 'Claim for eligible loyalty benefits.'),
(24, 'Bonus Claim', 'Claim related to accumulated policy bonuses.'),
(25, 'Other Benefit', 'Claim for other eligible policy benefits.');

INSERT INTO Claims
(claim_id, claim_number, policy_id, claim_type_id, nominee_id, claim_date, claimed_amount, claim_status, intimation_channel)
VALUES
(1, 'CLM100001', 1, 1, 1, '2025-02-10', 1000000.00, 'Approved', 'Online'),
(2, 'CLM100002', 2, 3, 2, '2025-03-15', 1500000.00, 'Approved', 'Branch'),
(3, 'CLM100003', 3, 5, 3, '2025-04-12', 300000.00, 'Under Review', 'Online'),
(4, 'CLM100004', 4, 6, 4, '2025-05-05', 500000.00, 'Approved', 'Email'),
(5, 'CLM100005', 5, 4, 5, '2025-05-20', 2000000.00, 'Approved', 'Branch'),
(6, 'CLM100006', 6, 8, 6, '2025-06-08', 400000.00, 'Under Review', 'Online'),
(7, 'CLM100007', 7, 2, 7, '2025-06-25', 1800000.00, 'Approved', 'Online'),
(8, 'CLM100008', 8, 10, 8, '2025-07-10', 900000.00, 'Pending', 'Branch'),
(9, 'CLM100009', 9, 3, 9, '2025-07-22', 1500000.00, 'Approved', 'Online'),
(10, 'CLM100010', 10, 5, 10, '2025-08-05', 500000.00, 'Under Review', 'Email'),
(11, 'CLM100011', 11, 1, 11, '2025-08-18', 2000000.00, 'Approved', 'Branch'),
(12, 'CLM100012', 12, 6, 12, '2025-09-02', 600000.00, 'Pending', 'Online'),
(13, 'CLM100013', 13, 2, 13, '2025-09-15', 700000.00, 'Approved', 'Online'),
(14, 'CLM100014', 14, 4, 14, '2025-09-28', 1600000.00, 'Approved', 'Branch'),
(15, 'CLM100015', 15, 7, 15, '2025-10-10', 500000.00, 'Under Review', 'Online'),
(16, 'CLM100016', 16, 8, 16, '2025-10-22', 800000.00, 'Pending', 'Email'),
(17, 'CLM100017', 17, 10, 17, '2025-11-05', 1000000.00, 'Approved', 'Online'),
(18, 'CLM100018', 18, 5, 18, '2025-11-18', 400000.00, 'Approved', 'Branch'),
(19, 'CLM100019', 19, 3, 19, '2025-12-01', 600000.00, 'Under Review', 'Online'),
(20, 'CLM100020', 20, 1, 20, '2025-12-15', 1500000.00, 'Approved', 'Branch'),
(21, 'CLM100021', 21, 4, 21, '2026-01-05', 1800000.00, 'Approved', 'Online'),
(22, 'CLM100022', 22, 2, 22, '2026-01-18', 800000.00, 'Pending', 'Email'),
(23, 'CLM100023', 23, 6, 23, '2026-02-02', 700000.00, 'Under Review', 'Online'),
(24, 'CLM100024', 24, 1, 24, '2026-02-15', 2500000.00, 'Approved', 'Branch'),
(25, 'CLM100025', 25, 5, 25, '2026-03-01', 500000.00, 'Pending', 'Online');

INSERT INTO Claim_Documents
(document_id, claim_id, document_type, submitted_date, verification_status, verified_by)
VALUES
(1, 1, 'Death Certificate', '2025-02-12', 'Verified', 1),
(2, 2, 'Accident Report', '2025-03-17', 'Verified', 2),
(3, 3, 'Medical Report', '2025-04-15', 'Pending', 3),
(4, 4, 'Disability Certificate', '2025-05-08', 'Verified', 4),
(5, 5, 'Death Certificate', '2025-05-22', 'Verified', 5),
(6, 6, 'Medical Report', '2025-06-10', 'Pending', 6),
(7, 7, 'Policy Document', '2025-06-27', 'Verified', 7),
(8, 8, 'Survival Certificate', '2025-07-12', 'Pending', 8),
(9, 9, 'Accident Report', '2025-07-24', 'Verified', 9),
(10, 10, 'Medical Report', '2025-08-07', 'Pending', 10),
(11, 11, 'Death Certificate', '2025-08-20', 'Verified', 11),
(12, 12, 'Disability Certificate', '2025-09-04', 'Pending', 12),
(13, 13, 'Maturity Certificate', '2025-09-17', 'Verified', 13),
(14, 14, 'Death Certificate', '2025-09-30', 'Verified', 14),
(15, 15, 'Medical Report', '2025-10-12', 'Pending', 15),
(16, 16, 'Medical Report', '2025-10-24', 'Pending', 16),
(17, 17, 'Survival Certificate', '2025-11-07', 'Verified', 17),
(18, 18, 'Medical Report', '2025-11-20', 'Verified', 18),
(19, 19, 'Accident Report', '2025-12-03', 'Pending', 19),
(20, 20, 'Death Certificate', '2025-12-17', 'Verified', 20),
(21, 21, 'Death Certificate', '2026-01-07', 'Verified', 21),
(22, 22, 'Maturity Certificate', '2026-01-20', 'Pending', 22),
(23, 23, 'Disability Certificate', '2026-02-04', 'Pending', 23),
(24, 24, 'Death Certificate', '2026-02-17', 'Verified', 24),
(25, 25, 'Medical Report', '2026-03-03', 'Pending', 25);

INSERT INTO Claim_Assessments
(assessment_id, claim_id, assessor_employee_id, assessment_date, approved_amount, assessment_result, remarks)
VALUES
(1, 1, 1, '2025-02-15', 1000000.00, 'Approved', 'All documents verified.'),
(2, 2, 2, '2025-03-20', 1500000.00, 'Approved', 'Accident documents verified.'),
(3, 3, 3, '2025-04-20', 250000.00, 'Under Review', 'Medical documents under review.'),
(4, 4, 4, '2025-05-12', 450000.00, 'Approved', 'Disability claim approved.'),
(5, 5, 5, '2025-05-28', 2000000.00, 'Approved', 'Death claim verified.'),
(6, 6, 6, '2025-06-15', 300000.00, 'Under Review', 'Additional medical report required.'),
(7, 7, 7, '2025-07-01', 1800000.00, 'Approved', 'Policy benefits verified.'),
(8, 8, 8, '2025-07-18', 900000.00, 'Pending', 'Verification pending.'),
(9, 9, 9, '2025-07-30', 1500000.00, 'Approved', 'Accident claim approved.'),
(10, 10, 10, '2025-08-12', 400000.00, 'Under Review', 'Medical assessment ongoing.'),
(11, 11, 11, '2025-08-25', 2000000.00, 'Approved', 'Death certificate verified.'),
(12, 12, 12, '2025-09-10', 500000.00, 'Pending', 'Disability documents pending.'),
(13, 13, 13, '2025-09-22', 700000.00, 'Approved', 'Maturity benefit verified.'),
(14, 14, 14, '2025-10-05', 1600000.00, 'Approved', 'All required documents verified.'),
(15, 15, 15, '2025-10-18', 400000.00, 'Under Review', 'Medical assessment ongoing.'),
(16, 16, 16, '2025-10-30', 700000.00, 'Pending', 'Medical documents pending.'),
(17, 17, 17, '2025-11-12', 1000000.00, 'Approved', 'Survival benefit approved.'),
(18, 18, 18, '2025-11-25', 400000.00, 'Approved', 'Medical documents verified.'),
(19, 19, 19, '2025-12-08', 500000.00, 'Under Review', 'Accident report under review.'),
(20, 20, 20, '2025-12-22', 1500000.00, 'Approved', 'Death claim approved.'),
(21, 21, 21, '2026-01-12', 1800000.00, 'Approved', 'Death certificate verified.'),
(22, 22, 22, '2026-01-25', 800000.00, 'Pending', 'Maturity documents pending.'),
(23, 23, 23, '2026-02-10', 600000.00, 'Under Review', 'Disability assessment ongoing.'),
(24, 24, 24, '2026-02-22', 2500000.00, 'Approved', 'Death claim verified.'),
(25, 25, 25, '2026-03-08', 400000.00, 'Pending', 'Medical documents pending.');

INSERT INTO Claim_Payments
(claim_payment_id, claim_id, payment_date, payment_amount, payment_method_id, payment_status, transaction_reference)
VALUES
(1, 1, '2025-02-18', 1000000.00, 6, 'Paid', 'CPAY100001'),
(2, 2, '2025-03-23', 1500000.00, 5, 'Paid', 'CPAY100002'),
(3, 3, NULL, 0.00, 3, 'Pending', 'CPAY100003'),
(4, 4, '2025-05-15', 450000.00, 7, 'Paid', 'CPAY100004'),
(5, 5, '2025-06-01', 2000000.00, 10, 'Paid', 'CPAY100005'),
(6, 6, NULL, 0.00, 4, 'Pending', 'CPAY100006'),
(7, 7, '2025-07-05', 1800000.00, 6, 'Paid', 'CPAY100007'),
(8, 8, NULL, 0.00, 9, 'Pending', 'CPAY100008'),
(9, 9, '2025-08-03', 1500000.00, 5, 'Paid', 'CPAY100009'),
(10, 10, NULL, 0.00, 3, 'Pending', 'CPAY100010'),
(11, 11, '2025-08-30', 2000000.00, 6, 'Paid', 'CPAY100011'),
(12, 12, NULL, 0.00, 4, 'Pending', 'CPAY100012'),
(13, 13, '2025-09-25', 700000.00, 7, 'Paid', 'CPAY100013'),
(14, 14, '2025-10-08', 1600000.00, 10, 'Paid', 'CPAY100014'),
(15, 15, NULL, 0.00, 6, 'Pending', 'CPAY100015'),
(16, 16, NULL, 0.00, 5, 'Pending', 'CPAY100016'),
(17, 17, '2025-11-15', 1000000.00, 9, 'Paid', 'CPAY100017'),
(18, 18, '2025-11-28', 400000.00, 6, 'Paid', 'CPAY100018'),
(19, 19, NULL, 0.00, 3, 'Pending', 'CPAY100019'),
(20, 20, '2025-12-25', 1500000.00, 10, 'Paid', 'CPAY100020'),
(21, 21, '2026-01-15', 1800000.00, 6, 'Paid', 'CPAY100021'),
(22, 22, NULL, 0.00, 4, 'Pending', 'CPAY100022'),
(23, 23, NULL, 0.00, 7, 'Pending', 'CPAY100023'),
(24, 24, '2026-02-25', 2500000.00, 5, 'Paid', 'CPAY100024'),
(25, 25, NULL, 0.00, 3, 'Pending', 'CPAY100025');

INSERT INTO Medical_Examinations
(examination_id, customer_id, policy_id, examination_date, medical_center, bmi, smoker_status, medical_risk, result)
VALUES
(1, 1, 1, '2024-01-12', 'Apollo Medical Center', 22.50, 'Non-Smoker', 'Low', 'Normal'),
(2, 2, 2, '2024-02-14', 'City Care Hospital', 24.10, 'Non-Smoker', 'Low', 'Normal'),
(3, 3, 3, '2024-03-08', 'LifeCare Clinic', 26.30, 'Smoker', 'Medium', 'Normal'),
(4, 4, 4, '2024-03-19', 'Apollo Medical Center', 23.40, 'Non-Smoker', 'Low', 'Normal'),
(5, 5, 5, '2024-04-09', 'Health Plus Hospital', 27.10, 'Smoker', 'Medium', 'Normal'),
(6, 6, 6, '2024-04-23', 'City Care Hospital', 25.60, 'Non-Smoker', 'Low', 'Normal'),
(7, 7, 7, '2024-05-13', 'LifeCare Clinic', 29.20, 'Smoker', 'High', 'Review'),
(8, 8, 8, '2024-05-24', 'Apollo Medical Center', 21.80, 'Non-Smoker', 'Low', 'Normal'),
(9, 9, 9, '2024-06-04', 'Health Plus Hospital', 24.90, 'Non-Smoker', 'Low', 'Normal'),
(10, 10, 10, '2024-06-18', 'City Care Hospital', 28.40, 'Smoker', 'Medium', 'Review'),
(11, 11, 11, '2024-07-04', 'Apollo Medical Center', 26.70, 'Non-Smoker', 'Medium', 'Normal'),
(12, 12, 12, '2024-07-17', 'LifeCare Clinic', 23.60, 'Non-Smoker', 'Low', 'Normal'),
(13, 13, 13, '2024-08-09', 'Health Plus Hospital', 30.10, 'Smoker', 'High', 'Review'),
(14, 14, 14, '2024-08-24', 'Apollo Medical Center', 25.20, 'Non-Smoker', 'Low', 'Normal'),
(15, 15, 15, '2024-09-04', 'City Care Hospital', 27.80, 'Non-Smoker', 'Medium', 'Normal'),
(16, 16, 16, '2024-09-19', 'LifeCare Clinic', 22.90, 'Non-Smoker', 'Low', 'Normal'),
(17, 17, 17, '2024-10-04', 'Health Plus Hospital', 31.20, 'Smoker', 'High', 'Review'),
(18, 18, 18, '2024-10-14', 'Apollo Medical Center', 24.50, 'Non-Smoker', 'Low', 'Normal'),
(19, 19, 19, '2024-10-29', 'City Care Hospital', 26.90, 'Smoker', 'Medium', 'Review'),
(20, 20, 20, '2024-11-09', 'LifeCare Clinic', 23.80, 'Non-Smoker', 'Low', 'Normal'),
(21, 21, 21, '2024-11-19', 'Apollo Medical Center', 28.70, 'Smoker', 'Medium', 'Normal'),
(22, 22, 22, '2024-12-04', 'Health Plus Hospital', 25.40, 'Non-Smoker', 'Low', 'Normal'),
(23, 23, 23, '2024-12-14', 'City Care Hospital', 29.80, 'Smoker', 'High', 'Review'),
(24, 24, 24, '2025-01-09', 'LifeCare Clinic', 22.30, 'Non-Smoker', 'Low', 'Normal'),
(25, 25, 25, '2025-01-19', 'Apollo Medical Center', 27.50, 'Non-Smoker', 'Medium', 'Normal');

INSERT INTO Underwriting
(underwriting_id, policy_id, underwriter_employee_id, assessment_date, risk_score, risk_category, decision, loading_percent, remarks)
VALUES
(1, 1, 7, '2024-01-14', 20, 'Low', 'Approved', 0.00, 'Low risk applicant.'),
(2, 2, 11, '2024-02-14', 25, 'Low', 'Approved', 0.00, 'Good health profile.'),
(3, 3, 17, '2024-03-09', 45, 'Medium', 'Approved', 10.00, 'Smoking risk considered.'),
(4, 4, 23, '2024-03-19', 18, 'Low', 'Approved', 0.00, 'Normal medical results.'),
(5, 5, 7, '2024-04-09', 42, 'Medium', 'Approved', 8.00, 'Moderate health risk.'),
(6, 6, 11, '2024-04-24', 22, 'Low', 'Approved', 0.00, 'Low medical risk.'),
(7, 7, 17, '2024-05-14', 70, 'High', 'Approved', 20.00, 'High risk due to smoking.'),
(8, 8, 23, '2024-05-24', 15, 'Low', 'Approved', 0.00, 'Healthy applicant.'),
(9, 9, 7, '2024-06-04', 24, 'Low', 'Approved', 0.00, 'Low risk profile.'),
(10, 10, 11, '2024-06-19', 50, 'Medium', 'Approved', 12.00, 'Additional risk loading applied.'),
(11, 11, 17, '2024-07-04', 38, 'Medium', 'Approved', 7.00, 'Moderate risk profile.'),
(12, 12, 23, '2024-07-17', 19, 'Low', 'Approved', 0.00, 'Normal health condition.'),
(13, 13, 7, '2024-08-09', 75, 'High', 'Approved', 25.00, 'High medical risk.'),
(14, 14, 11, '2024-08-24', 21, 'Low', 'Approved', 0.00, 'Low risk applicant.'),
(15, 15, 17, '2024-09-04', 40, 'Medium', 'Approved', 8.00, 'Moderate risk identified.'),
(16, 16, 23, '2024-09-19', 17, 'Low', 'Approved', 0.00, 'Healthy applicant.'),
(17, 17, 7, '2024-10-04', 78, 'High', 'Approved', 25.00, 'High risk due to smoking.'),
(18, 18, 11, '2024-10-14', 23, 'Low', 'Approved', 0.00, 'Low medical risk.'),
(19, 19, 17, '2024-10-29', 48, 'Medium', 'Approved', 10.00, 'Moderate health risk.'),
(20, 20, 23, '2024-11-09', 20, 'Low', 'Approved', 0.00, 'Normal medical results.'),
(21, 21, 7, '2024-11-19', 46, 'Medium', 'Approved', 10.00, 'Moderate risk profile.'),
(22, 22, 11, '2024-12-04', 26, 'Low', 'Approved', 0.00, 'Low health risk.'),
(23, 23, 17, '2024-12-14', 72, 'High', 'Approved', 20.00, 'High medical risk.'),
(24, 24, 23, '2025-01-09', 16, 'Low', 'Approved', 0.00, 'Healthy applicant.'),
(25, 25, 7, '2025-01-19', 43, 'Medium', 'Approved', 8.00, 'Moderate health risk.');

INSERT INTO Beneficiaries (beneficiary_id,policy_id,beneficiary_name,relationship,date_of_birth,
share_percent,contact_number) 
VALUES
(1, 1, 'Kavya Sharma', 'Wife', '1992-03-15', 100.00, '9876510001'),
(2, 2, 'Ramesh Patil', 'Father', '1965-07-20', 100.00, '9876510002'),
(3, 3, 'Anita Joshi', 'Wife', '1990-05-11', 100.00, '9876510003'),
(4, 4, 'Amit Deshmukh', 'Husband', '1993-02-18', 100.00, '9876510004'),
(5, 5, 'Snehal Kulkarni', 'Wife', '1989-09-25', 100.00, '9876510005'),
(6, 6, 'Raj Jadhav', 'Husband', '1991-06-14', 100.00, '9876510006'),
(7, 7, 'Pooja Pawar', 'Wife', '1987-12-05', 100.00, '9876510007'),
(8, 8, 'Neeraj Verma', 'Father', '1968-04-22', 100.00, '9876510008'),
(9, 9, 'Meera Rao', 'Wife', '1993-08-17', 100.00, '9876510009'),
(10, 10, 'Vijay Kumar', 'Husband', '1988-11-10', 100.00, '9876510010'),
(11, 11, 'Lakshmi Reddy', 'Wife', '1989-01-26', 100.00, '9876510011'),
(12, 12, 'Mahesh Shah', 'Father', '1966-09-18', 100.00, '9876510012'),
(13, 13, 'Rina Mehta', 'Wife', '1986-03-12', 100.00, '9876510013'),
(14, 14, 'Raj Singh', 'Husband', '1985-07-30', 100.00, '9876510014'),
(15, 15, 'Neha Jain', 'Sister', '1994-10-08', 100.00, '9876510015'),
(16, 16, 'Amit Gupta', 'Husband', '1991-02-16', 100.00, '9876510016'),
(17, 17, 'Madhuri Roy', 'Wife', '1987-06-21', 100.00, '9876510017'),
(18, 18, 'Suresh Mishra', 'Father', '1965-12-14', 100.00, '9876510018'),
(19, 19, 'Gurmeet Singh', 'Husband', '1986-05-19', 100.00, '9876510019'),
(20, 20, 'Sunita Kumar', 'Wife', '1992-09-07', 100.00, '9876510020'),
(21, 21, 'Anjali Naik', 'Sister', '1991-04-25', 100.00, '9876510021'),
(22, 22, 'Mohan Nair', 'Husband', '1989-11-16', 100.00, '9876510022'),
(23, 23, 'Sushma Das', 'Wife', '1987-08-13', 100.00, '9876510023'),
(24, 24, 'Arjun Raj', 'Brother', '1993-01-29', 100.00, '9876510024'),
(25, 25, 'Priya Kumar', 'Wife', '1985-06-17', 100.00, '9876510025');

INSERT INTO Policy_Status_History
(history_id, policy_id, old_status, new_status, changed_date, changed_by, change_reason)
VALUES
(1, 1, 'Pending', 'Active', '2024-01-15', 1, 'Policy issued'),
(2, 2, 'Pending', 'Active', '2024-02-15', 2, 'Policy issued'),
(3, 3, 'Pending', 'Active', '2024-03-10', 3, 'Policy issued'),
(4, 4, 'Pending', 'Active', '2024-03-20', 4, 'Policy issued'),
(5, 5, 'Pending', 'Active', '2024-04-10',5,'Policy issued'),
(6, 6, 'Pending', 'Active', '2024-04-25',6,'Policy issued'),
(7, 7, 'Pending', 'Active', '2024-05-15',7,'Policy issued'),
(8, 8, 'Pending', 'Active', '2024-05-25',8,'Policy issued'),
(9, 9, 'Pending', 'Active', '2024-06-05',9,'Policy issued'),
(10, 10, 'Pending', 'Active', '2024-06-20', 10, 'Policy issued'),
(11, 11, 'Pending', 'Active', '2024-07-05', 11, 'Policy issued'),
(12, 12, 'Pending', 'Active', '2024-07-18', 12, 'Policy issued'),
(13, 13, 'Pending', 'Active', '2024-08-10', 13, 'Policy issued'),
(14, 14, 'Pending', 'Active', '2024-08-25', 14, 'Policy issued'),
(15, 15, 'Pending', 'Active', '2024-09-05', 15, 'Policy issued'),
(16, 16, 'Pending', 'Active', '2024-09-20', 16, 'Policy issued'),
(17, 17, 'Pending', 'Active', '2024-10-05', 17, 'Policy issued'),
(18, 18, 'Pending', 'Active', '2024-10-15', 18, 'Policy issued'),
(19, 19, 'Pending', 'Active', '2024-10-30', 19, 'Policy issued'),
(20, 20, 'Pending', 'Active', '2024-11-10', 20, 'Policy issued'),
(21, 21, 'Pending', 'Active', '2024-11-20', 21, 'Policy issued'),
(22, 22, 'Pending', 'Active', '2024-12-05', 22, 'Policy issued'),
(23, 23, 'Pending', 'Active', '2024-12-15', 23, 'Policy issued'),
(24, 24, 'Pending', 'Active', '2025-01-10', 24, 'Policy issued'),
(25, 25, 'Pending', 'Active', '2025-01-20', 25, 'Policy issued');

DELETE FROM Policy_Status_History;

SELECT * FROM Policy_Status_History;

--- STORED PROCEDURE QUERIES ---

--- TO GET CUSTOMER DETAILS ---
GO
CREATE PROCEDURE Getcustomerdetails
@customer_id INT
AS
BEGIN
   SELECT * FROM customers
   WHERE customer_id = @customer_id
END;

EXEC Getcustomerdetails 4;

--- GET POLICIES OF A CUSTOMER ---
GO
CREATE PROCEDURE Getpolicies
@customer_id INT 
AS
BEGIN
   SELECT 
       policy_id,
       policy_number,
       sum_assured,
       premium_amount,
       premium_frequency,
       policy_term_years,
       status
    FROM Policies
    WHERE customer_id = @customer_id
END;

EXEC Getpolicies 4;

---- FIND ACTIVE POLICIES ---
GO
CREATE PROCEDURE Getactivepolicies
AS
BEGIN
   SELECT
       policy_id,
       policy_number,
       sum_assured,
       premium_amount,
       premium_frequency,
       policy_term_years,
       status
    FROM Policies
    WHERE status = 'active'
END;

EXEC Getactivepolicies;

--- GET PREMIUM PAYMENT DETAILS ---
GO
CREATE PROCEDURE Getpremiumpaymentdetails
@policy_id INT
AS 
BEGIN
   SELECT
       payment_id,
       policy_id,
       payment_method_id,
       due_date,
       payment_date,
       amount_paid,
       payment_status,
       transaction_reference
    FROM Premium_Payments
END;

EXEC Getpremiumpaymentdetails 4;

---- CUSTOMER POLICY SUMMARY ---
GO
CREATE PROCEDURE Getcustomerpolicy
@customer_id INT
AS
BEGIN
   SELECT 
       c.customer_id,
       c.customer_name,
       p.policy_number,
       p.sum_assured,
       p.premium_amount,
       p.premium_frequency,
       p.policy_term_years
    FROM
       customers c
       INNER JOIN Policies p
       ON c.customer_id = p.customer_id
       WHERE c.customer_id = @customer_id
END;

EXEC Getcustomerpolicy 4;

--- CALCULATE TOTAL PREMIUM PAID ---
GO
CREATE PROCEDURE Totalpremiumpaid
@policy_id INT
AS
BEGIN
   SELECT
       policy_id,
       SUM(amount_paid) AS Total_premium_paid
   FROM Premium_Payments
   WHERE policy_id = @policy_id
   AND payment_status = 'paid'
   GROUP BY policy_id
END;

EXEC Totalpremiumpaid 6;

---  ALL CUSTOMER , POLICY AND AGENT DETAILS ---
GO
CREATE PROCEDURE Getcustomerpolicyagentdetails
AS
BEGIN
   SELECT
      c.customer_id,
      c.customer_name,
      p.policy_number,
      p.sum_assured,
      p.premium_amount,
      p.status AS policy_status,
      a.agent_name,
      a.commission_rate
   FROM customers c
        INNER JOIN Policies p
        ON c.customer_id = p.customer_id
        INNER JOIN Agents a 
        ON p.agent_id = a.agent_id

END;

EXEC Getcustomerpolicyagentdetails;

--- CLAIM DETAILS WITH APPROVED AMOUNT ----
GO
CREATE PROCEDURE Getclaimdetails
@claim_id INT
AS
BEGIN
   SELECT
      c.claim_id,
      c.claim_number,
      c.claimed_amount,
      c.claim_status,
      ct.claim_type_name,
      ca.approved_amount,
      ca.assessment_result,
      ca.remarks
    FROM Claims c
    INNER JOIN Claim_Types ct
    ON c.claim_type_id = ct.claim_type_id
    LEFT JOIN Claim_Assessments ca
    ON c.claim_id = ca.claim_id
    WHERE c.claim_id = @claim_id
END;

EXEC Getclaimdetails 7;

--- POLICY PREMIUM & PAYMENT DETAILS ---
GO 
CREATE PROCEDURE GetPolicyPremiumPayment
AS
BEGIN
    SELECT 
        p.policy_id,
        p.policy_number,
        p.premium_amount,
        pm.amount_paid,
        pm.payment_date,
        pm.payment_status,
        pmt.method_name
    FROM Policies p
    LEFT JOIN Premium_Payments pm
    ON p.policy_id = pm.policy_id
    LEFT JOIN Payment_Methods pmt
    ON pm.payment_method_id = pmt.payment_method_id;
END;

EXEC GetPolicyPremiumPayment;

--- CLAIM PAYMENT DETAILS ---
GO 
CREATE PROCEDURE Getclaimpaymentdetails
AS
BEGIN
   SELECT 
       c.claim_id,
       c.claim_number,
       c.claimed_amount,
       c.claim_status,
       cp.payment_date,
       cp.payment_amount,
       cp.payment_status,
       pm.method_name
    FROM Claims c
    INNER JOIN Claim_Payments cp
    ON c.claim_id = cp.claim_id
    INNER JOIN Payment_Methods pm
    ON cp.payment_method_id = pm.payment_method_id
END;

EXEC Getclaimpaymentdetails;



















