<#include "home.ftl">
<div class="container my-5">
  <h2 class="mb-4">Attendance Delete Form</h2>

  <form action="deleteAttendance" method="post">

    <div class="mb-3">
      <label for="studentName" class="form-label">Student Name:</label>
      <input type="text" id="studentName" name="id" class="form-control" placeholder="Enter student name" required>
    </div>

    <div class="mb-3">
      <label for="attendanceDate" class="form-label">Date:</label>
      <input type="date" id="attendanceDate" name="attendanceDate" class="form-control" required>
    </div>

    <button type="submit" class="btn btn-primary">Delete Entry</button>

  </form>
</div>
<#include "footer.ftl">