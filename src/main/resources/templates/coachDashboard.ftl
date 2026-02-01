<#include "home.ftl" />

<div class="container" style="margin-top:30px;">

  <!-- Page Title -->

  <div class="row">
    <div class="col-md-12">
      <h3 class="text-uppercase">Coach Dashboard</h3>
      <p class="text-muted">Current & Upcoming Competitions</p>
      <hr>
    </div>
  </div>

  <!-- Competition Cards -->

  <div class="row">

<#if competitions?has_content>
  <#list competitions as c>
    <div class="col-md-4">
 <#assign compTeam = util.getCompetetionTeam(c,team)>
      <div class="panel panel-default" style="box-shadow:0 2px 6px rgba(0,0,0,0.15);">

        <!-- Competition Image -->
        <div style="height:200px;overflow:hidden;">
          <#if c.image?has_content>
             <img src="data:image/png;base64,${Base64UtilEncoder.encodeToString(c.image)}" class="img-responsive" style="width:100%;">
          <#else>
            <img src="/images/no-image.jpg" class="img-responsive" style="width:100%;">
          </#if>
        </div>

        <!-- Card Body -->
        <div class="panel-body">
          <h4 class="text-primary">${c.competitionName?if_exists}&nbsp;
<#if compTeam?has_content>
<#if compTeam.status=="REJECTED">
<span class="label label-danger">
<#else>
<span class="label label-success"></#if>
${compTeam.status?if_exists}</span>
</#if>
</h4>

          <p class="text-muted" style="margin-bottom:5px;">
            <strong>Date:</strong>
            ${c.competitionDate?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}
          </p>

          <p class="text-muted" style="margin-bottom:5px;">
            <strong>Type:</strong>
            ${c.competitionType?if_exists}
          </p>

          <p class="text-muted" style="margin-bottom:5px;">
            <strong>Venue:</strong>
            ${c.venue?if_exists}, ${c.city?if_exists}
          </p>

          <p class="text-muted" style="margin-bottom:10px;">
            <strong>Organized By:</strong>
            ${c.organizedBy.teamName?if_exists}
          </p>

          <hr style="margin:10px 0;">

          <!-- Actions -->
          <div class="text-center">
            <a href="${baseUrl?if_exists}/competition/display/${c.id?if_exists}" class="btn btn-info btn-sm">
              View Details
            </a>

<#if compTeam?has_content>
<#if compTeam.status?if_exists!="APPROVED">
            <a href="${baseUrl?if_exists}/competition/enrollCompetition/${compTeam.id?if_exists}" class="btn btn-success btn-sm">
              Enroll Team
            </a>
<#else>
     <a href="${baseUrl?if_exists}/competition/revokeCompetition/${compTeam.id?if_exists}" class="btn btn-success btn-sm">
              Revoke enrollment
            </a>
</#if>

<#if compTeam.status?if_exists!="REJECTED">
      <a href="${baseUrl?if_exists}/competition/rejectCompetition/${compTeam.id?if_exists}" class="btn btn-danger btn-sm">
              Reject
            </a>
</#if>
</#if>
          </div>
        </div>

      </div>
    </div>
  </#list>
<#else>
  <div class="col-md-12">
    <div class="alert alert-info">
      No active competitions available at the moment.
    </div>
  </div>
</#if>
  </div>

</div>

<#include "footer.ftl" />
