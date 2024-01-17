<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Transfer.aspx.cs" Inherits="FastPay.Transfer" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FastPay Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link href="styles.css" rel="stylesheet" />
    <script src="script.js"></script>

    <style>
        /* Transfer Page */
.transfer-form {
    background-color: #ffffff;
    padding: 20px;
    border-radius: 5px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12), 0 1px 2px rgba(0, 0, 0, 0.24);
}

.transfer-form label {
    display: block;
    margin-bottom: 5px;
    font-size: 16px;
}

.transfer-form input[type="text"],
.transfer-form input[type="number"] {
    display: block;
    width: 100%;
    padding: 8px;
    margin-bottom: 20px;
    border: 1px solid #ccc;
    border-radius: 4px;
}

.transfer-form .or-option {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-bottom: 20px;
}

    .transfer-form .or-option p {
        background-color: #ffffff;
        padding: 0 10px;
    }

.transfer-form button[type="submit"],
.transfer-form input[type="button"],
.transfer-form input[type="submit"] {
    display: inline-block;
    padding: 10px 20px;
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    font-size: 16px;
    font-weight: bold;
    text-align: center;
    text-decoration: none;
    transition: all 0.3s ease-in-out;
}

    .transfer-form button[type="submit"]:hover,
    .transfer-form input[type="button"]:hover,
    .transfer-form input[type="submit"]:hover {
        background-color: #0056b3;
    }

    /* Dropdown menu styles */
.transfer-form select {
    display: block;
    width: 100%;
    padding: 8px;
    margin-bottom: 20px;
    border: 1px solid #ccc;
    border-radius: 4px;
    background-color: #fff;
    -webkit-appearance: none;
    -moz-appearance: none;
    appearance: none;
    font-size: 16px;
}

.transfer-form select:focus {
    outline: none;
    border-color: #007bff;
}

.transfer-form .select-arrow {
    position: absolute;
    top: 50%;
    right: 16px;
    transform: translateY(-50%);
    pointer-events: none;
    color: #999;
}

/* Internet Explorer-specific styles */
.transfer-form select::-ms-expand {
    display: none;
}
.or-option {
    display: flex;
    align-items: center;
    justify-content: center;
    position: relative;
    margin: 20px 0;
}

.or-option::before,
.or-option::after {
    content: "";
    height: 1px;
    background-color: #ccc;
    width: 100%;
    position: absolute;
    top: 50%;
}

.or-option::before {
    left: 0;
    margin-right: 10px;
}

.or-option::after {
    right: 0;
    margin-left: 10px;
}

.or-option p {
    background-color: #f2f2f2;
    padding: 0 10px;
    position: relative;
    z-index: 1;
}
.subscribe-button {
    padding: 10px 20px;
        background-color: #343a40;
        color: #fff;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        transition: 0.3s;
        width: max-content;
		margin-bottom:30px;
		width:100%;
}

    .subscribe-button:hover {
        background-color: #fff;
            color: #343a40;
            border: 1px solid #343a40;
    }

    </style>
     
</head>
<body>
    <form id="form1" runat="server">
         <aside class="sidebar">
             <div class="logo">FastPay</div>
            <nav>
                <ul>
                    <li><a href="Dashboard.aspx" onclick="openDasboard()"><i class="fas fa-tachometer-alt"></i>Dashboard</a></li>
                    <li><a href="Wallet.aspx" onclick="openWalletPage()"><i class="fas fa-wallet"></i>Wallet</a></li>
                    <li><a href="Transfer.aspx" class="selected"  onclick="openTransferPage()"><i class="fas fa-exchange-alt"></i>Transfer</a></li>
                    <li><a href="TransactionHistory.aspx"onclick="openTransactionHistoryPage()"><i class="fas fa-history"></i>Transaction History</a></li>
                    <li><a href="BillPayment.aspx" onclick="openBillPaymentPage()"><i class="fas fa-credit-card"></i>Bill Payment</a></li>
                    <li><a href="Subscription.aspx" onclick="openSubscriptionPage()"><i class="fas fa-user"></i>Subscription</a></li>
                    <li><a href="Beneficiaries.aspx" onclick="openBeneficiariesPage()"><i class="fas fa-address-book"></i>Beneficiaries</a></li>
                    <li><a href="Profile.aspx" onclick="openProfilePage()"><i class="fas fa-user-circle"></i>Profile</a></li>
                    <li><a href="Contact.aspx" onclick="openContactPage()"><i class="fas fa-envelope"></i>Contact</a></li>
                    <li><a href="#" onclick="logout()"><i class="fas fa-sign-out-alt"></i>Log Out</a></li>
                </ul>
            </nav>
        </aside>
           <div class="content-header">
        <h1>Transfer</h1>
    </div>
<div class="content">
    <div class="transfer-form">
        <label for="userAccount">Select Your Account</label>
        <asp:DropDownList ID="userAccount" runat="server" />
        
        <label for="recipientAccountNumber">Recipient Account Number</label>
        <asp:TextBox runat="server" ID="recipientAccountNumberTextBox"></asp:TextBox>
        <asp:Button ID="verifyButton" runat="server" Text="Verify" OnClick="VerifyButton_Click" CssClass="subscribe-button" />
        <asp:Label ID="recipientNameLabel" runat="server" Text=""></asp:Label>

        <div class="or-option">
            <p>OR</p>
        </div>

        <label for="chooseBeneficiary">Choose from beneficiaries</label>
        <asp:DropDownList ID="chooseBeneficiary" runat="server" />
        <asp:Button ID="loadBeneficiaryButton" runat="server" Text="Load Beneficiary" OnClick="LoadBeneficiaryButton_Click" CssClass="subscribe-button" />

        <label for="transferAmount">Transfer Amount</label>
        <asp:TextBox ID="transferAmountTextBox" runat="server" type="number" step="0.01" min="0" />

        <label for="transferReason">Reason</label>
        <asp:TextBox ID="transferReasonTextBox" runat="server"></asp:TextBox>

         <asp:Button ID="proceedButton" runat="server" Text="Proceed" OnClick="ProceedButton_Click" CssClass="subscribe-button" />
        <p runat="server" id="transferStatus"></p>
    </div>
</div>

</form>


</body>
</html>

