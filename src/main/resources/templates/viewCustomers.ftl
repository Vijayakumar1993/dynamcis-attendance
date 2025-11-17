<#include "home.ftl">

<div class="mt-5">
<h2 class="mb-4">
    ${customer.name?if_exists} Details
    <a href="/payment/receivePayment/${customer.id?if_exists}" class="btn btn-primary pull-right">Recieve Payment</a>
</h2>
    <#if customer??>
        <div class="table-responsive">
            <table class="table table-striped table-bordered">
                <tbody>
                    <tr>
                        <th>ID</th>
                        <td>${customer.id?if_exists}</td>
                    </tr>
                    <tr>
                        <th>Name</th>
                        <td class="text-capitalize">${customer.name?if_exists}</td>
                    </tr>
                    <tr>
                        <th>Phone</th>
                        <td>${customer.phone?if_exists}</td>
                    </tr>
                    <tr>
                        <th>Email</th>
                        <td>${customer.email?if_exists}</td>
                    </tr>
                    <tr>
                        <th>Gender</th>
                        <td>${customer.gender?if_exists}</td>
                    </tr>
                    <tr>
                        <th>Status</th>
                        <td>${customer.status?if_exists}</td>
                    </tr>
                    <tr>
                        <th>Joined Date</th>
                        <td>${customer.joinedDate?if_exists}</td>
                    </tr>
                </tbody>
            </table>
        </div>
    <#else>
        <div class="alert alert-warning">
            Customer not found.
        </div>
    </#if>

</div>


<h3>Payment List</h3>
<hr>

<table class="table table-bordered table-striped table-hover">
    <thead>
        <tr class="info">
            <th>Payment Id</th>
            <th>Amount</th>
            <th>Payment Date</th>
            <th>Mode</th>
            <th>Tenure (Months)</th>
            <th>Remarks</th>
        </tr>
    </thead>

    <tbody>
    <#if payments?has_content>
        <#list payments as p>
            <tr>
                <td>${p.paymentId}</td>
                <td>₹${p.amount}</td>
                <td>${p.paymentDate}</td>
                <td>${p.paymentMethod}</td>
                <td>${p.tenure}</td>
                <td>${p.remarks!""}</td>
            </tr>
        </#list>
    <#else>
        <tr>
            <td colspan="6" class="text-center text-danger">No payments found</td>
        </tr>
    </#if>
    </tbody>
</table>
<#include "footer.ftl">