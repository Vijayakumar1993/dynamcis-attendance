<#include "home.ftl">

<div class="container-fluid">

<h3 class="text-primary">
    <span class="glyphicon glyphicon-stats"></span>
    Lead Follow-Up Reports
</h3>
<hr/>

<ul class="nav nav-tabs">
    <li class="active"><a data-toggle="tab" href="#daily">Daily</a></li>
    <li><a data-toggle="tab" href="#status">Status</a></li>
    <li><a data-toggle="tab" href="#interest">Interest</a></li>
    <li><a data-toggle="tab" href="#missed">Missed</a></li>
    <li><a data-toggle="tab" href="#employee">Employees</a></li>
    <li><a data-toggle="tab" href="#conversion">Conversion Time</a></li>
</ul>

<div class="tab-content" style="margin-top:20px;">

<!-- DAILY -->
<div id="daily" class="tab-pane fade in active">
    <h4>📅 Daily Activity</h4>
    <table class="table table-bordered table-hover">
        <tr class="info">
            <th>Date</th>
            <th>Total Calls</th>
        </tr>
        <#list dailyActivity as row>
        <tr>
            <td>${row[0]}</td>
            <td><span class="badge">${row[1]}</span></td>
        </tr>
        </#list>
    </table>
</div>

<!-- STATUS -->
<div id="status" class="tab-pane fade">
    <h4>📌 Lead Status Funnel</h4>
    <table class="table table-striped table-bordered">
        <tr class="info">
            <th>Status</th>
            <th>Count</th>
        </tr>
        <#list statusSummary as row>
        <tr>
            <td><strong>${row[0]}</strong></td>
            <td>${row[1]}</td>
        </tr>
        </#list>
    </table>
</div>

<!-- INTEREST -->
<div id="interest" class="tab-pane fade">
    <h4>🔥 Interest Level</h4>
    <table class="table table-striped table-bordered">
        <tr class="info">
            <th>Interest</th>
            <th>Leads</th>
        </tr>
        <#list interestSummary as row>
        <tr>
            <td>${row[0]}</td>
            <td>${row[1]}</td>
        </tr>
        </#list>
    </table>
</div>

<!-- MISSED -->
<div id="missed" class="tab-pane fade">
    <h4 class="text-danger">
        ⏰ Missed Follow-Ups
    </h4>

    <table class="table table-bordered table-hover">
        <tr class="danger">
            <th>Lead</th>
            <th>Last Call</th>
            <th>Next Call</th>
            <th>Status</th>
        </tr>

        <#list missedFollowups as f>
        <tr>
            <td><a href="${baseUrl?if_exists}/lead-management/viewLead/${f.lead.id}" target="_blank">
                                    ${f.lead.name}
                                </a></td>
            <td>${f.callDate}</td>
            <td class="text-danger"><strong>${f.nextCallDate}</strong></td>
            <td>
                <span class="label label-warning">${f.status.configValue}</span>
            </td>
        </tr>
        </#list>
    </table>
</div>

<!-- EMPLOYEE -->
<div id="employee" class="tab-pane fade">
    <h4>👨‍💼 Conversions by Employee</h4>

    <table class="table table-striped table-bordered">
        <tr class="info">
            <th>Employee</th>
            <th>Connected Leads</th>
        </tr>

        <#list conversionByUser as row>
        <tr>
            <td>${row[0]}</td>
            <td>
                <span class="label label-success">
                    ${row[1]}
                </span>
            </td>
        </tr>
        </#list>
    </table>
</div>

<!-- CONVERSION TIME -->
<div id="conversion" class="tab-pane fade">
    <h4>⏳ Lead Conversion Timeline</h4>

    <table class="table table-bordered table-hover">
        <tr class="info">
            <th>Lead</th>
            <th>First Call</th>
            <th>Connected On</th>
        </tr>

        <#list conversionTime as row>
        <tr>
            <td>${row[0]}</td>
            <td>${row[1]}</td>
            <td>
                <span class="label label-success">
                    ${row[2]}
                </span>
            </td>
        </tr>
        </#list>
    </table>
</div>

</div>
</div>

<#include "footer.ftl">
