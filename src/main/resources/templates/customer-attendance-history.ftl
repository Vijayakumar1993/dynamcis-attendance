<#include "home.ftl">

<div class="panel panel-primary">
    <div class="panel-heading">
        <strong>
            <span class="glyphicon glyphicon-user"></span>
            ${customer.name} — Attendance History
        </strong>
        <span class="pull-right badge">
            Total Days: ${totalDays}
        </span>
    </div>

    <div class="panel-body">

        <table class="table table-striped table-bordered">
            <tr class="info">
                <th>#</th>
                <th>Date</th>
                <th>Day</th>
            </tr>

            <#list history as d>
            <tr>
                <td>${d?index + 1}</td>
                <td>${d?date("yyyy-MM-dd")?string("MMM d yyyy")}</td>
                <td>${d?date("yyyy-MM-dd")?string("EEEE")}</td>
            </tr>
            </#list>

        </table>

        <#if history?size == 0>
            <p class="text-muted text-center">
                No attendance recorded yet.
            </p>
        </#if>

    </div>
</div>

<#include "footer.ftl">
