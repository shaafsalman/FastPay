function openDashboardPage() {
    window.location.href = "Dashboard.aspx";
}

function openWalletPage() {
    window.location.href = "Wallet.aspx";
}

function openTransferPage() {
    window.location.href = "Transfer.aspx";
}

function openTransactionHistoryPage() {
    window.location.href = "TransactionHistory.aspx";
}

function openBillPaymentPage() {
    window.location.href = "BillPayment.aspx";
}

function openSubscriptionPage() {
    window.location.href = "Subscription.aspx";
}

function openBeneficiariesPage() {
    window.location.href = "Beneficiaries.aspx";
}

function openProfilePage() {
    window.location.href = "Profile.aspx";
}

function openContactPage() {
    window.location.href = "Contact.aspx";
}

function logout() {
    window.location.href = "Login.aspx";
}





var updateModal = document.getElementById("updateModal");
var changePasswordModal = document.getElementById("changePasswordModal");

// Open the update personal information modal
function openUpdateModal() {
    updateModal.style.display = "block";
}

// Close the update personal information modal
function closeUpdateModal() {
    updateModal.style.display = "none";
}

// Open the change password modal
function openChangePasswordModal() {
    changePasswordModal.style.display = "block";
}

// Close the change password modal
function closeChangePasswordModal() {
    changePasswordModal.style.display = "none";
}

// Close the modals when clicking outside of them
window.onclick = function (event) {
    if (event.target == updateModal) {
        updateModal.style.display = "none";
    }
    if (event.target == changePasswordModal) {
        changePasswordModal.style.display = "none";
    }
}


    function filterSubscriptions() {
        var input = document.getElementById('searchInput');
        var filter = input.value.toUpperCase();
        var allSubscriptions = document.getElementById('allSubscriptions');
        var subscriptions = allSubscriptions.getElementsByClassName('subscription');

        for (var i = 0; i < subscriptions.length; i++) {
            var subscriptionName = subscriptions[i].getElementsByClassName('subscription-details')[0].getElementsByTagName('h3')[0];
            if (subscriptionName) {
                var txtValue = subscriptionName.textContent || subscriptionName.innerText;
                if (txtValue.toUpperCase().indexOf(filter) > -1) {
                    subscriptions[i].style.display = '';
                } else {
                    subscriptions[i].style.display = 'none';
                }
            }
        }
    }
function searchSubscriptions() {
    const input = document.getElementById('searchInput');
    const filter = input.value.toUpperCase();
    const allSubscriptionsContainer = document.getElementById('allSubscriptions');
    const subscriptionItems = allSubscriptionsContainer.getElementsByClassName('subscription');

    for (let i = 0; i < subscriptionItems.length; i++) {
        const subscriptionDetails = subscriptionItems[i].getElementsByClassName('subscription-details')[0];
        const title = subscriptionDetails.getElementsByTagName('h3')[0];

        if (title.innerHTML.toUpperCase().startsWith(filter)) {
            subscriptionItems[i].style.display = '';
        } else {
            subscriptionItems[i].style.display = 'none';
        }
    }
}




