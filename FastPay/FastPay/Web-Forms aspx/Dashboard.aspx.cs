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
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadBeneficiaries();
            }
        }

        private void LoadBeneficiaries()
        {
            if (Session["UserId"] != null)
            {
                int userId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 3;

                string connectionString = ConfigurationManager.ConnectionStrings["FastPayConnectionString"].ConnectionString;
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    using (SqlCommand cmd = new SqlCommand("SELECT b.Name FROM Accounts a INNER JOIN Beneficiaries b ON a.AccountId = b.AccountId WHERE a.UserId = @UserId", con))
                    {
                        cmd.Parameters.AddWithValue("@UserId", userId);
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        rptBeneficiaries.DataSource = dt;
                        rptBeneficiaries.DataBind();
                    }
                }
            }
        }



        protected void btnTransferFunds_Click(object sender, EventArgs e)
        {
            Response.Redirect("Transfer.aspx");
        }

        protected void btnBills_Click(object sender, EventArgs e)
        {
            Response.Redirect("BillPayment.aspx");
        }

        protected void btnSubscription_Click(object sender, EventArgs e)
        {
            Response.Redirect("Subscription.aspx");
        }

        protected void btnTransactionHistory_Click(object sender, EventArgs e)
        {
            Response.Redirect("TransactionHistory.aspx");
        }

        protected void btnLimitManagement_Click(object sender, EventArgs e)
        {
            Response.Redirect("Wallet.aspx");
        }

        protected void btnBeneficiaries_Click(object sender, EventArgs e)
        {
            Response.Redirect("Beneficiaries.aspx");
        }
    
    }
}

