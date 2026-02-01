<#include "home.ftl">

<div class="container">

  <#-- Disable buttons if event closed -->
  <#assign disable="">
  <#if event.status == "CLOSE">
    <#assign disable="disabled">
  </#if>

  <div class="row">

    <!-- ================= EVENT INFORMATION ================= -->
    <div class="col-md-6">
      <div class="panel panel-primary equal-panel-600">

        <div class="panel-heading clearfix">
          <h4 class="panel-title pull-left">Event Information <#if event.competition?has_content>(${event.competition.competitionName?if_exists})</#if></h4>

          <div class="pull-right">
            <#if event.prevEvent?has_content>
              <a href="${baseUrl}/matches/viewMatch/${event.prevEvent.id}"
                 class="btn btn-danger btn-xs border-yellow">Prev</a>
            </#if>

            <#if event.nextEvent?has_content>
              <a href="${baseUrl}/matches/viewMatch/${event.nextEvent.id}"
                 class="btn btn-danger btn-xs border-yellow">Next</a>
            </#if>
          </div>
        </div>

        <div class="panel-body">

          <div class="row">
            <div class="col-sm-6">
              <p><strong>Event ID</strong><br>${event.id}</p>
            </div>
            <div class="col-sm-6">
              <p><strong>Event Date</strong><br>
                ${event.eventDate?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}
              </p>
            </div>
          </div>

          <hr>

          <div class="row">
            <div class="col-sm-6">
              <p><strong>Round Of</strong><br>${event.roundOf?if_exists}</p>
            </div>
            <div class="col-sm-6">
              <p><strong>Status</strong><br>
                <span class="label
                  <#if event.status == 'OPEN'>label-success
                  <#elseif event.status == 'CLOSE'>label-danger
                  <#else>label-default</#if>">
                  ${event.status}
                </span>
              </p>
            </div>
          </div>

          <hr>

          <div class="row">
            <div class="col-sm-6">
              <p><strong>Total Matches</strong><br>${matches?size}</p>
            </div>
             <div class="col-sm-6">
              <p><strong>Bye Count</strong><br>${byes?size}</p>
            </div>
          </div>

          <hr>

          <div class="row">
            <div class="col-sm-6">
              <p><strong>Pending Matches</strong><br>${openMatches?size}</p>
            </div>
            <div class="col-sm-6">
              <p><strong>Completed Matches</strong><br>${closedMatches?size}</p>
            </div>
          </div>

          <hr>
            <div class="row">
            <div class="col-sm-6">
              <p><strong>Weight </strong><br>${event.weightDefination?if_exists?capitalize}</p>
            </div>
           <div class="col-sm-6">
              <p><strong>Category</strong><br>
<#if event.categoryDefination?has_content>
<#assign category = util.getConfig(event.categoryDefination)>
                    <#if category?has_content && category.configValue?has_content>
                        ${category.configValue?if_exists?capitalize}
                    </#if>
</#if>
</p>
            </div>
          </div>

          <hr>

          <div class="row">
            <div class="col-sm-6">
              <p><strong>Gender</strong><br>${event.genderDefination?if_exists}</p>
            </div>
            <div class="col-sm-6">
              <p><strong>Bye Count</strong><br>${byes?size}</p>
            </div>
          </div>
          <hr>

        <div class="row">
            <div class="col-sm-12">
              <p><strong>Description</strong><br>
                <em>${event.description?if_exists}</em>
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- ================= MATCH DETAILS ================= -->
    <div class="col-md-6">

      <#if matches?has_content>

        <div class="panel panel-primary equal-panel-600">

          <div class="panel-heading clearfix">
            <h4 class="panel-title pull-left">Match Details</h4>

            <div class="pull-right">
              <#if openMatches?size == 0 && event.status != "CLOSE">
                <form method="post"
                      action="${baseUrl}/matches/closeEvent"
                      class="form-inline"
                      style="display:inline;">
                  <input type="hidden" name="event" value="${event.id}">
                  <input type="text"
                         class="form-control input-sm"
                         name="description"
                         placeholder="Enter Fixture Description" required>
                  <button class="btn btn-danger btn-xs border-yellow">Finish</button>
                </form>
              </#if>

              <#if event.status == "CLOSE">
                <a href="${baseUrl}/matches/openEvent/${event.id}"
                   class="btn btn-danger btn-xs border-yellow">Open</a>
              </#if>
            </div>
          </div>

          <div class="panel-body">

            <div class="table-responsive">
              <table class="table table-bordered table-striped">
                <thead>
                  <tr>
                    <th>Match Id</th>
                    <th>Blue Corner</th>
                    <th>Red Corner</th>
                    <th>Winner</th>
                  </tr>
                </thead>
                <tbody>

                <#list matches as a>
                  <tr>
                    <td>
                      <#if a.getBye()>
                        <span class="bye-badge">BYE · ${a.matchId}</span>
                      <#else>
<a href="${baseUrl?if_exists}/matches/viewMatchPair/${a.matchId}" target="_blank">
                                ${a.matchId}
                            </a> <button type="button"
          class="btn btn-xs btn-default pull-right"
          data-toggle="modal"
          data-target="#editMatchModal_${a.matchId}"
          data-match="${a.matchId}"
          data-from="${a.from.id}"
          data-to="${a.to.id}">
    <span class="glyphicon glyphicon-pencil"></span></button>

<!-- ================= EDIT MATCH MODAL ================= -->
<div class="modal fade" id="editMatchModal_${a.matchId}" tabindex="-1">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">

      <form method="post" action="${baseUrl?if_exists}/matches/updateMatchFixture">
                        <input type="hidden" name="matchId" value="${a.matchId}">
                        <input type="hidden" name="event" value="${a.event.id}">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title">Edit Match(${a.matchId}</h4>
        </div>

        <div class="modal-body">
          <input type="hidden" name="match" id="modalMatchId">

          <!-- FROM -->
          <div class="form-group">
            <label>Blue Corner</label>
<#if players?has_content>
            <select name="from" class="form-control input-sm" id="modalFrom">
             <#list players as player>
                <option value="${player.id}" <#if a.from.id==player.id> selected </#if>>${player.customerId.name?if_exists}</option>
            </#list>
            </select>
</#if>
          </div>

          <!-- TO -->
          <div class="form-group">
            <label>Red Corner</label>
<#if players?has_content>
            <select name="to" class="form-control input-sm" id="modalTo">
                 <#list players as player>
                    <option value="${player.id}" <#if a.to.id==player.id> selected </#if>>${player.customerId.name?if_exists}</option>
                </#list>
            </select>
</#if>
          </div>

        </div>

        <div class="modal-footer">
          <button type="button" class="btn btn-default btn-xs" data-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary btn-xs">Save</button>
        </div>

      </form>

    </div>
  </div>
</div>


                      </#if>
                    </td>

                    <!-- BLUE -->
                    <td>
                      <form method="post" action="${baseUrl}/matches/updateMatch">
                        <input type="hidden" name="successor" value="${a.from.id}">
                        <input type="hidden" name="event" value="${a.event.id}">
                        <input type="hidden" name="match" value="${a.matchId}">
                        <input type="hidden" name="corner" value="${a.fromCorner}">
                        <button class="btn btn-xs blue-corner min-width-130" ${disable}>
                          ${a.from.customerId.getName()}<br>
                          (${a.from.customerId.team.getTeamName()})
                        </button>
                      </form>
                    </td>

                    <!-- RED -->
                    <td>
                      <form method="post" action="${baseUrl}/matches/updateMatch">
                        <input type="hidden" name="successor" value="${a.to.id}">
                        <input type="hidden" name="event" value="${a.event.id}">
                        <input type="hidden" name="match" value="${a.matchId}">
                        <input type="hidden" name="corner" value="${a.toCorner}">
                        <button class="btn btn-xs red-corner min-width-130" ${disable}>
                          ${a.to.customerId.getName()}<br>
                          (${a.to.customerId.team.getTeamName()})
                        </button>
                      </form>
                    </td>

                    <!-- WINNER -->
                    <td>
                      <#if a.successor?has_content>
                        <form method="post" action="${baseUrl}/matches/removeMatchSuccessor">
                          <input type="hidden" name="event" value="${a.event.id}">
                          <input type="hidden" name="match" value="${a.matchId}">
                          <button class="btn btn-xs min-width-130
                            <#if a.successorCorner == 'BLUE'>blue-corner<#else>red-corner</#if>"
                            ${disable}>
                            ${a.successor.customerId.getName()}<br>
                            (${a.successor.customerId.team.getTeamName()})
                          </button>
                        </form>
                      <#else>
                        <span class="text-muted">Yet To Decide.</span>
                      </#if>
                    </td>
                  </tr>
                </#list>

                </tbody>
              </table>
            </div>

          </div>

          <!-- ====== PANEL FOOTER : SHUFFLE (CORRECT PLACE) ====== -->

            <div class="panel-footer clearfix">
              <div class="pull-right">
<#if !event.parentEventId?has_content>
                <a href="${baseUrl}/matches/shuffleEvent/${event.id}"
                   class="btn btn-warning btn-xs">
                  Shuffle Matches
                </a>
          </#if>
                <form method="post"
                      action="${baseUrl}/reports/event"
                      class="form-inline"
                      style="display:inline;" target="_blank">
                  <input type="hidden" name="compId" value="${event.competition.id}">
                  <input type="hidden" name="eventId" value="${event.id}">
                  <button class="btn btn-primary btn-xs border-yellow">View</button>
                </form>
              </div>
            </div>
        </div>

      <#else>
        <div class="alert alert-info">No Event records available.</div>
      </#if>

    </div>

  </div>
</div>

<#include "footer.ftl">
