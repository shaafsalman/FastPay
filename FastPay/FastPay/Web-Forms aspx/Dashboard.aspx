<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="FastPay.Dashboard" %>

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
    
.button-grid {
    margin-left:300px;
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    grid-template-rows: repeat(2, 1fr);
    grid-gap:02px;


    justify-content: space-between;
    margin-right: 30px;
    margin-left: 280px;
    background-color: #fff;
    padding: 30px;
    border-radius: 5px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12), 0 1px 2px rgba(0, 0, 0, 0.24);
    margin-top: 20px;
}



.grid-button {
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

.grid-button:hover {
    background-color: #fff;
    color: #343a40;
    border: 1px solid #343a40;}





.beneficiaries-grid 
{
    margin-left:300px;
    display: flex;
    flex-wrap: nowrap;
    overflow-x: auto;
    justify-content: flex-start;
    align-items: center;
    margin: 30px;
    padding-bottom: 10px; /* To avoid scrollbar overlapping with the content */
}

/* Add scrollbar styling for better visual appearance */
.beneficiaries-grid::-webkit-scrollbar {
    height: 6px;
}

.beneficiaries-grid::-webkit-scrollbar-track {
    background-color: #f0f0f0;
}

.beneficiaries-grid::-webkit-scrollbar-thumb {
    background-color: #ccc;
    border-radius: 6px;
}
.beneficiary-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin: 10px;
}


.profile-picture {
    border-radius: 50%;
    width: 80px;
    height: 80px;
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 30px;
    color: white;
    background-color: #3c4858;
    box-shadow: 0 3px 6px rgba(0, 0, 0, 0.16), 0 3px 6px rgba(0, 0, 0, 0.23);
    margin-bottom: 10px;
    transition: all 0.3s ease;
}

.profile-picture:hover {
    transform: scale(1.1);
    background-color: #4a618c;
}

.beneficiary-name {
    text-align: center;
    font-size: 16px;
    color: #2d3436;
    font-weight: 500;
    transition: all 0.3s ease;
}

.beneficiary-name:hover {
    color: #4a618c;
}

.Bcontent-header2 {
    display: flex;
    justify-content:space-evenly;
    margin-right: 30px;
    margin-left: 280px;
    background-color: #fff;
    padding: 20px;
    border-radius: 5px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12), 0 1px 2px rgba(0, 0, 0, 0.24);
    margin-top: 20px;
}
        
.Bcontent-header {
    display: flex;
    justify-content:space-between;
    margin-right: 30px;
    margin-left: 280px;
    background-color: #fff;
    padding: 20px;
    border-radius: 5px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12), 0 1px 2px rgba(0, 0, 0, 0.24);
    margin-top: 20px;
}

    .Bcontent-header h1 {
        font-size: 30px;
        margin: 0;
    }

    .Bcontent-header button {
        padding: 10px 20px;
        background-color: #343a40;
        color: #fff;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        transition: 0.3s;
        width: max-content;
    }

        .Bcontent-header button:hover {
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
                    <li><a href="Dashboard.aspx" class="selected" onclick="openDasboard()"><i class="fas fa-tachometer-alt"></i>Dashboard</a></li>
                    <li><a href="Wallet.aspx" onclick="openWalletPage()"><i class="fas fa-wallet"></i>Wallet</a></li>
                    <li><a href="Transfer.aspx" onclick="openTransferPage()"><i class="fas fa-exchange-alt"></i>Transfer</a></li>
                    <li><a href="TransactionHistory.aspx" onclick="openTransactionHistoryPage()"><i class="fas fa-history"></i>Transaction History</a></li>
                    <li><a href="BillPayment.aspx" onclick="openBillPaymentPage()"><i class="fas fa-credit-card"></i>Bill Payment</a></li>
                    <li><a href="Subscription.aspx" onclick="openSubscriptionPage()"><i class="fas fa-user"></i>Subscription</a></li>
                    <li><a href="Beneficiaries.aspx" onclick="openBeneficiariesPage()"><i class="fas fa-address-book"></i>Beneficiaries</a></li>
                    <li><a href="Profile.aspx" onclick="openProfilePage()"><i class="fas fa-user-circle"></i>Profile</a></li>
                    <li><a href="Contact.aspx" onclick="openContactPage()"><i class="fas fa-envelope"></i>Contact</a></li>
                    <li><a href="#" onclick="logout()"><i class="fas fa-sign-out-alt"></i>Log Out</a></li>
                </ul>
            </nav>
        </aside>
        <div class="main">
            <div class="profile-info">
                <img src="https://i.ibb.co/bdfH7Cy/depositphotos-137014128-stock-illustration-user-profile-icon.webp" alt="Profile Picture">
                <div>
                    <h2><%: Session["UserName"] != null ? Session["UserName"] : "N/A" %></h2>
                    <p><%: Session["UserEmail"] != null ? Session["UserEmail"] : "N/A" %></p>
                </div>
            </div>
            
            
          <div class="button-grid">
                <asp:Button ID="btnTransferFunds" runat="server" Text="Transfer Funds" CssClass="grid-button" OnClick="btnTransferFunds_Click" Content='<i class="fa fa-exchange-alt"></i>' />
                <asp:Button ID="btnBills" runat="server" Text="Bills" CssClass="grid-button" OnClick="btnBills_Click" Content='<i class="fas fa-credit-card"></i>' />
                <asp:Button ID="btnSubscription" runat="server" Text="Subscription" CssClass="grid-button" OnClick="btnSubscription_Click" Content='<i class="fas fa-user"></i>' />
                <asp:Button ID="btnTransactionHistory" runat="server" Text="Transaction History" CssClass="grid-button" OnClick="btnTransactionHistory_Click" Content='<i class="fas fa-history"></i>' />
                <asp:Button ID="btnLimitManagement" runat="server" Text="Limit Management" CssClass="grid-button" OnClick="btnLimitManagement_Click" Content='<i class="fas fa-cogs"></i>' />
                <asp:Button ID="btnBeneficiaries" runat="server" Text="Beneficiaries" CssClass="grid-button" OnClick="btnBeneficiaries_Click" Content='<i class="fas fa-address-book"></i>' />



    </div>
                      <div class="Bcontent-header">
        <h1>Beneficiaries</h1>
        <button <%--onclick="showAddBeneficiaryModal(event)"--%>>Manage</button>

    </div>
           <div class="Bcontent-header2">
    <div class="beneficiaries-grid">
        <asp:Repeater ID="rptBeneficiaries" runat="server">
            <ItemTemplate>
                <a href="Beneficiaries.aspx">
                    <div class="beneficiary-item">
                        <div class="profile-picture">
                            <%# Eval("Name").ToString().Substring(0, 1).ToUpper() %>
                        </div>
                        <div class="beneficiary-name">
                            <%# Eval("Name") %>
                        </div>
                    </div>
                </a>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</div>


                 
</div>



    </form>
</body>
</html>
