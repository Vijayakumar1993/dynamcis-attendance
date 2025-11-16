<#include "home.ftl">
<div class="container my-5">
  <h2 class="mb-4">Attendance Delete Form</h2>

  <form action="deleteAttendance" method="post">

    <div class="mb-3">
      <input type="text" class="form-control" name="name" id="studentNames" placeholder="Search by Name" <#if name?has_content>value="${name?if_exists}" </#if>
        <input type="hidden" class="form-control" name="id" id="studentId" placeholder="Search by Name" <#if id?has_content>value="${id?if_exists}" </#if>>
     </div>

    <div class="mb-3">
      <label for="attendanceDate" class="form-label">Date:</label>
      <input type="date" id="attendanceDate" name="attendanceDate" class="form-control" required>
    </div>

    <button type="submit" class="btn btn-primary">Delete Entry</button>

  </form>
</div>
<#include "footer.ftl">