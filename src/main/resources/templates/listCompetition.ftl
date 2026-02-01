<#include "home.ftl" />

<div class="container" style="margin-top:30px;">

<!-- Page Header -->
<div class="row">
    <div class="col-md-6">
        <h3>Competitions</h3>
    </div>
    <div class="col-md-6 text-right">
        <a href="/competition/createCompetition" class="btn btn-success">
            <i class="glyphicon glyphicon-plus"></i> Create Competition
        </a>
    </div>
</div>

<hr/>

<!-- Competition Table -->
<div class="panel panel-default">
    <div class="panel-heading">
        <strong>Competition List</strong>
    </div>

    <div class="panel-body">
        <#if competitions?has_content>
            <div class="table-responsive">
                <table class="table table-bordered table-striped table-hover">
                    <thead>
                        <tr class="active">
                            <th>#</th>
                            <th>Name</th>
                            <th>Date</th>
                            <th>Type</th>
                            <th>Venue</th>
                            <th>City</th>
                            <th>Organized By</th>
                            <th>Teams</th>
                            <th>Status</th>
                            <th style="width:140px;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <#list competitions as c>
                            <tr>
                                <td>${c.id?if_exists}</td>
                                <td>
                                    <strong>${c.competitionName?if_exists}</strong>
                                </td>
                                <td><#if c.competitionDate?has_content>${c.competitionDate?if_exists?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}</#if></td>
                                <td>${c.competitionType?if_exists}</td>
                                <td>${c.venue?if_exists}</td>
                                <td>${c.city?if_exists}</td>
                                <td>${c.organizedBy.teamName?if_exists}</td>
                                <td>
                                    <span class="label label-info">
                                        ${c.competitionTeams?size}
                                    </span>
                                </td>
                                <td>
                                    <span class="label label-primary"> ${c.status?if_exists}</span>
                                </td>
                                <td>
                                    <a href="/competition/display/${c.id}"
                                       class="btn btn-xs btn-info">
                                        View
                                    </a>
                                    <a href="/competition/edit/${c.id}"
                                       class="btn btn-xs btn-warning">
                                        Edit
                                    </a>
                                </td>
                            </tr>
                        </#list>
                    </tbody>
                </table>
            </div>
        <#else>
            <div class="alert alert-info">
                No competitions found.
            </div>
        </#if>
    </div>
</div>

</div>

<#include "footer.ftl" />
