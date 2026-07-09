create database customer_churn;
use customer_churn;
CREATE TABLE customer_churn (
    customerID VARCHAR(20),
    gender VARCHAR(10),
    SeniorCitizen INT,
    Partner VARCHAR(5),
    Dependents VARCHAR(5),
    tenure INT,
    PhoneService VARCHAR(5),
    MultipleLines VARCHAR(30),
    InternetService VARCHAR(30),
    OnlineSecurity VARCHAR(30),
    OnlineBackup VARCHAR(30),
    DeviceProtection VARCHAR(30),
    TechSupport VARCHAR(30),
    StreamingTV VARCHAR(30),
    StreamingMovies VARCHAR(30),
    Contract VARCHAR(30),
    PaperlessBilling VARCHAR(5),
    PaymentMethod VARCHAR(50),
    MonthlyCharges DECIMAL(10,2),
    TotalCharges DECIMAL(10,2),
    Churn VARCHAR(5)
);


-- -------------------------------------------------------------------------
-- Total customers
select count(*)as Total_customers
from customer_churn;
-- Total churned customers
select count(*) as churned_cust
from customer_churn
where churn="No";
-- Churn percentage
select round(sum(case when churn='Yes' then 1 else 0 end) *100/count(*)) as churn__percentage
from customer_churn;

-- gender wise churn
select gender,count(*) as customers, sum(churn="Yes") as churned_customers from customer_churn
group by Gender;

-- senior citizen churn
select SeniorCitizen,count(*) as customers, sum(churn="Yes") as churned_customers from customer_churn
group by SeniorCitizen;

-- Contract- wise churn
select Contract,count(*) as customers, sum(churn="Yes") as churned_customers from customer_churn
group by Contract;

-- payment method-wise churn
select paymentMethod,count(*) as customers, sum(churn="Yes") as churned_customers from customer_churn
group by paymentMethod;

-- Internet service-wise churn
select InternetService,count(*) as customers, sum(churn="Yes") as churned_customers from customer_churn
group by InternetService;


-- Average tenure by churn
select churn,avg(tenure) as avg_ten  from customer_churn
group by Churn;

-- Average Total charges by churn
select churn,avg(TotalCharges) as Average_Total_charges
from customer_churn
group by churn;

-- Top 10 highest paying customers
select customerID,TotalCharges from customer_churn
order by TotalCharges desc
limit 10;

-- contract wise revenue
select contract , sum(TotalCharges) as total_revenue
from customer_churn
group by contract;

-- Payment Method Revenue
select PaymentMethod , sum(TotalCharges) as total_revenue
from customer_churn
group by PaymentMethod;

-- top 5 customers by total charges(Row number)
select customerID,TotalCharges,row_number() over (order by TotalCharges desc) as row_num
from customer_churn
limit 5;

-- Rank customers by Total charges(Rank)
select customerID,TotalCharges,rank() over (order by TotalCharges desc) as customer_rank
from customer_churn
limit 5;

-- Dense rank by cusotmers
select customerID,TotalCharges,rank() over (order by TotalCharges desc) as customer_rank
from customer_churn
limit 5;

-- Highest paying customer in each contract
select * from (select customerID,Contract,TotalCharges, Rank() over(partition by contract order by TotalCharges desc) as rnk from customer_churn) t where rnk=1;

-- Average monthly charges greater than overall averages
select * from customer_churn where MonthlyCharges>(select avg(MonthlyCharges) from customer_churn);

-- customer with above average tenure
select * from customer_churn where tenure > (select avg(tenure) from customer_churn);

-- common table expression
with churn_summary as (
select contract, count(*) as customers, sum(churn='Yes') as churned from customer_churn group by contract) 
select * from churn_summary;

-- create view
create view churn_view as
 select customerID,contract,MonthlyCharges,TotalCharges,churn from customer_churn;
select * from customer_churn
where tenure between 10 and 20;

-- Highest revenue contract
select Contract,sum(TotalCharges) as Revenue
from customer_churn
group by Contract
order by Revenue desc;

-- churn percentage by contract
select Contract,round(sum(case when churn="Yes" then 1 else 0 end) *100/count(*),2) as churn_percentage
from customer_churn 
group by Contract;

-- internet service with highest revenue
select InternetService ,sum(TotalCharges) as Revenue
from customer_churn
group by InternetService
order by Revenue desc;

-- customer paying more than 100 per month
select customerID,MonthlyCharges 
from customer_churn 
where MonthlyCharges >100;

-- Long term customers 
select customerID,tenure from customer_churn
where tenure >60;

-- top 10 highest revenue customers;
select customerID,TotalCharges from customer_churn order by TotalCharges desc limit 10;












