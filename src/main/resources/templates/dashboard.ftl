<#include "home.ftl">
<#--a href="${baseUrl?if_exists}/control/coachDashboard" class="fixed-fab glyphicon glyphicon-dashboard" target="_blank"> </a-->

 <!-- ================= KPI ROW ================= -->
    <div class="row" style="padding-bottom:20px">
        <div class="col-md-3 col-sm-6">
            <div class="kpi-card bg-gold">
                <span>GOLD MEDALS</span>
                <h3>${goldCount?default(0)}</h3>
            </div>
        </div>

        <div class="col-md-3 col-sm-6">
            <div class="kpi-card bg-silver">
                <span>SILVER MEDALS</span>
                <h3>${silverCount?default(0)}</h3>
            </div>
        </div>

        <div class="col-md-3 col-sm-6">
            <div class="kpi-card bg-bronze">
                <span>BRONZE MEDALS</span>
                <h3>${bronzeCount?default(0)}</h3>
            </div>
        </div>

        <div class="col-md-3 col-sm-6">
            <div class="kpi-card bg-events">
                <span>TOTAL EVENTS</span>
                <h3>${eventCount?default(0)}</h3>
            </div>
        </div>
    </div>


<!-- Cards Row -->
<div class="row g-4">
   <div class="col-md-2">
      <div class="border-50px  card p-3 text-center bg-primary text-white">
         <h4>Active Students</h4>
         <h3>
         ${totalActiveStudents?default("0")}</h2>
      </div>
   </div>
   <div class="col-md-2">
      <div class="border-50px  card p-3 text-center bg-danger text-white">
         <h4>Inactive Students</h4>
         <h3>
         ${totalInactiveStudents?default("0")}</h2>
      </div>
   </div>
   <div class="col-md-2">
      <div class="border-50px  card p-3 text-center bg-success text-white">
         <h4>Present Today</h4>
         <h3>
         ${presents?default("0")}</h2>
      </div>
   </div>
   <div class="col-md-2">
      <div class="border-50px  card p-3 text-center bg-danger text-white">
         <h4>Absent Today</h4>
         <h3>
         ${absents?default("0")}</h2>
      </div>
   </div>
   <div class="col-md-2">
      <div class="border-50px  card p-3 text-center bg-warning text-white">
         <h4>Fees Pending</h4>
         <h3>
         ${fees?default("0")}</h2>
      </div>
   </div>
   <div class="col-md-2">
      <div class="border-50px  card p-3 text-center bg-info text-white">
         <h4>Due Soon</h4>
         <h3>
         ${priorThirtyDays?size?default("0")}</h2>
      </div>
   </div>
</div>
<br/>
<div class="row">
   <div class="col-lg-6 col-md-6  d-flex">
      <div class="panel panel-primary  w-100 h-100 equal-panel">
         <h3 class="text-center">
         Person Enrollment Trend
         <form action="${baseUrl?if_exists}/control" method="post" class="row g-2 align-items-center" style="margin-bottom: 5px;margin-top: 5px;margin-left: 0px;">
            <div class="row text-center" style="margin-bottom: 5px;margin-top: 5px;margin-left: 0px;">
               <div class="col-md-2 col-lg-2">
                  <input type="date" id="from" name="from"
                  class="form-control"
                  required
                  <#if from?has_content>
                  value="${from?if_exists}"
                  <#else>
                  value="${.now?string('yyyy-MM-dd')}"
                  </#if>
                  >
               </div>
               <div class="col-md-2 col-lg-2">
                  <input type="date" id="to" name="to"
                  class="form-control"
                  required
                  <#if to?has_content>
                  value="${to?if_exists}"
                  <#else>
                  value="${.now?string('yyyy-MM-dd')}"
                  </#if>
                  >
               </div>
               <div class="col-md-2 col-lg-2">
                  <select name="chartType" class="form-control" required>
                     <option value="">Select Type</option>
                     <option <#if chartType?has_content && chartType=="bar">selected</#if> value="bar">Bar</option>
                     <option <#if chartType?has_content && chartType=="line">selected</#if> value="line">Line</option>
                     <option <#if chartType?has_content && chartType=="pie">selected</#if> value="pie">Pie</option>
                     <option <#if chartType?has_content && chartType=="doughnut">selected</#if> value="doughnut">DoughNut</option>
                     <option <#if chartType?has_content && chartType=="radar">selected</#if> value="radar">Radar</option>
                     <option <#if chartType?has_content && chartType=="polarArea">selected</#if> value="polarArea">Polar Area</option>
                     <option <#if chartType?has_content && chartType=="scatter">selected</#if> value="scatter">Scatter</option>
                     <option <#if chartType?has_content && chartType=="bubble">selected</#if> value="bubble">Bubble</option>
                  </select>
               </div>
               <div class="col-md-2 col-lg-2">
                  <select name="type" class="form-control" required>
                     <option value="">Select Type</option>
                     <option <#if type?has_content && type=="Week">selected</#if> value="Week">By Date</option>
                     <option <#if type?has_content && type=="Month">selected</#if> value="Month">By Month</option>
                     <option <#if type?has_content && type=="Year">selected</#if> value="Year">By Year</option>
                  </select>
               </div>
               <div class="col-md-2 col-lg-2">
                  <button type="submit" value="Submit" class="btn btn-success"><span class="glyphicon glyphicon-search">&nbsp;Search</span></button>
               </div>
               <div class="col-md-2 col-lg-2">
               </div>
            </div>
            <div class="panel panel-default">
               <div class="panel-heading">People's Growth <#if type?has_content>By ${type?if_exists}</#if></div>
               <div class="panel-body">
                  <canvas id="myChart" height="250"></canvas>
               </div>
            </div>
      </div>
   </div>
   <div class="col-lg-6 col-md-6  d-flex">
   <div class="panel panel-primary  w-100 h-100 equal-panel">
   <h3 class="text-center">Person Attendance Report
   <div class="row text-center" style="margin-bottom: 5px;margin-top: 5px;margin-left: 0px;">
   <div class="col-md-2 col-lg-2">
   <input type="date" id="atFrom" name="atFrom"
   class="form-control"
   required
   <#if atFrom?has_content>
   value="${atFrom?if_exists}"
   <#else>
   value="${.now?string('yyyy-MM-dd')}"
   </#if>
   >
   </div>
   <div class="col-md-2 col-lg-2">
   <input type="date" id="atTo" name="atTo"
   class="form-control"
   required
   <#if atTo?has_content>
   value="${atTo?if_exists}"
   <#else>
   value="${.now?string('yyyy-MM-dd')}"
   </#if>
   >
   </div>
   <div class="col-md-2 col-lg-2">
   <select name="atChartType" class="form-control" required>
   <option value="">Select Type</option>
   <option <#if atChartType?has_content && atChartType=="bar">selected</#if> value="bar">Bar</option>
   <option <#if atChartType?has_content && atChartType=="line">selected</#if> value="line">Line</option>
   <option <#if atChartType?has_content && atChartType=="pie">selected</#if> value="pie">Pie</option>
   <option <#if atChartType?has_content && atChartType=="doughnut">selected</#if> value="doughnut">DoughNut</option>
   <option <#if atChartType?has_content && atChartType=="radar">selected</#if> value="radar">Radar</option>
   <option <#if atChartType?has_content && atChartType=="polarArea">selected</#if> value="polarArea">Polar Area</option>
   <option <#if atChartType?has_content && atChartType=="scatter">selected</#if> value="scatter">Scatter</option>
   <option <#if atChartType?has_content && atChartType=="bubble">selected</#if> value="bubble">Bubble</option>
   </select>
   </div>
   <div class="col-md-2 col-lg-2">
   <select name="atType" class="form-control" required>
   <option value="">Select Type</option>
   <option <#if atType?has_content && atType=="Week">selected</#if> value="Week">By Date</option>
   <option <#if atType?has_content && atType=="Month">selected</#if> value="Month">By Month</option>
   <option <#if atType?has_content && atType=="Year">selected</#if> value="Year">By Year</option>
   </select>
   </div>
   <div class="col-md-2 col-lg-2">
   <button type="submit" value="Submit" class="btn btn-success"><span class="glyphicon glyphicon-search">&nbsp;Search</span></button>
   </div>
   <div class="col-md-2 col-lg-2">
   </div>
   </div>
   </form>
   <div class="panel panel-default">
   <div class="panel-heading">Attendance Summary <#if type?has_content>By ${atType?if_exists}</#if></div>
   <div class="panel-body">
   <canvas id="myChart1" height="250"></canvas>
   </div>
   </div>
   </div>
   </div>
</div>
<br/>
<div class="row">
    <div class="col-md-12">
        <div class="panel panel-primary animate__animated animate__fadeInUp">
            <div class="panel-heading">
                <strong>Competition Statistics</strong>
            </div>

            <div class="panel-body">

                <!-- YEAR WISE -->
                <div class="row">
                    <div class="col-md-6">
                        <div class="panel panel-info">
                            <div class="panel-heading">
                                <strong>Year-wise Competitions</strong>
                            </div>
                            <div class="panel-body">

                                <#if competitionsByYear?has_content>
                                    <table class="table table-bordered table-striped">
                                        <thead>
                                        <tr>
                                            <th>Year</th>
                                            <th>Total Competitions</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <#list competitionsByYear as year, count>
                                            <tr>
                                                <td>${year?string("0")}</td>
                                                <td>${count}</td>
                                            </tr>
                                        </#list>
                                        </tbody>
                                    </table>
                                <#else>
                                    <p class="text-muted text-center">No data available</p>
                                </#if>

                            </div>
                        </div>
                    </div>

                    <!-- MONTH WISE -->
                    <div class="col-md-6">
                        <div class="panel panel-success">
                            <div class="panel-heading">
                                <strong>Month-wise Competitions</strong>
                                <#if selectedYear?has_content>
                                    (${selectedYear})
                                </#if>
                            </div>
                            <div class="panel-body">

                                <#if competitionsByMonth?has_content>
                                    <table class="table table-bordered table-striped">
                                        <thead>
                                        <tr>
                                            <th>Year - Month</th>
                                            <th>Total Competitions</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <#list competitionsByMonth as month, count>
                                            <tr>
                                                <td>${month}</td>
                                                <td>${count}</td>
                                            </tr>
                                        </#list>
                                        </tbody>
                                    </table>
                                <#else>
                                    <p class="text-muted text-center">
                                        No data available
                                    </p>
                                </#if>

                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>

    <!-- ================= BREAKDOWN SECTION ================= -->
    <div class="row">

        <!-- By Team -->
        <div class="col-md-3">
            <div class="dashboard-card">
                <h4 class="section-title">Medals by Team</h4>
                <#list medalsByTeam as row>
                    <div class="summary-row">
                        <strong>${row.label?capitalize}
<#if row?index == 0>
       🥇
    </#if>
</strong>
                        <span class="pull-right">
                            ${row.count}
                        </span>
                    </div>
                </#list>
            </div>
        </div>


        <!-- By Gender -->
        <div class="col-md-3">
            <div class="dashboard-card">
                <h4 class="section-title">Medals by Gender</h4>
                <#list medalsByGender as row>
                    <div class="summary-row">
                        <strong>${row.label?capitalize}</strong>
                        <span class="pull-right">
                            ${row.gold + row.silver + row.bronze}
                        </span>
                    </div>
                </#list>
            </div>
        </div>

        <!-- By Category -->
        <div class="col-md-3">
            <div class="dashboard-card">
                <h4 class="section-title">Medals by Category</h4>
                <#list medalsByCategory as row>
                    <div class="summary-row">
                        <strong>

 <#if row.label?has_content>
                      <#assign cat = util.getConfig(row.label)>
                      ${cat.configValue?if_exists?capitalize}
                    </#if>

</strong>
                        <span class="pull-right">
                            ${row.gold + row.silver + row.bronze}
                        </span>
                    </div>
                </#list>
            </div>
        </div>

        <!-- By Weight -->
        <div class="col-md-3">
            <div class="dashboard-card">
                <h4 class="section-title">Medals by Weight</h4>
                <#list medalsByWeight as row>
                    <div class="summary-row">
                        <strong>${row.label?capitalize} kg</strong>
                        <span class="pull-right">
                            ${row.gold + row.silver + row.bronze}
                        </span>
                    </div>
                </#list>
            </div>
        </div>

    </div>

    <!-- ================= DETAILED TABLE ================= -->
    <div class="dashboard-card">
        <h4 class="section-title">Medal Distribution by Category</h4>

        <table class="table table-bordered table-hover">
            <thead>
            <tr class="active">
                <th>Category</th>
                <th class="text-center">Gold</th>
                <th class="text-center">Silver</th>
                <th class="text-center">Bronze</th>
            </tr>
            </thead>
            <tbody>
            <#list medalsByCategory as row>
                <tr>
                    <td> <#if row.label?has_content>
                      <#assign cat = util.getConfig(row.label)>
                      ${cat.configValue?if_exists?capitalize}
                    </#if></td>
                    <td class="text-center text-warning"><strong>${row.gold}</strong></td>
                    <td class="text-center"><strong>${row.silver}</strong></td>
                    <td class="text-center text-danger"><strong>${row.bronze}</strong></td>
                </tr>
            </#list>
            </tbody>
        </table>
    </div>


<#include "footer.ftl">
