<#include "home.ftl">

<div class="container-fluid">

    <h2>
        <span class="glyphicon glyphicon-stats"></span>
        Financial Overview
    </h2>
    <hr/>

    <!-- SUMMARY CARDS -->
    <div class="row">

        <div class="col-sm-4">
            <div class="panel panel-success text-center">
                <div class="panel-heading">
                    <span class="glyphicon glyphicon-ok-circle"></span>
                    Amount Received
                </div>
                <div class="panel-body">
                    <h3>₹ ${totalReceived!0}</h3>
                </div>
            </div>
        </div>

        <div class="col-sm-4">
            <div class="panel panel-warning text-center">
                <div class="panel-heading">
                    <span class="glyphicon glyphicon-time"></span>
                    Pending Amount
                </div>
                <div class="panel-body">
                    <h3>₹ ${totalPending!0}</h3>
                </div>
            </div>
        </div>

        <div class="col-sm-4">
            <div class="panel panel-info text-center">
                <div class="panel-heading">
                    <span class="glyphicon glyphicon-usd"></span>
                    Total Expected
                </div>
                <div class="panel-body">
                    <h3>₹ ${totalExpected!0}</h3>
                </div>
            </div>
        </div>

    </div>

    <!-- MONTHLY COLLECTION -->
    <h2>
        <span class="glyphicon glyphicon-calendar"></span>
        Monthly Collection
    </h2>
<hr />

    <table class="table table-bordered table-striped">
        <thead>
            <tr class="success">
                <th>Month</th>
                <th>Amount</th>
            </tr>
        </thead>
        <tbody>
        <#if monthlyCollection?has_content>
            <#list monthlyCollection?keys as m>
                <tr>
                    <td>${m}</td>
                    <td>₹ ${monthlyCollection[m]}</td>
                </tr>
            </#list>
        <#else>
            <tr>
                <td colspan="2" class="text-center text-muted">No data</td>
            </tr>
        </#if>
        </tbody>
    </table>

    <!-- STUDENT PENDING -->
    <h2>

        <span class="glyphicon glyphicon-user"></span>
        Collections Pending Summary
    </h2><hr />

    <table class="table table-bordered table-hover">
        <thead>
            <tr class="warning">
                <th>Student</th>
                <th>Pending Amount</th>
            </tr>
        </thead>
        <tbody>
       <#if pendingByStudent?has_content>
    <#assign keys = pendingByStudent?keys>
    <#assign values = pendingByStudent?values>

    <#list keys as cust>
        <#assign amount = values[cust_index]>

        <tr>
            <td>
                <a href="${baseUrl?if_exists}/customer/viewCustomer/${cust.id!}" target="_blank">
                    ${cust.name!}
                </a>
            </td>
            <td class="text-danger">₹ ${amount!0}</td>
        </tr>
    </#list>
<#else>
    <tr>
        <td colspan="2" class="text-center text-muted">
            No pending balances
        </td>
    </tr>
</#if>
        </tbody>
    </table>

</div>

<#include "footer.ftl">
