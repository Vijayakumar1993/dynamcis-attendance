<!DOCTYPE html>
<html>
<head>
<title><#assign titleList = util.getConfigs("title", "name")>
<#if titleList?has_content>
${titleList?first.configValue?if_exists}
</#if></title>
<link rel="icon" type="image/x-icon" href="/images/logo.ico">
<meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet"
      href="${baseUrl}/css/bootstrap.min.css">

<link rel="stylesheet"
      href="${baseUrl}/css/jquery.dataTables.min.css">
<link rel="stylesheet" href="${baseUrl}/css/animate.min.css"/>

<link rel="stylesheet"
      href="${baseUrl}/css/jquery-ui.css">
<link rel="stylesheet" href="${baseUrl}/css/custom.css">

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
     <a class="navbar-brand d-flex align-items-center gap-2" href="${baseUrl}/attendance/addAttendance">
            <img src="${baseUrl}/images/logo.png" alt="Logo" style="height:32px; width:auto;"><#assign titleList = util.getConfigs("title", "name")>
        </a>
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
              <li><a href="${baseUrl}/customer/createCustomer"><span class="glyphicon glyphicon-user">&nbsp;</span>Create Student</a></li>
              <li><a href="${baseUrl}/customer/viewCustomers"><span class="glyphicon glyphicon-search">&nbsp;</span>View Students</a></li>
            </ul>
          </li>

          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Attendance <span class="caret"></span></a>
            <ul class="dropdown-menu">
              <li><a href="${baseUrl}/attendance/addAttendance"><span class="glyphicon glyphicon-plus">&nbsp;</span>Create Attendance</a></li>
              <li><a href="${baseUrl}/attendance/removeAttendance"><span class="glyphicon glyphicon-minus">&nbsp;</span>Remove Attendance</a></li>
              <li><a href="${baseUrl}/attendance"><span class="glyphicon glyphicon-calendar">&nbsp;</span>View Attendance</a></li>
            </ul>
          </li>

          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Settings <span class="caret"></span></a>
            <ul class="dropdown-menu">
              <li><a href="${baseUrl}/settings"><span class="glyphicon glyphicon-asterisk">&nbsp;</span>Create Configuration</a></li>
              <li><a href="${baseUrl}/settings/viewConfigurations"><span class="glyphicon glyphicon-list-alt">&nbsp;</span>View Configurations</a></li>
            </ul>
          </li>
        <#else>
          <li class="dropdown">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">Attendance <span class="caret"></span></a>
            <ul class="dropdown-menu">
              <li><a href="${baseUrl}/attendance/addAttendance"><span class="glyphicon glyphicon-user">&nbsp;</span>Create Attendance</a></li>
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