using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FastPay
{

    public partial class BillPayment : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int userId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 3;
                LoadBasicFacilities();
                LoadPaidBills();
                LoadPendingBills();
            }
        }
        
        private void LoadPaidBills()
         {
                            int userId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 3;

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString))
            {
                con.Open();

                using (SqlCommand cmd = new SqlCommand("SELECT bp.BillPaymentId, b.BillerName, b.AccountNumber, bp.PaymentDate, bp.PaymentAmount FROM BillPayments bp INNER JOIN Billing b ON b.BillingId = bp.BillingId WHERE bp.UserId = @UserId AND bp.PaymentStatus = 'Paid'", con))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptPaidBills.DataSource = dt;
                    rptPaidBills.DataBind();
                }
            }
        }

        private void LoadPendingBills()
        {
                            int userId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 3;

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString))
            {
                con.Open();

                using (SqlCommand cmd = new SqlCommand("SELECT bp.BillPaymentId, b.BillerName, b.AccountNumber, bp.DueDate FROM BillPayments bp INNER JOIN Billing b ON b.BillingId = bp.BillingId WHERE bp.UserId = @UserId AND bp.PaymentStatus = 'Pending'", con))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptPendingBills.DataSource = dt;
                    rptPendingBills.DataBind();
                }
            }
        }
        private int GetBillingIdByBillPaymentId(int billPaymentId)
        {
            int billingId = -1;

            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString))
            {
                con.Open();

                using (SqlCommand cmd = new SqlCommand("SELECT BillingId FROM BillPayments WHERE BillPaymentId = @BillPaymentId", con))
                {
                    cmd.Parameters.AddWithValue("@BillPaymentId", billPaymentId);

                    object result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        billingId = Convert.ToInt32(result);
                    }
                }
            }

            return billingId;
        }

        protected void btnPayPendingBill_Command(object sender, CommandEventArgs e)
        {
            // Parse the CommandArgument (BillPaymentId) from the CommandEventArgs
            int billPaymentId;
            if (int.TryParse(e.CommandArgument.ToString(), out billPaymentId))
            {
                                int userId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 3;

                // Update the payment status for the selected bill
                UpdatePaymentStatus( billPaymentId);

                // Add a transaction for the bill payment
                int billingId = GetBillingIdByBillPaymentId(billPaymentId);
                AddTransaction(userId, billingId);

                // Reload the pending bills to reflect the changes
                LoadPendingBills();
            }
            else
            {
                // Handle the case when the CommandArgument is not a valid number.
                // You can show an error message or log the issue.
            }
        }

        public string GetBillerAccountNumber(int billingId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString;

            string query = "SELECT AccountNumber FROM Billing WHERE BillingId = @BillingId";

            using (SqlConnection connection = new SqlConnection(connectionString))
            using (SqlCommand command = new SqlCommand(query, connection))
            {
                command.Parameters.AddWithValue("@BillingId", billingId);

                connection.Open();
                string accountNumber = (string)command.ExecuteScalar();
                connection.Close();

                return accountNumber;
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
        private void LoadBasicFacilities()
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString))
            {
                con.Open();

                using (SqlCommand cmd = new SqlCommand("SELECT BillingId, BillerName FROM Billing", con))
                {
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    rptBasicFacilities.DataSource = dt;
                    rptBasicFacilities.DataBind();
                }
            }
        }

        private void GenerateNewBill(int billingId, int userId, decimal paymentAmount, DateTime dueDate)
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString))
            {
                con.Open();

                // Check if a bill for the same BillingId and UserId already exists with the status 'Pending'
                using (SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM BillPayments WHERE BillingId = @BillingId AND UserId = @UserId AND PaymentStatus = 'Pending'", con))
                {
                    checkCmd.Parameters.AddWithValue("@UserId", userId);
                    checkCmd.Parameters.AddWithValue("@BillingId", billingId);

                    int count = (int)checkCmd.ExecuteScalar();

                    // If a pending bill exists, skip the bill generation process
                    if (count > 0)
                    {
                        return;
                    }
                }

                using (SqlCommand cmd = new SqlCommand("INSERT INTO BillPayments (BillPaymentId,UserId, BillingId, PaymentAmount, PaymentDate, DueDate, PaymentStatus) \r\nVALUES ((SELECT ISNULL(MAX(BillPaymentId), 0) + 1 FROM BillPayments),@UserId, @BillingId, @PaymentAmount, NULL, @DueDate, 'Pending')\r\n", con))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@BillingId", billingId);
                    cmd.Parameters.AddWithValue("@PaymentAmount", paymentAmount);
                    cmd.Parameters.AddWithValue("@DueDate", dueDate);

                    cmd.ExecuteNonQuery();
                }
            }
        }

        public string GetFacilityIcon(string billerCategory)
        {
            // Replace the biller categories and their corresponding icon classes
            switch (billerCategory)
            {
                case "Electricity":
                    return "fas fa-bolt"; // lightning bolt icon for electricity
                case "Gas":
                    return "fas fa-fire"; // fire icon for gas
                case "Water":
                    return "fas fa-tint"; // water droplet icon for water
                case "Fuel":
                    return "fas fa-gas-pump"; // gas pump icon for fuel
                case "Broadband":
                case "Internet":
                    return "fas fa-wifi"; // Wi-Fi icon for broadband and internet
                default:
                    return "fas fa-question-circle"; // question mark icon for unknown categories
            }
        }

        private decimal CalculateBillAmount(string billerCategory)
        {
            Random random = new Random();
            decimal billAmount;

            switch (billerCategory)
            {
                case "Utilities":
                    // Electricity, gas, and water bills range between 500 PKR and 10000 PKR
                    billAmount = random.Next(500, 10001);
                    break;
                // Add more categories and their respective ranges here
                default:
                    // For unknown categories, generate an amount between 1000 PKR and 5000 PKR
                    billAmount = random.Next(1000, 5001);
                    break;
            }

            return billAmount;
        }

        private void UpdatePaymentStatus(int billPaymentId)
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString))
            {
                con.Open();

                using (SqlCommand cmd = new SqlCommand("UPDATE BillPayments SET PaymentStatus = 'Paid', PaymentDate = @PaymentDate WHERE BillPaymentId = @BillPaymentId", con))
                {
                    cmd.Parameters.AddWithValue("@BillPaymentId", billPaymentId);
                    cmd.Parameters.AddWithValue("@PaymentDate", DateTime.Now);

                    cmd.ExecuteNonQuery();
                }
            }
        }

        protected void btnFacility_Click(object sender, EventArgs e)
        {
            int billingId = Convert.ToInt32((sender as LinkButton).CommandArgument);
            hfSelectedBillingId.Value = billingId.ToString();
                            int userId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 3;

            // Get the billing category
            string billerCategory;
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString))
            {
                con.Open();

                using (SqlCommand cmd = new SqlCommand("SELECT BillerCategory FROM Billing WHERE BillingId = @BillingId", con))
                {
                    cmd.Parameters.AddWithValue("@BillingId", billingId);

                    billerCategory = (string)cmd.ExecuteScalar();
                }
            }

            // Generate a new bill
            DateTime dueDate = DateTime.Now.AddDays(14);
            decimal paymentAmount = CalculateBillAmount(billerCategory);
            GenerateNewBill(billingId, userId, paymentAmount, dueDate);

            // Display the bill details in the modal
            LoadBillDetails(userId, billingId);
            ScriptManager.RegisterStartupScript(this, GetType(), "ShowBillDetailsModal", "$(function() { $('#billDetailsModal').modal('show'); });", true);
        }

        private void LoadBillDetails(int userId, int billingId)
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString))
            {
                con.Open();

                using (SqlCommand cmd = new SqlCommand("SELECT TOP 1 b.BillerName, b.AccountNumber, bp.PaymentAmount, bp.DueDate FROM Billing b INNER JOIN BillPayments bp ON b.BillingId = bp.BillingId WHERE bp.UserId = @UserId AND bp.BillingId = @BillingId ORDER BY bp.DueDate DESC", con))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@BillingId", billingId);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblBillerName.Text = reader["BillerName"].ToString();
                            lblAccountNumber.Text = reader["AccountNumber"].ToString();
                            lblDueDate.Text = Convert.ToDateTime(reader["DueDate"]).ToString("yyyy-MM-dd");
                            lblAmount.Text = reader["PaymentAmount"].ToString();
                        }
                    }
                }
            }
        }

        protected void btnPayBill_Click(object sender, EventArgs e)
        {
            // Retrieve the current bill details
                            int userId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 3;
            int billingId = Convert.ToInt32(hfSelectedBillingId.Value);

            // Get the BillPaymentId by BillingId and UserId
            int billPaymentId = -1;
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString))
            {
                con.Open();

                using (SqlCommand cmd = new SqlCommand("SELECT BillPaymentId FROM BillPayments WHERE UserId = @UserId AND BillingId = @BillingId AND PaymentStatus = 'Pending'", con))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@BillingId", billingId);

                    object result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        billPaymentId = Convert.ToInt32(result);
                    }
                }
            }

            if (billPaymentId != -1)
            {
                // Update the payment status and payment date in the database
                UpdatePaymentStatus(billPaymentId);

                // Add the transaction to the Transactions table
                AddTransaction(userId, billingId);

                // Hide the bill details modal
                ScriptManager.RegisterStartupScript(this, GetType(), "HideBillDetailsModal", "$(function() { $('#billDetailsModal').modal('hide'); });", true);

                // Display a success message
                lblSuccessMessage.Text = "Bill payment successful!";
                lblSuccessMessage.Visible = true;

                // Reload the paid and pending bills to reflect the changes
                LoadPaidBills();
                LoadPendingBills();
            }
            else
            {
                // Handle the case when no BillPaymentId is found for the given BillingId and UserId.
                // You can show an error message or log the issue.
            }
        }

        private void AddTransaction(int userId, int billingId)
        {
            decimal amount;
            DateTime transactionDate = DateTime.Now;
            string reason = "Bill payment";

            // Get the payment amount from the BillPayments table
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString))
            {
                con.Open();

                using (SqlCommand cmd = new SqlCommand("SELECT PaymentAmount FROM BillPayments WHERE UserId = @UserId AND BillingId = @BillingId AND PaymentStatus = 'Paid'", con))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@BillingId", billingId);

                    amount = (decimal)cmd.ExecuteScalar(); // This might be causing the issue
                }
            }

            // Add the transaction to the Transactions table
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand("INSERT INTO Transactions (TransactionId, AccountId, RecipientAccount_id, Amount, TransactionDate, Reason) VALUES ((SELECT ISNULL(MAX(TransactionId), 0) + 1 FROM Transactions), @AccountId, @RecipientAccountId, @Amount, @TransactionDate, @Reason)", con))
                {
                    cmd.Parameters.AddWithValue("@AccountId", GetDefaultAccountId(userId));
                    cmd.Parameters.AddWithValue("@RecipientAccountId", billingId);
                    cmd.Parameters.AddWithValue("@Amount", amount);
                    cmd.Parameters.AddWithValue("@TransactionDate", transactionDate);
                    cmd.Parameters.AddWithValue("@Reason", reason);

                    cmd.ExecuteNonQuery();
                }
            }
        }

    }
}
