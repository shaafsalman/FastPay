CREATE DATABASE FastPay;
USE FastPay;

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

CREATE TABLE Bills (
  BillID INT PRIMARY KEY,
  UserID INT,
  BillerName VARCHAR(50),
  AccountNumber VARCHAR(20),
  PaymentAmount DECIMAL(10, 2),
  DueDate DATE,
  FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Subscriptions (
  SubscriptionId INT PRIMARY KEY,
  UserId INT,
  Name VARCHAR(50),
  Description VARCHAR(100),
  RecurringAmount DECIMAL(10, 2),
  StartDate DATE,
  EndDate DATE,
  FOREIGN KEY (UserId) REFERENCES Users(UserId)
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


-- First, drop the existing Subscriptions and Bills tables
DROP TABLE Subscriptions;
DROP TABLE Bills;

-- Then, create the new Subscriptions and Billing tables
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
  UserId INT,
  BillingId INT,
  FOREIGN KEY (UserId) REFERENCES Users(UserId),
  FOREIGN KEY (BillingId) REFERENCES Billing(BillingId)
);
