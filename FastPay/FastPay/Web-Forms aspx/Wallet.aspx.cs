using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FastPay
{
    public partial class Wallet : System.Web.UI.Page
    {
        // Connection string to the database
        string connectionString = ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindAccountBalances();
                UpdateCardInfo(0);
                int userId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 3;
                List<Account> accounts = GetAccountsByUserId(userId);
                rptAccounts.DataSource = accounts;
                rptAccounts.DataBind();
                List<Card> cards = GetCards();
                if (cards.Count > 0)
                {
                    DisplayCard(cards[0]);
                }
                CheckAndUpdateButtonStatus(userId);
            }
        }
        
        private void DisplayCard(Card card)
        {
            // Set distributor logo
            switch (card.Distributor.ToLower())
            {
                case "visa":
                    imgDistributorLogo.ImageUrl = "https://i.ibb.co/WHZ3nRJ/visa.png";
                    break;
                case "mastercard":
                    imgDistributorLogo.ImageUrl = "https://i.ibb.co/GWX8Kyg/Master-Card.jpg";
                    break;
                default:
                    imgDistributorLogo.Visible = false;
                    break;
            }

            // Update other card details
            lblCardNumber.InnerHtml = $"{card.CardNumber.Substring(0, 4)}&emsp;{card.CardNumber.Substring(4, 4)}&emsp;{card.CardNumber.Substring(8, 4)}&emsp;{card.CardNumber.Substring(12, 4)}";
            lblCardHolderName.Text = card.CardHolderName;
            lblExpirationDate.Text = card.ExpirationDate.ToString("MM / yy");
            lblCVC.InnerText = card.CVC;
        }

        private void CheckAndUpdateButtonStatus(int userId)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                using (SqlCommand cmd = new SqlCommand("SELECT IsActive FROM Cards WHERE UserId = @UserId", con))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            bool isActive = reader.GetBoolean(0);

                            btnActivateCard.Enabled = !isActive;
                            btnFreezeCard.Enabled = isActive;
                        }
                    }
                }
            }
        }



        protected void btnActivateCard_Click(object sender, EventArgs e)
        {
            int userId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 3; // Retrieve UserId from session
            ActivateOrFreezeCard(userId, true, "activate");
        }

        protected void btnFreezeCard_Click(object sender, EventArgs e)
        {
            int userId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 3; // Retrieve UserId from session
            ActivateOrFreezeCard(userId, false, "freeze");
        }

        protected void btnOrderNewCard_Click(object sender, EventArgs e)
        {
            int userId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 3; // Retrieve UserId from session
            OrderNewCard(userId);
        }

        private void ActivateOrFreezeCard(int userId, bool status, string action)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                using (SqlCommand cmd = new SqlCommand("UPDATE Cards SET IsActive = @IsActive WHERE UserId = @UserId", con))
                {
                    cmd.Parameters.AddWithValue("@IsActive", status);
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    int updatedRows = cmd.ExecuteNonQuery();
                    if (updatedRows == 0)
                    {
                        // Handle the case when the update fails
                    }
                }

                if (action == "freeze")
                {
                    using (SqlCommand cmd = new SqlCommand("UPDATE Cards SET IsActive = @IsActive WHERE UserId = @UserId", con))
                    {
                        cmd.Parameters.AddWithValue("@IsActive", false);
                        cmd.Parameters.AddWithValue("@UserId", userId);

                        int updatedRows = cmd.ExecuteNonQuery();
                        if (updatedRows == 0)
                        {
                            // Handle the case when the update fails
                        }
                    }
                }

                CheckAndUpdateButtonStatus(userId);
            }
        }


        private void OrderNewCard(int userId)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();

                // Get the maximum CardId for the given UserId
                int maxCardId = 0;
                using (SqlCommand cmd = new SqlCommand("SELECT MAX(CardId) FROM Cards WHERE UserId = @UserId", con))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    object result = cmd.ExecuteScalar();
                    if (result != DBNull.Value)
                    {
                        maxCardId = Convert.ToInt32(result);
                    }
                }

                // Generate new card details
                string newCardNumber = GenerateNewCardNumber();
                string newCardCVC = GenerateNewCVC();
                DateTime expirationDate = DateTime.Now.AddYears(3);

                using (SqlCommand cmd = new SqlCommand("INSERT INTO Cards (CardId, UserId, CardNumber, ExpirationDate, CVC, IsActive) VALUES (@CardId, @UserId, @CardNumber, @ExpirationDate, @CVC, @IsActive)", con))
                {
                    cmd.Parameters.AddWithValue("@CardId", maxCardId + 1);
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@CardNumber", newCardNumber);
                    cmd.Parameters.AddWithValue("@ExpirationDate", expirationDate);
                    cmd.Parameters.AddWithValue("@CVC", newCardCVC);
                    cmd.Parameters.AddWithValue("@IsActive", true);

                    int insertedRows = cmd.ExecuteNonQuery();
                    if (insertedRows == 0)
                    {
                        // Handle the case when the insertion fails
                    }
                }
            }
        }


        private string GenerateNewCardNumber()
        {
            Random random = new Random();
            string cardNumber = "";
            for (int i = 0; i < 16; i++)
            {
                cardNumber += random.Next(0, 10).ToString();
            }
            return cardNumber;
        }

        private string GenerateNewCVC()
        {
            Random random = new Random();
            string cvc = "";
            for (int i = 0; i < 3; i++)
            {
                cvc += random.Next(0, 10).ToString();
            }
            return cvc;
        }

        public class AccountData
        {
            public decimal transaction_limit { get; set; }
            public string pin { get; set; }
        }

        public List<Account> GetAccountsByUserId(int userId)
        {
            List<Account> accounts = new List<Account>();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                string query = "SELECT * FROM Accounts WHERE UserId = @UserId";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@UserId", userId);
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            accounts.Add(new Account
                            {
                                AccountId = Convert.ToInt32(reader["AccountId"]),
                                AccountType = reader["AccountType"].ToString(),
                                AccountNumber = reader["AccountNumber"].ToString(),
                                Balance = Convert.ToDecimal(reader["Balance"]),
                                TransactionLimit = Convert.ToDecimal(reader["TransactionLimit"]),
                                Pin = reader["Pin"].ToString()
                            });
                        }
                    }
                }
            }

            return accounts;
        }

      
        protected void BindAccountBalances()
        {
            int userId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 3;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT AccountType, AccountNumber, Balance FROM Accounts WHERE UserId = @UserId";
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@UserId", userId);

                try
                {
                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();
                    GridViewAccountBalances.DataSource = reader;
                    GridViewAccountBalances.DataBind();
                    reader.Close();
                }
                catch (Exception ex)
                {
                    // Handle exception
                }
            }
        }


        private int GetNextAccountId()
        {
            int maxAccountId = 0;

            using (SqlConnection connection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand command = new SqlCommand("SELECT MAX(AccountId) FROM Accounts", connection))
                {
                    object result = command.ExecuteScalar();
                    if (result != DBNull.Value)
                    {
                        maxAccountId = Convert.ToInt32(result);
                    }
                }
            }

            return maxAccountId + 1;
        }
        private bool IsAccountNumberUnique(string accountNumber)
        {
            using (SqlConnection connection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand command = new SqlCommand("SELECT COUNT(*) FROM Accounts WHERE AccountNumber = @AccountNumber", connection))
                {
                    command.Parameters.AddWithValue("@AccountNumber", accountNumber);

                    int count = Convert.ToInt32(command.ExecuteScalar());
                    return count == 0;
                }
            }
        }

        protected void AddAccount_Click(object sender, EventArgs e)
        {
            string selectedAccountType = accountType.SelectedValue;
            decimal openingBalanceValue;
            string accountNumberValue = accountNumber.Text;
            decimal transactionLimitValue;
            string pinValue = pin.Text;

            if (string.IsNullOrEmpty(selectedAccountType) ||
                    !decimal.TryParse(openingBalance.Text, out openingBalanceValue) ||
                    !decimal.TryParse(transactionLimit.Text, out transactionLimitValue) ||
                    string.IsNullOrEmpty(accountNumberValue) ||
                    string.IsNullOrEmpty(pinValue) ||
                    pinValue.Length != 4)
            {
                // Show an error message
                errorMessageLabel.Text = "Please fill in all required fields with valid values.";
                errorMessageLabel.Visible = true;
                return;
            }
            if (!IsAccountNumberUnique(accountNumberValue))
            {
                errorMessageLabel.Text = "Please Add Unique Account Number ";
                errorMessageLabel.Visible = true;
                return;
            }
            int accountId = GetNextAccountId();

            SaveAccount(accountId, Convert.ToInt32(Session["UserId"]), selectedAccountType, openingBalanceValue, accountNumberValue, transactionLimitValue, pinValue);

            // Clear the form fields after successful submission
            accountType.SelectedIndex = 0;
            openingBalance.Text = "";
            accountNumber.Text = "";
            transactionLimit.Text = "";
            pin.Text = "";

            // Hide the error message label if it was shown before
            errorMessageLabel.Visible = false;

            // Close the modal or update the UI to reflect the successful addition of the account
            // Add your JavaScript function call here to close the modal or update the UI as needed
            ScriptManager.RegisterStartupScript(this, this.GetType(), "CloseModal", "hideAddAccountModal();", true);
        }

        private void SaveAccount(int accountId, int userId, string accountType, decimal openingBalance, string accountNumber, decimal transactionLimit, string pin)
        {
            using (SqlConnection connection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString))
            {
                connection.Open();
                using (SqlCommand command = new SqlCommand("INSERT INTO Accounts (AccountId, UserId, Balance, AccountType, AccountNumber,TransactionLimit,Pin) VALUES (@AccountId, @UserId, @Balance, @AccountType, @AccountNumber,@TransactionLimit,@Pin)", connection))
                {
                    command.Parameters.AddWithValue("@AccountId", accountId);
                    command.Parameters.AddWithValue("@UserId", userId);
                    command.Parameters.AddWithValue("@Balance", openingBalance);
                    command.Parameters.AddWithValue("@AccountType", accountType);
                    command.Parameters.AddWithValue("@AccountNumber", accountNumber);
                    command.Parameters.AddWithValue("@TransactionLimit", transactionLimit);
                    command.Parameters.AddWithValue("@Pin", pin);


                    command.ExecuteNonQuery();
                }
            }
        }





        public List<Card> GetCards()
        {
                           int userId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 3;
            List<Card> cards = new List<Card>();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = @"
            SELECT c.CardId, c.CardType, c.Distributor, c.IsActive, c.CardNumber, 
                   c.ExpirationDate, c.CVC, u.FirstName, u.LastName
            FROM Cards c
            INNER JOIN Users u ON c.UserId = u.UserId
            WHERE c.UserId = @UserId";
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@UserId", userId);

                try
                {
                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                        Card card = new Card();
                        card.CardType = reader["CardType"].ToString();
                        card.Distributor = reader["Distributor"].ToString();
                        card.IsActive = (bool)reader["IsActive"];
                        card.CardNumber = reader["CardNumber"].ToString();
                        card.ExpirationDate = (DateTime)reader["ExpirationDate"];
                        card.CVC = reader["CVC"].ToString();
                        card.CardHolderName = $"{reader["FirstName"]} {reader["LastName"]}";
                        cards.Add(card);
                    }
                    reader.Close();
                }
                catch (Exception ex)
                {
                    // Handle exception
                }
            }

            return cards;
        }

        protected void UpdateCardInfo(int cardIndex)
        {
            List<Card> cards = GetCards();
            if (cards.Count > cardIndex)
            {
                lblCardNumber.InnerText = cards[cardIndex].CardType;

                string cardNumber = cards[cardIndex].CardNumber;
                lblCardNumber.InnerHtml = $"{cardNumber.Substring(0, 4)}&emsp;{cardNumber.Substring(4, 4)}&emsp;{cardNumber.Substring(8, 4)}&emsp;{cardNumber.Substring(12, 4)}";

                lblCardHolderName.Text = cards[cardIndex].CardHolderName;

                lblExpirationDate.Text = cards[cardIndex].ExpirationDate.ToString("MM / yy");

                lblCVC.InnerText = cards[cardIndex].CVC;

                ViewState["CurrentCardIndex"] = cardIndex;

                btnLeftArrow.Enabled = (cardIndex > 0);

                btnRightArrow.Enabled = (cardIndex < cards.Count - 1);
            }
        }

        private int GetCurrentCardIndex()
        {
            if (ViewState["CurrentCardIndex"] == null)
            {
                ViewState["CurrentCardIndex"] = 0;
            }
            return (int)ViewState["CurrentCardIndex"];
        }

        private void SetCurrentCardIndex(int index)
        {
            ViewState["CurrentCardIndex"] = index;
        }


        protected void btnLeftArrow_Click(object sender, EventArgs e)
        {
            int currentIndex = GetCurrentCardIndex();
            if (currentIndex > 0)
            {
                currentIndex--;
                SetCurrentCardIndex(currentIndex);
                UpdateCardInfo(currentIndex);
            }
        }

        protected void btnRightArrow_Click(object sender, EventArgs e)
        {
            int currentIndex = GetCurrentCardIndex();
            List<Card> cards = GetCards();
            if (currentIndex < cards.Count - 1)
            {
                currentIndex++;
                SetCurrentCardIndex(currentIndex);
                UpdateCardInfo(currentIndex);
            }
        }

        private void UpdateTransactionLimitAndPin(int accountId, decimal transactionLimit, string pin)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string updateQuery = "UPDATE Accounts SET TransactionLimit = @TransactionLimit, Pin = @Pin WHERE AccountId = @AccountId";
                using (SqlCommand command = new SqlCommand(updateQuery, connection))
                {
                    command.Parameters.AddWithValue("@TransactionLimit", transactionLimit);
                    command.Parameters.AddWithValue("@Pin", pin);
                    command.Parameters.AddWithValue("@AccountId", accountId);

                    command.ExecuteNonQuery();
                }
            }
        }

        protected void UpdateLimits_Click(object sender, EventArgs e)
        {
            // Loop through the accounts and update their transaction limits and PINs
            foreach (RepeaterItem item in rptAccounts.Items)
            {
                if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
                {
                    int accountId = Convert.ToInt32(((HiddenField)item.FindControl("hfAccountId")).Value);
                    TextBox txtTransactionLimit = item.FindControl("txtTransactionLimit") as TextBox;
                    TextBox txtPin = item.FindControl("txtPin") as TextBox;

                    if (txtTransactionLimit != null && txtPin != null)
                    {
                        decimal transactionLimit = Convert.ToDecimal(txtTransactionLimit.Text);
                        string pin = txtPin.Text;

                        // Update the transaction limit and PIN in the database
                        UpdateTransactionLimitAndPin(accountId, transactionLimit, pin);
                    }
                }
            }

            // Show a message to the user that the limits and PINs were updated successfully
            // You can use a label or any other way you prefer to display the message
        }

        public class Account
        {
            public int AccountId { get; set; }
            public string AccountType { get; set; }
            public string AccountNumber { get; set; }
            public decimal Balance { get; set; }
            public decimal TransactionLimit { get; set; }
            public string Pin { get; set; }
        }
        // Card class to store card information
        public class Card
        {
            public string CardType { get; set; }
            public string Distributor { get; set; }
            public bool IsActive { get; set; }
            public string CardNumber { get; set; }
            public DateTime ExpirationDate { get; set; }
            public string CVC { get; set; }
            public string CardHolderName { get; set; }

        }
    }
}
