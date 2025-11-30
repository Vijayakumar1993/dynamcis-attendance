<!DOCTYPE html>
<html>
<head>
<title>Dynamics101 MMA Attendance</title>
<link rel="icon" type="image/x-icon" href="/images/logo.ico">
<meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet"
      href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">

<link rel="stylesheet"
      href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>

<link rel="stylesheet"
      href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
<style>
.equal-panel {
height: 450px;       /* you can change the height */
overflow-y: auto;    /* scroll only inside the panel */
}
.nav-tabs {
border-bottom: 2px solid #ddd;
gap: 8px; /* space between tabs */
}
.navbar-brand{
    padding: 10px 15px !important;

}
.nav-tabs .nav-item {
margin-bottom: -2px; /* align correctly */
}

.nav-tabs .nav-link {
border: none !important;
background: #f8f9fa;
padding: 10px 18px;
border-radius: 8px 8px 0 0;
color: #495057;
font-weight: 500;
transition: 0.3s;
}

/* Hover effect */
.nav-tabs .nav-link:hover {
background: #e9ecef;
color: #0d6efd;
}

/* Active tab styling */
.nav-tabs .nav-link.active {
background: #0d6efd !important;
color: white !important;
border: none !important;
box-shadow: 0 -2px 8px rgba(0, 0, 0, 0.15);
}

/* Tab content card look */
.tab-content {
border: 1px solid #ddd;
border-top: none;
padding: 20px;
border-radius: 0 0 10px 10px;
background: #fff;
}
.card-header{
border-radius: 5px !important;
}
.card {
border-radius: 0px !important;
box-shadow: 0 0px 0px rgba(0, 0, 0, 0.1) !important;
padding: 2px !important;
}
.attendance-table th, .attendance-table td {
text-align: center;
vertical-align: middle;
}
.vertical-text {
writing-mode: vertical-rl; /* vertical, right-to-left */
text-orientation: mixed;    /* keep letters normal */
transform: rotate(180deg);  /* optional: flip to bottom → top */
}
.font-weight-bold{
    font-weight: bold;
    padding-bottom: 10px;
}
.present {
background-color: #d4edda !important; /* green */
}
.absent {
background-color: #f8d7da !important; /* red */
}
.dt-button{
background: #337ab7;
color: #ffffff;
border-radius: 8px;
border-color: #d9edf7;
}

.dt-buttons{
padding-bottom: 10px !important;
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
h2,.panel-heading{
    background: black !important;
    color: white !important;
    padding: 6px !important;
    border-radius: 5px !important;
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
.border-50px{
    border-radius: 50px !important;
}
thead{
    background: #fcf8e3!important;
}
span.present{
background: green !important;
color: white !important;
padding: 5px !important;
border-radius: 5px;
}
span.absent{
background: #d9534f !important;
color: white !important;
padding: 5px !important;
border-radius: 5px;
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
 <nav class="navbar navbar-inverse navbar-fixed-top">
  <div class="container-fluid">
    <!-- Navbar Header -->
    <div class="navbar-header">
      <!-- Collapsed Hamburger Button -->
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#mainNavbar" aria-expanded="false">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>

      <!-- Brand -->
      <#if admin_access>
                <a class="navbar-brand d-flex align-items-center gap-2" href="${baseUrl}/control">
            <img src="${baseUrl}/images/logo.png" alt="Logo" style="height:32px; width:auto;"><#assign titleList = util.getConfigs("title", "name")>
        </a>
      <#else>
    <a class="navbar-brand d-flex align-items-center gap-2" href="${baseUrl}/attendance/addAttendance">Dynamics 101 MMA</a>>
        <img src="${baseUrl}/images/logo.png" alt="Logo" style="height:32px; width:auto;">
    </a>
        <a class="navbar-brand"
      </#if>
    </div>

    <!-- Navbar Links -->
    <div class="collapse navbar-collapse" id="mainNavbar">
      <ul class="nav navbar-nav">
        <#if admin_access>
          <li class="active"><a href="${baseUrl}/control">Home</a></li>

          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Students <span class="caret"></span></a>
            <ul class="dropdown-menu">
              <li><a href="${baseUrl}/customer/createCustomer">Create Student</a></li>
              <li><a href="${baseUrl}/customer/viewCustomers">View Students</a></li>
            </ul>
          </li>

          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Attendance <span class="caret"></span></a>
            <ul class="dropdown-menu">
              <li><a href="${baseUrl}/attendance/addAttendance">Create Attendance</a></li>
              <li><a href="${baseUrl}/attendance/removeAttendance">Remove Attendance</a></li>
              <li><a href="${baseUrl}/attendance">View Attendance</a></li>
            </ul>
          </li>

          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Settings <span class="caret"></span></a>
            <ul class="dropdown-menu">
              <li><a href="${baseUrl}/settings">Create Configuration</a></li>
              <li><a href="${baseUrl}/settings/viewConfigurations">View Configurations</a></li>
            </ul>
          </li>
        <#else>
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Attendance <span class="caret"></span></a>
            <ul class="dropdown-menu">
              <li><a href="${baseUrl}/attendance/addAttendance">Create Attendance</a></li>
            </ul>
          </li>
        </#if>
      </ul>

      <!-- Right Side -->
      <ul class="nav navbar-nav navbar-right">
        <li>
          <#if userLogin?has_content>
            <a href="${baseUrl?if_exists}/customer/viewCustomer/${userLogin.id?if_exists}">
              <span class="glyphicon glyphicon-user">&nbsp;</span>${userLogin.name?if_exists}
            </a>
          </#if>
        </li>

        <li>
          <form action="${baseUrl}/logout" method="post" style="margin:0; padding:0;">
            <button class="btn btn-danger navbar-btn" style="margin-right:10px;">Logout</button>
          </form>
        </li>
      </ul>
    </div>
  </div>
</nav>
</div>
<div class="container-fluid"  style="margin-top:70px">
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