<#include "home.ftl">

<div class="mt-5">

    <!-- ===================================================== -->
    <!-- FIND FIXTURE -->
    <!-- ===================================================== -->
    <h2 class="mb-3">Find Fixture<span  class="pull-right" style="font-size: 15px">
 <form action="${baseUrl}/reports/eventList"
                  method="post"
                  onsubmit="return submitSelectedFixtures();"
                  class="form-inline"
                      style="display:inline;" target="_blank">

                <input type="hidden" name="eventId" id="fixtureIds"/>

                <input type="text"
                         class="form-control input-sm"
                         name="bout"
                         placeholder="Enter Bout Index" required>

                <button type="submit" class="btn btn-sm btn-danger">
                    View
                </button>
            </form>
</span></h2>

    <div class="card mb-4">
        <div class="card-body p-3">
            <div class="">
<form action="${baseUrl}/fixture/filterFixtures" method="post">

    <!-- ================= Row 1 ================= -->
    <div class="row" style="margin-bottom:10px;">

        <!-- Competition -->
        <div class="col-md-3">
            <div class="form-group">
                <label class="control-label">Competition</label>
                <select name="competition" class="form-control" required onchange="getCategories(this)">
                    <option value="">-- Select Competition --</option>
                    <#if competitions?has_content>
                        <#list competitions as c>
                            <option value="${c.id?if_exists}"
                              <#if event?? && event.competition?has_content && event.competition.id == c.id>selected</#if>>
                                ${c.competitionName?capitalize?if_exists}
                            </option>
                        </#list>
                    </#if>
                </select>
            </div>
        </div>

        <!-- Fixture ID -->
        <div class="col-md-2">
            <div class="form-group">
                <label class="control-label">Fixture ID</label>
                <input type="text"
                       name="id"
                       class="form-control"
                       placeholder="Fixture ID"
                       <#if event?has_content>value="${event.id?if_exists}"</#if>>
            </div>
        </div>

        <!-- Event Date -->
        <div class="col-md-2">
            <div class="form-group">
                <label class="control-label">Event Date</label>
                <input type="date"
                       name="eventDate"
                       class="form-control"
                       <#if event?has_content>value="${event.eventDate?if_exists}"</#if>>
            </div>
        </div>

        <!-- Round Of -->
        <div class="col-md-2">
            <div class="form-group">
                <label class="control-label">Round</label>

                <#assign roundOffList = []>
                <#list 1..10 as i>
                    <#assign value = 1>
                    <#list 1..i as j>
                        <#assign value = value * 2>
                    </#list>
                    <#assign roundOffList = roundOffList + [value?string]>
                </#list>

                <select name="roundOf" class="form-control">
                    <option value="">-- Select --</option>
                    <#list roundOffList as c>
                        <option value="${c}"
                          <#if event?has_content && event.roundOf?has_content && event.roundOf?string == c>selected</#if>>
                            ${c}
                        </option>
                    </#list>
                </select>
            </div>
        </div>

        <!-- Category -->
        <div class="col-md-3">
            <div class="form-group">
                <label class="control-label">Category</label>
                <select id="category" name="categoryDefination" class="form-control">
                    <option value="">-- Select Category --</option>
                    <#if categories?has_content>
                              <#list categories as cat>
                                <option value="${cat.configId?if_exists}" <#if event.categoryDefination??><#if event.categoryDefination=="${cat.configId}"> selected</#if></#if>>
                                  ${cat.configValue?capitalize}
                                </option>
                              </#list>
                    </#if>
                </select>
            </div>
        </div>

    </div>

    <!-- ================= Row 2 ================= -->
    <div class="row" style="margin-bottom:15px;">
        <!-- Gender -->
        <div class="col-md-3">
            <div class="form-group">
                <label class="control-label">Gender</label>
                <select name="genderDefination" class="form-control">
                    <option value="">-- Select --</option>
                    <option value="male"
                      <#if event?has_content && event.genderDefination?? && event.genderDefination == 'male'>selected</#if>>
                        Male
                    </option>
                    <option value="female"
                      <#if event?has_content && event.genderDefination?? && event.genderDefination == 'female'>selected</#if>>
                        Female
                    </option>
                    <option value="other"
                      <#if event?has_content && event.genderDefination?? && event.genderDefination == 'other'>selected</#if>>
                        Other
                    </option>
                </select>
            </div>
        </div>

        <!-- Status -->
        <div class="col-md-2">
            <div class="form-group">
                <label class="control-label">Status</label>
                <select name="status" class="form-control">
                    <option value="">-- All --</option>
                    <option value="OPEN"
                      <#if event?has_content && event.status?if_exists == "OPEN">selected</#if>>
                        OPEN
                    </option>
                    <option value="CLOSE"
                      <#if event?has_content && event.status?if_exists == "CLOSE">selected</#if>>
                        CLOSE
                    </option>
                </select>
            </div>
        </div>

        <!-- Show Primary -->
        <div class="col-md-4">
            <div class="form-group">
                <label class="control-label">&nbsp;</label>
                <div class="checkbox" style="margin-top:6px;">
                    <label>
                        <input type="checkbox" name="show"
                          <#if show?has_content && show>checked</#if>>
                        Show Primary Fixtures
                    </label>
                </div>
            </div>
        </div>

        <!-- Search Button -->
        <div class="col-md-3 text-right">
            <div class="form-group">
                <label class="control-label">&nbsp;</label>
                <div>
                    <button type="submit" class="btn btn-primary btn-sm">
                        <i class="glyphicon glyphicon-search"></i> Search
                    </button>
                </div>
            </div>
        </div>

    </div>

</form>

            </div>

        </div>
    </div>

    <!-- ===================================================== -->
    <!-- FIXTURE LIST HEADER BAR -->
    <!-- ===================================================== -->
    <div class="d-flex justify-content-between align-items-center mb-3 border-bottom pb-2">

         <h2 class="mb-4">Fixtures List</h2>
    </div>

    <!-- ===================================================== -->
    <!-- TABLE -->
    <!-- ===================================================== -->
    <div class="table-responsive">
        <table class="table table-striped table-bordered"
               id="fixtureTable">
            <thead class="table-dark">
            <tr>
            <th class="text-center">
                    <input type="checkbox" onclick="toggleAll(this)">
                </th>
                <th>ID</th>
                <th>Parent Fixture</th>
                <th>Event Date</th>
                <th>Round Of</th>
                <th>Description</th>
                <th>Category</th>
                <th>Weight</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
            </thead>

            <tbody>
            <#if events?? && events?size gt 0>
                <#list events as c>
                    <tr>
                    <td class="text-center">
                            <input type="checkbox"
                                   class="fixture-check"
                                   value="${c.id}">
                        </td>
                        <td>
                            <a href="${baseUrl?if_exists}/matches/viewMatch/${c.id}">
                                ${c.id}
                            </a>
                        </td>

                        <td>
                            <#if c.parentEventId?has_content>
                                ${c.parentEventId.id}
                            </#if>
                        </td>

                        <td>
                            <#if c.eventDate?has_content>
                                ${c.eventDate?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}
                            </#if>
                        </td>

                        <td>${c.roundOf?if_exists}</td>
                        <td>${c.description?if_exists}</td>

                        <td>
                            <#if c.categoryDefination?has_content>
                                <#assign cat = util.getConfig(c.categoryDefination)>
                                <#if cat?has_content>${cat.configValue}</#if>
                            </#if>
                        </td>

                        <td>${c.weightDefination?if_exists}</td>

                        <td>
                            <span class="badge badge-secondary">
                                ${c.status?if_exists}
                            </span>
                        </td>

                        <td class="text-center">
                            <a href="${baseUrl?if_exists}/fixture/deleteEvent/${c.id}"
                               onclick="return confirm('Delete this fixture?')">
                                <span class="text-danger">&#10008;</span>
                            </a>
                        </td>
                    </tr>
                </#list>
            <#else>
                <tr>
                    <td colspan="9" class="text-center text-muted">
                        No Events found.
                    </td>
                </tr>
            </#if>
            </tbody>
        </table>
    </div>

</div>


<!-- ===================================================== -->
<!-- JAVASCRIPT -->
<!-- ===================================================== -->
<script>
    function submitSelectedFixtures() {
var ids = [];
$('.fixture-check:checked').each(function () {
ids.push($(this).val());
});

        if (ids.length === 0) {
alert('Please select at least one fixture.');
return false;
}

        $('#fixtureIds').val(ids.join(','));
        return true;
    }

    function toggleAll(source) {
$('.fixture-check').prop('checked', source.checked);
}
</script>
<#include "footer.ftl">
