<#include "home.ftl">

<!-- Cards Row -->
<div class="row g-4">
    <div class="col-md-2">
        <div class="border-50px animate__animated animate__rubberBand card p-3 text-center bg-primary text-white">
            <h4>Active Students</h4>
            <h3>${totalActiveStudents?default("0")}</h2>
        </div>
    </div>
<div class="col-md-2">
        <div class="border-50px animate__animated animate__rubberBand card p-3 text-center bg-danger text-white">
            <h4>Inactive Students</h4>
            <h3>${totalInactiveStudents?default("0")}</h2>
        </div>
    </div>
    <div class="col-md-2">
        <div class="border-50px animate__animated animate__rubberBand card p-3 text-center bg-success text-white">
            <h4>Present Today</h4>
            <h3>${presents?default("0")}</h2>
        </div>
    </div>

    <div class="col-md-2">
        <div class="border-50px animate__animated animate__rubberBand card p-3 text-center bg-danger text-white">
            <h4>Absent Today</h4>
            <h3>${absents?default("0")}</h2>
        </div>
    </div>

    <div class="col-md-2">
        <div class="border-50px animate__animated animate__rubberBand card p-3 text-center bg-warning text-white">
            <h4>Fees Pending</h4>
            <h3>${fees?default("0")}</h2>
        </div>
    </div>
  <div class="col-md-2">
        <div class="border-50px animate__animated animate__rubberBand card p-3 text-center bg-info text-white">
            <h4>Due Soon</h4>
            <h3>${priorThirtyDays?size?default("0")}</h2>
        </div>
    </div>
</div>

<br/>
<div class="row">
<div class="col-lg-6 col-md-6  d-flex">
<div class="panel panel-primary animate__animated animate__slideInUp w-100 h-100 equal-panel">
    <h3 class="text-center">Student Enrollment Trend
<form action="${baseUrl?if_exists}/control" method="post" class="row g-2 align-items-center" style="margin-bottom: 5px;margin-top: 5px;margin-left: 0px;">
<div class="row text-center">
    <div class="col-md-2 col-lg-2">
        <input type="date" id="from" name="from"
               class="form-control"
               required
               <#if from?has_content>
                   value="${from?if_exists}"
               <#else>
                   value="${.now?string('yyyy-MM-dd')}"
               </#if>
        >
    </div>

    <div class="col-md-2 col-lg-2">
        <input type="date" id="to" name="to"
               class="form-control"
               required
               <#if to?has_content>
                   value="${to?if_exists}"
               <#else>
                   value="${.now?string('yyyy-MM-dd')}"
               </#if>
        >
    </div>

    <div class="col-md-2 col-lg-2">
        <select name="chartType" class="form-control" required>
            <option value="">Select Type</option>
            <option <#if chartType?has_content && chartType=="bar">selected</#if> value="bar">Bar</option>
            <option <#if chartType?has_content && chartType=="line">selected</#if> value="line">Line</option>
            <option <#if chartType?has_content && chartType=="pie">selected</#if> value="pie">Pie</option>
            <option <#if chartType?has_content && chartType=="doughnut">selected</#if> value="doughnut">DoughNut</option>
            <option <#if chartType?has_content && chartType=="radar">selected</#if> value="radar">Radar</option>
            <option <#if chartType?has_content && chartType=="polarArea">selected</#if> value="polarArea">Polar Area</option>
            <option <#if chartType?has_content && chartType=="scatter">selected</#if> value="scatter">Scatter</option>
            <option <#if chartType?has_content && chartType=="bubble">selected</#if> value="bubble">Bubble</option>
        </select>
    </div>
    <div class="col-md-2 col-lg-2">
        <select name="type" class="form-control" required>
            <option value="">Select Type</option>
            <option <#if type?has_content && type=="Week">selected</#if> value="Week">By Week</option>
            <option <#if type?has_content && type=="Month">selected</#if> value="Month">By Month</option>
            <option <#if type?has_content && type=="Year">selected</#if> value="Year">By Year</option>
        </select>
    </div>

    <div class="col-md-2 col-lg-2">
        <input type="submit" value="Submit" class="btn btn-info">
    </div>
    <div class="col-md-2 col-lg-2">
        <input type="button" value="Clear" class="btn btn-info">
    </div>
</div>
    <div class="panel panel-default">
        <div class="panel-heading">Student Growth <#if type?has_content>By ${type?if_exists}</#if></div>
        <div class="panel-body">
            <canvas id="myChart" height="250"></canvas>
        </div>
    </div>
</div>
</div>

<div class="col-lg-6 col-md-6  d-flex">
<div class="panel panel-primary animate__animated animate__slideInUp w-100 h-100 equal-panel">
    <h3 class="text-center">Student Attendance Report
<div class="row text-center">
    <div class="col-md-2 col-lg-2">
        <input type="date" id="atFrom" name="atFrom"
               class="form-control"
               required
               <#if atFrom?has_content>
                   value="${atFrom?if_exists}"
               <#else>
                   value="${.now?string('yyyy-MM-dd')}"
               </#if>
        >
    </div>

    <div class="col-md-2 col-lg-2">
        <input type="date" id="atTo" name="atTo"
               class="form-control"
               required
               <#if atTo?has_content>
                   value="${atTo?if_exists}"
               <#else>
                   value="${.now?string('yyyy-MM-dd')}"
               </#if>
        >
    </div>
 <div class="col-md-2 col-lg-2">
        <select name="atChartType" class="form-control" required>
            <option value="">Select Type</option>
            <option <#if atChartType?has_content && atChartType=="bar">selected</#if> value="bar">Bar</option>
            <option <#if atChartType?has_content && atChartType=="line">selected</#if> value="line">Line</option>
            <option <#if atChartType?has_content && atChartType=="pie">selected</#if> value="pie">Pie</option>
            <option <#if atChartType?has_content && atChartType=="doughnut">selected</#if> value="doughnut">DoughNut</option>
            <option <#if atChartType?has_content && atChartType=="radar">selected</#if> value="radar">Radar</option>
            <option <#if atChartType?has_content && atChartType=="polarArea">selected</#if> value="polarArea">Polar Area</option>
            <option <#if atChartType?has_content && atChartType=="scatter">selected</#if> value="scatter">Scatter</option>
            <option <#if atChartType?has_content && atChartType=="bubble">selected</#if> value="bubble">Bubble</option>
        </select>
    </div>
    <div class="col-md-2 col-lg-2">
        <select name="atType" class="form-control" required>
            <option value="">Select Type</option>
            <option <#if atType?has_content && atType=="Week">selected</#if> value="Week">By Week</option>
            <option <#if atType?has_content && atType=="Month">selected</#if> value="Month">By Month</option>
            <option <#if atType?has_content && atType=="Year">selected</#if> value="Year">By Year</option>
        </select>
    </div>

    <div class="col-md-2 col-lg-2">
        <input type="submit" value="Submit" class="btn btn-info">
    </div>
    <div class="col-md-2 col-lg-2">
        <input type="button" value="Clear" class="btn btn-info">
    </div>
</div>
</form>
    <div class="panel panel-default">
        <div class="panel-heading">Attendance Summary <#if type?has_content>By ${atType?if_exists}</#if></div>
        <div class="panel-body">
            <canvas id="myChart1" height="250"></canvas>
        </div>
    </div>
</div>
</div>
</div>
<!-- Aging Panel --><div class="row">
<div class="row">
<div class="col-lg-6 col-md-6  d-flex">
<div class="panel panel-primary animate__animated animate__slideInUp w-100 h-100 equal-panel">
    <div class="panel-heading">Fee Pending Reports</div>

    <!-- Nav Tabs -->
    <ul class="nav nav-tabs" style="margin-top:15px;">
        <li class="active"><a data-toggle="tab"  class="bg-info text-white" href="#priorThirtyDays">Due Soon (Next 30 Days) (${priorThirtyDays?size?default("0")})</a></li>
        <li><a data-toggle="tab" href="#thirty"  class="bg-info text-white">Overdue (0–30 Days) (${thirtyDays?size?default("0")})</a></li>
        <li><a data-toggle="tab" class="bg-info text-white" href="#sixty">30–60 Days (${sixtyDays?size?default("0")})</a></li>
        <li><a data-toggle="tab"  class="bg-info text-white" href="#ninety">60–90 Days (${nintyDays?size?default("0")})</a></li>
        <li><a data-toggle="tab" class="bg-info text-white" href="#other">Older than 90 Days (${otherDays?size?default("0")})</a></li>
        <li><a data-toggle="tab" class="bg-info text-white" href="#pendings">Pending Balance (${pendings?size?default("0")})</a></li>
    </ul>

    <!-- Tab Content -->
    <div class="tab-content " style="margin-top:20px;">

 <!-- 30-60 Days -->
        <div id="priorThirtyDays" class="table-responsive tab-pane fade in active">
            <table class="table table-bordered">
                <thead class="thead-dark">
                    <tr>
                        <th>Student</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Payment Date</th>
                        <th>Amount</th>
                        <th>Balance</th>
                    </tr>
                </thead>
                <tbody>
                <#if priorThirtyDays?has_content>
                    <#list priorThirtyDays as customer>
                        <tr>
                            <td><a href="${baseUrl?if_exists}/customer/viewCustomer/${customer.id?if_exists}" target="_BLANK">${customer.name?if_exists}</a></td>
                            <td>${customer.email?if_exists}</td>
                            <td>${customer.phone?if_exists}</td>
                            <td>${customer.joiningDate?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}</td>
                            <td>${customer.amount?if_exists}</td>
                            <td>${customer.balance?if_exists}</td>
                        </tr>
                    </#list>
                <#else>
                    <tr>
                        <td colspan="6" class="text-center text-muted">No Records found.</td>
                    </tr>
                </#if>
                </tbody>
            </table>
        </div>

        <!-- 30 Days -->
        <div id="thirty" class="table-responsive tab-pane fade">
            <table class="table table-bordered">
                <thead class="thead-dark">
                    <tr>
                        <th>Student</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Payment Date</th>
                        <th>Amount</th>
                        <th>Balance</th>
                    </tr>
                </thead>
                <tbody>
                <#if thirtyDays?has_content>
                    <#list thirtyDays as customer>
                        <tr>
                            <td><a href="${baseUrl?if_exists}/customer/viewCustomer/${customer.id?if_exists}" target="_BLANK">${customer.name?if_exists}</a></td>
                            <td>${customer.email?if_exists}</td>
                            <td>${customer.phone?if_exists}</td>
                            <td>${customer.joiningDate?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}</td>
                            <td>${customer.amount?if_exists}</td>
                            <td>${customer.balance?if_exists}</td>
                        </tr>
                    </#list>
                <#else>
                    <tr>
                        <td colspan="6" class="text-center text-muted">No Records found.</td>
                    </tr>
                </#if>
                </tbody>
            </table>
        </div>

        <!-- 30-60 Days -->
        <div id="sixty" class="table-responsive tab-pane fade">
            <table class="table table-bordered">
                <thead class="thead-dark">
                    <tr>
                        <th>Student</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Payment Date</th>
                        <th>Amount</th>
                        <th>Balance</th>
                    </tr>
                </thead>
                <tbody>
                <#if sixtyDays?has_content>
                    <#list sixtyDays as customer>
                        <tr>
                            <td><a href="${baseUrl?if_exists}/customer/viewCustomer/${customer.id?if_exists}" target="_BLANK">${customer.name?if_exists}</a></td>
                            <td>${customer.email?if_exists}</td>
                            <td>${customer.phone?if_exists}</td>
                            <td>${customer.joiningDate?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}</td>
                            <td>${customer.amount?if_exists}</td>
                            <td>${customer.balance?if_exists}</td>
                        </tr>
                    </#list>
                <#else>
                    <tr>
                        <td colspan="6" class="text-center text-muted">No Records found.</td>
                    </tr>
                </#if>
                </tbody>
            </table>
        </div>

        <!-- 60-90 Days -->
        <div id="ninety" class="table-responsive tab-pane fade">
            <table class="table table-bordered">
                <thead class="thead-dark">
                    <tr>
                        <th>Student</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Payment Date</th>
                        <th>Amount</th>
                        <th>Balance</th>
                    </tr>
                </thead>
                <tbody>
                <#if nintyDays?has_content>
                    <#list nintyDays as customer>
                        <tr>
                            <td><a href="${baseUrl?if_exists}/customer/viewCustomer/${customer.id?if_exists}" target="_BLANK">${customer.name?if_exists}</a></td>
                            <td>${customer.email?if_exists}</td>
                            <td>${customer.phone?if_exists}</td>
                            <td>${customer.joiningDate?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}</td>
                            <td>${customer.amount?if_exists}</td>
                            <td>${customer.balance?if_exists}</td>
                        </tr>
                    </#list>
                <#else>
                    <tr>
                        <td colspan="6" class="text-center text-muted">No Records found.</td>
                    </tr>
                </#if>
                </tbody>
            </table>
        </div>

        <!-- 90+ Days -->
        <div id="other" class="table-responsive tab-pane fade">
            <table class="table table-bordered">
                <thead class="thead-dark">
                    <tr>
                        <th>Student</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Payment Date</th>
                        <th>Amount</th>
                        <th>Balance</th>
                    </tr>
                </thead>
                <tbody>
                <#if otherDays?has_content>
                    <#list otherDays as customer>
                        <tr>
                            <td><a href="${baseUrl?if_exists}/customer/viewCustomer/${customer.id?if_exists}" target="_BLANK">${customer.name?if_exists}</a></td>
                            <td>${customer.email?if_exists}</td>
                            <td>${customer.phone?if_exists}</td>
                            <td>${customer.joiningDate?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}</td>
                            <td>${customer.amount?if_exists}</td>
                            <td>${customer.balance?if_exists}</td>
                        </tr>
                    </#list>
                <#else>
                    <tr>
                        <td colspan="6" class="text-center text-muted">No Records found.</td>
                    </tr>
                </#if>
                </tbody>
            </table>
        </div>

 <!-- Pendings -->
        <div id="pendings" class="table-responsive tab-pane fade">
            <table class="table table-bordered">
                <thead class="thead-dark">
                    <tr>
                        <th>Student</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Payment Date</th>
                        <th>Amount</th>
                        <th>Balance</th>
                    </tr>
                </thead>
                <tbody>
                <#if pendings?has_content>
                    <#list pendings as customer>
                        <tr>
                            <td><a href="${baseUrl?if_exists}/customer/viewCustomer/${customer.id?if_exists}" target="_BLANK">${customer.name?if_exists}</a></td>
                            <td>${customer.email?if_exists}</td>
                            <td>${customer.phone?if_exists}</td>
                            <td>${customer.joiningDate?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}</td>
                            <td>${customer.amount?if_exists}</td>
                            <td>${customer.balance?if_exists}</td>
                        </tr>
                    </#list>
                <#else>
                    <tr>
                        <td colspan="6" class="text-center text-muted">No Records found.</td>
                    </tr>
                </#if>
                </tbody>
            </table>
        </div>
    </div>
</div>
</div>

<div class="col-lg-6 col-md-6  d-flex">
<!-- Recent Activity Table -->
<div class="panel panel-primary animate__animated animate__slideInUp  w-100 h-100 equal-panel">
    <div class="panel-heading">Recent Attendance</div>

    <div class="table-responsive">
        <table class="table">
            <thead class="table-dark">
                <tr>
                    <th>Student</th>
                    <th>Date</th>
                    <th>Status</th>
                </tr>
            </thead>

            <tbody>
            <#if attendance?has_content>
                <#list attendance as ls>
                    <tr>
                        <td><a href="${baseUrl?if_exists}/customer/viewCustomer/${ls.id?if_exists}" target="_BLANK">${ls.name?if_exists}</a></td>
                        <td>${ls.date?if_exists}</td>
                        <td><span class="text-success">Present</span></td>
                    </tr>
                </#list>
            <#else>
                <tr>
                    <td colspan="3" class="text-center text-muted">No Records found.</td>
                </tr>
            </#if>
            </tbody>
        </table>
    </div>
</div>
</div>
</div>
<#include "footer.ftl">