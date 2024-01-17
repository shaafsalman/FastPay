<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="FastPay.ForgotPassword" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>


<style>
* {
			box-sizing: border-box;
			margin: 0;
			padding: 0;
		}

		body {
			font-family: Arial, sans-serif;
			background-color: #f2f2f2;
		}

		.container {
			background-color: white;
			max-width: 500px;
			margin: 100px auto;
			padding: 40px;
			border-radius: 10px;
			box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
			text-align: center;
		}

		h1 {
			font-size: 32px;
			font-weight: bold;
			margin-bottom: 40px;
			color: #333;
			display: flex;
			align-items: center;
			justify-content: center;
		}

		h1 img {
			margin-right: 20px;
		}

		form {
			display: flex;
			flex-direction: column;
			align-items: center;
		}

		label {
			display: block;
			margin-bottom: 20px;
			color: #333;
			font-size: 20px;
		}

		input[type="email"],
		input[type="password"] {
			width: 100%;
			padding: 15px;
			margin-bottom: 20px;
			border: none;
			border-radius: 5px;
			background-color: #f2f2f2;
			color: #333;
			font-size: 18px;
		}

		input[type="email"]:focus,
		input[type="password"]:focus {
			background-color: #e6e6e6;
		}

		button[type="submit"] {
			background-color: #333;
			color: white;
			border: none;
			border-radius: 5px;
			font-size: 20px;
			padding: 15px 50px;
			cursor: pointer;
			transition: background-color 0.3s ease-in-out;
		}

		button[type="submit"]:hover {
			background-color: #555;
		}

		.form__link {
			color: #333;
			font-size: 16px;
			margin-top: 20px;
			text-decoration: none;
		}

		.form__link:hover {
			color: #555;
		}
		.submit-btn {
            padding: 8px 16px;
            background-color: #007bff;
            color: #fff;
            font-size: 16px;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        .submit-btn:hover {
            background-color: #0056b3;
        }
	</style>
</head>
<body>
    <div class="container">
        <h1>
            <img src="Images\apple-touch-icon.png" alt="FastPay Logo">
            Forgot Password
        </h1>
        <form runat="server">
            <asp:Panel ID="pnlVerifyEmail" runat="server" Visible="true">
                <label for="email"><i class="fas fa-envelope"></i></label>
                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="Enter your email address" required></asp:TextBox>
                <asp:Button ID="btnVerifyEmail" runat="server" Text="Verify" OnClick="btnVerifyEmail_Click" CssClass="submit-btn" />
                <asp:Label ID="lblEmailError" runat="server" Visible="false" ForeColor="Red">The email address you entered is not registered.</asp:Label>
            </asp:Panel>
            <asp:Panel ID="pnlResetPassword" runat="server" Visible="false">
                <label for="newPassword"><i class="fas fa-lock"></i></label>
                <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" placeholder="New Password" required></asp:TextBox>
                <label for="confirmPassword"><i class="fas fa-lock"></i></label>
                <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" placeholder="Confirm Password" required></asp:TextBox>
                <asp:Button ID="btnResetPassword" runat="server" Text="Reset Password" OnClick="btnResetPassword_Click" CssClass="submit-btn" />
                <asp:Label ID="lblPasswordMatchError" runat="server" Visible="false" ForeColor="Red">The new password and confirm password fields do not match.</asp:Label>
            </asp:Panel>
            <asp:Button ID="btnSignIn" runat="server" Text="Back to Sign In" OnClick="btnSignIn_Click" CssClass="submit-btn" Visible="false" />
        </form>
    </div>
</body></html>
