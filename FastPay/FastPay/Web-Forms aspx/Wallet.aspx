<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Wallet.aspx.cs" Inherits="FastPay.Wallet" %>


<!DOCTYPE html>
<html lang="en">
<head>
     <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FastPay Wallet</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    
    <link href="styles.css" rel="stylesheet" />
    <script src="script.js"></script>
    <link rel="stylesheet2" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>


<style>
 



.account-balance-container{
    justify-content: space-between;
    align-items: center;
    margin-right: 30px;
    margin-left: 280px;
    background-color: #fff;
    padding: 20px;
    border-radius: 5px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12), 0 1px 2px rgba(0, 0, 0, 0.24);
    margin-top: 20px;
}

.grid-view {
    width: 100%;
    margin-top:20px;
    border-collapse: collapse;
    border: 1px solid #ddd;
}

.grid-view th,
.grid-view td {
    text-align: left;
    padding: 8px;
    border: 1px solid #ddd;
}

.grid-view th {
    background-color: #f2f2f2;
}



@import url('https://fonts.googleapis.com/css2?family=josefin+Sans:wght@400;500;600;700&display=swap');


.container {
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

.card {
   justify-content: center;
    margin-left:300px;
    width: 350px;
    height: 200px;
    color: #fff;
    cursor: pointer;
    perspective: 1000px;
}

.card-inner {
    width: 100%;
    height: 100%;
    position: relative;
    transition: transform 1s;
    transform-style: preserve-3d;
}

.front, .back {
    width: 100%;
    height: 100%;
     background: linear-gradient(to bottom right, #444444, #888888);
     box-shadow: 0 0 10px rgba(255, 255, 255, 0.3), 0 0 20px rgba(255, 255, 255, 0.2), 0 0 30px rgba(255, 255, 255, 0.1);
    position: absolute;
    top: 0;
    left: 0;
    padding: 20px 30px;
    border-radius: 15px;
    overflow: hidden;
    z-index: 1;
    backface-visibility: hidden;
}

.row {

    display: flex;
    align-items: center;
    justify-content: space-between;
}

.map-img {
    width: 100%;
    position: absolute;
    top: 0;
    left: 0;
    opacity: 0.3;
    z-index: -1;
}

.card-no {
    font-size: 22px;
    margin-top: 20px;
}

.card-holder {
    font-size: 16px;
    margin-top: 45px;
}

.name {
    font-size: 15px;
    margin-top: 10px;
}

.bar {
    background: #222;
    margin-left: -30px;
    margin-right: -30px;
    height: 60px;
    margin-top: 10px;
}

.card-cvv {
    margin-top: 20px;
}

.card-cvv div {
    flex: 1;
}

.card-cvv img {
    width: 100%;
    display: block;
    line-height: 0;
}

.card-cvv p {
    background: #fff;
    color: #000;
    font-size: 22px;
    padding: 10px 20px;
}

.card-text {
    margin-top: 10px;
    font-size: 10px;
}

.signature {
    margin-top: 30px;
}

.back {
    transform: rotateY(180deg);
}



.card:hover .card-inner {
    transform: rotateY(-180deg);
}

.card-navigation {
    display: flex;
    justify-content: center;
    margin-top: 15px;
}

.nav-button {
    background-color: transparent;
    border: none;
    font-size: 18px;
    cursor: pointer;
    padding: 5px 10px;
    margin: 0 5px;
}

.nav-button:hover {
    background-color: rgba(0, 0, 0, 0.1);
}







.Button-container {
  
}

.Button-container h3 {
  margin-top: 0;
  margin-bottom: 20px;
  font-size: 24px;
}

.button-group {
  display: flex;
  justify-content: center;
}

.button-group button {

    margin-top: 20px;
    padding: 10px 20px;
    background-color: #343a40;
    color: #fff;
    cursor: pointer;
    transition: 0.3s;


  
  color: white;
  border-radius: 5px;
  padding: 10px 20px;
  margin: 0 10px;
  font-size: 18px;
  display: flex;
  align-items: center;
}

.button-group button:hover {
        background-color: #fff;
        color: #343a40;
        border: 1px solid #343a40;}

.button-group button:focus {
  outline: none;
}

.icon {
  margin-right: 10px;
  font-size: 20px;
}

.btn-update
{
    margin-top: 30px;
    padding: 10px 20px;
    background-color: #343a40;
    color: #fff;
    cursor: pointer;
    transition: 0.3s;

  color: white;
  border-radius: 5px;
  padding: 10px 20px;
  font-size: 18px;
  align-items: center;
}
.btn-update:hover{
background-color: #fff;
        color: #343a40;
        border: 1px solid #343a40;}


h3, h4, h5 {
  margin: 0 0 20px;
}

.form-group {
  margin-bottom: 20px;
}

label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
}

input[type="range"] {
  width: 100%;
}

#transaction-limit-value {
  display: inline-block;
  margin-left: 10px;
  font-weight: bold;
}

.account {
  margin-bottom: 20px;
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 5px;
}

.account h5 {
  margin: 0 0 10px;
}

input[type="password"] {
  width: 100%;
  font-family: 'Courier New', Courier, monospace;
  letter-spacing: 1px;
}

.transaction-input {
  width: 100%;
  padding: 8px 12px;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-size: 14px;
  background-color: #f8f8f8;
  transition: background-color 0.3s, border-color 0.3s;
}

.transaction-input:focus {
  outline: none;
  background-color: #fff;
  border-color: #66afe9;
}

.pin-input-container {
  position: relative;
  display: inline-block;
}

.pin-input {
  padding-right: 30px;
}

.toggle-pin-visibility {
  position: absolute;
  right: 0;
  top: 0;
  bottom: 0;
  width: 30px;
  border: none;
  background: none;
  font-size: 18px;
  cursor: pointer;
}

.toggle-pin-visibility:focus {
  outline: none;
}

.btn-update,
.btn-activate,
.btn-freeze,
.btn-order {
    margin-top: 30px;
    padding: 10px 20px;
    background-color: #343a40;
    color: #fff;
    cursor: pointer;
    transition: 0.3s;
    color: white;
    border-radius: 5px;
    padding: 10px 20px;
    font-size: 18px;
    align-items: center;
    margin-right:50px;
}

.btn-activate::before {
    content: '\1F4B7';
    margin-right: 14px;
}

.btn-freeze::before {
    content: '\1F4DB';
    margin-right: 4px;
}

.btn-order::before {
    content: '\1F4B7';
    margin-right: 4px;
}

.btn-update:hover,
.btn-activate:hover,
.btn-freeze:hover,
.btn-order:hover {
    background-color: #fff;
    color: #343a40;
    border: 1px solid #343a40;
}
.modal {
  display: none;
  position: fixed;
  z-index: 1000;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  overflow: auto;
  background-color: rgba(0, 0, 0, 0.5);
}

.modal-content {
  background-color: #fff;
  margin: 15% auto;
  padding: 20px;
  border: 1px solid #888;
  width: 50%;
  max-width: 600px;
  box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
}

.close {
  color: #aaa;
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

.input-field {
  margin-bottom: 15px;
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
 
 
  overflow: auto;
}

.submit-btn:hover {
background-color: #fff;
            color: #343a40;
            border: 1px solid #343a40;}

@media screen and (max-width: 600px) {
  .modal-content {
    width: 90%;
  }
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
                    <li><a href="Wallet.aspx" class="selected"onclick="openWalletPage()"><i class="fas fa-wallet"></i>Wallet</a></li>
                    <li><a href="Transfer.aspx" onclick="openTransferPage()"><i class="fas fa-exchange-alt"></i>Transfer</a></li>
                    <li><a href="TransactionHistory.aspx"  onclick="openTransactionHistoryPage()"><i class="fas fa-history"></i>Transaction History</a></li>
                    <li><a href="BillPayment.aspx" onclick="openBillPaymentPage()"><i class="fas fa-credit-card"></i>Bill Payment</a></li>
                    <li><a href="Subscription.aspx" onclick="openSubscriptionPage()"><i class="fas fa-user"></i>Subscription</a></li>
                    <li><a href="Beneficiaries.aspx" onclick="openBeneficiariesPage()"><i class="fas fa-address-book"></i>Beneficiaries</a></li>
                    <li><a href="Profile.aspx" onclick="openProfilePage()"><i class="fas fa-user-circle"></i>Profile</a></li>
                    <li><a href="Contact.aspx" onclick="openContactPage()"><i class="fas fa-envelope"></i>Contact</a></li>
                    <li><a href="#" onclick="logout()"><i class="fas fa-sign-out-alt"></i>Log Out</a></li>
                </ul>
            </nav>
        </aside>
      <main>
          <div class="content-header">
        <h2>Add a new Account</h2>
       <button type="button" class="add-account-btn" data-toggle="modal" data-target="#addAccountModal">Add Account</button>
    </div>

 
        <div class="account-balance-container">
    <h2>Account Balances</h2>
    <asp:GridView ID="GridViewAccountBalances" runat="server" AutoGenerateColumns="False" CssClass="grid-view">
        <Columns>
            <asp:BoundField DataField="AccountType" HeaderText="Account Type" />
            <asp:BoundField DataField="AccountNumber" HeaderText="Account Number" />
            <asp:BoundField DataField="Balance" HeaderText="Balance" DataFormatString="PKR {0:N2}" />
        </Columns>
    </asp:GridView>
</div>

          <div class="credit-card">
    <div class="container">
          <h2>User Cards</h2>
        <div class="card">
            <div class="card-inner">
                <div class="front">
<%--                    <img src="https://i.ibb.co/PYss3yv/map.png" class="map-img">--%>
                    <div class="row">
                   <img src="https://i.ibb.co/G9pDnYJ/chip.png" width="40px">
                    <img src=Images\apple-touch-icon.png width="40px">
                    <asp:Image ID="imgDistributorLogo" runat="server" Width="50px" />
</div>
                    <div class="row card-no" id="lblCardNumber" runat="server"></div>
                    <div class="row card-holder">
                          <asp:Label ID="lblCardHolderName" runat="server"></asp:Label>
                           <asp:Label ID="lblExpirationDate" runat="server"></asp:Label>
                    </div>
                    <div class="row name">
                        <div class="name">
                         
                      </div>

                    </div>
                </div>
                <div class="back">
                    <img src="https://i.ibb.co/PYss3yv/map.png" class="map-img">
                    <div class="bar"></div>
                    <div class="row card-cvv">
                        <div>
                            <img src="https://i.ibb.co/S6JG8px/pattern.png">
                        </div>
                        <p id="lblCVC" runat="server"></p>
                    </div>
                    <div class="row card-text">
                    </div>
                    <div class="row signature">
                        <p>CUSTOMER SIGNATURE</p>
                        <img src="https://i.ibb.co/WHZ3nRJ/visa.png" width="40px">
                    </div>
                </div>
            </div>
        </div>
    
    <div class="card-navigation">
        <asp:Button ID="btnLeftArrow" runat="server" CssClass="nav-button" OnClick="btnLeftArrow_Click" Text="&#10094;" />
        <asp:Button ID="btnRightArrow" runat="server" CssClass="nav-button" OnClick="btnRightArrow_Click" Text="&#10095;" />
    </div>


        <div class="Button-container">
  <h3>Card Options</h3>
<div class="button-group">
  <asp:Button ID="btnActivateCard" CssClass="btn-activate" runat="server" OnClick="btnActivateCard_Click" Text="Activate Card" />
  <asp:Button ID="btnFreezeCard" CssClass="btn-freeze" runat="server" OnClick="btnFreezeCard_Click" Text="Freeze Card" />
  <asp:Button ID="btnOrderNewCard" CssClass="btn-order" runat="server" OnClick="btnOrderNewCard_Click" Text="Order New Card" />
</div>

      <div class="modal fade" id="confirmationModal" tabindex="-1" role="dialog" aria-labelledby="confirmationModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="confirmationModalLabel">Confirmation</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        Are you sure you want to proceed?
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-primary" id="btnConfirmAction">Confirm</button>
      </div>
    </div>
  </div>
</div>


  </div>
</div>

        </div>
      <div class="container">
  <h3>Update Transaction Limits and PINs</h3>

  <h4>Your Accounts</h4>
  <asp:Repeater ID="rptAccounts" runat="server">
    <ItemTemplate>
      <div class="account">
        <asp:HiddenField ID="hfAccountId" runat="server" Value='<%# Eval("AccountId") %>' />
        <h5><%# Eval("AccountType") %></h5>
        <p><strong>Account Number:</strong> <%# Eval("AccountNumber") %></p>
        <p><strong>Balance:</strong> <%# Eval("Balance") %></p>
        <div class="form-group">
          <label for="txtTransactionLimit">Transaction Limit:</label>
          <asp:TextBox ID="txtTransactionLimit" runat="server" CssClass="transaction-input" Text='<%# Eval("TransactionLimit") %>' TextMode="Number" Min="0" Step="10"></asp:TextBox>
        </div>
        <div class="form-group">
          <label for="txtPin">PIN:</label>
          <div class="pin-input-container">
            <asp:TextBox ID="txtPin" runat="server" CssClass="pin-input" Text='<%# Eval("Pin") %>' TextMode="Password"></asp:TextBox>
            <button type="button" class="toggle-pin-visibility" onclick="togglePinVisibility(<%# Eval("AccountId") %>)">&#128065;</button>
          </div>
        </div>
      </div>
    </ItemTemplate>
  </asp:Repeater>
  <asp:Button ID="btnUpdateLimits" runat="server" CssClass="btn-update" OnClick="UpdateLimits_Click" Text="Update Limits" />
</div>





</main>

<asp:Panel ID="addAccountModal" runat="server" CssClass="modal">
    <div class="modal-content">
        <span class="close" onclick="hideAddAccountModal()">&times;</span>
        <h2>Add a new account</h2>
        <asp:Panel ID="addAccountForm" runat="server">
             <div class="input-field">
                <asp:Label ID="accountNumberLabel" runat="server" AssociatedControlID="accountNumber" Text="Account Number:" />
                <asp:TextBox ID="accountNumber" runat="server" />
                <asp:RegularExpressionValidator ID="accountNumberValidator" runat="server" ErrorMessage="Account number must be at least 7 digits" ControlToValidate="accountNumber" ValidationExpression="^\d{7,}$" />
            </div>
            <div class="input-field">
                <asp:Label ID="accountTypeLabel" runat="server" AssociatedControlID="accountType" Text="Account Type:" />
                <asp:DropDownList ID="accountType" runat="server">
                    <asp:ListItem Text="--Select Account Type--" Value="" />
                    <asp:ListItem Text="Savings" Value="Savings" />
                    <asp:ListItem Text="Checking" Value="Checking" />
                    <asp:ListItem Text="Credit Card" Value="Credit Card" />
                    <asp:ListItem Text="Other" Value="Other" />
                </asp:DropDownList>
            </div>
            <div class="input-field">
                <asp:Label ID="openingBalanceLabel" runat="server" AssociatedControlID="openingBalance" Text="Opening Balance:" />
                <asp:TextBox ID="openingBalance" runat="server" />
            </div>
            <div class="input-field">
    <asp:Label ID="transactionLimitLabel" runat="server" AssociatedControlID="transactionLimit" Text="Transaction Limit:" />
    <asp:TextBox ID="transactionLimit" runat="server" />
</div>
<div class="input-field">
    <asp:Label ID="pinLabel" runat="server" AssociatedControlID="pin" Text="PIN (4 digits):" />
    <asp:TextBox ID="pin" runat="server" MaxLength="4" />
</div>
            <asp:Label ID="errorMessageLabel" runat="server" CssClass="error-message" Visible="false"></asp:Label>
            <asp:Button ID="addAccountButton" runat="server" Text="Submit" CssClass="submit-btn" OnClick="AddAccount_Click" />
        </asp:Panel>
    </div>
</asp:Panel>



    </form>

    <script>


            function showAddAccountModal() {
        var modal = $('#<%= addAccountModal.ClientID %>');
    modal.show();
    }

    function hideAddAccountModal() {
        var modal = $('#<%= addAccountModal.ClientID %>');
        modal.hide();
    }

    $(document).ready(function () {
        // Get the add account modal
        var modal = $('#<%= addAccountModal.ClientID %>');

    // When the user clicks anywhere outside of the modal, close it
    $(window).click(function (event) {
            if ($(event.target).is(modal)) {
        modal.hide();
            }
        });
    });



        function updateTransactionLimitValue(accountId, value) {
            document.getElementById('transaction-limit-value-' + accountId).innerHTML = value;
        }

        function updateLimits() {
            var accountData = [];
            var inputs = document.querySelectorAll('input[type=range]');
            inputs.forEach(function (input) {
                var accountId = input.id.split('-')[2];
                var fieldName = input.id.split('-')[0];
                if (!accountData[accountId]) {
                    accountData[accountId] = {};
                }
                accountData[accountId][fieldName] = input.value;
            });

            // AJAX call to update limits and PINs
            var xhttp = new XMLHttpRequest();
            xhttp.onreadystatechange = function () {
                if (this.readyState == 4 && this.status == 200) {
                    alert('Transaction limits and PINs updated successfully.');
                }
            };
            xhttp.open("POST", "UpdateLimits.aspx/UpdateAccountLimits", true);
            xhttp.setRequestHeader("Content-type", "application/json");
            xhttp.send(JSON.stringify({ 'accountData': accountData }));
        }



        function updateSliderValue(accountId, inputElement) {
            var valueSpan = document.getElementById("transaction-limit-value-" + accountId);
            valueSpan.innerHTML = inputElement.value;
            valueSpan.style.left = (inputElement.value / inputElement.max * 100) + "%";
            updateTransactionLimitValue(accountId, inputElement.value);
        }

        function togglePinVisibility(accountId) {
            const pinInput = document.getElementById('pin-' + accountId);
            const pinVisibilityButton = pinInput.nextElementSibling;

            if (pinInput.type === 'password') {
                pinInput.type = 'text';
                pinVisibilityButton.innerHTML = '&#128064;';
            } else {
                pinInput.type = 'password';
                pinVisibilityButton.innerHTML = '&#128065;';
            }
        }
        $(document).ready(function () {
            let action = "";

            // Triggered when the modal is about to be shown
            $("#confirmationModal").on("show.bs.modal", function (event) {
                const button = $(event.relatedTarget);
                action = button.data("action");

                // Update the modal title based on the action
                $("#confirmationModalLabel").text(
                    action === "activate"
                        ? "Activate Card"
                        : action === "freeze"
                            ? "Freeze Card"
                            : "Order New Card"
                );

                // Disable the Activate or Freeze button if already active or frozen
                if (action === "activate" || action === "freeze") {
                    const cardIsActive = /* check if the card is active from the C# code */;
                    const shouldDisableButton = (action === "activate" && cardIsActive) || (action === "freeze" && cardIsFrozen);
                    const cardIsActive = /* check if the card is active from the C# code */;
                    const cardIsFrozen = /* check if the card is frozen from the C# code */;
                    const shouldDisableButton = (action === "activate" && cardIsActive) || (action === "freeze" && cardIsFrozen);
                    $("#btnConfirmAction").prop("disabled", shouldDisableButton);
                }
            });

            // Perform the desired action when the confirm button is clicked
            $("#btnConfirmAction").on("click", function () {
                // Close the modal
                $("#confirmationModal").modal("hide");

                switch (action) {
                    case "activate":
                        // Call the function to activate the card
                        btnActivateCard_Click();
                        break;
                    case "freeze":
                        // Call the function to freeze the card
                        btnFreezeCard_Click();
                        break;
                    case "order":
                        // Call the function to order a new card, then update the card container
                        btnOrderNewCard_Click();
                        break;
                    default:
                        console.error("Invalid action: " + action);
                }
            });
        });


    </script>

</body>
</html>