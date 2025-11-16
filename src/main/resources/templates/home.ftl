<!DOCTYPE html>
<html>
<head>
<title>Index</title>
<meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js"></script>
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
</style>

</head>
<div class="row">
    <nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="#">Dynamics 101 MMA</a>
    </div>
    <ul class="nav navbar-nav">
      <li class="active"><a href="#">Home</a></li>
      <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown">
            Students <span class="caret"></span>
          </a>
          <ul class="dropdown-menu">
            <li><a href="${baseUrl}/customer/createCustomer">Create Student</a></li>
            <li><a href="${baseUrl}/customer/viewCustomers">View Students</a></li>
          </ul>
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown">
            Attendance <span class="caret"></span>
          </a>
          <ul class="dropdown-menu">
            <li><a href="${baseUrl}/attendance/addAttendance">Create Attendance</a></li>
            <li><a href="${baseUrl}/attendance/removeAttendance">Remove Attendance</a></li>
            <li><a href="${baseUrl}/attendance">View Attendance</a></li>
          </ul>
        </li>
      <li><a href="#">Report</a></li>
    </ul>
  </div>
</nav>
</div>