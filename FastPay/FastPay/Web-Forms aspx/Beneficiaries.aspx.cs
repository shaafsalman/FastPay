using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace FastPay
{
    public class Beneficiary
    {
        public int BeneficiaryId { get; set; }
        public int AccountId { get; set; }
        public string Name { get; set; }
        public string AccountNumber { get; set; }
        public string Relationship { get; set; }
    }

    public partial class Beneficiaries : System.Web.UI.Page
    {
        public List<Beneficiary> beneficiaries;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int userId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 3;

                List<Beneficiary> beneficiaries = GetBeneficiaries(userId);
                rptBeneficiaries.DataSource = beneficiaries;
                rptBeneficiaries.DataBind();
            }
        }


        private int GetAccountIdByUserID( int userId)
        {
            int accountId = -1;
            string connString = ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connString))
            {
                connection.Open();

                using (SqlCommand cmd = new SqlCommand("SELECT AccountId FROM Accounts WHERE UserId = @UserId", connection))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.HasRows)
                    {
                        while (reader.Read())
                        {
                            accountId = reader.GetInt32(0);
                        }
                    }
                    reader.Close();
                }
            }
            return accountId;
        }

        protected void AddBeneficiary_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserId"]);

            int accountId = Convert.ToInt32(AccountId.Text);
            string relationshipValue = relationship.SelectedValue;

            if (string.IsNullOrEmpty(relationshipValue))
            {
                // Show an error message: Relationship is required
                return;
            }

            string connectionString = ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                SqlCommand command = new SqlCommand("SELECT COUNT(*) FROM Beneficiaries WHERE AccountId = @AccountId AND Name = @Name", connection);
                command.Parameters.AddWithValue("@AccountId", accountId);
                command.Parameters.AddWithValue("@Name", accountName.Text);

                int count = (int)command.ExecuteScalar();
                if (count > 0)
                {
                    // Beneficiary already exists
                    // Display an error message or handle the error as appropriate
                    return;
                }
            }

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                int accountid = GetAccountIdByUserID(Convert.ToInt32(Session["UserId"]));
                

                SqlCommand command = new SqlCommand("INSERT INTO Beneficiaries (BeneficiaryId, AccountId, Name, AccountNumber, Relationship) VALUES ((SELECT ISNULL(MAX(BeneficiaryId), 0) + 1 FROM Beneficiaries), @accountid, @Name, @AccountNumber, @Relationship)", connection);
                command.Parameters.AddWithValue("@AccountId", accountid);
                command.Parameters.AddWithValue("@Name", accountName.Text);
                command.Parameters.AddWithValue("@AccountNumber", accountNumber.Text);
                command.Parameters.AddWithValue("@Relationship", relationshipValue);

                int rowsAffected = command.ExecuteNonQuery();
                if (rowsAffected > 0)
                {
                    // Beneficiary was successfully added
                    // Reload the page to show updated list of beneficiaries
                    Response.Redirect(Request.RawUrl);
                }
                else
                {
                    // An error occurred while adding the beneficiary
                    // Display an error message or handle the error as appropriate
                }
            }
        }

        protected void VerifyAccount_Click(object sender, EventArgs e)
        {
            string accountNumberValue = accountNumber.Text.Trim();

            if (string.IsNullOrEmpty(accountNumberValue))
            {
                // Show error message: account number is required
                return;
            }

            Account account = GetAccountDetails(accountNumberValue);

            if (account != null)
            {
                // If the account exists, display its details
                AccountId.Text = account.AccountId.ToString();
                accountName.Text = account.AccountName;
                accountDetails.Visible = true;
            }
            else
            {
                // Show error message: Invalid account number
            }
        }

        private Account GetAccountDetails(string accountNumber)
        {
            Account account = null;

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString))
            {
                string query = "SELECT a.AccountId, a.AccountNumber, u.FirstName + ' ' + u.LastName AS AccountName " +
                               "FROM Accounts a " +
                               "JOIN Users u ON a.UserId = u.UserId " +
                               "WHERE a.AccountNumber = @AccountNumber";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@AccountNumber", accountNumber);

                    con.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.HasRows)
                        {
                            reader.Read();
                            account = new Account()
                            {
                                AccountId = Convert.ToInt32(reader["AccountId"]),
                                AccountNumber = reader["AccountNumber"].ToString(),
                                AccountName = reader["AccountName"].ToString()
                            };
                        }
                    }
                }
            }

            return account;
        }
   
        protected void rptBeneficiaries_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "RemoveBeneficiary")
            {
                int beneficiaryId = Convert.ToInt32(e.CommandArgument);
                // Your existing code to remove the beneficiary from the database
                // Remove the beneficiary from the database
                string connectionString = ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString;
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    SqlCommand command = new SqlCommand("DELETE FROM Beneficiaries WHERE BeneficiaryId = @BeneficiaryId", connection);
                    command.Parameters.AddWithValue("@BeneficiaryId", beneficiaryId);
                    int rowsAffected = command.ExecuteNonQuery();
                    if (rowsAffected > 0)
                    {
                        // Beneficiary was successfully removed
                        // Reload the page to show updated list of beneficiaries
                        Response.Redirect(Request.RawUrl);
                    }
                    else
                    {
                        // An error occurred while removing the beneficiary
                        // Display an error message or handle the error as appropriate
                    }
                }
            }
        }
     
        private List<Beneficiary> GetBeneficiaries(int userId)
        {
            List<Beneficiary> beneficiaries = new List<Beneficiary>();
            HashSet<string> uniqueAccountNumbers = new HashSet<string>();

            string connString = ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connString))
            {
                connection.Open();

                using (SqlCommand cmd = new SqlCommand("SELECT DISTINCT b.BeneficiaryId, b.AccountId, b.Name, b.AccountNumber, b.Relationship FROM Beneficiaries b JOIN Accounts a ON b.AccountId = a.AccountId WHERE a.UserId = @UserId", connection))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        string accountNumber = reader["AccountNumber"].ToString();
                        if (!uniqueAccountNumbers.Contains(accountNumber))
                        {
                            Beneficiary beneficiary = new Beneficiary();
                            beneficiary.BeneficiaryId = Convert.ToInt32(reader["BeneficiaryId"]);
                            beneficiary.AccountId = Convert.ToInt32(reader["AccountId"]);
                            beneficiary.Name = reader["Name"].ToString();
                            beneficiary.AccountNumber = accountNumber;
                            beneficiary.Relationship = reader["Relationship"].ToString();
                            beneficiaries.Add(beneficiary);

                            uniqueAccountNumbers.Add(accountNumber);
                        }
                    }

                    reader.Close();
                }
            }

            return beneficiaries;
        }
        public class Account
        {
            public int AccountId { get; set; }
            public string AccountNumber { get; set; }
            public string AccountName { get; set; }
        }
    }
}

