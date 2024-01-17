using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace FastPay
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string userQuery = "SELECT UserId, FirstName, Email, COUNT(*) as UserCount FROM Users WHERE Email=@Email AND Password=@Password GROUP BY UserId, FirstName, Email";
                string adminQuery = "SELECT AdminId, Username, COUNT(*) as AdminCount FROM Admins WHERE Username=@Username AND Password=@Password GROUP BY AdminId, Username";

                bool isAdmin = false;

                // Check for admin
                using (SqlCommand adminCommand = new SqlCommand(adminQuery, connection))
                {
                    adminCommand.Parameters.AddWithValue("@Username", email.Value);
                    adminCommand.Parameters.AddWithValue("@Password", password.Value);

                    connection.Open();
                    SqlDataReader adminReader = adminCommand.ExecuteReader();

                    if (adminReader.HasRows)
                    {
                        adminReader.Read();
                        int adminCount = adminReader.GetInt32(adminReader.GetOrdinal("AdminCount"));
                        if (adminCount > 0)
                        {
                            isAdmin = true;
                        }
                    }

                    adminReader.Close();
                    connection.Close();
                }

                if (isAdmin)
                {
                    Response.Redirect("AdminDashboard.aspx");
                }
                else
                {
                    // Check for user
                    using (SqlCommand userCommand = new SqlCommand(userQuery, connection))
                    {
                        userCommand.Parameters.AddWithValue("@Email", email.Value);
                        userCommand.Parameters.AddWithValue("@Password", password.Value);

                        connection.Open();
                        SqlDataReader userReader = userCommand.ExecuteReader();

                        if (userReader.HasRows)
                        {
                            userReader.Read();
                            int count = userReader.GetInt32(userReader.GetOrdinal("UserCount"));
                            if (count > 0)
                            {
                                // Save user's UserId, FirstName, and Email in session
                                int userId = userReader.GetInt32(userReader.GetOrdinal("UserId"));
                                string firstName = userReader.GetString(userReader.GetOrdinal("FirstName"));
                                string userEmail = userReader.GetString(userReader.GetOrdinal("Email"));

                                Session["UserId"] = userId;
                                Session["UserName"] = firstName;
                                Session["UserEmail"] = userEmail;

                                // Successful login, redirect to the desired page
                                Response.Redirect("Dashboard.aspx");
                            }
                        }
                        else
                        {
                            // Invalid credentials, display an error message
                            lblMessage.Text = "Invalid email or password";
                        }

                        userReader.Close();
                    }
                }
            }
        }

        public void btnForgotPassword_Click(object sender, EventArgs e)
        {
            Response.Redirect("ForgotPassword.aspx");
        }

        public void btnSignUp_Click(object sender, EventArgs e)
        {
            Response.Redirect("register.aspx");
        }
    }
}
