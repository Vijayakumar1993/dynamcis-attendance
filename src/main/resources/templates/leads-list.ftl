<#include "home.ftl" />

<div class="container" style="margin-top:25px;">

    <h2 class="text-primary">Lead Management Dashboard</h2>
    <hr/>

    <div class="row">

        <!-- NEW LEADS -->
        <div class="col-sm-4">
            <div class="panel panel-info">
                <div class="panel-heading">
                    <strong>🆕 New Leads</strong>
                </div>
                <div class="panel-body">

                    <#if newLeads?has_content>
                        <#list newLeads as lead>
                            <div class="well well-sm">
                                <strong>${lead.name}</strong><br/>
                                📞 ${lead.phone}<br/>
                                ✉ ${lead.email}<br/>
                                <a href="${baseUrl?if_exists}/lead-management/viewLead/${lead.id?if_exists}" class="btn btn-xs btn-primary" style="margin-top:5px;">
                                    Open
                                </a>
                            </div>
                        </#list>
                    <#else>
                        <p class="text-muted">No new leads</p>
                    </#if>

                </div>
            </div>
        </div>

        <!-- NEXT FOLLOW UPS -->
        <div class="col-sm-4">
            <div class="panel panel-warning">
                <div class="panel-heading">
                    <strong>⏭ Upcoming Follow-ups</strong>
                </div>
                <div class="panel-body">

                    <#if nextFollowUps?has_content>
                        <#list nextFollowUps as f>

                            <div class="well well-sm">
                                <strong>${f.lead.name}</strong><br/>
                                📅 ${f.nextCallDate}<br/>
                                📞 ${f.lead.phone}<br/>

                                <span class="label label-info"><#if f.interest??>${f.interest.configValue?if_exists}</#if></span>
                                <span class="label label-danger"><#if f.priority??>${f.priority.configValue?if_exists}</#if></span>

                                <br/>
                                <a href="${baseUrl?if_exists}/lead-management/viewLead/${f.lead.id?if_exists}" class="btn btn-xs btn-warning" style="margin-top:6px;">
                                    Follow Up
                                </a>
                            </div>

                        </#list>
                    <#else>
                        <p class="text-muted">No upcoming follow-ups</p>
                    </#if>

                </div>
            </div>
        </div>

        <!-- MISSED FOLLOW UPS -->
        <div class="col-sm-4">
            <div class="panel panel-danger">
                <div class="panel-heading">
                    <strong>❗ Missed Follow-ups</strong>
                </div>
                <div class="panel-body">

                    <#if missedFollowUps?has_content>
                        <#list missedFollowUps as f>

                            <div class="well well-sm">
                                <strong>${f.lead.name}</strong><br/>
                                ⏰ Missed on: ${f.nextCallDate}<br/>
                                📞 ${f.lead.phone}<br/>

                                <span class="label label-danger"><#if f.priority??>${f.priority.configValue?if_exists}</#if></span>

                                <br/>
                                <a href="${baseUrl?if_exists}/lead-management/viewLead/${f.lead.id?if_exists}" class="btn btn-xs btn-danger" style="margin-top:6px;">
                                    Call Now
                                </a>
                            </div>

                        </#list>
                    <#else>
                        <p class="text-muted">No missed follow-ups</p>
                    </#if>

                </div>
            </div>
        </div>

    </div>

</div>

<#include "footer.ftl" />
