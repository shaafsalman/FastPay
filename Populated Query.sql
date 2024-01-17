
CREATE TABLE Users (
  UserId INT PRIMARY KEY,
  FirstName VARCHAR(50),
  LastName VARCHAR(50),
  Email VARCHAR(100),
  PhoneNumber VARCHAR(20),
  Password VARCHAR(100),
  UserPicture varbinary(MAX),
  Address VARCHAR(100),
  City VARCHAR(50),
  State VARCHAR(50),
  ZipCode VARCHAR(10)

);

CREATE TABLE Accounts
(
  AccountId INT PRIMARY KEY,
  UserId INT,
  Balance DECIMAL(10, 2),
  TransactionLimit DECIMAL(10, 2),
  AccountType VARCHAR(50),
  AccountNumber VARCHAR(20),
  Pin VARCHAR(4),
  FOREIGN KEY (UserId) REFERENCES Users(UserId)
);

CREATE TABLE Transactions (
  TransactionId INT PRIMARY KEY,
  AccountId INT,
  RecipientAccount_id INT,
  Amount DECIMAL(10, 2),
  TransactionDate DATE,
  Reason VARCHAR(100),
  FOREIGN KEY (AccountId) REFERENCES Accounts(AccountId)
);


CREATE TABLE Cards (
  CardId INT PRIMARY KEY,
  UserId INT,
  CardType VARCHAR(20),
  Distributor VARCHAR(20),
  IsActive BIT,
  CardNumber VARCHAR(20),
  ExpirationDate DATE,
  CVC VARCHAR(3),
  FOREIGN KEY (UserId) REFERENCES Users(UserId)
);

CREATE TABLE Beneficiaries (
  BeneficiaryId INT PRIMARY KEY,
  AccountId INT,
  Name VARCHAR(50),
  AccountNumber VARCHAR(20),
  Relationship VARCHAR(50),
  FOREIGN KEY (AccountId) REFERENCES Accounts(AccountId)
);

CREATE TABLE Admins (
  AdminId INT PRIMARY KEY,
  Username VARCHAR(50),
  Password VARCHAR(50),
);


CREATE TABLE Subscriptions (
  SubscriptionId INT PRIMARY KEY,
  Name VARCHAR(50),
  Description VARCHAR(100),
  RecurringAmount DECIMAL(10, 2),
  StartDate DATE,
  EndDate DATE
);

CREATE TABLE Billing (
  BillingId INT PRIMARY KEY,
  UserId INT,
  BillerName VARCHAR(50),
  AccountNumber VARCHAR(20),
  PaymentAmount DECIMAL(10, 2),
  DueDate DATE,
  FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Then, create the new UserSubscriptions and UserBilling tables
CREATE TABLE UserSubscriptions (
  UserSubscriptionId INT PRIMARY KEY,
  UserId INT,
  SubscriptionId INT,
  FOREIGN KEY (UserId) REFERENCES Users(UserId),
  FOREIGN KEY (SubscriptionId) REFERENCES Subscriptions(SubscriptionId)
);

CREATE TABLE UserBilling (

  UserBillingId INT PRIMARY KEY,
  BillingId INT,
  UserId INT,
  FOREIGN KEY (UserId) REFERENCES Users(UserId),
  FOREIGN KEY (BillingId) REFERENCES Billing(BillingId)
);


-- Users Table
INSERT INTO Users (UserId, FirstName, LastName, Email, PhoneNumber, Password, Address, City, State, ZipCode)
VALUES
(1, 'Jawad', 'Shahid', 'jawad.shahid@example.com', '+923331234567', '1122', 'House 1, Street 2', 'Karachi', 'Sindh', '75500'),
(2, 'Rumaisa', 'Qadeer', 'rumaisa.qadeer@example.com', '+923332345678', '1122', 'House 10, Street 5', 'Lahore', 'Punjab', '54000'),
(3, 'Shaaf', 'Salman', 'shaaf.salman@example.com', '+923333456789', '1122', 'House 20, Street 10', 'Islamabad', 'ICT', '44000'),
(4, 'Haider', 'Khan', 'haider.khan@example.com', '+923334567890', '1122', 'House 30, Street 15', 'Peshawar', 'KPK', '25000'),
(5, 'Abdul', 'Hadi', 'abdul.hadi@example.com', '+923335678901', '1122', 'House 40, Street 20', 'Quetta', 'Balochistan', '87300'),
(6, 'Farhan', 'Jaffri', 'farhan.jaffri@example.com', '+923336789012', '1122', 'House 50, Street 25', 'Faisalabad', 'Punjab', '38000'),
(7, 'Zoya', 'Arif', 'zoya.arif@example.com', '+923337890123', '1122', 'House 60, Street 30', 'Multan', 'Punjab', '60000'),
(8, 'Sadia', 'Saleem', 'sadia.saleem@example.com', '+923338901234', '1122', 'House 70, Street 35', 'Gujranwala', 'Punjab', '52250'),
(9, 'Laiba', 'Habib', 'laiba.habib@example.com', '+923339012345', '1122', 'House 80, Street 40', 'Rawalpindi', 'Punjab', '46000');

-- Accounts Table
INSERT INTO Accounts (AccountId, UserId, Balance, TransactionLimit, AccountType, AccountNumber, Pin)
VALUES
(1, 1, 50000, 1000000, 'Savings', '1111222233334444', '1234'),
(2, 2, 60000, 1000000, 'Savings', '2222333344445555', '2345'),
(3, 3, 70000, 1000000, 'Savings', '3333444455556666', '3456'),
(4, 4, 80000, 1000000, 'Savings', '4444555566667777', '4567'),
(5, 5, 90000, 1000000, 'Savings', '5555666677778888', '5678'),
(6, 6, 100000, 1000000, 'Savings', '6666777788889999', '6789'),
(7, 7, 110000, 1000000, 'Savings', '7777888899990000', '7890'),
(9, 9, 130000, 1000000, 'Savings', '9999000011112222', '9012');

-- Transactions Table
INSERT INTO Transactions (TransactionId, AccountId, RecipientAccount_id, Amount, TransactionDate, Reason)
VALUES
(1, 1, 2, 5000, '2023-04-10', 'Birthday gift'),
(2, 2, 3, 3000, '2023-04-11', 'Utility bill'),
(3, 3, 4, 4000, '2023-04-12', 'Groceries'),
(4, 4, 5, 2000, '2023-04-13', 'Dinner with friends'),
(5, 5, 6, 1000, '2023-04-14', 'Mobile top-up');


-- Cards Table
INSERT INTO Cards (CardId, UserId, CardType, Distributor, IsActive, CardNumber, ExpirationDate, CVC)
VALUES
(1, 1, 'Debit', 'Visa', 1, '4111111122223333', '2025-12-31', '123'),
(2, 2, 'Debit', 'Mastercard', 1, '5500001122334455', '2025-10-31', '234'),
(3, 3, 'Debit', 'Visa', 1, '4111111166667777', '2024-09-30', '345');

-- Beneficiaries Table
INSERT INTO Beneficiaries (BeneficiaryId, AccountId, Name, AccountNumber, Relationship)
VALUES
(1, 1, 'Rumaisa Qadeer', '2222333344445555', 'Friend'),
(2, 2, 'Shaaf Salman', '3333444455556666', 'Relative'),
(3, 3, 'Haider Khan', '4444555566667777', 'Colleague');

-- Admins Table
INSERT INTO Admins (AdminId, Username, Password)
VALUES
(1, 'Admin1', '1122'),
(2, 'Admin2', '1122');




use FastPay
-- Transactions Table
INSERT INTO Transactions (TransactionId, AccountId, RecipientAccount_id, Amount, TransactionDate, Reason)
VALUES

(16, 3, 3, 2000, '2023-03-15', 'Transfer to friend'),
(17, 3, 5, 5000, '2023-02-16', 'Shopping spree'),
(18, 3, 6, 10000, '2023-01-17', 'Monthly savings'),
(19, 3, 1, 4000, '2023-06-18', 'Loan repayment'),
(20, 3, 2, 1500, '2023-08-19', 'Charitable donation'),
(21, 3, 4, 8000, '2023-05-20', 'Travel expenses'),
(22, 3, 7, 1000, '2023-03-21', 'Gift for family'),
(23, 3, 4, 6000, '2023-02-22', 'Family dinner'),
(24, 3, 2, 3000, '2023-01-23', 'Home repairs'),
(25, 3, 9, 2000, '2023-09-24', 'Clothing shopping');



-- Subscriptions Table
INSERT INTO Subscriptions (SubscriptionId, Name, Description, RecurringAmount, StartDate, EndDate)
VALUES
(1, 'Netflix', 'Monthly subscription for Netflix', 15, '2022-12-01', '2023-11-30'),
(2, 'Amazon Prime', 'Yearly subscription for Amazon Prime', 120, '2022-06-01', '2023-05-31'),
(3, 'Spotify', 'Monthly subscription for Spotify', 10, '2022-09-01', '2023-08-31'),
(4, 'Hulu', 'Monthly subscription for Hulu', 20, '2022-11-01', '2023-10-31');

-- Bills Table
INSERT INTO Billing (BillingId, BillerName, AccountNumber, PaymentAmount, DueDate)
VALUES
(1, 'PTCL', '1111222233334444', 200, '2023-04-20'),
(2, 'Sui Gas', '2222333344445555', 300, '2023-04-25'),
(3, 'WAPDA', '3333444455556666', 400, '2023-04-30'),
(4, 'Zong', '4444555566667777', 150, '2023-05-05');

-- UserSubscriptions Table
INSERT INTO UserSubscriptions (UserSubscriptionId, UserId, SubscriptionId)
VALUES
(1, 1, 1),
(2, 1, 2),
(3, 2, 1),
(4, 2, 3),
(5, 3, 4),
(6, 3, 2),
(7, 4, 1),
(8, 4, 3),
(9, 5, 4),
(10, 6, 2);

-- UserBills Table
INSERT INTO UserBilling (UserBillingId,UserId, BillingId)
VALUES
(1,1,1),
(2,1,2),
(3,1,3),
(4,1,4),

(5,2,1),
(6,2,2),
(7,2,3),
(8,2,4),

(9,3,1),
(10,3,2),
(11,3,3),
(12,3,4);
