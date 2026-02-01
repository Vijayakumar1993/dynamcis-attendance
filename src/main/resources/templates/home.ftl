<#include "macros.ftl">
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
<div class="row-fluid padding-left-5 padding-right-5">
 <nav class="navbar navbar-inverse navbar-fixed-top">
  <div class="container-fluid">

    <!-- ================= BRAND ================= -->
    <div class="navbar-header">
      <button type="button"
              class="navbar-toggle collapsed"
              data-toggle="collapse"
              data-target="#mainNavbar">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>

<#assign access_grant=false />
<#if authorities?has_content>
<#if authorities?seq_contains("ROLE_ADMIN") || authorities?seq_contains("ROLE_EMPLOYEE")>
<#assign access_grant=true />
</#if>
</#if>

<#if authorities?has_content>
<#if authorities?seq_contains("ROLE_ADMIN") >
<a class="navbar-brand" href="${baseUrl}/control">
          <img src="${baseUrl}/images/logo.png" style="height:32px;">
        </a>
<#elseif authorities?seq_contains("ROLE_PLAYER") >
<a class="navbar-brand" href="${baseUrl}/person">
          <img src="${baseUrl}/images/logo.png" style="height:32px;">
        </a>
<#elseif authorities?seq_contains("ROLE_STUDENT") >
<a class="navbar-brand" href="${baseUrl}/person/student">
          <img src="${baseUrl}/images/logo.png" style="height:32px;">
        </a>
<#elseif authorities?seq_contains("ROLE_COACH") >
<a class="navbar-brand" href="${baseUrl}/control/coachDashboard">
          <img src="${baseUrl}/images/logo.png" style="height:32px;">
        </a>
<#else>
    <a class="navbar-brand" href="${baseUrl}/access-denied">
          <img src="${baseUrl}/images/logo.png" style="height:32px;">
        </a>
</#if>
</#if>
    </div>

    <!-- ================= MENU ================= -->
    <div class="collapse navbar-collapse" id="mainNavbar">
      <ul class="nav navbar-nav">

<#if authorities?has_content>
<#if authorities?seq_contains("ROLE_ADMIN") >
        <li class="active">
          <a href="${baseUrl}/control">
            <span class="glyphicon glyphicon-home"></span> Home
          </a>
        </li>

        <!-- Leads -->
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown">
            <span class="glyphicon glyphicon-user"></span> Leads <span class="caret"></span>
          </a>
          <ul class="dropdown-menu">
            <li><a href="${baseUrl}/lead-management/findLeads">
              <span class="glyphicon glyphicon-time"></span> Leads Followups</a></li>
 <li><a href="${baseUrl}/lead-management/reports">
              <span class="glyphicon glyphicon-calendar"></span> Leads Reports</a></li>
          </ul>
        </li>
        <!-- Students -->
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown">
            <span class="glyphicon glyphicon-education"></span> Persons <span class="caret"></span>
          </a>
          <ul class="dropdown-menu">
            <li><a href="${baseUrl}/customer/createCustomer">
              <span class="glyphicon glyphicon-plus-sign"></span> Create Person</a></li>
            <li><a href="${baseUrl}/customer/viewCustomers">
              <span class="glyphicon glyphicon-search"></span> View Persons</a></li>
          </ul>
        </li>

        <!-- Attendance -->
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown">
            <span class="glyphicon glyphicon-calendar"></span> Attendance <span class="caret"></span>
          </a>
          <ul class="dropdown-menu">
            <li><a href="${baseUrl}/attendance/addAttendance">
              <span class="glyphicon glyphicon-plus"></span> Create Attendance</a></li>
            <li><a href="${baseUrl}/attendance/removeAttendance">
              <span class="glyphicon glyphicon-minus"></span> Remove Attendance</a></li>
            <li><a href="${baseUrl}/attendance">
              <span class="glyphicon glyphicon-list-alt"></span> View Attendance</a></li>

        <li class="divider"></li>

        <li>
            <a href="${baseUrl}/attendance/reports">
                <span class="glyphicon glyphicon-calendar"></span>
                 Reports
            </a>
        </li>
          </ul>
        </li>

        <!-- Competition -->
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown">
            <span class="glyphicon glyphicon-tower"></span> Competition <span class="caret"></span>
          </a>
          <ul class="dropdown-menu">
            <li><a href="${baseUrl}/competition/createCompetition">
              <span class="glyphicon glyphicon-plus-sign"></span> Create Competition</a></li>
            <li><a href="${baseUrl}/competition/listCompetition">
              <span class="glyphicon glyphicon-th-list"></span> List Competition</a></li>
          </ul>
        </li>

        <!-- Team -->
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown">
            <span class="glyphicon glyphicon-briefcase"></span> Team <span class="caret"></span>
          </a>
          <ul class="dropdown-menu">
            <li><a href="${baseUrl}/teams">
              <span class="glyphicon glyphicon-plus"></span> Create Team</a></li>
            <li><a href="${baseUrl}/teams/viewTeams">
              <span class="glyphicon glyphicon-th-list"></span> View Teams</a></li>
            <li class="divider"></li>
            <li><a href="${baseUrl}/fixture/createCoach">
              <span class="glyphicon glyphicon-user"></span> Create Coach</a></li>
            <li><a href="${baseUrl}/fixture/createPlayer">
              <span class="glyphicon glyphicon-user"></span> Create Player</a></li>
          </ul>
        </li>

        <!-- Fixtures -->
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown">
            <span class="glyphicon glyphicon-list-alt"></span> Fixtures <span class="caret"></span>
          </a>
          <ul class="dropdown-menu">
            <li><a href="${baseUrl}/fixture">
              <span class="glyphicon glyphicon-plus"></span> Create Fixture</a></li>
            <li><a href="${baseUrl}/fixture/viewFixtures">
              <span class="glyphicon glyphicon-calendar"></span> List Fixtures</a></li>
          </ul>
        </li>

       <!-- Financials -->
<li class="dropdown">
    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
        <span class="glyphicon glyphicon-stats"></span>
        Finance <span class="caret"></span>
    </a>

    <ul class="dropdown-menu">
        <li>
            <a href="${baseUrl}/financials/summary">
                <span class="glyphicon glyphicon-list-alt"></span>
                Financial Summary
            </a>
        </li>

        <li>
            <a href="${baseUrl}/payment/receivePayment">
                <span class="glyphicon glyphicon-credit-card"></span>
                Receive Payment
            </a>
        </li>

        <li class="divider"></li>

        <li>
            <a href="${baseUrl}/financials/aging">
                <span class="glyphicon glyphicon-hourglass"></span>
                Aging Report
            </a>
        </li>
    </ul>
</li>
        <!-- Settings -->
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown">
            <span class="glyphicon glyphicon-cog"></span> Settings <span class="caret"></span>
          </a>
          <ul class="dropdown-menu">
            <li><a href="${baseUrl}/settings">
              <span class="glyphicon glyphicon-wrench"></span> Create Configuration</a></li>
            <li><a href="${baseUrl}/settings/viewConfigurations">
              <span class="glyphicon glyphicon-list"></span> View Configurations</a></li>
          </ul>
        </li>

<#else>
<#if authorities?seq_contains("ROLE_STUDENT") >
 <!-- Attendance -->
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown">
            <span class="glyphicon glyphicon-calendar"></span> Attendance <span class="caret"></span>
          </a>
          <ul class="dropdown-menu">
            <li><a href="${baseUrl}/attendance/addAttendance">
              <span class="glyphicon glyphicon-plus"></span> Create Attendance</a></li>
          </ul>
        </li>
</#if>
<#if authorities?seq_contains("ROLE_EMPLOYEE") >
<!-- Leads -->
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown">
            <span class="glyphicon glyphicon-user"></span> Leads <span class="caret"></span>
          </a>
          <ul class="dropdown-menu">
            <li><a href="${baseUrl}/lead-management/findLeads">
              <span class="glyphicon glyphicon-time"></span> Leads Followups</a></li>
 <li><a href="${baseUrl}/lead-management/reports">
              <span class="glyphicon glyphicon-calendar"></span> Leads Reports</a></li>
          </ul>
        </li>

        <!-- Attendance -->
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown">
            <span class="glyphicon glyphicon-calendar"></span> Attendance <span class="caret"></span>
          </a>
          <ul class="dropdown-menu">
            <li><a href="${baseUrl}/attendance/addAttendance">
              <span class="glyphicon glyphicon-plus"></span> Create Attendance</a></li>
            <li><a href="${baseUrl}/attendance/removeAttendance">
              <span class="glyphicon glyphicon-minus"></span> Remove Attendance</a></li>
            <li><a href="${baseUrl}/attendance">
              <span class="glyphicon glyphicon-list-alt"></span> View Attendance</a></li>
          </ul>
        </li>
</#if>
<#if authorities?seq_contains("ROLE_COACH") >
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown">
            <span class="glyphicon glyphicon-briefcase"></span> Team <span class="caret"></span>
          </a>
          <ul class="dropdown-menu">
        <li><a href="${baseUrl}/teams/viewTeams">
              <span class="glyphicon glyphicon-th-list"></span> View Teams</a></li>
            <li><a href="${baseUrl}/fixture/createPlayer">
              <span class="glyphicon glyphicon-user"></span> Create Player</a></li>
          </ul>
        </li>
</#if>
</#if>

</#if>
      </ul>

      <!-- ================= RIGHT SIDE ================= -->
      <ul class="nav navbar-nav navbar-right">

        <#if userLogin??>
        <li>
          <a href="${baseUrl}/customer/viewCustomer/${userLogin.id}">
            <span class="glyphicon glyphicon-user"></span> ${userLogin.name?capitalize}
          </a>
        </li>
        </#if>

        <li>
          <form action="${baseUrl}/logout" method="post" style="margin:0;">
            <button class="btn btn-danger navbar-btn">
              <span class="glyphicon glyphicon-log-out"></span> Logout
            </button>
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

<#if success_msg?has_content>
<div id="successAlert"
     class="alert alert-success"
     style="position: fixed; top: 20px; right: 20px; z-index: 9999; min-width: 250px;">
    ${success_msg}
</div>

<script>
    // Hide after 5 seconds
    setTimeout(function() {
$("#successAlert").fadeOut("slow");
}, 5000);
</script>
</#if>