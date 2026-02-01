<#include "home.ftl">

<div class="container">

  <!-- ================= SEARCH PANEL ================= -->
  <div class="panel panel-default">
    <div class="panel-heading">
      <h2 class="panel-title">Search Persons</h2>
    </div>

    <div class="panel-body">
      <form action="${baseUrl?if_exists}/customer/viewCustomers"
            id="fixture-form" method="post">

        <div class="row">

          <!-- Full Name -->
          <div class="col-lg-3 col-md-4 col-sm-6">
            <div class="form-group">
              <label>Full Name</label>
              <input type="text" name="name" class="form-control"
                     placeholder="Enter full name"
                     value="<#if name??>${name?if_exists}</#if>">
            </div>
          </div>

          <!-- Phone -->
          <div class="col-lg-3 col-md-4 col-sm-6">
            <div class="form-group">
              <label>Phone Number</label>
              <input type="text" name="phone" class="form-control"
                     placeholder="Enter phone number"
                     value="<#if phone??>${phone?if_exists}</#if>">
            </div>
          </div>

          <!-- Gender -->
          <div class="col-lg-3 col-md-4 col-sm-6">
            <div class="form-group">
              <label>Gender</label>
              <select name="gender" class="form-control">
                <option value="">-- Select Gender --</option>
                <option value="male" <#if gender??><#if gender == "male">selected</#if></#if>>Male</option>
                <option value="female" <#if gender??><#if gender == "female">selected</#if></#if>>Female</option>
                <option value="other" <#if gender??><#if gender == "other">selected</#if></#if>>Other</option>
              </select>
            </div>
          </div>

          <!-- Email -->
          <div class="col-lg-3 col-md-4 col-sm-6">
            <div class="form-group">
              <label>Email</label>
              <input type="email" name="email" class="form-control"
                     placeholder="Enter email"
                     value="<#if email??>${email?if_exists}</#if>">
            </div>
          </div>

          <!-- Status -->
          <div class="col-lg-3 col-md-4 col-sm-6">
            <div class="form-group">
              <label>Status</label>
              <select name="status" class="form-control">
                <option value="">-- Select Status --</option>
                <option value="ACTIVE" <#if status??> <#if status == "ACTIVE">selected</#if></#if>>Active</option>
                <option value="INACTIVE" <#if status??><#if status == "INACTIVE">selected</#if></#if>>Inactive</option>
              </select>
            </div>
          </div>

          <!-- Package -->
          <div class="col-lg-3 col-md-4 col-sm-6">
            <div class="form-group">
              <label>Package</label>
              <select name="pack" class="form-control">
                <option value="">-- Select Package --</option>
                <#list packages as c>
                  <option value="${c.configId}"
                    <#if pack??><#if pack == c.configId?string>selected</#if></#if>>
                    ${c.configValue?capitalize}
                  </option>
                </#list>
              </select>
            </div>
          </div>

          <!-- Category -->
          <div class="col-lg-3 col-md-4 col-sm-6">
            <div class="form-group">
              <label>Category</label>
              <#assign categorization = util.getConfigs("categorization","name")>
              <select name="category" class="form-control">
                <option value="">-- Select Category --</option>
                <#list categorization as c>
                  <option value="${c.configId?if_exists}"
                    <#if category??><#if category == c.configId?string>selected</#if></#if>>
                    ${c.configValue?capitalize?if_exists}
                  </option>
                </#list>
              </select>
            </div>
          </div>

          <!-- Weight Range -->
          <div class="col-lg-3 col-md-4 col-sm-6">
            <div class="form-group">
              <label>Weight Range (kg)</label>
              <div class="input-group">
                <input type="number" name="from" class="form-control"
                       placeholder="From"
                       value="<#if from??>${from?if_exists}</#if>">
                <span class="input-group-addon">to</span>
                <input type="number" name="to" class="form-control"
                       placeholder="To"
                       value="<#if to??>${to?if_exists}</#if>">
              </div>
            </div>
          </div>

        <!-- Roles -->
          <div class="col-lg-3 col-md-4 col-sm-6">
            <div class="form-group">
              <label>Roles</label>
              <select name="role" class="form-control">
                <option value="">-- Select Status --</option>
               <#assign completeRoles = util.roles()>
                <#if completeRoles?has_content>
                    <#list completeRoles as rl>
                            <option value="${rl?if_exists}" <#if rl?has_content && rl == "${role?if_exists}">selected</#if>>${rl.getDisplayName()?if_exists}</option>
                    </#list>
                </#if>
              </select>
            </div>
          </div>

 <!-- Teams -->
          <div class="col-lg-3 col-md-4 col-sm-6">
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
          <!-- Search Button -->
          <div class="col-lg-3 col-md-4 col-sm-6">
            <div class="form-group">
              <label>&nbsp;</label>
              <button type="submit" class="btn btn-primary btn-block">
                Search Students
              </button>
            </div>
          </div>

        </div>
      </form>
    </div>
  </div>
  <!-- ================= STUDENT TABLE ================= -->
  <div class="panel panel-default">
    <div class="panel-heading">
      <h2 class="panel-title">Persons List</h2>
    </div>

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
            <th>Team</th>
            <th>Joined Date</th>
            <th>Created Date</th>
            <th>Actions</th>
          </tr>
        </thead>

        <tbody>
        <#if customers?has_content>
          <#list customers as c>
            <tr <#if c.status?? && c.status == "INACTIVE">class="danger"</#if>>
              <td>
                <a href="${baseUrl?if_exists}/customer/viewCustomer/${c.id?if_exists}">
                  ${c.id?if_exists}
                </a>
              </td>
              <td>${c.name?if_exists}</td>
              <td>
                <#if c.category?has_content>
                  ${util.getConfig(c.category).configValue?if_exists}
                </#if>
              </td>
              <td>${c.weight?default("0")}</td>
              <td>${c.gender?if_exists}</td>
              <td>${c.phone?if_exists}</td>
              <td>${c.email?if_exists}</td>
              <td><#if c.team?has_content>${c.team.teamName?if_exists}</#if></td>
              <td>${c.joiningDate?if_exists}</td>
              <td>${c.createdDate?if_exists}</td>
              <td>
                <a class="btn btn-xs btn-primary"
                   href="${baseUrl?if_exists}/customer/editCustomer/${c.id}">
                   Edit
                </a>
                <a class="btn btn-xs btn-danger"
                   href="${baseUrl?if_exists}/customer/deleteCustomer/${c.id}" onclick="return confirm('Are you sure?');">
                   Deactivate
                </a>
                <a class="btn btn-xs btn-danger"
                   href="${baseUrl?if_exists}/customer/removeCustomer/${c.id}" onclick="return confirm('Are you sure?');">
                   Delete
                </a>
              </td>
            </tr>
          </#list>
        <#else>
          <tr>
            <td colspan="10" class="text-center text-muted">
              No customers found
            </td>
          </tr>
        </#if>
        </tbody>
      </table>
    </div>
  </div>

</div>

<#include "footer.ftl">
