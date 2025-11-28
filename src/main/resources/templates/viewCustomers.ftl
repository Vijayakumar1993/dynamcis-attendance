<#include "home.ftl">

<div class="card shadow-sm mb-4">
    <div class="card-header bg-primary text-white">
       <h2 class="mb-4">
    ${customer.name?capitalize?if_exists} Details
   <#if admin_access><a href="/payment/receivePayment/${customer.id?if_exists}" class="btn btn-default pull-right">Receive Payment</a>
 <a href="/login/createLogin/${customer.id?if_exists}" class="btn btn-default pull-right" style="margin-right: 2px" >Create Login</a></#if>
</h2>
    </div>

    <div class="card-body">

        <div class="row mb-3">
            <div class="col-sm-4 font-weight-bold">ID</div>
            <div class="col-sm-8">${customer.id?if_exists}</div>
        </div>

        <div class="row mb-3">
            <div class="col-sm-4 font-weight-bold">Name</div>
            <div class="col-sm-8 text-capitalize">${customer.name?if_exists}</div>
        </div>

        <div class="row mb-3">
            <div class="col-sm-4 font-weight-bold">Guardian / Father / Spouse</div>
            <div class="col-sm-8 text-capitalize">${customer.guardianName?if_exists}</div>
        </div>

        <div class="row mb-3">
            <div class="col-sm-4 font-weight-bold">Phone</div>
            <div class="col-sm-8">${customer.phone?if_exists}</div>
        </div>

        <div class="row mb-3">
            <div class="col-sm-4 font-weight-bold">Email</div>
            <div class="col-sm-8">${customer.email?if_exists}</div>
        </div>

        <div class="row mb-3">
            <div class="col-sm-4 font-weight-bold">Gender</div>
            <div class="col-sm-8">${customer.gender?if_exists?capitalize}</div>
        </div>

        <div class="row mb-3">
            <div class="col-sm-4 font-weight-bold">Status</div>
            <div class="col-sm-8 <#if customer.status=='INACTIVE'>absent<#else>present</#if>">
                <span class="<#if customer.status=='INACTIVE'>text-danger font-weight-bold<#else>text-success font-weight-bold</#if>">
                    ${customer.status?if_exists}
                </span>
            </div>
        </div>

        <div class="row mb-3">
            <div class="col-sm-4 font-weight-bold">Joined Date</div>
            <div class="col-sm-8">
                ${customer.joiningDate?if_exists?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}
            </div>
        </div>

        <#if customer.renewalDate?has_content>
        <div class="row mb-3">
            <div class="col-sm-4 font-weight-bold">Renewel Date</div>
            <div class="col-sm-8">
                ${customer.renewalDate?if_exists?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}
            </div>
        </div>
        </#if>
        <#if customer.createdDate?has_content>
        <div class="row mb-3">
            <div class="col-sm-4 font-weight-bold">Created Date</div>
            <div class="col-sm-8">
                ${customer.createdDate?if_exists?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}
            </div>
        </div>
        </#if>

        <div class="row mb-3">
            <div class="col-sm-4 font-weight-bold">Created By</div>
            <div class="col-sm-8">${customer.createdBy?if_exists}</div>
        </div>

    </div>

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
                <td<#if p.enabled?default(false)> class="present" <#else> class="absent" </#if>><#if p.enabled?default(false)> Yes <#else> No </#if></td>
<td>

<#if admin_access><a href="${baseUrl?if_exists}/login/removeLogin/${p.id?if_exists}" class="btn btn-danger">Remove</a></#if>
<a href="${baseUrl?if_exists}/login/updateLogin/${p.id?if_exists}" class="btn btn-primary">Update</a>
</td>
            </tr>
        </#list>
    <#else>
        <tr>
            <td colspan="4" class="text-center text-danger">No Logins found</td>
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
                <td>${p.paymentDate?if_exists?if_exists?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}</td>
                <td>${p.paymentMethod?if_exists?capitalize}</td>
                <td>${p.tenure?if_exists}</td>
                <td>${p.remarks!""}</td>
<td>
<a href="${baseUrl?if_exists}/payment/receivePayment/${customer.id?if_exists}?paymentId=${p.paymentId?if_exists}" class="btn btn-primary">Update</a>
<a href="${baseUrl?if_exists}/payment/removePayment/${p.paymentId?if_exists}?customerId=${customer.id?if_exists}" class="btn btn-danger">Remove</a>
</td>
            </tr>
        </#list>
    <#else>
        <tr>
            <td colspan="8" class="text-center text-danger">No payments found</td>
        </tr>
    </#if>
    </tbody>
</table>
</#if>
<#include "footer.ftl">