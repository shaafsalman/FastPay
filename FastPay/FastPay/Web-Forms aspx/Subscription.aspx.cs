// Subscription.aspx.cs
using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.Web.UI.WebControls;
using System.Runtime.Remoting.Lifetime;

namespace FastPay
{



    public partial class Subscription : System.Web.UI.Page
    {


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int userId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 3;
                LoadUserSubscriptions();
                LoadAllSubscriptions();

            }
        }

        private int GetDefaultAccountId(int userId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString;

       
             using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT TOP 1 AccountId FROM Accounts WHERE UserId = @UserId ORDER BY Balance DESC";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@UserId", userId);

                    connection.Open();
                    object result = command.ExecuteScalar();

                    if (result != null)
                    {
                        return Convert.ToInt32(result);
                    }
                }
             }

            return -1;
        }

        private decimal GetSubscriptionAmount(int subscriptionId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT RecurringAmount FROM Subscriptions WHERE SubscriptionId = @SubscriptionId";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@SubscriptionId", subscriptionId);

                    connection.Open();
                    object result = command.ExecuteScalar();

                    if (result != null)
                    {
                        return Convert.ToDecimal(result);
                    }
                }
            }

            return -1;
        }
        protected string GetSubscriptionName(int subscriptionId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString;
            string subscriptionName = "";

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT Name FROM Subscriptions WHERE SubscriptionId = @SubscriptionId";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@SubscriptionId", subscriptionId);

                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();

                    if (reader.Read())
                    {
                        subscriptionName = reader["Name"].ToString();
                    }

                    reader.Close();
                }
            }

            return subscriptionName;
        }

        protected bool IsUserSubscribed(int subscriptionId)
        {
                int userId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 3;
            string connectionString = ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                string query = "SELECT COUNT(*) FROM UserSubscriptions WHERE UserId = @UserId AND SubscriptionId = @SubscriptionId";
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.AddWithValue("@UserId", userId);
                    command.Parameters.AddWithValue("@SubscriptionId", subscriptionId);

                    connection.Open();
                    int count = (int)command.ExecuteScalar();

                    return count > 0;
                }
            }
        }



        protected string GetIconClass(string subscriptionName)
        {
            switch (subscriptionName.ToLower())
            {
                case "netflix":
                    return "fas fa-film";
                case "spotify":
                    return "fas fa-music";
                case "amazon prime":
                    return "fas fa-shopping-cart";
                case "hulu":
                    return "fas fa-tv";
                case "apple music":
                    return "fas fa-music";
                case "adobe creative cloud":
                    return "fas fa-palette";
                case "linkedin learning":
                    return "fas fa-book-open";
                case "microsoft office 365":
                    return "fas fa-file-alt";
                case "dropbox plus":
                    return "fas fa-cloud";
                case "grammarly premium":
                    return "fas fa-spell-check";
                // Add more cases for other subscription names
                default:
                    return "fas fa-question-circle";
            }
        }


        private void LoadUserSubscriptions()
        {
                int userId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 3;

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString))
            {
                con.Open();

                using (SqlCommand cmd = new SqlCommand("SELECT us.UserSubscriptionId, s.SubscriptionId, s.Name, s.Description, s.RecurringAmount, us.RenewalDate FROM Subscriptions s INNER JOIN UserSubscriptions us ON s.SubscriptionId = us.SubscriptionId WHERE us.UserId = @UserId", con))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);
                        rptUserSubscriptions.DataSource = dt;
                        rptUserSubscriptions.DataBind();
                    }
                }
            }
        }


        private void LoadAllSubscriptions()
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString))
            {
                con.Open();

                using (SqlCommand cmd = new SqlCommand("SELECT SubscriptionId, Name, Description, RecurringAmount FROM Subscriptions", con))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);
                        rptAllSubscriptions.DataSource = dt;
                        rptAllSubscriptions.DataBind();
                    }
                }
            }
        }

        protected void btnSubscribe_Click(object sender, EventArgs e)
        {
            // Get the subscription id from the command argument
            int subscriptionId = Convert.ToInt32((sender as Button).CommandArgument);
                int userId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 3;
            DateTime renewalDate = DateTime.Now.AddDays(30); // Set the renewal date 30 days from now

            // Get the user's default account for transactions
            int accountId = GetDefaultAccountId(userId);

            // Save the subscription to the UserSubscriptions table
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString))
            {
                string insertQuery = "INSERT INTO UserSubscriptions (UserSubscriptionId, UserId, SubscriptionId, RenewalDate) VALUES ((SELECT ISNULL(MAX(UserSubscriptionId), 0) + 1 FROM UserSubscriptions), @UserId, @SubscriptionId, @RenewalDate)";
                SqlCommand cmd = new SqlCommand(insertQuery, conn);
                cmd.Parameters.AddWithValue("@UserId", userId);
                cmd.Parameters.AddWithValue("@SubscriptionId", subscriptionId);
                cmd.Parameters.AddWithValue("@RenewalDate", renewalDate);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();

                    // Add a transaction entry for the subscription
                    decimal subscriptionAmount = GetSubscriptionAmount(subscriptionId);
                    string subscriptionName = GetSubscriptionName(subscriptionId);

                    string transactionQuery = "INSERT INTO Transactions (TransactionId, AccountId, RecipientAccount_id, Amount, TransactionDate, Reason) VALUES ((SELECT ISNULL(MAX(TransactionId), 0) + 1 FROM Transactions), @AccountId, @RecipientAccount_id, @Amount, @TransactionDate, @Reason)";
                    SqlCommand transactionCmd = new SqlCommand(transactionQuery, conn);
                    transactionCmd.Parameters.AddWithValue("@AccountId", accountId);
                    transactionCmd.Parameters.AddWithValue("@Amount", subscriptionAmount);
                    transactionCmd.Parameters.AddWithValue("@RecipientAccount_id", subscriptionId);
                    transactionCmd.Parameters.AddWithValue("@TransactionDate", DateTime.Now);
                    transactionCmd.Parameters.AddWithValue("@Reason", "Subscription to " + subscriptionName);

                    transactionCmd.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    // Handle exceptions
                }
                finally
                {
                    conn.Close();
                }
            }

            LoadUserSubscriptions();
            LoadAllSubscriptions();
        }

        protected void btnCancelSubscription_Click(object sender, EventArgs e)
        {
            int userSubscriptionId = Convert.ToInt32((sender as Button).CommandArgument);
                int userId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 3;

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString))
            {
                string deleteQuery = "DELETE FROM UserSubscriptions WHERE UserSubscriptionId = @UserSubscriptionId AND UserId = @UserId";
                SqlCommand cmd = new SqlCommand(deleteQuery, conn);
                cmd.Parameters.AddWithValue("@UserSubscriptionId", userSubscriptionId);
                cmd.Parameters.AddWithValue("@UserId", userId);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                }
            }

            LoadUserSubscriptions();
            LoadAllSubscriptions();
        }

    }

}



