<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="FastPay.Login" %>

<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>FastPay - Login</title>
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
	      max-width: 500px;
	      width: 90%; /* Make sure it fits on smaller screens */
	      height: calc(100vh - 40px); /* Subtracting the top and bottom padding */
	      margin: 0 auto;
	      padding: 20px;
	      border-radius: 10px;
	      box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
	      text-align: center;
	      display: flex; /* Added to center content vertically */
	      flex-direction: column; /* Added to align content in a column */
	      justify-content: center; /* Added to center content vertically */
          margin-top:20px;
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
        width: max-content;
		margin-bottom:30px;
		width:300px;
}

button[type="submit"]:hover {
background-color: #fff;
            color: #343a40;
            border: 1px solid #343a40;}

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
  color: #1abc9c;
}
        
        .submit-btn:hover {
            background-color: #0056b3;
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
				#error-message {
			
              color: #e74c3c;
              font-size: 16px;
              margin-bottom: 20px;
               font-weight: 500;
                }
				.form__link {
  color: #777;
  font-size: 18px;
  text-decoration: none;
  transition: color 0.3s ease;
}

.form__link:hover {
  color: #1abc9c;



}
	</style>
</head>
<body>
	<div class="container">
		<h1>
			<img src="Images\apple-touch-icon.png" alt="FastPay Logo">
			Welcome to FastPay
		</h1>
		       <form runat="server">
    <label for="email"><i class="fas fa-envelope"></i></label>
    <input type="email" id="email" name="email" placeholder="Email Address" required runat="server" />
    <label for="password"><i class="fas fa-lock"></i></label>
    <input type="password" id="password" name="password" placeholder="Password" required runat="server" />
    <button type="submit" OnServerClick="btnLogin_Click" runat="server">Log In</button>
    

	<asp:Button ID="btnForgotPassword" runat="server" Text="Forgot Password?" OnClick="btnForgotPassword_Click" CssClass="button" />
    <asp:Button ID="btnSignUp" runat="server" Text="Don't have an account? Register" OnClick="btnSignUp_Click" CssClass="button" />
    <a href="#" class="form__link">Contact Us</a>

    <asp:Label ID="lblMessage" runat="server"></asp:Label>
     </form>

		
	
	</div>
</body>
</html>

