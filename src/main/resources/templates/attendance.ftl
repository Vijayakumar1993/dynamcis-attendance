<#include "home.ftl">

<!-- Filter / Add attendance -->
<div class="container my-5">
<form action="/attendance" method="get">
 <div class="col-md-3">
        <input type="text" class="form-control" name="name" id="studentNames" placeholder="Search by Name" <#if name?has_content>value="${name?if_exists}" </#if>
        <input type="hidden" class="form-control" name="id" id="studentId" placeholder="Search by Name" <#if id?has_content>value="${id?if_exists}" </#if>>
      </div>
      <div class="col-md-3">
        <input type="date" name="from" class="form-control"  <#if from?has_content>value="${from?if_exists}" </#if>>
      </div>
      <div class="col-md-3">
        <input type="date" name="to" class="form-control"  <#if to?has_content>value="${to?if_exists}" </#if>>
      </div>
      <div class="col-md-3">
        <button class="btn btn-primary w-100">Find Attendance</button>
      </div>
    </div>
</form>
    <h2 class="mb-4">Students - Attendance Sheet</h2>

    <div class="table-responsive">
      <table class="table table-bordered attendance-table">
        <thead class="table-dark">
          <tr>
            <th>Roll No</th>
            <th>Student Name</th>
            <#if days?has_content>
            <#list days as day>
                        <th class="vertical-text">${day?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}</th>
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
                        <td class=""><span class="text-danger">&#10008;</span></td>
                    </#if>
             </#list> </tr>
            </#list>
</#if>

        </tbody>
      </table>
    </div>
  </div>

<#include "footer.ftl">