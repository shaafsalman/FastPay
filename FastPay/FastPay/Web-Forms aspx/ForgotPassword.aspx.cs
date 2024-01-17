using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace FastPay
{
    public partial class ForgotPassword : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnVerifyEmail_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string connectionString = ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = "SELECT UserId FROM Users WHERE Email=@Email";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    con.Open();
                    object result = cmd.ExecuteScalar();

                    if (result == null)
                    {
                        lblEmailError.Visible = true;
                        pnlResetPassword.Visible = false;
                    }
                    else
                    {
                        int userId = Convert.ToInt32(result);
                        lblEmailError.Visible = false;
                        pnlResetPassword.Visible = true;
                        ViewState["UserId"] = userId;
                        pnlVerifyEmail.Visible = false; // Add this line to hide the email verification panel

                    }
                }
            }
        }

        protected void btnResetPassword_Click(object sender, EventArgs e)
        {
            string newPassword = txtNewPassword.Text.Trim();
            string confirmPassword = txtConfirmPassword.Text.Trim();
            int userId = Convert.ToInt32(ViewState["UserId"]);
            string connectionString = ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString;

            if (newPassword == confirmPassword)
            {
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    string query = "UPDATE Users SET Password=@Password WHERE UserId=@UserId";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Password", newPassword);
                        cmd.Parameters.AddWithValue("@UserId", userId);
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                lblPasswordMatchError.Visible = false;
                pnlResetPassword.Visible = false;
                btnSignIn.Visible = true;
            }
            else
            {
                lblPasswordMatchError.Visible = true;
            }
        }

        protected void btnSignIn_Click(object sender, EventArgs e)
        {
            Response.Redirect("Login.aspx");
        }
    }
}
