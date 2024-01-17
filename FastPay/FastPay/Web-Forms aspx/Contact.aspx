<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="FastPay.Contact" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - FastPay</title>
    <meta name="description" content="Contact FastPay customer support for assistance with your account, billing, and transactions.">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link href="styles.css" rel="stylesheet" />
</head>
<style>
    body {
        font-family: 'Arial', sans-serif;
        background-color: #f0f0f0;
    }

    h1 {
        font-size: 2.5rem;
        margin-bottom: 30px;
        color: #555;
        text-transform: uppercase;
        letter-spacing: 1px;
    }

    .contact-box 
    {   
       justify-content: space-between;
       align-items: center;
       margin-right: 30px;
       margin-left: 280px;
       background-color: #fff;
       padding: 20px;
       border-radius: 5px;
       box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12), 0 1px 2px rgba(0, 0, 0, 0.24);
       margin-top: 20px;  
       margin-bottom:30px;
    }

    label {
        margin-top:20px;
        margin-left:20px;
        display: block;
        font-size: 1rem;
        margin-bottom: 5px;
        color: #555;
        text-transform: uppercase;
        letter-spacing: 1px;
    }

    input[type="text"],
    input[type="email"],
    textarea {
        margin-left:20px;
        width: 70%;
        padding: 10px;
        border-radius: 5px;
        border: 2px solid #ddd;
        font-size: 1rem;
        margin-bottom: 20px;
        background-color: #f2f2f2;
        color: #555;
    }

    input[type="submit"] {
                margin-left:20px;

        background-color: #3B9C9C;
        color: #fff;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        font-size: 1rem;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }

    input[type="submit"]:hover {
        background-color: #2F7F7F;
    }
</style>

<body>
    <form id="form2" runat="server" title="Contact Us">
        <aside class="sidebar">
            <div class="logo">FastPay</div>
            <nav>
                <ul>
                    <li><a href="Dashboard.aspx" onclick="openDasboard()"><i class="fas fa-tachometer-alt"></i>Dashboard</a></li>
                    <li><a href="Wallet.aspx" onclick="openWalletPage()"><i class="fas fa-wallet"></i>Wallet</a></li>
                    <li><a href="Transfer.aspx" onclick="openTransferPage()"><i class="fas fa-exchange-alt"></i>Transfer</a></li>
                    <li><a href="TransactionHistory.aspx" onclick="openTransactionHistoryPage()"><i class="fas fa-history"></i>Transaction History</a></li>
<li><a href="BillPayment.aspx" onclick="openBillPaymentPage()"><i class="fas fa-credit-card"></i>Bill Payment</a></li>
<li><a href="Subscription.aspx" onclick="openSubscriptionPage()"><i class="fas fa-user"></i>Subscription</a></li>
<li><a href="Beneficiaries.aspx" onclick="openBeneficiariesPage()"><i class="fas fa-address-book"></i>Beneficiaries</a></li>
<li><a href="Profile.aspx" onclick="openProfilePage()"><i class="fas fa-user-circle"></i>Profile</a></li>
<li><a href="Contact.aspx" class="selected" onclick="openContactPage()"><i class="fas fa-envelope"></i>Contact</a></li>
<li><a href="#" onclick="logout()"><i class="fas fa-sign-out-alt"></i>Log Out</a></li>
</ul>
</nav>
</aside>
<main class="main">
< <div class="content-header">
        <h1>Contact Us</h1>
    </div>
<div class="contact-box">
                <label for="name">Name:</label>
                <input type="text" id="name" name="name" required>
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required>

                <label for="subject">Subject:</label>
                <input type="text" id="subject" name="subject" required>

                <label for="message">Message:</label>
                <textarea id="message" name="message" required></textarea>

        <button> Submit</button>
    </div>
    </main>
</form>
    </body>
</html>



