<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="FastPay.Profile" %>
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
    <form id="form1" runat="server">
        <!-- Update Personal Information Modal -->
        <div id="updateModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeUpdateModal();">&times;</span>
                <h3>Update Personal Information</h3>
                <table>
                    <tr>
                        <th>Email:</th>
                        <td><asp:TextBox ID="email" runat="server" TextMode="Email"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th>Phone Number:</th>
                        <td><asp:TextBox ID="phoneNumber" runat="server" TextMode="Phone"></asp:TextBox></td>
                    </tr>
                </table>
                <input type="submit" value="Save Changes" class="submit-btn" OnClick="UpdatePersonalInfo_Click" />
            </div>
        </div>

        <!-- Change Password Modal -->
        <div id="changePasswordModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeChangePasswordModal();">&times;</span>
                <h3>Change Password</h3>
                <table>
                    <tr>
                        <th>Current Password:</th>
                        <td><asp:TextBox ID="currentPassword" runat="server" TextMode="Password"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th>New Password:</th>
                        <td><asp:TextBox ID="newPassword" runat="server" TextMode="Password"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <th>Confirm New Password:</th>
                        <td><asp:TextBox ID="confirmNewPassword" runat="server" TextMode="Password"></asp:TextBox></td>
                    </tr>
                </table>
                <input type="submit" value="Change Password" class="submit-button" OnClick="ChangePassword_Click" />
            </div>
        </div>

        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="logo">FastPay</div>
            <nav>
                <ul>
                    <li><a href="Dashboard.aspx"><i class="fas fa-tachometer-alt"></i>Dashboard</a></li>
                    <li><a href="Wallet.aspx"><i class="fas fa-wallet"></i>Wallet</a></li>
                    <li><a href="Transfer.aspx"><i class="fas fa-exchange-alt"></i>Transfer</a></li>
                    <li><a href="TransactionHistory.aspx" ><i class="fas fa-history"></i>Transaction History</a></li>
                    <li><a href="BillPayment.aspx"><i class="fas fa-credit-card"></i>Bill Payment</a></li>
                    <li><a href="Subscription.aspx"><i class="fas fa-user"></i>Subscription</a></li>
                    <li><a href="Beneficiaries.aspx"><i class="fas fa-address-book"></i>Beneficiaries</a></li>
                    <li><a href="Profile.aspx"class="selected"><i class="fas fa-user-circle"></i>Profile</a></li>
                    <li><a href="Contact.aspx"><i class="fas fa-envelope"></i>Contact</a></li>
                    <li><a href="#" onclick="logout()"><i class="fas fa-sign-out-alt"></i>Log Out</a></li>
                </ul>
            </nav>
        </aside>

        <!-- Main Content -->
        <div class="main">
            <div class="profile-info">
                <img src="https://i.ibb.co/bdfH7Cy/depositphotos-137014128-stock-illustration-user-profile-icon.webp" alt="Profile Picture">
                <div>
                    <h2><%: Session["UserName"] != null ? Session["UserName"] : "N/A" %></h2>
                    <p><%: Session["UserEmail"] != null ? Session["UserEmail"] : "N/A" %></p>
                </div>
            </div>

            <div class="user-details">
                <h3>All Details</h3>
                <table>
                    <tr>
                        <th>First Name:</th>
                        <td><%: Session["UserName"] != null ? Session["UserName"].ToString().Split(' ')[0] : "N/A" %></td>
                    </tr>
                    <tr>
                        <th>Last Name:</th>
                        <td><%: Session["UserName"] != null && Session["UserName"].ToString().Split(' ').Length > 1 ? Session["UserName"].ToString().Split(' ')[1] : "N/A" %></td>
                    </tr>
                    <tr>
                        <th>Email:</th>
                        <td><%: Session["UserEmail"] != null ? Session["UserEmail"] : "N/A" %></td>
                    </tr>
                    <tr>
                        <th>Phone Number:</th>
                        <td><%: Session["UserPhoneNumber"] != null ? Session["UserPhoneNumber"] : "N/A" %></td>
                    </tr>
                    <tr>
                        <th>Address:</th>
                        <td><%: Session["UserAddress"] != null ? Session["UserAddress"] : "N/A" %></td>
                    </tr>
                </table>

                <button type="button" onclick="openUpdateModal();" class="update-button">Update Personal Information</button>
                <button type="button" onclick="openChangePasswordModal();" class="update-button">Change Password</button>
            </div>
        </div>

        <script>
            function openUpdateModal() {
                document.getElementById('updateModal').style.display = 'block';
            }

            function closeUpdateModal() {
                document.getElementById('updateModal').style.display = 'none';
            }

            function openChangePasswordModal() {
                document.getElementById('changePasswordModal').style.display = 'block';
            }

            function closeChangePasswordModal() {
                document.getElementById('changePasswordModal').style.display = 'none';
            }
        </script>
    </form>
</body>
</html>

