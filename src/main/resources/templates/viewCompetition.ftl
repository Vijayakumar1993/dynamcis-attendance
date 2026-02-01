<#include "home.ftl" />

<div class="container" style="margin-top:30px;">

<!-- ================= COMPETITION HEADER ================= -->
<div class="panel panel-primary">
    <div class="panel-heading">
        <h2 class="panel-title">
            ${competition.competitionName?if_exists}
<#if access_grant>
            <span class="pull-right">
<#if competition.competitionDate?has_content>
                ${competition.competitionDate?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}
</#if>
<#if competition.status?if_exists=="INPROGRESS">
                <a href="${baseUrl}/competition/scheduleCompetition/${competition.id}" class="btn btn-default btn-xs">Schedule</a>
</#if>
<#if competition.status?if_exists=="SCHEDULED">
                <a href="${baseUrl}/competition/closeCompetition/${competition.id}" class="btn btn-default btn-xs">Complete</a>
</#if>
                <a href="${baseUrl}/reports/fixture/${competition.id}" class="btn btn-default btn-xs" target="_blank">View</a>
            <a href="${baseUrl}/competition/delete/${competition.id}" class="btn btn-danger btn-xs">Delete</a>
            </span>
</#if>
        </h2>
    </div>

    <div class="panel-body">
        <div class="row">
            <div class="col-md-4"><strong>Type:</strong> ${competition.competitionType?if_exists}</div>
            <div class="col-md-4"><strong>Venue:</strong> ${competition.venue?if_exists}, ${competition.city?if_exists}</div>
            <div class="col-md-4"><strong>Organized By:</strong> ${competition.organizedBy.teamName?if_exists}</div>
        </div>

        <br/>

        <div class="row">
            <div class="col-md-4"><strong>Rounds:</strong> ${competition.rounds}</div>
            <div class="col-md-4"><strong>Round Duration:</strong> ${competition.roundDuration} mins</div>
            <div class="col-md-4">
                <strong>Status:</strong>
                <span class="label label-info">${competition.status?if_exists}</span>
            </div>
        </div>

        <#if competition.remarks?has_content>
            <hr/>
            <strong>Remarks:</strong>
            <p>${competition.remarks}</p>
        </#if>
    </div>
</div>

<!-- ================= TEAMS ================= -->
<div class="panel panel-default">
    <div class="panel-heading">
        <h3 class="panel-title">Participating Teams</h3>
    </div>

    <div class="panel-body">
        <#if competition.competitionTeams?has_content>
            <table class="table table-bordered table-striped">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Team</th>
                    <th>Status</th>
                    <th>Requested Date</th>
                    <th>Remarks</th>
                </tr>
                </thead>
                <tbody>
<#assign coach=false>
<#if authorities?has_content>
<#if authorities?seq_contains("ROLE_COACH") >

<#assign coach=true>
</#if>
</#if>
                <#list competition.competitionTeams as ct>
                    <tr>
                        <td><#if coach>
${ct.id}
<#else>
<a href="${baseUrl?if_exists}/teams/viewTeam/${ct.team.id}" target="_blank">${ct.id}</a>
</#if>
</td>
                        <td>${ct.team.teamName}</td>
                        <td>
                            <#if ct.status=="APPROVED">
                                <span class="label label-success">Approved</span>
                            <#elseif ct.status=="REJECTED">
                                <span class="label label-danger">Rejected</span>
                            <#else>
                                <span class="label label-warning">Requested</span>
                            </#if>
                        </td>
                        <td><#if ct.requestedDate??>${ct.requestedDate?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}</#if></td>
                        <td>${ct.remarks?if_exists}</td>
                    </tr>
                </#list>
                </tbody>
            </table>
        <#else>
            <div class="alert alert-info">No teams added.</div>
        </#if>
    </div>
</div>
<#if access_grant>
<!-- ================= EVENTS / FIXTURES ================= -->
<div class="panel panel-info">
    <div class="panel-heading">
        <h3 class="panel-title">
            Events / Fixtures
            <span class="badge"><#if events?has_content>${events?size!0}<#else>0</#if></span>
            <span class="pull-right">
                <a href="${baseUrl}/fixture" class="btn btn-success btn-xs">
                    + Create Event
                </a>
            </span>
        </h3>
    </div>

    <div class="panel-body">
        <#if events?has_content>
            <table class="table table-bordered table-striped table-hover" id="eventTable">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Date</th>
                    <th>Round</th>
                    <th>Description</th>
                    <th>Category</th>
                    <th>Gender</th>
                    <th>Weight</th>
                    <th>Status</th>
                </tr>
                </thead>
                <tbody>
                <#list events as e>
                    <tr>
                        <td>
                            <a href="${baseUrl}/matches/viewMatch/${e.id}" target="_blank">
                                ${e.id}
                            </a>
                        </td>

                        <td><#if e.eventDate??>${e.eventDate?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}</#if></td>

                        <td>
<#if e.roundOf?has_content>
<#assign round = "${e.roundOf}">
    <#if round?if_exists == "8">
        <span class="label label-warning">Quarter Final</span>
    <#elseif round?if_exists == "4">
        <span class="label label-info">Semi Final</span>
    <#elseif round?if_exists == "2">
        <span class="label label-success">Final</span>
`<#else>
        <span class="label label-default">Round of ${round}</span>
    </#if>
</#if>
                        </td>

                        <td>${e.description?if_exists}</td>

                        <td>
                            <#if e.categoryDefination?has_content>
                                <#assign cat = util.getConfig(e.categoryDefination)>
                                ${cat.configValue?if_exists}
                            </#if>
                        </td>

                        <td>${e.genderDefination?if_exists}</td>
                        <td>${e.weightDefination?if_exists}</td>

                        <td>
<#if e.status?has_content>
                            <#if e.status=="OPEN">
                                <span class="label label-success">OPEN</span>
                            <#else>
                                <span class="label label-default">CLOSED</span>
                            </#if>
</#if>
                        </td>
                    </tr>
                </#list>
                </tbody>
            </table>
        <#else>
            <div class="alert alert-info">No events created for this competition.</div>
        </#if>
    </div>
</div>


<!-- =====MEDALS REPORT===-->
<div class="panel panel-info">
    <div class="panel-heading">
        <h3 class="panel-title">
            Medals Report By Player
        </h3>
    </div>

    <div class="panel-body">
        <#if medalReports?has_content>
            <table class="table table-bordered table-striped table-hover" id="eventTable">
                <thead>
                <tr>
                    <th>Weight</th>
                    <th>Category</th>
                    <th>Gender</th>
                    <th>Gold</th>
                    <th>Silver</th>
                    <th>Bronze 1</th>
                    <th>Bronze 2</th>
                </tr>
                </thead>
                <tbody>
                <#list medalReports as medalReport>
                    <tr>

                        <td>
                           ${medalReport.weightDefination?if_exists}</td>

                        <td>
<#if medalReport.categoryDefination??>
<#assign cat = util.getConfig(medalReport.categoryDefination)>
                  <#if cat?has_content>
                    ${cat.configValue?if_exists?capitalize}
                  </#if>
                  </#if>
</td>
                        <td>
                           ${medalReport.genderDefination?if_exists?capitalize}</td>

                        <td>
<#if medalReport.gold??>
                           <a href="${baseUrl?if_exists}/customer/viewCustomer/${medalReport.gold.id?if_exists}">${medalReport.gold.name?if_exists} (${medalReport.gold.team.teamName})</a>

</#if>
</td>

                        <td>
<#if medalReport.silver??>
                          <a href="${baseUrl?if_exists}/customer/viewCustomer/${medalReport.silver.id?if_exists}">${medalReport.silver.name?if_exists} (${medalReport.silver.team.teamName})</a>

</#if>
</td>
                        <td>
<#if medalReport.bronze1??>
                         <a href="${baseUrl?if_exists}/customer/viewCustomer/${medalReport.bronze1.id?if_exists}">${medalReport.bronze1.name?if_exists} (${medalReport.bronze1.team.teamName})</a>

 </#if>
</td>

<td>

<#if medalReport.bronze2??>
<a href="${baseUrl?if_exists}/customer/viewCustomer/${medalReport.bronze2.id?if_exists}">${medalReport.bronze2.name?if_exists} (${medalReport.bronze2.team.teamName})</a>

</#if>
</td>
                    </tr>
                </#list>
                </tbody>
            </table>
        <#else>
            <div class="alert alert-info">No Medals created for this competition.</div>
        </#if>
    </div>
</div>


<!-- =====Team Medals REPORT===-->
<div class="panel panel-info">
    <div class="panel-heading">
        <h3 class="panel-title">
            Medals Report By Team
        </h3>
    </div>

    <div class="panel-body">
        <#if teamMedals?has_content>
            <table class="table table-bordered table-striped text-center">
    <thead>
        <tr>
            <th>Team</th>
            <th>Gold</th>
            <th>Silver</th>
            <th>Bronze 1</th>
            <th>Bronze 2</th>
            <th>Total</th>
        </tr>
    </thead>
    <tbody>
       <#if teamMedals?has_content>
    <#list teamMedals as team, medals>
        <tr>
            <td><a href="${baseUrl?if_exists}/teams/viewTeam/${team.id}" target="_blank">${team.teamName?if_exists}</a></td>
            <td>${medals["GOLD"]?default(0)}</td>
            <td>${medals["SILVER"]?default(0)}</td>
            <td>${medals["BRONZE1"]?default(0)}</td>
            <td>${medals["BRONZE2"]?default(0)}</td>

            <td>
                ${(medals["GOLD"]?default(0)
+ medals["SILVER"]?default(0)
+ medals["BRONZE1"]?default(0)
+ medals["BRONZE2"]?default(0))}
            </td>
        </tr>
    </#list>
<#else>
    <tr>
        <td colspan="6">No medal data available</td>
    </tr>
</#if>

    </tbody>
</table>
        <#else>
            <div class="alert alert-info">No medal data available</div>
        </#if>
    </div>
</div>
<!-- ================= ACTIONS ================= -->
<div class="text-right">
    <a href="${baseUrl}/competition/listCompetition" class="btn btn-default">Back</a>
    <a href="${baseUrl}/competition/edit/${competition.id}" class="btn btn-primary">Edit</a>
</div>

</div>
</#if>
<#include "footer.ftl" />
