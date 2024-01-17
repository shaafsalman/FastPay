using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;
using System.Collections.Generic;
using System.Data;

namespace FastPay
{
    public partial class Transfer : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUserAccounts();
                LoadBeneficiaries();
            }
        }
        private void LoadBeneficiaries()
        {
            chooseBeneficiary.Items.Clear();
            int currentUserId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 3;
            List<Beneficiary> beneficiaries = GetBeneficiaries(currentUserId);
            foreach (Beneficiary beneficiary in beneficiaries)
            {
                ListItem item = new ListItem();
                item.Text = beneficiary.BeneficiaryId + " - " + beneficiary.Name + " (" + beneficiary.AccountNumber + ")";
                item.Value = beneficiary.AccountNumber;
                chooseBeneficiary.Items.Add(item);
            }
        }
        private int GetAccountIdByAccountNumber(string accountNumber)
        {
            int accountId = -1;
            string connString = ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connString))
            {
                connection.Open();

                using (SqlCommand cmd = new SqlCommand("SELECT AccountId FROM Accounts WHERE AccountNumber = @AccountNumber", connection))
                {
                    cmd.Parameters.AddWithValue("@AccountNumber", accountNumber);

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


        // Retrieves the name of the recipient associated with the specified account number
        private string GetRecipientName(string accountNumber)
        {
            string recipientName = null;

            string connString = ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connString))
            {
                connection.Open();

                using (SqlCommand cmd = new SqlCommand("SELECT FirstName, LastName FROM Users WHERE Email = (SELECT Email FROM Accounts INNER JOIN Users ON Accounts.UserId = Users.UserId WHERE AccountNumber = @AccountNumber)", connection))
                {
                    cmd.Parameters.AddWithValue("@AccountNumber", accountNumber);

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.HasRows)
                    {
                        reader.Read();
                        recipientName = reader["FirstName"].ToString() + " " + reader["LastName"].ToString();
                    }

                    reader.Close();
                }
            }

            return recipientName;
        }

        // Retrieves a list of beneficiaries associated with the specified recipient account number
        private List<Beneficiary> GetBeneficiaries(int userId)
        {
            List<Beneficiary> beneficiaries = new List<Beneficiary>();

            string connString = ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connString))
            {
                connection.Open();

                using (SqlCommand cmd = new SqlCommand("SELECT BeneficiaryId, Name, AccountNumber FROM Beneficiaries WHERE AccountId IN (SELECT AccountId FROM Accounts WHERE UserId = @UserId)", connection))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    SqlDataReader reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        Beneficiary beneficiary = new Beneficiary();
                        beneficiary.BeneficiaryId = Convert.ToInt32(reader["BeneficiaryId"]);
                        beneficiary.Name = reader["Name"].ToString();
                        beneficiary.AccountNumber = reader["AccountNumber"].ToString();
                        beneficiaries.Add(beneficiary);
                    }

                    reader.Close();
                }
            }

            return beneficiaries;
        }



        // Retrieves the name of the beneficiary associated with the specified account number
        private string GetBeneficiaryName(string accountNumber)
        {
            string beneficiaryName = null;

            string connString = ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connString))
            {
                connection.Open();

                using (SqlCommand cmd = new SqlCommand("SELECT Name FROM Beneficiaries WHERE AccountNumber = @AccountNumber", connection))
                {
                    cmd.Parameters.AddWithValue("@AccountNumber", accountNumber);

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.HasRows)
                    {
                        reader.Read();
                        beneficiaryName = reader["Name"].ToString();
                    }

                    reader.Close();
                }
            }

            return beneficiaryName;
        }

        // Retrieves the balance of the specified account
        private decimal GetAccountBalance(int accountId)
        {
            decimal balance = 0;

            string connString = ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connString))
            {
                connection.Open();

                using (SqlCommand cmd = new SqlCommand("SELECT Balance FROM Accounts WHERE AccountId = @AccountId", connection))
                {
                    cmd.Parameters.AddWithValue("@AccountId", accountId);

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.HasRows)
                    {
                        reader.Read();
                        balance = Convert.ToDecimal(reader["Balance"]);
                    }

                    reader.Close();
                }
            }

            return balance;
        }
        
        private void AddTransaction(int currentUserAccountId, int beneficiaryAccountId, decimal transferAmount, DateTime transactionDate, string reason)
        {
            string connString = ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connString))
            {
                connection.Open();

                // Retrieve the maximum TransactionId value from the Transactions table
                int maxTransactionId;
                using (SqlCommand cmd = new SqlCommand("SELECT ISNULL(MAX(TransactionId), 0) AS MaxTransactionId FROM Transactions", connection))
                {
                    maxTransactionId = (int)cmd.ExecuteScalar();
                }

                // Increment the maxTransactionId to create a new transactionId
                int newTransactionId = maxTransactionId + 1;

                // Insert the new transaction
                using (SqlCommand cmd = new SqlCommand("INSERT INTO Transactions (TransactionId, AccountId, RecipientAccount_id, Amount, TransactionDate, Reason) VALUES (@TransactionId, @AccountId, @RecipientAccount_id, @Amount, @TransactionDate, @Reason)", connection))
                {
                    cmd.Parameters.AddWithValue("@TransactionId", newTransactionId);
                    cmd.Parameters.AddWithValue("@AccountId", currentUserAccountId);
                    cmd.Parameters.AddWithValue("@RecipientAccount_id", beneficiaryAccountId);
                    cmd.Parameters.AddWithValue("@Amount", transferAmount);
                    cmd.Parameters.AddWithValue("@TransactionDate", transactionDate);
                    cmd.Parameters.AddWithValue("@Reason", reason);
                    cmd.ExecuteNonQuery();
                }
            }
        }
        protected void LoadBeneficiaryButton_Click(object sender, EventArgs e)
        {
            string selectedBeneficiary = chooseBeneficiary.SelectedValue;
            if (!string.IsNullOrEmpty(selectedBeneficiary))
            {
                recipientAccountNumberTextBox.Text = selectedBeneficiary;
                VerifyButton_Click(sender, e);
            }
            else
            {
                recipientNameLabel.Text = "Please select a beneficiary from the dropdown list.";
            }
        }

        private void UpdateAccountBalance(int currentUserAccountId, decimal newBalance)
        {
            string connString = ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connString))
            {
                connection.Open();

                using (SqlCommand cmd = new SqlCommand("UPDATE Accounts SET Balance = @NewBalance WHERE AccountId = @AccountId", connection))
                {
                    cmd.Parameters.AddWithValue("@NewBalance", newBalance);
                    cmd.Parameters.AddWithValue("@AccountId", currentUserAccountId);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private decimal GetTransactionLimit(int accountId)
        {
            decimal transactionLimit = 0;

            string connString = ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connString))
            {
                connection.Open();

                using (SqlCommand cmd = new SqlCommand("SELECT TransactionLimit FROM Accounts WHERE AccountId = @AccountId", connection))
                {
                    cmd.Parameters.AddWithValue("@AccountId", accountId);

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.HasRows)
                    {
                        reader.Read();
                        transactionLimit = Convert.ToDecimal(reader["TransactionLimit"]);
                    }

                    reader.Close();
                }
            }

            return transactionLimit;
        }

        private void LoadUserAccounts()
        {
            int currentUserId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 3;

            string connString = ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connString))
            {
                connection.Open();

                using (SqlCommand cmd = new SqlCommand("SELECT AccountId, AccountNumber FROM Accounts WHERE UserId = @UserId", connection))
                {
                    cmd.Parameters.AddWithValue("@UserId", currentUserId);

                    SqlDataReader reader = cmd.ExecuteReader();
                    if (reader.HasRows)
                    {
                        while (reader.Read())
                        {
                            ListItem accountItem = new ListItem(reader["AccountNumber"].ToString(), reader["AccountId"].ToString());
                            userAccount.Items.Add(accountItem);
                        }
                    }
                    else
                    {
                        transferStatus.InnerHtml = "You don't have any accounts to transfer from.";
                    }

                    reader.Close();
                }
            }
        }

        protected void VerifyButton_Click(object sender, EventArgs e)
        {
            string recipientAccountNumber = recipientAccountNumberTextBox.Text;
            if (string.IsNullOrEmpty(recipientAccountNumber))
            {
                // Handle the case where the recipient account number is empty or null
                return;
            }

            string recipientName = GetRecipientName(recipientAccountNumber);
            recipientNameLabel.Text = recipientName;
        }




        protected void ProceedButton_Click(object sender, EventArgs e)
        {
            decimal transferAmount;
            if (!decimal.TryParse(transferAmountTextBox.Text, out transferAmount))
            {
                transferStatus.InnerHtml = "Invalid transfer amount.";
                return;
            }

            // Retrieve the recipient name and beneficiary name
            string recipientName = recipientNameLabel.Text;
            string beneficiaryAccountNumber = chooseBeneficiary.SelectedValue;
            string beneficiaryName = GetBeneficiaryName(beneficiaryAccountNumber);

            // Retrieve the beneficiary account ID
            int beneficiaryAccountId = GetAccountIdByAccountNumber(beneficiaryAccountNumber); // Implement this method to retrieve the account ID using the account number.

            // Retrieve the current account balance
            int currentUserId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 3;
            int currentUserAccountId = Convert.ToInt32(userAccount.SelectedValue);
            decimal currentBalance = GetAccountBalance(currentUserAccountId);

            // Retrieve the transfer amount
            transferAmount = Convert.ToDecimal(transferAmountTextBox.Text);

            // Check if the transfer amount is within the transaction limit
            decimal transactionLimit = GetTransactionLimit(currentUserAccountId);
            if (transferAmount > transactionLimit)
            {
                transferStatus.InnerHtml = "Transfer amount exceeds transaction limit.";
                return;
            }

            // Check if the current account has sufficient balance
            if (transferAmount > currentBalance)
            {
                transferStatus.InnerHtml = "Insufficient balance.";
                return;
            }


            // Update the transaction history
            AddTransaction(currentUserAccountId, beneficiaryAccountId, transferAmount, DateTime.Now, transferReasonTextBox.Text);

            // Update the sender account balance
            UpdateAccountBalance(currentUserAccountId, currentBalance - transferAmount);

            // Update the receiver account balance
            decimal beneficiaryBalance = GetAccountBalance(beneficiaryAccountId);
            UpdateAccountBalance(beneficiaryAccountId, beneficiaryBalance + transferAmount);

            // Update the UI
            transferStatus.InnerHtml = "Transfer successful.";
        }



    }
}
