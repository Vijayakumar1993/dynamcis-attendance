<#-- teams.ftl -->
<#include "home.ftl">

<div class="container" style="margin-top:30px;">
  <div class="row">
    <div class="col-md-10 col-md-offset-1">

      <div class="panel panel-default shadow-sm">

        <!-- Header -->
        <div class="panel-heading" style="background:#222;color:#f0ad4e;">
          <h3 class="panel-title text-uppercase">
            <#if team?has_content>Update<#else>Create</#if> Team
          </h3>
        </div>

        <!-- Body -->
        <div class="panel-body">
          <form method="post"
                action="${baseUrl?if_exists}/teams/createTeam"
                enctype="multipart/form-data">

            <#if team?has_content>
              <input type="hidden" name="id" value="${team.id?if_exists}">
            </#if>

            <!-- ================= Team Basic Info ================= -->
            <h4 class="text-primary">Team Information</h4>
            <hr>

            <div class="row">
              <div class="col-md-6">
                <div class="form-group">
                  <label>Team Name <span class="text-danger">*</span></label>
                  <input type="text"
                         name="teamName"
                         class="form-control"
                         placeholder="Enter team name"
                         value="<#if team?has_content>${team.teamName?if_exists}</#if>"
                         required>
                </div>
              </div>

              <div class="col-md-6">
                <#assign teamId="">
                <#assign teamName="">
                <#if team?has_content>
                  <#assign teamId="${team.id?if_exists}">
                  <#assign teamName="${team.teamName?if_exists}">
                </#if>
               <@inputCustomers
                label="Coach"
                name="coachName"
                defaultId="${(team.customer.id)!''}"
                defaultValue="${(team.customer.id)!''}"
                lookupFunction="openCustomerLookupWithRole('ROLE_COACH')" />
              </div>
            </div>

            <!-- ================= Location & Status ================= -->
            <h4 class="text-primary">Additional Details</h4>
            <hr>

            <div class="row">
              <div class="col-md-6">
                <div class="form-group">
                  <label>Location <span class="text-danger">*</span></label>
                  <input type="text"
                         name="location"
                         class="form-control"
                         placeholder="City / Area"
                         value="<#if team?has_content>${team.location?if_exists}</#if>"
                         required>
                </div>
              </div>

              <div class="col-md-6">
                <div class="form-group">
                  <label>Status <span class="text-danger">*</span></label>
                  <select name="status" class="form-control" required>
                    <option value="">-- Select Status --</option>
                    <option value="ACTIVE"
                      <#if team?has_content && team.status == 'ACTIVE'>selected</#if>>
                      ACTIVE
                    </option>
                    <option value="INACTIVE"
                      <#if team?has_content && team.status == 'INACTIVE'>selected</#if>>
                      INACTIVE
                    </option>
                  </select>
                </div>
              </div>
            </div>

            <!-- ================= Description ================= -->
            <div class="form-group">
              <label>Description</label>
              <textarea name="description"
                        class="form-control"
                        rows="3"
                        placeholder="Short description (optional)"><#if team?has_content>${team.description?if_exists}</#if></textarea>
            </div>

            <hr>

            <!-- ================= Actions ================= -->
            <div class="text-right">
              <button type="submit" class="btn btn-success">
                <#if team?has_content>Update<#else>Create</#if> Team
              </button>
              <a href="${baseUrl?if_exists}/teams/list"
                 class="btn btn-default">
                Cancel
              </a>
            </div>

          </form>
        </div>

      </div>
    </div>
  </div>
</div>

<#include "footer.ftl">
