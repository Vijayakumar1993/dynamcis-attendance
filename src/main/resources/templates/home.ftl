<!DOCTYPE html>
<html>
<head>
<title>Dynamics101 MMA Attendance</title>
<meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet"
      href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">

<link rel="stylesheet"
      href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">

<link rel="stylesheet"
      href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
<style>
.attendance-table th, .attendance-table td {
text-align: center;
vertical-align: middle;
}
.vertical-text {
writing-mode: vertical-rl; /* vertical, right-to-left */
text-orientation: mixed;    /* keep letters normal */
transform: rotate(180deg);  /* optional: flip to bottom → top */
}

.present {
background-color: #d4edda !important; /* green */
}
.absent {
background-color: #f8d7da !important; /* red */
}
.padding-bottom-5{
    padding-bottom: 5px;
}
input.form-control{
    padding-bottom: 5px !important;
}
.content {
    margin-left: 260px;
    padding: 30px;
}
h2{
    background: #337ab7;
    color: white;
    padding: 4px;
    border-radius: 5px;
}

.card {
    border-radius: 12px;
    box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    padding: 2px !important;
}
.padding-top-5{
    padding-top: 5px !important;
}

.padding-left-5{
padding-left: 5px !important;
}

.padding-right-5{
padding-right: 5px !important;
}
button {
    margin-top: 3px;
}
</style>

</head>
<#assign admin_access=false>
<#if authorities?has_content>
<#if authorities?seq_contains("ROLE_ADMIN") >
    <#assign admin_access=true>
</#if>
</#if>
<div class="row-fluid padding-left-5 padding-right-5">
    <nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <div class="navbar-header">
<#if admin_access>
    <a class="navbar-brand" href="${baseUrl}/">Dynamics 101 MMA</a>
<#else>
    <a class="navbar-brand" href="${baseUrl}/attendance/addAttendance">Dynamics 101 MMA</a>
</#if>

    </div>
    <ul class="nav navbar-nav">
<#if admin_access>
      <li class="active"><a href="${baseUrl}/">Home</a></li>
      <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown">
            Students <span class="caret"></span>
          </a>
          <ul class="dropdown-menu">
            <li class="padding-bottom-5"><a href="${baseUrl}/customer/createCustomer">Create Student</a></li>
            <li class="padding-bottom-5"><a href="${baseUrl}/customer/viewCustomers">View Students</a></li>
          </ul>
</li>
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown">
            Attendance <span class="caret"></span>
          </a>
          <ul class="dropdown-menu">
            <li class="padding-bottom-5"><a href="${baseUrl}/attendance/addAttendance">Create Attendance</a></li>
            <li class="padding-bottom-5"><a href="${baseUrl}/attendance/removeAttendance">Remove Attendance</a></li>
            <li class="padding-bottom-5"><a href="${baseUrl}/attendance">View Attendance</a></li>
          </ul>
        </li>
<#else>
<li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown">
            Attendance <span class="caret"></span>
          </a>
          <ul class="dropdown-menu">
            <li class="padding-bottom-5"><a href="${baseUrl}/attendance/addAttendance">Create Attendance</a></li>
          </ul>
        </li>
</#if>
    </ul>
  <!-- ============ RIGHT SIDE ============= -->
    <ul class="nav navbar-nav navbar-right">

      <!-- USERNAME DISPLAY -->
      <li>
 <#if userLogin?has_content>
        <a href="${baseUrl?if_exists}/customer/viewCustomer/${userLogin.id?if_exists}">
          <span class="glyphicon glyphicon-user">&nbsp;</span>${userLogin.name?if_exists}
        </a>
</#if>
      </li>

      <!-- LOGOUT BUTTON -->
      <li>
        <form action="${baseUrl}/logout" method="post" style="margin:0; padding:0;">
          <button class="btn btn-danger navbar-btn" style="margin-right:10px;">
            Logout
          </button>
        </form>
      </li>
    </ul>
  </div>
</nav>
</div>
<div class="container-fluid">
<#if error_msg?has_content>
<div id="errorAlert"
     class="alert alert-danger"
     style="position: fixed; top: 20px; right: 20px; z-index: 9999; min-width: 250px;">
    ${error_msg}
</div>

<script>
    // Hide after 5 seconds
    setTimeout(function() {
$("#errorAlert").fadeOut("slow");
}, 5000);
</script>
</#if>