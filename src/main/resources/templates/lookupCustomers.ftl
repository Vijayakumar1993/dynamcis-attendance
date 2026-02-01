<div class="container">
<div class="my-5">
  <h2 class="mb-4">Find Customers</h2>
  <form action="${baseUrl?if_exists}/lookup/viewCustomers" id="fixture-form" method="post">
<div class="row">

  <!-- Name -->
  <div class="col-md-4 col-sm-4 col-xs-4 mb-3 pb-2">
    <div class="form-group">
      <label for="name">Full Name</label>
      <input type="text" id="name" name="name" class="form-control"
             placeholder="Enter full name"
             value="<#if name??>${name?if_exists}</#if>">
    </div>
  </div>

  <!-- Phone -->
  <div class="col-md-4 col-sm-4 col-xs-4  mb-3 pb-2">
    <div class="form-group">
      <label for="phone">Phone Number</label>
      <input type="text" id="phone" name="phone" class="form-control"
             placeholder="Enter phone number"
             value="<#if phone??>${phone?if_exists}</#if>">
    </div>
  </div>

  <!-- Gender -->
  <div class="col-md-4  col-sm-4 col-xs-4 mb-3 pb-2">
    <div class="form-group">
      <label for="gender">Gender</label>
      <select id="gender" name="gender" class="form-control">
        <option value="">-- Select Gender--</option>
        <option value="male" <#if gender?has_content && gender == "male">selected</#if>>Male</option>
        <option value="female" <#if gender?has_content && gender == "female">selected</#if>>Female</option>
        <option value="other" <#if gender?has_content && gender == "other">selected</#if>>Other</option>
      </select>
    </div>
  </div>

  <!-- Email -->
  <div class="col-md-4  col-sm-4 col-xs-4 mb-3 pb-2">
    <div class="form-group">
      <label for="email">Email</label>
      <input type="email" id="email" name="email" class="form-control"
             placeholder="Enter email"
             value="<#if email??>${email?if_exists}</#if>">
    </div>
  </div>

  <!-- Status -->
  <div class="col-md-4 col-sm-4 col-xs-4  mb-3 pb-2">
    <div class="form-group">
      <label for="status">Status</label>
      <select id="status" name="status" class="form-control">
        <option value="">-- Select Status--</option>
        <option value="ACTIVE" <#if status?has_content && status=='ACTIVE'>selected</#if>>Active</option>
        <option value="INACTIVE" <#if status?has_content && status=='INACTIVE'>selected</#if>>Inactive</option>
      </select>
    </div>
  </div>
<!-- Teams -->
          <div class="col-md-4 col-sm-4 col-xs-4  mb-3 pb-2">
            <div class="form-group">
              <label>Teams</label>
              <select name="team" class="form-control">
                <option value="">-- Select Team --</option>
              <#assign teams = util.teams()>
                <#if teams?? && teams?size gt 0>
                  <#list teams as rl>
                    <option value="${rl.id}"
                      <#if selectedTeam?? &&  selectedTeam == "${rl.id}">
                        selected
                      </#if>>
                      ${rl.teamName}
                    </option>
                  </#list>
                </#if>
              </select>
            </div>
          </div>
        <!-- Roles -->
      <input type="hidden" name="role" value="${role?if_exists}" />

  <!-- Submit Btn -->
  <div class="col-md-4 col-sm-4 col-xs-4  mb-3 pb-2">
    <div class="form-group">
      <label>&nbsp;</label>
      <button type="submit" class="btn btn-primary btn-block">
        Search
      </button>
    </div>
  </div>

</div>

  </form>
</div>

<div class="mt-5">
  <h2 class="mb-4">Customers List</h2>

  <div class="table-responsive">
    <table class="table table-striped table-bordered">
      <thead class="table-dark">
        <tr>
          <th>Name</th>
          <th>Category</th>
          <th>Weight</th>
          <th>Gender</th>
          <th>Phone</th>
          <th>Email</th>
          <th>Joined Date</th>
          <th>Created Date</th>
        </tr>
      </thead>
      <tbody>
        <#if customers?? && customers?size gt 0>
          <#list customers as c>
            <tr <#if c.status=="INACTIVE"> class="absent" </#if>>
              <td><a href="#" onclick="selectCustomer('${c.id?if_exists}', '${c.name?if_exists}')">${c.name?if_exists}</a></td>
              <td>
                <#if c.category?has_content>
                  <#assign cat = util.getConfig(c.category)>
                  <#if cat?has_content>
                    ${cat.configValue?if_exists}
                  </#if>
                </#if>
              </td>
              <td>${c.weight?if_exists}</td>
              <td>${c.gender?if_exists}</td>
              <td>${c.phone?if_exists}</td>
              <td>${c.email?if_exists}</td>
              <td>${c.joiningDate?if_exists}</td>
              <td>${c.createdDate?if_exists}</td>
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

<#include "footer.ftl">