<#include "home.ftl">
<#assign months = [
"","Jan","Feb","Mar","Apr","May","Jun",
"Jul","Aug","Sep","Oct","Nov","Dec"
]>
<h3 class="text-primary">
    <span class="glyphicon glyphicon-stats"></span> Attendance Reports
</h3>
<hr/>

<ul class="nav nav-tabs">
    <li class="active"><a data-toggle="tab" href="#daily">
        <span class="glyphicon glyphicon-calendar"></span> Daily</a></li>

    <li><a data-toggle="tab" href="#monthly">
        <span class="glyphicon glyphicon-signal"></span> Monthly</a></li>

    <li><a data-toggle="tab" href="#customers">
        <span class="glyphicon glyphicon-user"></span> Customers</a></li>

    <li><a data-toggle="tab" href="#staff">
        <span class="glyphicon glyphicon-briefcase"></span> Staff</a></li>

    <li><a data-toggle="tab" href="#today">
        <span class="glyphicon glyphicon-ok-circle"></span> Today</a></li>

    <li><a data-toggle="tab" href="#absent">
        <span class="glyphicon glyphicon-remove-circle"></span> Absentees</a></li>
</ul>

<div class="tab-content" style="margin-top:20px;">

<!-- DAILY -->
<div id="daily" class="tab-pane fade in active">
<table class="table table-bordered table-striped">
<tr><th>Date</th><th>Count</th></tr>
<#list dailyAttendance as r>
<tr><td>${r[0]}</td><td>${r[1]}</td></tr>
</#list>
</table>
</div>

<!-- MONTHLY -->
<div id="monthly" class="tab-pane fade">
<table class="table table-striped">
<tr><th>Month</th><th>Attendance</th></tr>
<#list monthlyAttendance as r>
<tr><td>${months[r[0]?number]}</td><td>${r[1]}</td></tr>
</#list>
</table>
</div>

<!-- CUSTOMER -->
<div id="customers" class="tab-pane fade">
<table class="table table-bordered">
<tr><th>Name</th><th>Days Present</th></tr>
<#list attendanceByCustomer as r>
<tr><td>${r[0]}</td><td>${r[1]}</td></tr>
</#list>
</table>
</div>

<!-- STAFF -->
<div id="staff" class="tab-pane fade">
<table class="table table-striped">
<tr><th>Staff</th><th>Entries</th></tr>
<#list attendanceByStaff as r>
<tr><td>
 <#assign cust = util.getCustomer("${r[0]}")>
<#if cust??>
    ${cust.name}
</#if></td><td>${r[1]}</td></tr>
</#list>
</table>
</div>

<!-- TODAY -->
<div id="today" class="tab-pane fade">
<table class="table table-bordered">
<tr><th>Customer</th><th>Date</th></tr>
<#list todayList as a>
<tr>
<td>${a.customerId.name}</td>
<td>${a.date}</td>
</tr>
</#list>
</table>
</div>

<!-- ABSENT -->
<div id="absent" class="tab-pane fade">
<table class="table table-bordered table-danger">
<tr><th>Customer</th><th>Phone</th></tr>
<#list absentees as c>
<tr>
<td>${c.name}</td>
<td><a href="tel:+91${c.phone}">📞${c.phone}</a></td>
</tr>
</#list>
</table>
</div>

</div>

<#include "footer.ftl">
