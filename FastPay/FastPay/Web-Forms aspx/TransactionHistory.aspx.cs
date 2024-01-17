using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace FastPay
{
    public partial class TransactionHistory : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadTransactionHistory();
            }
        }

        private void LoadTransactionHistory()
        {
            int userId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 3;
            string connectionString = ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                // Query for transaction history
                using (SqlCommand command = new SqlCommand("SELECT t.TransactionId, a.AccountNumber, t.Amount, t.TransactionDate, t.Reason, u1.FirstName + ' ' + u1.LastName AS SenderName, CASE WHEN t.Reason = 'Bill Payment' THEN b.BillerName WHEN t.Reason LIKE 'Subscription to %' THEN s.Name ELSE u2.FirstName + ' ' + u2.LastName END AS ReceiverName FROM Transactions t INNER JOIN Accounts a ON t.AccountId = a.AccountId INNER JOIN Users u1 ON a.UserId = u1.UserId LEFT JOIN Accounts a2 ON t.RecipientAccount_id = a2.AccountId LEFT JOIN Users u2 ON a2.UserId = u2.UserId LEFT JOIN Billing b ON t.RecipientAccount_id = b.BillingId LEFT JOIN Subscriptions s ON t.RecipientAccount_id = s.SubscriptionId WHERE u1.UserId = @UserId", connection))
                {
                    command.Parameters.AddWithValue("@UserId", userId);

                    SqlDataAdapter adapter = new SqlDataAdapter(command);
                    DataTable transactionHistoryTable = new DataTable();
                    adapter.Fill(transactionHistoryTable);

                    TransactionHistoryGridView.DataSource = transactionHistoryTable;
                    TransactionHistoryGridView.DataBind();
                }
            }
        }

    }




}

