<#include "home.ftl">

<div class="mt-5">
<h2 class="mb-4">
    ${customer.name?if_exists} Details
   <#if admin_access> &nbsp;<a href="/payment/receivePayment/${customer.id?if_exists}" class="btn btn-default pull-right">Recieve Payment</a>
  &nbsp;<a href="/login/createLogin/${customer.id?if_exists}" class="btn btn-default pull-right" >Create Login</a></#if>
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
                        <td>${customer.gender?if_exists?capitalize}</td>
                    </tr>
                    <tr>
                        <th>Status</th>
                        <td>${customer.status?if_exists}</td>
                    </tr>
                    <tr>
                        <th>Joined Date</th>
                        <td>${customer.joiningDate?if_exists?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}</td>
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
<h2>User Login Details</h2>
<table class="table table-bordered table-striped table-hover">
    <thead>
        <tr class="info">
            <th>Id</th>
            <th>User name</th>
            <th>Enabled</th>
            <th>Update</th>
        </tr>
    </thead>

    <tbody>
    <#if users?has_content>
        <#list users as p>
            <tr>
                <td>${p.id?if_exists}</td>
                <td>${p.username?if_exists}</td>
                <td><#if p.enabled?default(false)> Yes <#else> No </#if></td>
<td>

<#if admin_access><a href="${baseUrl?if_exists}/login/removeLogin/${p.id?if_exists}" class="btn btn-danger">Remove</a></#if>
<a href="${baseUrl?if_exists}/login/updateLogin/${p.id?if_exists}" class="btn btn-primary">Update</a>
</td>
            </tr>
        </#list>
    <#else>
        <tr>
            <td colspan="6" class="text-center text-danger">No Logins found</td>
        </tr>
    </#if>
    </tbody>
</table>
<#if admin_access>
<h2>Payment List</h2>
<table class="table table-bordered table-striped table-hover">
    <thead>
        <tr class="info">
            <th>Payment Id</th>
            <th>Amount</th>
            <th>Balance</th>
            <th>Payment Date</th>
            <th>Mode</th>
            <th>Tenure (Months)</th>
            <th>Remarks</th>
            <th>Update</th>
        </tr>
    </thead>

    <tbody>
    <#if payments?has_content>
        <#list payments as p>
            <tr>
                <td>${p.paymentId?if_exists}</td>
                <td>₹${p.amount?if_exists}</td>
                <td>₹${p.balance?if_exists}</td>
                <td>${p.paymentDate?if_exists}</td>
                <td>${p.paymentMethod?if_exists?capitalize}</td>
                <td>${p.tenure?if_exists}</td>
                <td>${p.remarks!""}</td>
<td>
<a href="${baseUrl?if_exists}/payment/receivePayment/${customer.id?if_exists}?paymentId=${p.paymentId?if_exists}" class="btn btn-primary">Update Payment</a>
<a href="${baseUrl?if_exists}/payment/removePayment/${p.paymentId?if_exists}?customerId=${customer.id?if_exists}" class="btn btn-danger">Remove Payment</a>
</td>
            </tr>
        </#list>
    <#else>
        <tr>
            <td colspan="6" class="text-center text-danger">No payments found</td>
        </tr>
    </#if>
    </tbody>
</table>
</#if>
<#include "footer.ftl">