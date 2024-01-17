<!-- Subscription.aspx -->
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Subscription.aspx.cs" Inherits="FastPay.Subscription" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FastPay - Subscriptions</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link href="styles.css" rel="stylesheet" />
    <script src="script.js"></script>
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
                    <li><a href="BillPayment.aspx" onclick="openBillPaymentPage()"><i class="fas fa-credit-card"></i>Bill Payment</a></li>
                    <li><a href="Subscription.aspx"class="selected"  onclick="openSubscriptionPage()"><i class="fas fa-user"></i>Subscription</a></li>
                    <li><a href="Beneficiaries.aspx" onclick="openBeneficiariesPage()"><i class="fas fa-address-book"></i>Beneficiaries</a></li>
                    <li><a href="Profile.aspx" onclick="openProfilePage()"><i class="fas fa-user-circle"></i>Profile</a></li>
                    <li><a href="Contact.aspx" onclick="openContactPage()"><i class="fas fa-envelope"></i>Contact</a></li>
                    <li><a href="#" onclick="logout()"><i class="fas fa-sign-out-alt"></i>Log Out</a></li>
                </ul>
            </nav>
        </aside>
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
        <div class="content">
    <h2>My Subscriptions</h2>
    <div id="userSubscriptions">
        <asp:Repeater ID="rptUserSubscriptions" runat="server">
            <ItemTemplate>
                <div class="subscription">
                    <div class="subscription-icon">
                        <i class="<%# GetIconClass(Eval("Name").ToString()) %>"></i>
                    </div>
                    <div class="subscription-details">
                        <h3><%# Eval("Name") %></h3>
                        <p><%# Eval("Description") %></p>
                        <p>Recurring Amount: PKR <%# Eval("RecurringAmount", "{0:N}") %></p>
                        <p>Renewal Date: <%# Eval("RenewalDate", "{0:dd MMMM yyyy}") %></p>
                    </div>
                    <div class="subscription-action">
                        <p>Subscribed</p>
                    <asp:Button ID="btnCancelSubscription" runat="server" Text="Cancel Subscription" OnClick="btnCancelSubscription_Click" CssClass="cancel-subscription-button" CommandArgument='<%# Eval("UserSubscriptionId") %>' />
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>



    <h2>All Subscriptions</h2>
    <div id="allSubscriptions">
    <asp:Repeater ID="rptAllSubscriptions" runat="server">
        <ItemTemplate>
            <div class="subscription">
                <div class="subscription-icon">
                    <i class="<%# GetIconClass(Eval("Name").ToString()) %>"></i>
                </div>
                <div class="subscription-details">
                    <h3><%# Eval("Name") %></h3>
                    <p><%# Eval("Description") %></p>
                    <p>Recurring Amount: PKR <%# Eval("RecurringAmount", "{0:N}") %></p>
                </div>
                <div class="subscription-action">
                <asp:Button ID="btnSubscribe" runat="server" Text='<%# IsUserSubscribed((int)Eval("SubscriptionId")) ? "Subscribed" : "Subscribe" %>' OnClick="btnSubscribe_Click" CssClass='<%# IsUserSubscribed((int)Eval("SubscriptionId")) ? "subscribe-button subscribed" : "subscribe-button" %>' CommandArgument='<%# Eval("SubscriptionId") %>' Enabled='<%# !IsUserSubscribed((int)Eval("SubscriptionId")) %>' />
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>
</div>
            </div>
    </form>
</body>
</html>