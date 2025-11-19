<#include "home.ftl">

<!-- Cards Row -->
<div class="row g-4">
    <div class="col-md-3">
        <div class="card p-3 text-center bg-primary text-white">
            <h4>Total Students</h4>
            <h3>${total?default("0")}</h2>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card p-3 text-center bg-success text-white">
            <h4>Present Today</h4>
            <h3>${presents?default("0")}</h2>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card p-3 text-center bg-danger text-white">
            <h4>Absent Today</h4>
            <h3>${absents?default("0")}</h2>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card p-3 text-center bg-warning text-white">
            <h4>Fees Pending</h4>
            <h3>${fees?default("0")}</h2>
        </div>
    </div>
</div>

<br/>

<!-- Aging Panel -->
<div class="panel panel-primary">
    <div class="panel-heading">Fee Pending Reports</div>

    <!-- Nav Tabs -->
    <ul class="nav nav-tabs" style="margin-top:15px;">
        <li class="active"><a data-toggle="tab" href="#thirty">30 Days (${thirtyDays?size?default("0")})</a></li>
        <li><a data-toggle="tab" href="#sixty">30 to 60 Days (${sixtyDays?size?default("0")})</a></li>
        <li><a data-toggle="tab" href="#ninety">60 to 90 Days (${nintyDays?size?default("0")})</a></li>
        <li><a data-toggle="tab" href="#other">90+ Days (${otherDays?size?default("0")})</a></li>
        <li><a data-toggle="tab" href="#pendings">Pending Balance (${pendings?size?default("0")})</a></li>
    </ul>

    <!-- Tab Content -->
    <div class="tab-content" style="margin-top:20px;">

        <!-- 30 Days -->
        <div id="thirty" class="tab-pane fade in active">
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
        <div id="sixty" class="tab-pane fade">
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
        <div id="ninety" class="tab-pane fade">
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
        <div id="other" class="tab-pane fade">
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
        <div id="pendings" class="tab-pane fade">
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

<!-- Recent Activity Table -->
<div class="panel panel-primary" style="margin-top:40px;">
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

<#include "footer.ftl">