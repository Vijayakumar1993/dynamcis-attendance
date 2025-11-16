<#include "home.ftl">
<div class="container my-5">
  <h2 class="mb-4">Attendance Form</h2>

  <form action="createAttendance" method="post">

    <div class="mb-3">
      <label for="studentName" class="form-label">Student Name:</label>
         <input type="text" class="form-control" name="name" id="studentNames" placeholder="Search by Name" <#if name?has_content>value="${name?if_exists}" </#if>>
        <input type="hidden" class="form-control" name="id" id="studentId" placeholder="Search by Name" <#if id?has_content>value="${id?if_exists}" </#if>>
    </div>

    <div class="mb-3">
      <label for="attendanceDate" class="form-label">Date:</label>
      <input type="date" id="attendanceDate" name="attendanceDate" class="form-control" required value="${.now?string('yyyy-MM-dd')}">
    </div>

    <button type="submit" class="btn btn-primary">Submit</button>

  </form>
</div>
<#include "footer.ftl">