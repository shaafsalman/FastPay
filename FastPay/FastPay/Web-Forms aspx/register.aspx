<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="register.aspx.cs" Inherits="FastPay.register" %>

<!DOCTYPE html>
<html>
  <head>
    <title>Banking Website - Register</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
	<link rel="stylesheet" href="style.css">
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
			max-width: 1000px;
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

		input[type="text"],
		input[type="email"],
		input[type="tel"],
		input[type="password"],
		select,
		textarea {
			width: 100%;
			padding: 15px;
			margin-bottom: 20px;
			border: none;
			border-radius: 5px;
			background-color: #f2f2f2;
			color: #333;
			font-size: 18px;
		}

		input[type="text"]:focus,
		input[type="email"]:focus,
		input[type="tel"]:focus,
		input[type="password"]:focus,
		select:focus,
		textarea:focus {
			background-color: #e6e6e6;
		}

		input:focus {
			outline: none;
			border-bottom-color: #1abc9c;
		}

		button[type="submit"] {
			padding: 10px 20px;
			background-color: #343a40;
			color: #fff;
			border: none;
			border-radius: 4px;
			cursor: pointer;
			transition: 0.3s;
			margin-bottom: 30px;
			margin-top:30px;
			width: 500px;
			height:50px;
			font-size:20px;
		}

		button[type="submit"]:hover {
			background-color: #fff;
			color: #343a40;
			border: 1px solid #343a40;
		}

		.button {
			background-color: transparent;
			border: none;
			color: #2c3e50;
			cursor: pointer;
			font-size: 18px;

			margin-bottom: 20px;
			transition: color 0.3s ease;
		}

		.button:hover {
			color: #1abc9c	}

	.form__link {
		color: #777;
		font-size: 18px;
		text-decoration: none;
		transition: color 0.3s ease;
	}

	.form__link:hover {
		color: #1abc9c;
	}

	@media screen and (max-width: 600px) {
		.container {
			max-width: 100%;
			padding: 40px;
		}

		.container h1 {
			font-size: 36px;
			margin-bottom: 40px;
		}
	}
</style>

  </head>
<body>
	<div class="container">
		<h1>
			<img src="Images\apple-touch-icon.png" alt="FastPay Logo">
			Register to FastPay
		</h1>
		<form id="registerForm" runat="server">
			<label for="firstname">First Name:</label>
			<asp:TextBox ID="firstname" runat="server" ClientIDMode="Static"></asp:TextBox>
					<label for="lastname">Last Name:</label>
		<asp:TextBox ID="lastname" runat="server" ClientIDMode="Static"></asp:TextBox>

		<label for="email">Email:</label>
		<asp:TextBox ID="email" runat="server" ClientIDMode="Static" TextMode="Email"></asp:TextBox>

		<label for="phonenumber">Phone Number:</label>
		<asp:TextBox ID="phonenumber" runat="server" ClientIDMode="Static"></asp:TextBox>

		<label for="password">Password:</label>
		<asp:TextBox ID="password" runat="server" ClientIDMode="Static" TextMode="Password"></asp:TextBox>

		<label for="address">Address:</label>
		<asp:TextBox ID="address" runat="server" ClientIDMode="Static" TextMode="MultiLine" Rows="4"></asp:TextBox>

		<label for="postalcode">Postal Code:</label>
		<asp:TextBox ID="postalcode" runat="server" ClientIDMode="Static"></asp:TextBox>

		<label for="provinceDropDownList">Province:</label>
		<asp:DropDownList ID="provinceDropDownList" runat="server">
			<asp:ListItem Value="">--Select a Province--</asp:ListItem>
			<asp:ListItem Value="KPK">Khyber Pakhtunkhwa</asp:ListItem>
			<asp:ListItem Value="PUNJAB">Punjab</asp:ListItem>
			<asp:ListItem Value="SINDH">Sindh</asp:ListItem>
			<asp:ListItem Value="BALOCHISTAN">Balochistan</asp:ListItem>
			<asp:ListItem Value="GILGIT-BALTISTAN">Gilgit-Baltistan</asp:ListItem>
		    			<asp:ListItem Value="AJK">Azad Jammu & Kashmir</asp:ListItem>
		</asp:DropDownList>

		<label for="cityDropDownList">City:</label>
		<asp:DropDownList ID="cityDropDownList" runat="server">
			<asp:ListItem Value="">--Select a City--</asp:ListItem>
			<asp:ListItem Value="Karachi">Karachi</asp:ListItem>
			<asp:ListItem Value="Lahore">Lahore</asp:ListItem>
			<asp:ListItem Value="Faisalabad">Faisalabad</asp:ListItem>
			<asp:ListItem Value="Rawalpindi">Rawalpindi</asp:ListItem>
			<asp:ListItem Value="Multan">Multan</asp:ListItem>
			<asp:ListItem Value="Hyderabad">Hyderabad</asp:ListItem>
			<asp:ListItem Value="Gujranwala">Gujranwala</asp:ListItem>
			<asp:ListItem Value="Peshawar">Peshawar</asp:ListItem>
			<asp:ListItem Value="Quetta">Quetta</asp:ListItem>
			<asp:ListItem Value="Islamabad">Islamabad</asp:ListItem>
			<asp:ListItem Value="Sargodha">Sargodha</asp:ListItem>
			<asp:ListItem Value="Bahawalpur">Bahawalpur</asp:ListItem>
			<asp:ListItem Value="Sialkot">Sialkot</asp:ListItem>
			<asp:ListItem Value="Sheikhupura">Sheikhupura</asp:ListItem>
			<asp:ListItem Value="Larkana">Larkana</asp:ListItem>
		</asp:DropDownList>

			    <button type="submit" OnServerClick="registerButton_Click" runat="server">Register</button>
                <button type="submit" OnServerClick="btnLogin_Click" runat="server">Log In</button>

		</form>
</div>

</body>
</html>