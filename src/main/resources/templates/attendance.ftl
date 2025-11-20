<#include "home.ftl">
<!-- Filter / Add attendance -->
<div class="col-*-12">
    <h2 class="mb-4">Find Attendance</h2>

    <form action="/attendance" method="get" class="row g-3">

        <div class="col-md-3">
            <input type="text"
                   class="form-control"
                   name="name"
                   id="studentNames"
                   placeholder="Search by Name"
                   <#if name?has_content>value="${name}"</#if>>

            <input type="hidden"
                   class="form-control"
                   name="id"
                   id="studentId"
                   <#if id?has_content>value="${id}"</#if>>
        </div>

        <div class="col-md-3">
            <input type="date"
                   name="from"
                   class="form-control"
                   <#if from?has_content>value="${from}"</#if>>
        </div>

        <div class="col-md-3">
            <input type="date"
                   name="to"
                   class="form-control"
                   <#if to?has_content>value="${to}"</#if>>
        </div>

        <div class="col-md-3">
            <button class="btn btn-primary w-100">Find Attendance</button>
        </div>

    </form>
</div>

<!-- Attendance Table -->
<div class="col-*-12 mt-4">
    <h2 class="mb-4">Students - Attendance Sheet</h2>

    <div class="table-responsive">
        <table class="table table-bordered attendance-table table-responsive">
            <thead class="table-dark">
                <tr>
                    <th>Id</th>
                    <th>Student Name</th>

                    <#if days?has_content>
                        <#list days as day>
                            <th class="vertical-text">
                                ${day?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}
                            </th>
                        </#list>
                    </#if>
                </tr>
            </thead>

            <tbody>
                <#if dates?has_content>
                    <#list dates as key, atts>
                        <tr>
                            <td>${key.id!}</td>
<td><a href="${baseUrl?if_exists}/customer/viewCustomer/${key.id!}" target="_BLANK">${key.name!}</a></td>

                            <#list days as day>
                                <#assign valid = "N">

                                <#list atts as att>
                                    <#if att.date == day>
                                        <#assign valid = "Y">
                                    </#if>
                                </#list>

                                <#if valid == "Y">
                                    <td class="present">
                                        <span class="text-success">&#10004;</span>
                                    </td>
                                <#else>
                                    <td>
                                        <span class="text-danger">&#10008;</span>
                                    </td>
                                </#if>
                            </#list>

                        </tr>
                    </#list>
                </#if>
            </tbody>
        </table>
    </div>
</div>

<#include "footer.ftl">