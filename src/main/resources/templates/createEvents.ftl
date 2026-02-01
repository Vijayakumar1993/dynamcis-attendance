<#include "home.ftl">

<div class="container">

  <!-- Search Section -->
  <div class="row">
    <div class="col-xs-12">
      <h2>Search Fixtures Player</h2>
    </div>
  </div>

  <form action="${baseUrl}/fixture/viewFixtures" id="fixture-form" method="post">
    <div class="row">

 <!-- Competition -->
      <div class="col-lg-3 col-md-3 col-sm-6">
        <div class="form-group">
          <label>Competition</label>
         <select name="competitions" class="form-control" required onchange="getCategories(this)">
            <option value="">-- Select Competition --</option>
<#if competitions?has_content>
            <#list competitions as c>
              <option value="${c.id?if_exists}"
                <#if compId?has_content && compId == c.id?string>selected</#if>>
                ${c.competitionName?capitalize?if_exists}
              </option>
            </#list>
</#if>
          </select>
        </div>
      </div>

      <!-- Gender -->
      <div class="col-lg-3 col-md-3 col-sm-6">
        <div class="form-group">
          <label>Gender</label>
          <select name="gender" class="form-control" required>
            <option value="">-- Select Gender --</option>
            <option value="male" <#if gender?has_content && gender == "male">selected</#if>>Male</option>
            <option value="female" <#if gender?has_content && gender == "female">selected</#if>>Female</option>
            <option value="other" <#if gender?has_content && gender == "other">selected</#if>>Other</option>
          </select>
        </div>
      </div>

      <!-- Category -->
      <div class="col-lg-3 col-md-3 col-sm-6">
        <div class="form-group">
          <label>Category</label>
          <#assign categorization = util.getConfigs("categorization", "name")>
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
        </div>
      </div>

      <!-- Weight Range -->
      <div class="col-lg-3 col-md-3 col-sm-6">
        <div class="form-group">
          <label>Weight Range (kg)</label>
          <div class="input-group">
            <input type="number" class="form-control"
                   name="from" placeholder="From"
                   <#if from?has_content>value="${from}"</#if> min=0 step="any" required>
            <span class="input-group-addon">to</span>
            <input type="number" class="form-control"
                   name="to" placeholder="To"
                   <#if to?has_content>value="${to}"</#if>  min=0 step="any" required>
          </div>
        </div>
      </div>

      <!-- Search Button -->
      <div class="col-lg-3 col-md-3 col-sm-6">
        <div class="form-group">
          <label>&nbsp;</label>
          <button type="submit" class="btn btn-primary btn-block">
            Search
          </button>
        </div>
      </div>

    </div>
  </form>

  <hr>

  <!-- Students Section -->
  <div class="row">
    <div class="col-xs-12">
      <h2>
        Fixture's Player List
          <form action="${baseUrl}/fixture/createFixture" method="post" class="form-inline pull-right">
            <input type="hidden" name="gender" value="${gender?if_exists}">
            <input type="hidden" name="category" value="${category?if_exists}">
            <input type="hidden" name="from" value="${from?if_exists}">
            <input type="hidden" name="to" value="${to?if_exists}">
            <input type="hidden" name="compId" value="${compId?if_exists}">
            <input type="text" class="form-control  input-sm"
                   name="description"
                   id="description"
                   placeholder="Enter Fixture Description." required>
            <button class="btn btn-primary btn-xs border-yellow">Create Fixture</button>
          </form>
      </h2>
    </div>
  </div>

  <!-- Table -->
  <div class="row">
    <div class="col-xs-12">
      <div class="table-responsive">
        <table class="table table-striped table-bordered">
          <thead>
            <tr>
              <th>ID</th>
              <th>Name</th>
              <th>Category</th>
              <th>Weight</th>
              <th>Gender</th>
              <th>Phone</th>
              <th>Email</th>
              <th>Joined Date</th>
              <th>Created Date</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <#if customers?? && customers?size gt 0>
              <#list customers as c>
                <tr <#if c.status?? && c.status == "INACTIVE">class="absent"</#if>>
                  <td>
                    <a href="${baseUrl}/customer/viewCustomer/${c.id?if_exists}">
                      ${c.id?if_exists}
                    </a>
                  </td>
                  <td>${c.name?if_exists}</td>
                  <td>
                    <#if c.category?has_content>
                      <#assign cat = util.getConfig(c.category)>
                      ${cat.configValue?if_exists}
                    </#if>
                  </td>
                  <td>${c.weight?if_exists}</td>
                  <td>${c.gender?if_exists}</td>
                  <td>${c.phone?if_exists}</td>
                  <td>${c.email?if_exists}</td>
                  <td>${c.joiningDate?if_exists}</td>
                  <td>${c.createdDate?if_exists}</td>
                  <td>
                    <a href="${baseUrl}/customer/editCustomer/${c.id?if_exists}"
                       class="btn btn-primary btn-xs">Edit</a>
                    <a href="${baseUrl}/customer/deleteCustomer/${c.id?if_exists}"
                       class="btn btn-danger btn-xs">Deactivate</a>
                  </td>
                </tr>
              </#list>
            <#else>
              <tr>
                <td colspan="10" class="text-center text-muted">
                  No customers found.
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