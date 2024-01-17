using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FastPay
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUsersAndAccounts();
                LoadCreditCards();
                LoadTransactions();
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {

            Response.Redirect("Login.aspx");
        }
        protected void GridViewUsers_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GridViewUsers.EditIndex = e.NewEditIndex;
            LoadUsersAndAccounts();
        }

        protected void GridViewUsers_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GridViewUsers.EditIndex = -1;
            LoadUsersAndAccounts();
        }

        protected void GridViewUsers_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            // Implement your updating logic here and then reset the edit index
            GridViewUsers.EditIndex = -1;
            LoadUsersAndAccounts();
        }

        protected void GridViewCards_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GridViewCards.EditIndex = e.NewEditIndex;
            LoadCreditCards();
        }

        protected void GridViewCards_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GridViewCards.EditIndex = -1;
            LoadCreditCards();
        }

        protected void GridViewCards_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int cardId = Convert.ToInt32(GridViewCards.DataKeys[e.RowIndex].Value);

            TextBox txtCardType = (TextBox)GridViewCards.Rows[e.RowIndex].FindControl("txtCardType");
            TextBox txtDistributor = (TextBox)GridViewCards.Rows[e.RowIndex].FindControl("txtDistributor");
            CheckBox chkIsActive = (CheckBox)GridViewCards.Rows[e.RowIndex].FindControl("chkIsActive");
            TextBox txtCardNumber = (TextBox)GridViewCards.Rows[e.RowIndex].FindControl("txtCardNumber");
            TextBox txtExpirationDate = (TextBox)GridViewCards.Rows[e.RowIndex].FindControl("txtExpirationDate");
            TextBox txtCVC = (TextBox)GridViewCards.Rows[e.RowIndex].FindControl("txtCVC");

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("UPDATE Cards SET CardType = @CardType, Distributor = @Distributor, IsActive = @IsActive, CardNumber = @CardNumber, ExpirationDate = @ExpirationDate, CVC = @CVC WHERE CardId = @CardId", conn);
                cmd.Parameters.AddWithValue("@CardId", cardId);
                cmd.Parameters.AddWithValue("@CardType", txtCardType.Text);
                cmd.Parameters.AddWithValue("@Distributor", txtDistributor.Text);
                cmd.Parameters.AddWithValue("@IsActive", chkIsActive.Checked);
                cmd.Parameters.AddWithValue("@CardNumber", txtCardNumber.Text);
                cmd.Parameters.AddWithValue("@ExpirationDate", txtExpirationDate.Text);
                cmd.Parameters.AddWithValue("@CVC", txtCVC.Text);
                cmd.ExecuteNonQuery();
            }

            GridViewCards.EditIndex = -1;
            LoadCreditCards();
        }


        protected void GridViewTransactions_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GridViewTransactions.EditIndex = e.NewEditIndex;
            LoadTransactions();
        }



        protected void GridViewTransactions_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GridViewTransactions.EditIndex = -1;
            LoadTransactions();
        }


        protected void GridViewUsers_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int userId = Convert.ToInt32(GridViewUsers.DataKeys[e.RowIndex].Value);
            bool  deleteTransactions = false, deleteBeneficiaries = false, deleteAccount = false;
            int accountId = Convert.ToInt32(GridViewUsers.Rows[e.RowIndex].Cells[4].Text);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

              

                // Delete related records from Transactions table
                SqlCommand cmdDeleteTransactions = new SqlCommand("DELETE FROM Transactions WHERE AccountId = @AccountId", conn);
                cmdDeleteTransactions.Parameters.AddWithValue("@AccountId", accountId);
                int rowsAffectedTransactions = cmdDeleteTransactions.ExecuteNonQuery();
                deleteTransactions = (rowsAffectedTransactions > 0);

                // Delete related records from Beneficiaries table
                SqlCommand cmdDeleteBeneficiaries = new SqlCommand("DELETE FROM Beneficiaries WHERE AccountId = @AccountId", conn);
                cmdDeleteBeneficiaries.Parameters.AddWithValue("@AccountId", accountId);
                int rowsAffectedBeneficiaries = cmdDeleteBeneficiaries.ExecuteNonQuery();
                deleteBeneficiaries = (rowsAffectedBeneficiaries > 0);

                // Delete the user's account
                SqlCommand cmdDeleteAccount = new SqlCommand("DELETE FROM Accounts WHERE UserId = @UserId and AccountId = @AccountId", conn);
                cmdDeleteAccount.Parameters.AddWithValue("@UserId", userId);
                cmdDeleteAccount.Parameters.AddWithValue("@AccountId", accountId);
                int rowsAffectedAccount = cmdDeleteAccount.ExecuteNonQuery();
                deleteAccount = (rowsAffectedAccount > 0);
            }

            if ( deleteTransactions && deleteBeneficiaries && deleteAccount)
            {
                LoadUsersAndAccounts();
            }
            else
            {
                string message = "The following queries were not successfully executed: ";
                if (!deleteTransactions) message += "Delete from Transactions, ";
                if (!deleteBeneficiaries) message += "Delete from Beneficiaries, ";
                if (!deleteAccount) message += "Delete from Accounts, ";
                message = message.Remove(message.Length - 2);
                lblDebug.Text = message;
            }
        }


        protected void GridViewTransactions_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            if (e.RowIndex >= 0 && e.RowIndex < GridViewTransactions.DataKeys.Count)
            {
                int transactionId = Convert.ToInt32(GridViewTransactions.DataKeys[e.RowIndex].Value);

                TextBox txtAccountId = (TextBox)GridViewTransactions.Rows[e.RowIndex].FindControl("txtAccountId");
                TextBox txtRecipientAccount_id = (TextBox)GridViewTransactions.Rows[e.RowIndex].FindControl("txtRecipientAccount_id");
                TextBox txtAmount = (TextBox)GridViewTransactions.Rows[e.RowIndex].FindControl("txtAmount");
                TextBox txtTransactionDate = (TextBox)GridViewTransactions.Rows[e.RowIndex].FindControl("txtTransactionDate");
                TextBox txtReason = (TextBox)GridViewTransactions.Rows[e.RowIndex].FindControl("txtReason");

                if (txtAccountId != null && txtRecipientAccount_id != null && txtAmount != null && txtTransactionDate != null && txtReason != null)
                {
                    using (SqlConnection conn = new SqlConnection(connectionString))
                    {
                        conn.Open();
                        SqlCommand cmd = new SqlCommand("UPDATE Transactions SET AccountId = @AccountId, RecipientAccount_id = @RecipientAccount_id, Amount = @Amount, TransactionDate = @TransactionDate, Reason = @Reason WHERE TransactionId = @TransactionId", conn);
                        cmd.Parameters.AddWithValue("@TransactionId", transactionId);
                        cmd.Parameters.AddWithValue("@AccountId", Convert.ToInt32(txtAccountId.Text));
                        cmd.Parameters.AddWithValue("@RecipientAccount_id", Convert.ToInt32(txtRecipientAccount_id.Text));
                        cmd.Parameters.AddWithValue("@Amount", Convert.ToDecimal(txtAmount.Text));
                        cmd.Parameters.AddWithValue("@TransactionDate", Convert.ToDateTime(txtTransactionDate.Text));
                        cmd.Parameters.AddWithValue("@Reason", txtReason.Text);

                        cmd.ExecuteNonQuery();
                    }

                    GridViewTransactions.EditIndex = -1;
                    LoadTransactions();
                }
                else
                {
                    lblDebug.Text = "Some controls were not found.";
                }
            }
            else
            {
                lblDebug.Text = $"Row index: {e.RowIndex}, DataKeys count: {GridViewTransactions.DataKeys.Count}";
            }
        }



        protected void GridViewCards_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int cardId = Convert.ToInt32(GridViewCards.DataKeys[e.RowIndex].Value);

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // Delete card record from Cards table
                SqlCommand cmdDeleteCard = new SqlCommand("DELETE FROM Cards WHERE CardId = @CardId", conn);
                cmdDeleteCard.Parameters.AddWithValue("@CardId", cardId);
                cmdDeleteCard.ExecuteNonQuery();
            }

            LoadCreditCards();
        }

        protected void GridViewTransactions_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            if (e.RowIndex >= 0 && e.RowIndex < GridViewTransactions.DataKeys.Count)
            {
                int transactionId = Convert.ToInt32(GridViewTransactions.DataKeys[e.RowIndex].Value);

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();

                    // Delete transaction record from Transactions table
                    SqlCommand cmdDeleteTransaction = new SqlCommand("DELETE FROM Transactions WHERE TransactionId = @TransactionId", conn);
                    cmdDeleteTransaction.Parameters.AddWithValue("@TransactionId", transactionId);
                    int rowsAffected = cmdDeleteTransaction.ExecuteNonQuery();

                    if (rowsAffected > 0)
                    {
                        //lblTransactionStatus.Text = "Transaction deleted successfully.";
                    }
                    else
                    {
                        //lblTransactionStatus.Text = "Transaction not found or already deleted.";
                    }
                }

                LoadTransactions();
            }
            else
            {
                //lblTransactionStatus.Text = "Error: Invalid row index.";
            }
        }



        private void LoadUsersAndAccounts()
        {
            // Fetch user and account data from the database
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Users JOIN Accounts ON Users.UserId = Accounts.UserId", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                GridViewUsers.DataSource = dt;
                GridViewUsers.DataBind();
            }
        }

        private void LoadCreditCards()
        {
            // Fetch credit card data from the database
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Cards", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                GridViewCards.DataSource = dt;
                GridViewCards.DataBind();
            }
        }

        private void LoadTransactions()
        {
            // Fetch transaction data from the database
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Transactions", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                GridViewTransactions.DataSource = dt;
                GridViewTransactions.DataBind();
            }
        }
    }
}
