<#-- teams.ftl -->
<#include "home.ftl">

<div class="container" style="margin-top:30px;">
  <div class="row">
    <div class="col-md-12">

      <div class="panel panel-default">

        <!-- Panel Header -->
        <div class="panel-heading" style="background:#222;color:#f0ad4e;">
          <div class="row">
            <div class="col-md-6">
              <h3 class="panel-title text-uppercase">Teams</h3>
            </div>
            <div class="col-md-6 text-right">
              <a href="${baseUrl?if_exists}/teams"
                 class="btn btn-xs btn-success">
                + Create Team
              </a>
            </div>
          </div>
        </div>

        <!-- Panel Body -->
        <div class="panel-body table-responsive">

          <table class="table table-bordered table-striped table-hover">
            <thead>
              <tr class="bg-primary" style="color:#fff;">
                <th style="width:60px;">ID</th>
                <th>Team Name</th>
                <th>Coach</th>
                <th>Location</th>
                <th>Description</th>
                <th style="width:90px;">Status</th>
                <th style="width:130px;">Actions</th>
              </tr>
            </thead>

            <tbody>
            <#if teams?has_content>
              <#list teams as t>
                <tr>
                  <!-- ID -->
                  <td class="text-center">
                     <a href="${baseUrl?if_exists}/teams/viewTeam/${t.id?if_exists}" target="_blank">
                  ${t.id?if_exists}
                </a>
                  </td>

                  <!-- Team Name -->
                  <td>
                    <strong>${t.teamName?if_exists}</strong>
                  </td>

                  <!-- Coach -->
                  <td>
                    <#if t.customer??>
                      ${t.customer.name?if_exists}
                    <#else>
                      <span class="text-muted">Not Assigned</span>
                    </#if>
                  </td>

                  <!-- Location -->
                  <td>${t.location?if_exists}</td>

                  <!-- Description -->
                  <td>
                    <#if t.description?has_content>
                      ${t.description}
                    <#else>
                      <span class="text-muted">-</span>
                    </#if>
                  </td>

                  <!-- Status -->
                  <td class="text-center">
                    <#if t.status == 'ACTIVE'>
                      <span class="label label-success">ACTIVE</span>
                    <#else>
                      <span class="label label-default">INACTIVE</span>
                    </#if>
                  </td>

                  <!-- Actions -->
                  <td class="text-center">
<#if authorities?has_content>
<#if authorities?seq_contains("ROLE_ADMIN") || authorities?seq_contains("ROLE_EMPLOYEE")>
<a href="${baseUrl?if_exists}/teams/edit/${t.id}"
                       class="btn btn-xs btn-primary">
                      Edit
                    </a>
                    <a href="${baseUrl?if_exists}/teams/delete/${t.id}"
                       class="btn btn-xs btn-danger"
                       onclick="return confirm('Delete this team?');">
                      Delete
                    </a>
</#if>
</#if>
                  </td>
                </tr>
              </#list>
            <#else>
              <tr>
                <td colspan="7" class="text-center text-muted">
                  No teams found.
                </td>
              </tr>
            </#if>
            </tbody>

          </table>

        </div>
      </div>

    </div>
  </div>
</div>

<#include "footer.ftl">
