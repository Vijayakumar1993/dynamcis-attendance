<#include "home.ftl" />

<div class="container" style="margin-top:40px;">
  <div class="row">
    <div class="col-md-10 col-md-offset-1">

      <div class="panel panel-default">
        <div class="panel-heading" style="background:#222;color:#f0ad4e;">
          <h3 class="panel-title text-uppercase"><#if competition?has_content>Edit<#else>Create</#if> Competition</h3>
        </div>

        <div class="panel-body">

          <form action="${baseUrl?if_exists}/competition/createCompetition" method="post"  enctype="multipart/form-data">

            <#-- Hidden ID for Edit -->
            <#if competition?has_content>
              <input type="hidden" name="id" value="${competition.id?if_exists}">
            </#if>

            <!-- ================= Competition Details ================= -->
            <h4 class="text-primary">Competition Details</h4>
            <hr>

            <div class="row">
              <div class="col-md-6">
                <div class="form-group">
                  <label>Competition Name <span class="text-danger">*</span></label>
                  <input type="text" class="form-control"
                         name="competitionName"
                         placeholder="New Year Boxing Championship"
                         value="<#if competition?has_content>${competition.competitionName?if_exists}</#if>"
                         required>
                </div>
              </div>

              <div class="col-md-3">
                <div class="form-group">
                  <label>Competition Date <span class="text-danger">*</span></label>
                  <input type="date" class="form-control"
                         name="competitionDate"
                         value="<#if competition?has_content>${competition.competitionDate?if_exists}</#if>"
                         required>
                </div>
              </div>

              <div class="col-md-3">
                <div class="form-group">
                  <label>Competition Type <span class="text-danger">*</span></label>
                  <select class="form-control" name="competitionType" required>
                    <option value="">-- Select --</option>
                    <#list ["District","State","Open","Invitational"] as type>
                      <option value="${type}"
                        <#if competition?has_content && competition.competitionType == type>selected</#if>>
                        ${type}
                      </option>
                    </#list>
                  </select>
                </div>
              </div>
            </div>

            <!-- ================= Venue & Organizer ================= -->
            <h4 class="text-primary">Venue, Organizer & Rules</h4>
            <hr>

            <div class="row">
              <div class="col-md-6">
                <div class="form-group">
                  <label>Venue Name <span class="text-danger">*</span></label>
                  <input type="text" class="form-control"
                         name="venue"
                         value="<#if competition?has_content>${competition.venue?if_exists}</#if>"
                         required>
                </div>
              </div>

              <div class="col-md-3">
                <div class="form-group">
                  <label>City <span class="text-danger">*</span></label>
                  <input type="text" class="form-control"
                         name="city"
                         value="<#if competition?has_content>${competition.city?if_exists}</#if>"
                         required>
                </div>
              </div>

              <div class="col-md-3">
                <div class="form-group">
                  <label>Organized By <span class="text-danger">*</span></label>
                  <select class="form-control" name="organizedBy" required>
                    <option value="">-- Select Team --</option>
                    <#assign teams = util.teams()>
                    <#list teams as t>
                      <option value="${t.id}"
                        <#if competition?has_content
                             && competition.organizedBy?has_content
                             && competition.organizedBy.id == t.id>selected</#if>>
                        ${t.teamName?capitalize}
                      </option>
                    </#list>
                  </select>
                </div>
              </div>
            </div>

            <div class="row">
              <div class="col-md-4">
                <div class="form-group">
                  <label>Image <span class="text-danger">*</span></label>
                   <input type="file" name="matchImage" class="form-control mb-2">
              <#if competition?has_content> <p class="help-block">Update the image here, or leave it empty to keep the existing one.</p></#if>
                </div>
              </div>
              <div class="col-md-4">
                <div class="form-group">
                  <label>No. of Rounds <span class="text-danger">*</span></label>
                  <input type="number" class="form-control"
                         name="rounds" min="1" max="12" step="any"
                         value="<#if competition?has_content>${competition.rounds?if_exists}</#if>"
                         required>
                </div>
              </div>

              <div class="col-md-4">
                <div class="form-group">
                  <label>Round Duration (mins) <span class="text-danger">*</span></label>
                  <input type="number" class="form-control"
                         name="roundDuration" min="1" max="5"
                         value="<#if competition?has_content>${competition.roundDuration?if_exists}</#if>"
                         required>
                </div>
              </div>
            </div>

            <!-- ================= Participating Teams ================= -->
            <h4 class="text-primary">Requesting Teams & Categories</h4>
            <hr>

<!-- categrization filter -->
            <div class="row">
              <div class="col-md-6">
  <div class="form-group">
<label>Teams<span class="text-danger">*</span></label>
              <select class="form-control" name="requestedTeams" multiple size="5">
                <#list teams as t>
   <#assign isSelected = false>

    <#if competition?has_content && competition.competitionTeams?has_content>
      <#list competition.competitionTeams as ct>
        <#if ct.team?has_content && ct.team.id == t.id>
          <#assign isSelected = true>
        </#if>
      </#list>
    </#if>
                  <option value="${t.id}" <#if isSelected>selected</#if>>
                    ${t.teamName?capitalize}
                  </option>
                </#list>
              </select>
              <p class="help-block">Hold Ctrl to select multiple teams</p>
            </div>

</div>
              <div class="col-md-6">
  <div class="form-group">
<label>Categories<span class="text-danger">*</span></label>
<#assign categorization = util.getConfigs("categorization","name")>
              <select class="form-control" name="categories" multiple size="5">
               <#list categorization as c>
<#assign isSelected = false>
    <#if competition?has_content && competition.competitionCategories?has_content>
      <#list competition.competitionCategories as ct>
        <#if ct.category?has_content && ct.category.configId == c.configId>
          <#assign isSelected = true>
        </#if>
      </#list>
    </#if>
                  <option value="${c.configId?if_exists}"
                    <#if isSelected>selected</#if>>
                    ${c.configValue?capitalize?if_exists}
                  </option>
                </#list>
              </select>
              <p class="help-block">Hold Ctrl to select multiple teams</p>
            </div>
</div>
</div>


            <!-- ================= Remarks ================= -->
            <div class="form-group">
              <label>Remarks</label>
              <textarea class="form-control" rows="3"
                        name="remarks"><#if competition?has_content>${competition.remarks?if_exists}</#if></textarea>
            </div>

            <hr>

            <!-- ================= Actions ================= -->
            <div class="text-right">
              <button type="submit" class="btn btn-success">
                Save Competition
              </button>
              <a href="/competition/listCompetition" class="btn btn-default">
                Cancel
              </a>
            </div>

          </form>

        </div>
      </div>

    </div>
  </div>
</div>

<#include "footer.ftl" />
