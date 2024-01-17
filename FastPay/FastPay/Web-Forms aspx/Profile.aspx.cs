using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FastPay
{
    public partial class Profile : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            // Get the UserId from the Session variable
                int userId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 3;

            // Define the SQL query to retrieve the user information
            string sql = "SELECT FirstName, LastName, Email, PhoneNumber, Address FROM Users WHERE UserId = @UserId";

            // Retrieve the connection string from the Web.config file
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString;

            // Create a new SqlConnection object and open the connection
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // Create a new SqlCommand object with the SQL query and the SqlConnection object
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    // Add the UserId parameter to the SqlCommand object
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    // Execute the SQL query and get the result
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        // Check if the result contains any data
                        if (reader.HasRows)
                        {
                            // Loop through the result and retrieve the user information
                            while (reader.Read())
                            {
                                string firstName = reader.IsDBNull(0) ? string.Empty : reader.GetString(0);
                                string lastName = reader.IsDBNull(1) ? string.Empty : reader.GetString(1);
                                string email = reader.IsDBNull(2) ? string.Empty : reader.GetString(2);
                                string phoneNumber = reader.IsDBNull(3) ? string.Empty : reader.GetString(3);
                                string address = reader.IsDBNull(4) ? string.Empty : reader.GetString(4);

                                // Store the user information in the Session variables
                                Session["UserName"] = firstName + " " + lastName;
                                Session["UserEmail"] = email;
                                Session["UserPhoneNumber"] = phoneNumber;
                                Session["UserAddress"] = address;
                            }
                        }
                    }
                }
            }
        }
        protected void UpdatePersonalInfo_Click(object sender, EventArgs e)
        {
                int userId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 3;
            string email = this.email.Text;
            string phoneNumber = this.phoneNumber.Text;

            using (SqlConnection connection = new SqlConnection("FastPayConnectionString"))
            {
                string query = "UPDATE Users SET Email=@Email, PhoneNumber=@PhoneNumber WHERE UserId=@UserId";

                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@UserId", userId);
                    command.Parameters.AddWithValue("@Email", email);
                    command.Parameters.AddWithValue("@PhoneNumber", phoneNumber);

                    connection.Open();
                    command.ExecuteNonQuery();
                    connection.Close();
                }
            }

            Session["UserEmail"] = email;
            Session["UserPhoneNumber"] = phoneNumber;
        }

        protected void ChangePassword_Click(object sender, EventArgs e)
        {
                int userId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 3;
            string currentPassword = this.currentPassword.Text;
            string newPassword = this.newPassword.Text;
            string confirmNewPassword = this.confirmNewPassword.Text;

            if (newPassword == confirmNewPassword)
            {
                using (SqlConnection connection = new SqlConnection("FastPayConnectionString"))
                {
                    string query = "UPDATE Users SET Password=@Password WHERE UserId=@UserId AND Password=@CurrentPassword";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@UserId", userId);
                        command.Parameters.AddWithValue("@Password", newPassword);
                        command.Parameters.AddWithValue("@CurrentPassword", currentPassword);

                        connection.Open();
                        int rowsAffected = command.ExecuteNonQuery();
                        connection.Close();

                        if (rowsAffected > 0)
                        {
                           // this.changePasswordMessage.InnerText = "Password changed successfully.";
                        }
                        else
                        {
                            //this.changePasswordMessage.InnerText = "Failed to change password. Make sure you entered the correct current password.";
                        }
                    }
                }
            }
            else
            {
                //this.changePasswordMessage.InnerText = "New password and confirm new password do not match.";
            }
        }
    }
}
    

