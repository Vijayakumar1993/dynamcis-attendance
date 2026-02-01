<#include "home.ftl">
<div class="container">
<#assign scheduledCompetitionByTeam = util.findScheduledCompetitionByTeam(team) />
  <!-- ================= TEAM DETAILS ================= -->
  <div class="panel panel-primary">
    <div class="panel-heading">
      <h4 class="panel-title">Team Details</h4>
    </div>

    <div class="panel-body">

      <div class="row">
        <div class="col-sm-6">
          <p><strong>Team ID</strong><br/>
            <span class="text-muted">${team.id?if_exists}</span>
          </p>
        </div>

        <div class="col-sm-6">
          <p><strong>Team Name</strong><br/>
            <span class="text-muted">${team.teamName?if_exists}</span>
          </p>
        </div>
      </div>

      <hr/>

      <div class="row">
        <div class="col-sm-6">
          <p><strong>Coach</strong><br/>
            <span class="text-muted">
<#if team.customer??>
    <#assign cust = util.getCustomer("${team.customer.id}")>
    <a href="${baseUrl?if_exists}/customer/viewCustomer/${team.customer.id!}" target="_BLANK">${team.customer.name?if_exists}</a>
</#if>
</span>
          </p>
        </div>

        <div class="col-sm-6">
          <p><strong>Location</strong><br/>
            <span class="text-muted">${team.location?if_exists}</span>
          </p>
        </div>
      </div>

      <hr/>

      <div class="row">
        <div class="col-sm-6">
          <p><strong>Status</strong><br/>
            <span class="label <#if team.status == 'ACTIVE'>label-success<#else>label-danger</#if>">
              ${team.status?if_exists}
            </span>
          </p>
        </div>

        <div class="col-sm-6">
          <p><strong>Description</strong><br/>
            <span class="text-muted">${team.description?if_exists}</span>
          </p>
        </div>
      </div>

    </div>
  </div>
  <!-- ================= STUDENT LIST ================= -->
  <div class="panel panel-default">

    <!-- Header + Filters -->
    <div class="panel-heading clearfix">
      <h4 class="panel-title pull-left" style="margin-top:6px;">
        Students List
      </h4>

      <form action="${baseUrl?if_exists}/teams/selection"
            method="post"
            class="form-inline pull-right">

        <input type="hidden" name="team" value="${team.id?if_exists}"/>
<select name="competitions" class="form-control input-sm" required onchange="getCategories(this)">
            <option value="">-- Select Competition --</option>
<#if scheduledCompetitionByTeam?has_content>
            <#list scheduledCompetitionByTeam as c>
              <option value="${c.id?if_exists}"
                <#if selectedCompetition?has_content && selectedCompetition.id?string == c.id?string>selected</#if>>
                ${c.competitionName?capitalize?if_exists}
              </option>
            </#list>
</#if>
          </select>
        <select name="gender" class="form-control input-sm">
          <option value="">Gender</option>
          <option value="male" <#if gender??><#if gender == "male">selected</#if></#if>>Male</option>
          <option value="female" <#if gender??><#if gender == "female">selected</#if></#if>>Female</option>
        </select>

        <select id="category" name="category" class="form-control input-sm">
          <option value="">-- Select Category --</option>
<#if categories?has_content>
          <#list categories as cat>
            <option value="${cat.configId?if_exists}" <#if category??><#if category=="${cat.configId}"> selected</#if></#if>>
              ${cat.configValue?capitalize}
            </option>
          </#list>
</#if>
        </select>

        <input type="number" name="from"
               class="form-control input-sm"
               placeholder="Weight From"
value="${from?if_exists}"
               style="width:90px"/>

        <input type="number" name="to"
               class="form-control input-sm"
               placeholder="Weight To"
value="${to?if_exists}"
               style="width:90px"/>

        <button type="submit" class="btn btn-sm btn-danger">
          Search
        </button>
      </form>
    </div>
    <div class="table-responsive">
      <table class="table table-bordered table-striped table-hover">
        <thead class="bg-info">
          <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Category</th>
            <th>Weight</th>
            <th>Gender</th>
            <th>Phone</th>
            <th>Email</th>
            <th>Team</th>
            <th>Joined</th>
            <th>Created</th>
            <th>Action</th>
          </tr>
        </thead>

        <tbody>
        <#if customers?has_content>
          <#list customers as c>
            <tr <#if c.status == "INACTIVE">class="danger"</#if>>
              <td>
                <a href="${baseUrl?if_exists}/customer/viewCustomer/${c.id}">
                  ${c.id}
                </a>
              </td>
              <td>${c.name}</td>
              <td>
<#if c.category??>
<#assign category = util.getConfig(c.category)>
                    <#if category?has_content && category.configValue?has_content>
                        ${category.configValue?if_exists?capitalize}</div>
                    </#if>
</#if>
</td>
              <td>${c.weight?default("0")}</td>
              <td>${c.gender?if_exists}</td>
              <td>${c.phone?if_exists}</td>
              <td>${c.email?if_exists}</td>
              <td>${c.team.teamName?if_exists}</td>
              <td><#if c.joiningDate??>${c.joiningDate}</#if></td>
              <td><#if c.createdDate??>${c.createdDate}</#if></td>
              <td>
<#if selectedCompetition?has_content>
    <#assign selectedCompetion = util.findByTeamAndCompetitionAndCustomerFindFirst(team, c,selectedCompetition)>
        <div class="checkbox">
            <label>
                <input type="checkbox"
                       name="compId"
                       value="${selectedCompetition.id?if_exists}"
                       onclick="saveTeamCompetition('${team.id?if_exists}','${c.id?if_exists}',this);"
                       <#if selectedCompetion?has_content && selectedCompetion.isPresent()>
                           checked
                       </#if>
                />
            </label>
        </div>
</#if>
              </td>
            </tr>
          </#list>
        <#else>
          <tr>
            <td colspan="11" class="text-center text-muted">
              No students found
            </td>
          </tr>
        </#if>
        </tbody>
      </table>
    </div>

  </div>
</div>

<#include "footer.ftl">
