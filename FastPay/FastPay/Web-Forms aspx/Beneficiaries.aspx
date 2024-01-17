<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Beneficiaries.aspx.cs" Inherits="FastPay.Beneficiaries" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FastPay Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link href="styles.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
     <script src="script.js"></script>

   
    <style>
        /* Modal styles */
.modal {
    display: none;
    position: fixed;
    z-index: 1000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgba(0, 0, 0, 0.4);
}

.modal-content {
    background-color: #ffffff;
    margin: 15% auto;
    padding: 20px;
    border: 1px solid #888;
    width: 50%;
    border-radius: 4px;
}

.close {
    color: #aaaaaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
    cursor: pointer;
}

.close:hover,
.close:focus {
    color: #000;
    text-decoration: none;
    cursor: pointer;
}

/* Form styles */
.input-field {
    display: flex;
    flex-direction: column;
    margin-bottom: 20px;
}

input[type='text'],
input[type='password'],
select {
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 4px;
    font-size: 16px;
}

.submit-btn {
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

.submit-btn:hover {
           background-color: #fff;
            color: #343a40;
            border: 1px solid #343a40;}

    </style>
</head>

<body>

    <form id="form1" runat="server">
        <asp:Panel ID="addBeneficiaryModal" runat="server" CssClass="modal">
            <div class="modal-content">
                <span class="close" onclick="hideAddBeneficiaryModal()">&times;</span>
                <h2>Add a new beneficiary</h2>
                <asp:Panel ID="addBeneficiaryForm" runat="server">
                    <div class="input-field">
                        <asp:Label ID="accountNumberLabel" runat="server" AssociatedControlID="accountNumber" Text="Account Number:" />
                        <asp:TextBox ID="accountNumber" runat="server" />
                        <asp:Button ID="verifyAccountButton" runat="server" Text="Verify Account" CssClass="submit-btn" OnClick="VerifyAccount_Click" />
                    </div>
                    <asp:Panel ID="accountDetails" runat="server" Visible="false">
                        <div class="input-field">
                            <asp:Label ID="AccountIdLabel" runat="server" AssociatedControlID="AccountId" Text="Account ID:" />
                            <asp:TextBox ID="AccountId" runat="server" ReadOnly="true" />
                        </div>
                        <div class="input-field">
                            <asp:Label ID="accountNameLabel" runat="server" AssociatedControlID="accountName" Text="Account Name:" />
                            <asp:TextBox ID="accountName" runat="server" ReadOnly="true" />
                        </div>
                    </asp:Panel>
                    <div class="input-field">
                        <asp:Label ID="relationshipLabel" runat="server" AssociatedControlID="relationship" Text="Relationship:" />
                        <asp:DropDownList ID="relationship" runat="server">
                            <asp:ListItem Text="--Select Relationship--" Value="" />
                            <asp:ListItem Text="Family" Value="Family" />
                            <asp:ListItem Text="Friend" Value="Friend" />
                            <asp:ListItem Text="Colleague" Value="Colleague" />
                            <asp:ListItem Text="Other" Value="Other" />
                        </asp:DropDownList>
                    </div>
                    <asp:Button ID="addBeneficiaryButton" runat="server" Text="Submit" CssClass="submit-btn" OnClick="AddBeneficiary_Click" />
                </asp:Panel>
            </div>
        </asp:Panel>



        <aside class="sidebar">
            <div class="logo">FastPay</div>
            <nav>
                <ul>
                    <li><a href="Dashboard.aspx" onclick="openDashboard(event)"><i class="fas fa-tachometer-alt"></i>Dashboard</a></li>
                    <li><a href="Wallet.aspx" onclick="openWalletPage(event)"><i class="fas fa-wallet"></i>Wallet</a></li>
                    <li><a href="Transfer.aspx" onclick="openTransferPage(event)"><i class="fas fa-exchange-alt"></i>Transfer</a></li>
                    <li><a href="TransactionHistory.aspx" onclick="openTransactionHistoryPage(event)"><i class="fas fa-history"></i>Transaction History</a></li>
                    <li><a href="BillPayment.aspx" onclick="openBillPaymentPage(event)"><i class="fas fa-credit-card"></i>Bill Payment</a></li>
                    <li><a href="Subscription.aspx" onclick="openSubscriptionPage(event)"><i class="fas fa-user"></i>Subscription</a></li>
                    <li><a href="Beneficiaries.aspx" class="selected" onclick="openBeneficiariesPage(event)"><i class="fas fa-address-book"></i>Beneficiaries</a></li>
                    <li><a href="Profile.aspx" onclick="openProfilePage(event)"><i class="fas fa-user-circle"></i>Profile</a></li>
                    <li><a href="Contact.aspx" onclick="openContactPage(event)"><i class="fas fa-envelope"></i>Contact</a></li>
                    <li><a href="#" onclick="logout(event)"><i class="fas fa-sign-out-alt"></i>Log Out</a></li>
                </ul>
            </nav>
        </aside>





        <main class="main">
    <div class="content-header">
        <h1>Beneficiaries</h1>
    </div>
    
            
    <div class="content-header">

             <h2>User Details</h2>
        <% if (Session["UserId"] != null) { %>
            <p>User ID: <%= Session["UserId"] %></p>
            <p>Name: <%= Session["UserName"] %></p>
            <p>Email: <%= Session["UserEmail"] %></p>
        <% } else { %>
            <p>No user logged in</p>
        <% } %>

    </div>


    <div class="content-header">
        <h2>Add a new Account</h2>
        <button onclick="showAddBeneficiaryModal(event)">Add Beneficiary</button>
    </div>


    <div class="beneficiaries-container">
    <h2>Existing Beneficiaries</h2>

    <asp:Repeater ID="rptBeneficiaries" runat="server" OnItemCommand="rptBeneficiaries_ItemCommand">
        <ItemTemplate>
            <div class="beneficiary">
                <div class="beneficiary-info">
                    <div class="beneficiary-avatar">
                        <%# Eval("Name").ToString().Substring(0, 1).ToUpper() %>
                    </div>
                    <div class="beneficiary-details">
                        <div class="beneficiary-name"><%# Eval("Name") %></div>
                        <div class="beneficiary-email"><%# Eval("AccountNumber") %></div>
                    </div>
                </div>
                <div class="beneficiary-actions">
                    <div class="beneficiary-relationship"><%# Eval("Relationship") %></div>
                   <asp:Button ID="btnRemove" runat="server" Text="Remove" CssClass="cancel-subscription-button" CommandName="RemoveBeneficiary" CommandArgument='<%# Eval("BeneficiaryId") %>' />
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>
</div>

</main>

         



</form>

<script type="text/javascript">


    function showAddBeneficiaryModal(event) {
        event.preventDefault();
        document.getElementById("addBeneficiaryModal").style.display = "block";
    }

    function hideAddBeneficiaryModal() {
        document.getElementById("addBeneficiaryModal").style.display = "none";
    }



</script>

  
   


</body>



</html>