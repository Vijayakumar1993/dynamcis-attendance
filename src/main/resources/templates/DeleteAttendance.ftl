<#include "home.ftl">
<div class=" my-5">
  <h2 class="mb-4">Attendance Delete Form</h2>

  <form action="${baseUrl?if_exists}/attendance/deleteAttendance" method="post">

   <@inputCustomers
    label="Customer"
    name="coachName"
    defaultId=customer?has_content?then(customer.id, "")
    defaultValue=customer?has_content?then(customer.name, "")
    lookupFunction="openCustomerLookup()" />
    <input type="date" id="attendanceDate" name="attendanceDate" class="form-control" required value="${.now?string('yyyy-MM-dd')}">

    <button type="submit" class="btn btn-primary">Delete Entry</button>

  </form>
</div>
<#include "footer.ftl">