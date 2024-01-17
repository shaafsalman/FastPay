<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TransactionHistory.aspx.cs" Inherits="FastPay.TransactionHistory" %>

<!DOCTYPE html>
<html lang="en">
<head>
     <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FastPay Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link href="styles.css" rel="stylesheet" />
    <script src="script.js"></script>

</head>
<body>


    <form id="form2" runat="server">
        <aside class="sidebar">
             <div class="logo">FastPay</div>
            <nav>
                <ul>
                    <li><a href="Dashboard.aspx" onclick="openDasboard()"><i class="fas fa-tachometer-alt"></i>Dashboard</a></li>
                    <li><a href="Wallet.aspx" onclick="openWalletPage()"><i class="fas fa-wallet"></i>Wallet</a></li>
                    <li><a href="Transfer.aspx" onclick="openTransferPage()"><i class="fas fa-exchange-alt"></i>Transfer</a></li>
                    <li><a href="TransactionHistory.aspx" class="selected" onclick="openTransactionHistoryPage()"><i class="fas fa-history"></i>Transaction History</a></li>
                    <li><a href="BillPayment.aspx" onclick="openBillPaymentPage()"><i class="fas fa-credit-card"></i>Bill Payment</a></li>
                    <li><a href="Subscription.aspx" onclick="openSubscriptionPage()"><i class="fas fa-user"></i>Subscription</a></li>
                    <li><a href="Beneficiaries.aspx" onclick="openBeneficiariesPage()"><i class="fas fa-address-book"></i>Beneficiaries</a></li>
                    <li><a href="Profile.aspx" onclick="openProfilePage()"><i class="fas fa-user-circle"></i>Profile</a></li>
                    <li><a href="Contact.aspx" onclick="openContactPage()"><i class="fas fa-envelope"></i>Contact</a></li>
                    <li><a href="#" onclick="logout()"><i class="fas fa-sign-out-alt"></i>Log Out</a></li>
                </ul>
            </nav>
        </aside>
      <main class="main">
          <div class="content-header">
        <h1>Transaction History</h1>
        <button <%--onclick="showAddBeneficiaryModal(event)"--%>>Download PDF</button>

    </div>
    
    
    <br />
   <asp:GridView ID="TransactionHistoryGridView" runat="server" AutoGenerateColumns="False" CssClass="transaction-history-grid">
    <Columns>
        <asp:BoundField DataField="TransactionId" HeaderText="Transaction ID" />
        <asp:BoundField DataField="AccountNumber" HeaderText="Account Number" />
        <asp:BoundField DataField="SenderName" HeaderText="Sender Name" />
        <asp:BoundField DataField="ReceiverName" HeaderText="Recipient Name" />
        <asp:BoundField DataField="Amount" HeaderText="Amount" DataFormatString="Rs. {0:N2}" />
        <asp:BoundField DataField="TransactionDate" HeaderText="Transaction Date" DataFormatString="{0:d}" />
        <asp:BoundField DataField="Reason" HeaderText="Reason" />
    </Columns>
</asp:GridView>
</main>


       
    </form>




</body>
</html>