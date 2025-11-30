<#include "home.ftl">

<div class="container my-5">
    <div class="row">

        <!-- LEFT SIDE — FORM -->
        <div class="col-md-6 col-sm-12">

            <h2 class="mb-4">Attendance Form</h2>

            <form action="${baseUrl?if_exists}/attendance/createAttendance" method="post">

                <div class="mb-3">
                    <label class="form-label">Student Name:</label>
                    <input type="text" class="form-control"
                           name="name" id="studentNames"
                           placeholder="Search by Name"
                           <#if customer?has_content>value="${customer.name}"</#if> />

                    <input type="hidden" class="form-control"
                           name="id" id="studentId"
                           <#if customer?has_content>value="${customer.id}"</#if> />
                </div>

                <div class="mb-3">
                    <label class="form-label">Date:</label>
                    <input type="date" id="attendanceDate" name="attendanceDate"
                           class="form-control"
                           required
                           value="${.now?string('yyyy-MM-dd')}" />
                </div>

                <button type="submit" class="btn btn-primary">Submit</button>

            </form>
        </div>


        <!-- RIGHT SIDE — ATTENDANCE LIST -->
        <div class="col-md-6 col-sm-12">

            <h2 class="mb-4">Attendance Records</h2>

            <#if attendanceList?has_content>
                <table class="table table-bordered table-striped table-responsive">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Created By</th>
                            <th>Remove</th>
                        </tr>
                    </thead>
                    <tbody>
                        <#list attendanceList as a>
                            <tr>
                                <td>${a.date?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}</td>
                                <td>

<#assign createdBy = a.createdBy?if_exists>
<#assign cust = util.getCustomer(createdBy)>
${cust.name?if_exists}</td>
                                <td><a href="${baseUrl?if_exists}/attendance/removeSingleAttendance/${a.id?if_exists}"> <span class="text-danger">&#10008;</span></a></td>
                            </tr>
                        </#list>
                    </tbody>
                </table>
            <#else>
                <div class="alert alert-info">No attendance records available.</div>
            </#if>

        </div>

    </div>
</div>

<#include "footer.ftl">
