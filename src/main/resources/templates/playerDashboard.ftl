<#include "home.ftl" />

<!-- Main Content -->
<div class="col-sm-12">

            <h2 class="page-header">Welcome, ${customer.name?capitalize}</h2>

            <!-- Stats Row -->
            <div class="row">
                <div class="col-sm-3">
                    <div class="stat-box">
                        <h2><#if totalMatches?has_content>${totalMatches?size}<#else>0</#if></h2>
                        <p>Total Matches</p>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="stat-box">
                        <h2><#if successorMatches?has_content>${pendingMatches?size}<#else>0</#if></h2>
                        <p>Pending</p>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="stat-box">
                        <h2><#if successorMatches?has_content>${successorMatches?size}<#else>0</#if></h2>
                        <p>Wins</p>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="stat-box">
                        <h2><#if failureMatches?has_content>${failureMatches?size}<#else>0</#if></h2>
                        <p>Losses</p>
                    </div>
                </div>
            </div>

            <!-- Profile + Matches -->
            <div class="row">

                <!-- Profile -->
                <div class="col-sm-4">
                    <div class="profile-box text-center">
 <div class="fighter-img">
                        <#assign img1 = util.getPhotoByCustomerId(customer.id?string)! />
                            <#if img1?has_content && img1.document?has_content>
                                <img src="data:image/png;base64,${Base64UtilEncoder.encodeToString(img1.document)}">
                            <#else>
                               <#if customer.gender?if_exists=="male">
                                <img src="${baseUrl?if_exists}/images/male.png" alt="Profile">
                                <#else>
                                <img src="${baseUrl?if_exists}/images/female.png" alt="Profile" style="background:white">
                                </#if>
                            </#if>
</div>
                        <h4><#if customer?has_content>${customer.name?capitalize}</#if></h4>
                        <p>Weight: <#if customer?has_content>${customer.weight}</#if></p>
                        <p>Age: <#if customer?has_content>${customer.age}</#if></p>
                        <p>Status: <strong><#if customer?has_content><span class="label label-info">${customer.status?if_exists}</span></#if></strong></p>
                    </div>
                </div>

                <!-- Recent Matches -->
                <div class="col-sm-8">
                    <div class="profile-box">
                        <h4>Recent Matches</h4>
                        <table class="table table-bordered table-hover">
                            <thead>
                            <tr>
                                <th>Date</th>
                                <th>Competition</th>
                                <th>Match</th>
                                <th>Type</th>
                                <th>Result</th>
                                <th>Stage</th>
                                <th>View</th>
                            </tr>
                            </thead>
                            <tbody>
<#if pendingMatches?has_content>
<#list pendingMatches as pm>
 <tr class="upcoming">
                                <td>${pm.event.eventDate?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}</td>
                                <td>${pm.event.competition.competitionName?if_exists}</td>
                                <td>${pm.from.customerId.name?if_exists} vs ${pm.to.customerId.name?if_exists}</td>
                                <td>${pm.event.competition.competitionType?if_exists} Championship</td>
                                <td><span class="label yet">Yet To Start</span></td>
<td>
<#if pm.event.roundOf?has_content>
<#assign round = "${pm.event.roundOf}">
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
                                <td> <a href="${baseUrl}/matches/viewMatch/${pm.event.id?if_exists}"><span class="glyphicon glyphicon-zoom-in"></span></a></td>

                            </tr>
</#list>
</#if>
<#if successorMatches?has_content>
<#list successorMatches as pm>
 <tr>
                                <td>${pm.event.eventDate?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}</td>
                                <td>${pm.event.competition.competitionName?if_exists}</td>
                                <td>${pm.from.customerId.name?if_exists} vs ${pm.to.customerId.name?if_exists}</td>
                                <td>${pm.event.competition.competitionType?if_exists} Championship</td>
                                <td><span class="label label-success">Win</span></td><td>
<#if pm.event.roundOf?has_content>
<#assign round = "${pm.event.roundOf}">
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
                                <td> <a href="${baseUrl}/matches/viewMatch/${pm.event.id?if_exists}"><span class="glyphicon glyphicon-zoom-in"></span></a></td>
                            </tr>
</#list>
</#if><#if failureMatches?has_content>
<#list failureMatches as pm>
 <tr>
                                <td>${pm.event.eventDate?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}</td>
                                <td>${pm.event.competition.competitionName?if_exists}</td>
                                <td>${pm.from.customerId.name?if_exists} vs ${pm.to.customerId.name?if_exists}</td>
                                <td>${pm.event.competition.competitionType?if_exists} Championship</td>
                                <td><span class="label label-danger">Loss</span></td><td>
<#if pm.event.roundOf?has_content>
<#assign round = "${pm.event.roundOf}">
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
                                <td> <a href="${baseUrl}/matches/viewMatch/${pm.event.id?if_exists}"><span class="glyphicon glyphicon-zoom-in"></span></a></td>
                            </tr>
</#list>
</#if>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>

        </div>

<#include "footer.ftl" />
