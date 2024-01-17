using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI.WebControls;

namespace FastPay
{
    public partial class register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            Response.Redirect("Login.aspx");

        }
        protected void registerButton_Click(object sender, EventArgs e)
        {
            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString;



                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    // Get the maximum UserId from the Users table
                    string getMaxUserIdQuery = "SELECT MAX(UserId) FROM Users";
                    int maxUserId;

                    using (SqlCommand getMaxUserIdCommand = new SqlCommand(getMaxUserIdQuery, connection))
                    {
                        connection.Open();
                        object result = getMaxUserIdCommand.ExecuteScalar();
                        maxUserId = result == DBNull.Value ? 0 : Convert.ToInt32(result);
                        connection.Close();
                    }

                    int newUserId = maxUserId + 1; // Increment UserId by 1

                    string query = "INSERT INTO Users (UserId,FirstName, LastName, Email, PhoneNumber, Password, Address, City, State, Zipcode) VALUES (@UserId,@FirstName, @LastName, @Email, @PhoneNumber, @Password, @Address, @City, @State, @Zipcode)";

                    using (SqlCommand command = new SqlCommand(query, connection))
                    {
                        command.Parameters.AddWithValue("@UserId", newUserId);
                        command.Parameters.AddWithValue("@FirstName", firstname.Text);
                        command.Parameters.AddWithValue("@LastName", lastname.Text);
                        command.Parameters.AddWithValue("@Email", email.Text);
                        command.Parameters.AddWithValue("@PhoneNumber", phonenumber.Text);
                        command.Parameters.AddWithValue("@Password", password.Text);

                        //// Save uploaded image
                        //if (userImageUpload.HasFile)
                        //{
                        //    string fileName = Path.GetFileName(userImageUpload.FileName);
                        //    string uploadFolderPath = Server.MapPath("~/UploadedImages/");
                        //    string filePath = Path.Combine(uploadFolderPath, fileName);
                        //    userImageUpload.SaveAs(filePath);
                        //    command.Parameters.AddWithValue("@UserPicture", "~/UploadedImages/" + fileName);
                        //}
                        //else
                        //{
                        //    command.Parameters.AddWithValue("@UserPicture", DBNull.Value);
                        //}

                        command.Parameters.AddWithValue("@Address", address.Text);
                        command.Parameters.AddWithValue("@City", cityDropDownList.SelectedValue);
                        command.Parameters.AddWithValue("@State", provinceDropDownList.SelectedValue);
                        command.Parameters.AddWithValue("@Zipcode", postalcode.Text);

                        connection.Open();
                        command.ExecuteNonQuery();
                    }
                }

                Response.Redirect("Login.aspx");
            }
            catch (Exception ex)
            {
                //ErrorMessage.Text = "An error occurred: " + ex.Message;
            }
        }
    }
}
