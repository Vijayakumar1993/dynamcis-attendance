<#include "home.ftl">

<div class="container">

    <div class="row">

        <!-- LEFT SIDE — FORM -->
        <div class="col-md-6 col-sm-12">

            <h2>Attendance Form</h2>
            <hr>

            <form action="${baseUrl?if_exists}/attendance/createAttendance" method="post">

                <@inputCustomers
                    label="Customer"
                    name="coachName"
                    defaultId=customer?has_content?then(customer.id, "")
                    defaultValue=customer?has_content?then(customer.name, "")
                    lookupFunction="openCustomerLookupWithRole('ROLE_STUDENT')" />

                <div class="form-group">
                    <input type="date"
                           id="attendanceDate"
                           name="attendanceDate"
                           class="form-control"
                           required
                           value="${.now?string('yyyy-MM-dd')}" />
                </div>

                <button type="submit" class="btn btn-primary">
                    Submit
                </button>

            </form>
        </div>

        <!-- RIGHT SIDE — ATTENDANCE LIST -->
        <div class="col-md-6 col-sm-12">

            <h2>Attendance Records</h2>
            <hr>

            <#if attendanceList?has_content>
                <div class="table-responsive">
                    <table class="table table-bordered table-striped">
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
                                    <td>
                                        ${a.date?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}
                                    </td>
                                    <td>
                                        <#assign createdBy = a.createdBy?if_exists>
                                        <#assign cust = util.getCustomer(createdBy)>
                                        ${cust.name?if_exists}
                                    </td>
                                    <td class="text-center">
                                        <a href="${baseUrl?if_exists}/attendance/removeSingleAttendance/${a.id?if_exists}">
                                            <span class="text-danger">&#10008;</span>
                                        </a>
                                    </td>
                                </tr>
                            </#list>
                        </tbody>
                    </table>
                </div>
            <#else>
                <div class="alert alert-info">
                    No attendance records available.
                </div>
            </#if>

        </div>

    </div>
</div>

<#include "footer.ftl">
