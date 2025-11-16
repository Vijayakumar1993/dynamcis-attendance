<#include "home.ftl">

<!-- Filter / Add attendance -->
<div class="container my-5">
 <div class="col-md-4">
        <input type="text" class="form-control" placeholder="Search by Name">
      </div>
      <div class="col-md-4">
        <input type="date" class="form-control">
      </div>
      <div class="col-md-4">
        <button class="btn btn-primary w-100">Add Attendance</button>
      </div>
    </div>
    <h2 class="mb-4">Students - Attendance Sheet</h2>

    <div class="table-responsive">
      <table class="table table-bordered attendance-table">
        <thead class="table-dark">
          <tr>
            <th>Roll No</th>
            <th>Student Name</th>
            <#if days?has_content>
            <#list days as day>
                        <th class="vertical-1">${day?date("yyyy-MM-dd")?string("EEEE, MMM d")}</th>
            </#list>
            </#if>
          </tr>
        </thead>
        <tbody>

<#if dates?has_content>
            <#list dates as key,atts>
 <tr>
                <td>${key.id?if_exists}</td>
                <td>${key.name?if_exists}</td>
             <#list days as day>
                 <#assign valid = "N">
                <#list atts as att>
                    <#if att.date == day>
                        <#assign valid = "Y">
                    </#if>
                </#list>
                    <#if valid=="Y">
                        <td class="present"><span class="text-success">&#10004;</span></td>
                    <#else>
                        <td class="absent"><span class="text-danger">&#10008;</span></td>
                    </#if>
             </#list> </tr>
            </#list>
</#if>

        </tbody>
      </table>
    </div>
  </div>

<#include "footer.ftl">