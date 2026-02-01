<#include "home.ftl">

<div class="col-sm-12">

    <h2 class="page-header">
        Welcome, ${customer.name?capitalize}
    </h2>

    <!-- Stats -->
    <div class="row">
        <div class="col-sm-4">
            <div class="stat-card">
                <h2>${totalSessions!0}</h2>
                <p>Total Sessions</p>
            </div>
        </div>
        <div class="col-sm-4">
            <div class="stat-card">
                <h2>${recentTrainings?size}</h2>
                <p>Attended</p>
            </div>
        </div>
        <div class="col-sm-4">
            <div class="stat-card">
                <h2>${pendingSessions!0}</h2>
                <p>Pending / Missed</p>
            </div>
        </div>
    </div>

    <!-- Profile + Training -->
    <div class="row">

        <!-- Fighter Profile -->
        <div class="col-sm-4">
            <div class="profile-box text-center"> <div class="fighter-img">
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
                <h4>${customer.name!''}</h4>
                <p>Category: <strong>

<#if customer.category?has_content>
                <#assign category = util.getConfig(customer.category)>
                    <#if category?has_content && category.configValue?has_content>
                        ${category.configValue?if_exists?capitalize}
                    </#if></#if></strong></p>
                <p>Pack:
<#if customer.pack?has_content><#assign pack = util.getConfig(customer.pack)>
                    <#if pack?has_content && pack.configValue?has_content>
                        ${pack.configValue?if_exists?capitalize}
                    </#if> </#if></p>
                <p>Status: <span class="label label-info">${customer.status?if_exists}</span></p>
            </div>
        </div>

        <!-- Recent Training -->
        <div class="col-sm-8">
            <div class="profile-box">
                <h4>Recent Training Sessions</h4>

                <table class="table table-bordered table-hover">
                    <thead>
                    <tr>
                        <th>Date</th>
                        <th>Discipline</th>
                        <th>Attendance</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#if recentTrainings?has_content>
                        <#list recentTrainings as t>
                            <tr>
                                <td>${t.date?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}</td>
                                <td><#assign category = util.getConfig(t.customerId.pack)>
                    <#if category?has_content && category.configValue?has_content>
                        ${category.configValue?if_exists?capitalize}
                    </#if></td>
                                <td> <span class="label label-success">Present</span></td>
                            </tr>
                        </#list>
                    <#else>
                        <tr>
                            <td colspan="4" class="text-center text-muted">
                                No training records available
                            </td>
                        </tr>
                    </#if>
                    </tbody>
                </table>

            </div>
        </div>

    </div>

</div>

<#include "footer.ftl">
