
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

CREATE TABLE UserSubscriptions (
  UserSubscriptionId INT,
  UserId INT,
  SubscriptionId INT,
  RenewalDate DATE,
  PRIMARY KEY (UserSubscriptionId, UserId, SubscriptionId),
  FOREIGN KEY (UserId) REFERENCES Users(UserId),
  FOREIGN KEY (SubscriptionId) REFERENCES Subscriptions(SubscriptionId)
);




CREATE TABLE Billing (
  BillingId INT PRIMARY KEY,
  BillerName VARCHAR(50),
  BillerCategory VARCHAR(50),
  BillerAddress VARCHAR(100),
  BillerCity VARCHAR(50),
  BillerState VARCHAR(50),
  BillerZipCode VARCHAR(10),
  AccountNumber VARCHAR(20)
);
CREATE TABLE BillPayments (
  BillPaymentId INT PRIMARY KEY,
  UserId INT,
  BillingId INT,
  PaymentAmount DECIMAL(10, 2),
  PaymentDate DATE,
  DueDate DATE,
  PaymentStatus VARCHAR(50),
  FOREIGN KEY (UserId) REFERENCES Users(UserId),
  FOREIGN KEY (BillingId) REFERENCES Billing(BillingId)
);

CREATE TABLE UserBiller (
  UserBillerId INT PRIMARY KEY,
  UserId INT,
  BillingId INT,
  CustomBillerName VARCHAR(50),
  CustomAccountNumber VARCHAR(20),
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


-- Subscriptions Table
INSERT INTO Subscriptions (SubscriptionId, UserId, Name, Description, RecurringAmount, StartDate, EndDate)
VALUES
(1, 1, 'Netflix', 'Monthly subscription for Netflix', 950, '2023-04-01', '2023-05-01'),
(2, 2, 'Spotify', 'Monthly subscription for Spotify Premium', 500, '2023-04-15', '2023-05-15');

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
(2, 1, 'Shaaf Salman', '3333444455556666', 'Friend'),
(3, 1, 'Haider Khan', '4444555566667777', 'Friend'),

(4, 2, 'Jawad Shahid', '1111222233334444', 'Friend'),
(5, 2, 'Shaaf Salman', '3333444455556666', 'Friend'),
(6, 2, 'Haider Khan', '4444555566667777', 'Friend'),

(7, 3, 'Jawad Shahid', '1111222233334444', 'Friend'),
(8, 3, 'Rumaisa Qadeer', '2222333344445555', 'Friend'),
(9, 3, 'Haider Khan', '4444555566667777', 'Friend'),

(10, 4, 'Jawad Shahid', '1111222233334444', 'Friend'),
(11, 4, 'Rumaisa Qadeer', '2222333344445555', 'Friend'),
(12, 4, 'Shaaf Salman', '3333444455556666', 'Friend');


-- Admins Table
INSERT INTO Admins (AdminId, Username, Password)
VALUES
(1, 'Admin1', '1122'),
(2, 'Admin2', '1122');


INSERT INTO Subscriptions (SubscriptionId, Name, Description, RecurringAmount, StartDate, EndDate)
VALUES
(1, 'Netflix', 'Stream your favorite TV shows and movies', 15.99, '2023-05-01', '2024-04-30'),
(2, 'Spotify', 'Stream your favorite music and podcasts', 9.99, '2023-05-01', '2024-04-30'),
(3, 'Amazon Prime', 'Free shipping, exclusive deals, and more', 12.99, '2023-05-01', '2024-04-30'),
(4, 'Hulu', 'Stream TV shows and movies', 11.99, '2023-05-01', '2024-04-30'),
(5, 'Apple Music', 'Stream your favorite music and playlists', 9.99, '2023-05-01', '2024-04-30'),
(6, 'Adobe Creative Cloud', 'Access to industry-leading creative software', 52.99, '2023-05-01', '2024-04-30'),
(7, 'LinkedIn Learning', 'Access to thousands of online courses', 29.99, '2023-05-01', '2024-04-30'),
(8, 'Microsoft Office 365', 'Access to Microsoft Office applications and services', 99.99, '2023-05-01', '2024-04-30'),
(9, 'Dropbox Plus', 'Cloud storage and file sharing', 11.99, '2023-05-01', '2024-04-30'),
(10, 'Grammarly Premium', 'Grammar and spell checker with advanced writing suggestions', 29.95, '2023-05-01', '2024-04-30');



-- UserSubscriptions Table
INSERT INTO UserSubscriptions (UserSubscriptionId, UserId, SubscriptionId, RenewalDate)
VALUES
(1, 1, 1, '2023-06-01'),
(2, 1, 2, '2023-06-01'),
(3, 2, 3, '2023-06-01'),
(4, 3, 4, '2023-06-01'),
(5, 4, 5, '2023-06-01'),
(6, 5, 6, '2023-06-01'),
(7, 6, 7, '2023-06-01'),
(8, 7, 8, '2023-06-01'),
(9, 8, 9, '2023-06-01'),
(10, 9, 10, '2023-06-01'),
(11, 1, 3, '2023-07-01'),
(12, 2, 4, '2023-07-01'),
(13, 3, 5, '2023-07-01'),
(14, 4, 6, '2023-07-01'),
(15, 5, 7, '2023-07-01'),
(16, 6, 8, '2023-07-01'),
(17, 7, 9, '2023-07-01'),
(18, 8, 10, '2023-07-01'),
(19, 9, 1, '2023-07-01'),
(20, 1, 4, '2023-08-01'),
(21, 2, 5, '2023-08-01'),
(22, 3, 6, '2023-08-01'),
(23, 4, 7, '2023-08-01'),
(24, 5, 8, '2023-08-01'),
(25, 6, 9, '2023-08-01'),
(26, 7, 10, '2023-08-01'),
(27, 8, 1, '2023-08-01'),
(28, 9, 2, '2023-08-01'),
(29, 1, 5, '2023-09-01'),
(30, 2, 6, '2023-09-01');


INSERT INTO Billing (BillingId, BillerName, BillerCategory, BillerAddress, BillerCity, BillerState, BillerZipCode, AccountNumber)
VALUES
(1, 'Electricity Company', 'Utilities', '123 Power Street', 'Karachi', 'Sindh', '75500', '11112222'),
(2, 'Gas Company', 'Utilities', '456 Gas Avenue', 'Lahore', 'Punjab', '54000', '33334444'),
(3, 'Water Company', 'Utilities', '789 Water Drive', 'Islamabad', 'ICT', '44000', '55556666');

INSERT INTO BillPayments (BillPaymentId, UserId, BillingId, PaymentAmount, PaymentDate, DueDate, PaymentStatus)
VALUES
(1, 1, 1, 1000, '2023-04-01', '2023-04-15', 'Paid'),
(2, 2, 2, 800, '2023-04-05', '2023-04-20', 'Paid'),
(3, 3, 3, 900, '2023-04-07', '2023-04-22', 'Paid'),
(4, 4, 1, 1500, '2023-04-11', '2023-04-25', 'Paid'),
(5, 5, 2, 1200, '2023-04-15', '2023-04-30', 'Pending'),
(6, 6, 3, 950, '2023-04-16', '2023-05-01', 'Pending');
INSERT INTO UserBiller (UserBillerId, UserId, BillingId, CustomBillerName, CustomAccountNumber)
VALUES
(1, 1, 1, 'Electricity - Karachi', '1234'),
(2, 2, 2, 'Gas - Lahore', '2345'),
(3, 3, 3, 'Water - Islamabad', '3456'),
(4, 4, 1, 'Electricity - Peshawar', '4567'),
(5, 5, 2, 'Gas - Quetta', '5678'),
(6, 6, 3, 'Water - Faisalabad', '6789'),
(7, 7, 1, 'Electricity - Multan', '7890'),
(8, 8, 2, 'Gas - Gujranwala', '8901'),
(9, 9, 3, 'Water - Rawalpindi', '9012');
