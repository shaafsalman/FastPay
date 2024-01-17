<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="FastPay.AdminDashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <link href="styles.css" rel="stylesheet" />

    <style>
        .content-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-right: 30px;
            margin-left: 30px;
            background-color: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.12), 0 1px 2px rgba(0, 0, 0, 0.24);
            margin-top: 20px;
            margin-bottom: 30px;
        }

        .content-header h1 {
            font-size: 30px;
            margin: 0;
        }

        .content-header button {
            padding: 10px 20px;
            background-color: #343a40;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: 0.3s;
            width: max-content;
        }

        .content-header button:hover {
            background-color: #fff;
            color: #343a40;
            border: 1px solid #343a40;
        }
        /* General styles */
body {
    font-family: Arial, sans-serif;
    font-size: 14px;
    line-height: 1.6;
    background-color: #f4f4f4;
    margin: 0;
    padding: 0;
}

h1, h4 {
    color: #333;
    margin-top: 0;
}



/* Container styles */
.Admin-Container {
    margin: 30px;
}

.card {
    background: #fff;
    border-radius: 5px;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    margin-bottom: 20px;
}

.card-header {
    background-color: #f4f4f4;
    border-bottom: 1px solid #e9e9e9;
    border-radius: 5px 5px 0 0;
    padding: 15px 20px;
}

.card-body {
    padding: 20px;
}

/* Grid styles */
asp\:GridView {
    width: 100%;
    border-collapse: collapse;
    box-sizing: border-box;
    font-size: 14px;
}

asp\:GridView th,
asp\:GridView td {
    border: 1px solid #ddd;
    padding: 8px;
    text-align: left;
}

asp\:GridView th {
    background-color: #f2f2f2;
    color: #333;
}

asp\:GridView tr:nth-child(even) {
    background-color: #f9f9f9;
}

asp\:GridView tr:hover {
    background-color: #f1f1f1;
}

/* Button styles */
asp\:LinkButton {
    background-color: #4CAF50;
    border: none;
    color: white;
    padding: 8px 16px;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 14px;
    margin: 4px 2px;
    cursor: pointer;
    border-radius: 5px;
}

asp\:LinkButton:hover {
    background-color: #45a049;
}

    </style>
</head>
<body>
    <form id="form2" runat="server">
        <div class="content-header">
            <h1>Admin Dashboard</h1>
            <asp:Button ID="Button1" runat="server" Text="Logout" OnClick="btnLogout_Click" CssClass="content-header button" />
        </div>
         <div class="Admin-Container">
        <div class="card mb-4">
            <div class="card-header">
                <h4>Users and Account Information</h4>
            </div>
            <div class="card-body">
                <asp:GridView ID="GridViewUsers" runat="server" AutoGenerateColumns="False" OnRowEditing="GridViewUsers_RowEditing" OnRowCancelingEdit="GridViewUsers_RowCancelingEdit" OnRowUpdating="GridViewUsers_RowUpdating" OnRowDeleting="GridViewUsers_RowDeleting" DataKeyNames="UserId">
                    <Columns>
                          <asp:BoundField DataField="UserId" HeaderText="User ID" ReadOnly="True" />
                        <asp:BoundField DataField="FirstName" HeaderText="First Name" />
                        <asp:BoundField DataField="LastName" HeaderText="Last Name" />
                        <asp:BoundField DataField="Email" HeaderText="Email" />
                        <asp:BoundField DataField="AccountId" HeaderText="Account ID" ReadOnly="True" />
                        <asp:BoundField DataField="Balance" HeaderText="Balance" ReadOnly="True" />
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" Text="Delete" OnClientClick="return confirm('Are you sure you want to delete this record?');"></asp:LinkButton>
                            </ItemTemplate>
                            
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>

        <div class="card mb-4">
            <div class="card-header">
                <h4>Credit Card Information</h4>
            </div>
            <div class="card-body">
             <asp:GridView ID="GridViewCards" runat="server" AutoGenerateColumns="False" DataKeyNames="CardId" OnRowDeleting="GridViewCards_RowDeleting">
                    <Columns>
                        <asp:BoundField DataField="CardId" HeaderText="Card ID" ReadOnly="True" />
                        <asp:BoundField DataField="UserId" HeaderText="User ID" ReadOnly="True" />
                        <asp:BoundField DataField="CardType" HeaderText="Card Type" />
                        <asp:BoundField DataField="Distributor" HeaderText="Distributor" />
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" Text="Delete" OnClientClick="return confirm('Are you sure you want to delete this record?');"></asp:LinkButton> 
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
             <div class="card mb-4">
    <div class="card-header">
        <h4>Transaction Information</h4>
    </div>
    <div class="card-body">
        <asp:GridView ID="GridViewTransactions" runat="server" AutoGenerateColumns="False" DataKeyNames="TransactionId" OnRowUpdating="GridViewTransactions_RowUpdating" OnRowDeleting="GridViewTransactions_RowDeleting" OnRowCancelingEdit="GridViewTransactions_RowCancelingEdit" OnRowEditing="GridViewTransactions_RowEditing">
    <Columns>
        <asp:BoundField DataField="TransactionId" HeaderText="Transaction ID" ReadOnly="True" />
        
        <asp:TemplateField HeaderText="Account ID">
            <ItemTemplate>
                <asp:Label ID="lblAccountId" runat="server" Text='<%# Eval("AccountId") %>'></asp:Label>
            </ItemTemplate>
            <EditItemTemplate>
                <asp:TextBox ID="txtAccountId" runat="server" Text='<%# Eval("AccountId") %>' ReadOnly="True"></asp:TextBox>
            </EditItemTemplate>
        </asp:TemplateField>
        
        <asp:BoundField DataField="RecipientAccount_id" HeaderText="Recipient Account ID" />
        <asp:BoundField DataField="Amount" HeaderText="Amount" />
        <asp:BoundField DataField="TransactionDate" HeaderText="Transaction Date" />
        
        <asp:TemplateField HeaderText="Reason">
            <ItemTemplate>
                <asp:Label ID="lblReason" runat="server" Text='<%# Eval("Reason") %>'></asp:Label>
            </ItemTemplate>
            <EditItemTemplate>
                <asp:TextBox ID="txtReason" runat="server" Text='<%# Eval("Reason") %>'></asp:TextBox>
            </EditItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField>
            <ItemTemplate>
                <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" Text="Delete" OnClientClick="return confirm('Are you sure you want to delete this record?');"></asp:LinkButton>
<%--                <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" Text="Edit"></asp:LinkButton>--%>
            </ItemTemplate>
            <EditItemTemplate>
                <asp:LinkButton ID="btnUpdate" runat="server" CommandName="Update" Text="Update"></asp:LinkButton>
                <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel" Text="Cancel"></asp:LinkButton>
            </EditItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>
<asp:Label ID="lblDebug" runat="server" />

        </div>
</div>

</div>
</form>

</body>
</html>
    