<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BillPayment.aspx.cs" Inherits="FastPay.BillPayment" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FastPay - Subscriptions</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link href="styles.css" rel="stylesheet" />
    <script src="script.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<style>
    .Button-grid-content 
    {
       margin-top:30px;
       margin-bottom:30px;

       display: grid;
       grid-template-columns: repeat(2,450px);
       grid-template-rows: repeat(2, 70px); /* Set the row height to 150px */
       grid-gap: 0px; /* Add a gap between grid items */
       overflow-y: auto; /* Add vertical scroll if content overflows */
       margin-left:350px;
    }

    .facility-item {
        align-self:center;
        padding: 10px 20px;
        background-color: #343a40;
        color: #fff;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        transition: 0.3s;
        width:380px;
        height:50px;
    }
    .facility-item a {
        color: #fff; /* Change the color of the button text to white */
        text-decoration: none;
    }
    .facility-item:hover
    {
         background-color: #fff;
        color: #343a40;
        border: 1px solid #343a40;
    }
    .facility-item:hover a {
        color: #343a40; 
    }

    .facility-item i {
       font-size: 24px;
       margin-right: 10px;
       color: #fff;
       align-self:center;
    }
    .facility-item:hover i {
        color: #343a40; 
    }



    .bills-grid {
        margin-top: 30px;
        margin-left: 320px;
        width: 900px;
    }

    .bills-grid .row {
        border-bottom: 1px solid #ccc;
        padding: 10px 0;
    }

    .bills-grid .row:nth-child(odd) {
        background-color: #f8f8f8;
    }

    .pay-btn {
         background-color: #4CAF50;
         color: white;
         border: none;
         cursor: pointer;
         margin-right: 10px;
         margin-left:70px;
         width:100px;
    }
    .pay-btn:hover
    {
        background-color: #3e8e41;

    }
    .successMessage {
    color: green;
    font-weight: bold;
    margin-top: 10px;
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
                    <li><a href="Transfer.aspx" onclick="openTransferPage()"><i class="fas fa-exchange-alt"></i>Transfer</a></li>
                    <li><a href="TransactionHistory.aspx" onclick="openTransactionHistoryPage()"><i class="fas fa-history"></i>Transaction History</a></li>
                    <li><a href="BillPayment.aspx" class="selected" onclick="openBillPaymentPage()"><i class="fas fa-credit-card"></i>Bill Payment</a></li>
                    <li><a href="Subscription.aspx" onclick="openSubscriptionPage()"><i class="fas fa-user"></i>Subscription</a></li>
                    <li><a href="Beneficiaries.aspx" onclick="openBeneficiariesPage()"><i class="fas fa-address-book"></i>Beneficiaries</a></li>
                    <li><a href="Profile.aspx" onclick="openProfilePage()"><i class="fas fa-user-circle"></i>Profile</a></li>
                    <li><a href="Contact.aspx" onclick="openContactPage()"><i class="fas fa-envelope"></i>Contact</a></li>
                    <li><a href="#" onclick="logout()"><i class="fas fa-sign-out-alt"></i>Log Out</a></li>
                </ul>
            </nav>
        </aside>
<div class="main">
    <div class="content-header">
        <h1>Pay</h1>
    </div>
    <div class="Button-grid-content">
        <asp:Repeater ID="rptBasicFacilities" runat="server">
            <ItemTemplate>
                <div class="col-lg-6 col-md-6 col-sm-12">
                    <div class="facility-item">
                        <asp:LinkButton ID="btnFacility" runat="server" OnClick="btnFacility_Click" CommandArgument='<%# Eval("BillingId") %>'>
                            <i class='<%# GetFacilityIcon(Eval("BillerName").ToString()) %>'></i> <%# Eval("BillerName") %>
                        </asp:LinkButton>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
    <asp:HiddenField ID="hfSelectedBillingId" runat="server" />
</div>

<!-- Pending Bills Section -->
<div class="content-header">
    <h1>Pending Bills</h1>
</div>
<div class="bills-grid">
    <asp:Repeater ID="rptPendingBills" runat="server">
        <ItemTemplate>
            <div class="row">
                <div class="col-lg-2 col-md-2 col-sm-12">
                    <%# Eval("BillPaymentId") %>
                </div>
                <div class="col-lg-2 col-md-2 col-sm-12">
                    <%# Eval("BillerName") %>
                </div>
                <div class="col-lg-2 col-md-2 col-sm-12">
                    <%# Eval("AccountNumber") %>
                </div>
                <div class="col-lg-2 col-md-2 col-sm-12">
                    <%# Eval("DueDate") %>
                </div>
                <div class="col-lg-2 col-md-2 col-sm-12">
                <asp:LinkButton ID="btnPayPendingBill" runat="server" CssClass="btn btn-primary pay-btn" OnCommand="btnPayPendingBill_Command" CommandArgument='<%# Eval("BillPaymentId") %>'>Pay</asp:LinkButton>
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>
</div>


<div class="content-header">
    <h1>Paid Bills</h1>
</div>
<div class="bills-grid">
    <asp:Repeater ID="rptPaidBills" runat="server">
        <ItemTemplate>
            <div class="row">
                <div class="col-lg-3 col-md-3 col-sm-12">
                    <%# Eval("BillerName") %>
                </div>
                <div class="col-lg-3 col-md-3 col-sm-12">
                    <%# Eval("AccountNumber") %>
                </div>
                <div class="col-lg-3 col-md-3 col-sm-12">
                    <%# Eval("PaymentDate") %>
                </div>
                <div class="col-lg-3 col-md-3 col-sm-12">
                    <%# Eval("PaymentAmount") %>
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>
</div>
     

        !-- Bill Details Modal -->
<div class="modal fade" id="billDetailsModal" tabindex="-1" role="dialog" aria-labelledby="billDetailsModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="billDetailsModalLabel">Bill Details</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <p>Biller Name: <asp:Label ID="lblBillerName" runat="server" /></p>
        <p>Account Number: <asp:Label ID="lblAccountNumber" runat="server" /></p>
        <p>Due Date: <asp:Label ID="lblDueDate" runat="server" /></p>
        <p>Amount: <asp:Label ID="lblAmount" runat="server" /></p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        <asp:Button ID="btnPayBill" runat="server" CssClass="btn btn-primary" Text="Pay Bill" OnClick="btnPayBill_Click" />
        <asp:Label ID="lblSuccessMessage" runat="server" CssClass="successMessage" Visible="false"></asp:Label>

      </div>
    </div>
  </div>
</div>
        </form>
 
    


</body>
</html>