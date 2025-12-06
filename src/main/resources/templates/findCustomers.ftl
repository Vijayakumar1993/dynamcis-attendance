<#include "home.ftl">

<div class="my-5">
  <h2 class="mb-4">Student Form</h2>
  <form action="/customer/viewCustomers" method="post">

    <div class="row">

      <!-- Name -->
      <div class="col-md-6 mb-3 pb-2">
        <input type="text" name="name" class="form-control"
               placeholder="Full Name"
               value="<#if name??>${name?if_exists}</#if>">
      </div>

      <!-- Phone -->
      <div class="col-md-6 mb-3 pb-2">
        <input type="text" name="phone" class="form-control"
               placeholder="Phone Number"
               value="<#if phone??>${phone?if_exists}</#if>">
      </div>

      <!-- Gender -->
      <div class="col-md-6 mb-3 pb-2">
        <select name="gender" class="form-control form-select">
          <option value="">-- Select Gender--</option>
          <option value="male" <#if gender?has_content && gender == "male">selected</#if>>Male</option>
          <option value="female" <#if gender?has_content && gender == "female">selected</#if>>Female</option>
          <option value="other" <#if gender?has_content && gender == "other">selected</#if>>Other</option>
        </select>
      </div>

      <!-- Email -->
      <div class="col-md-6 mb-3 pb-2">
        <input type="email" name="email" class="form-control"
               placeholder="Email"
               value="<#if email??>${email?if_exists}</#if>">
      </div>

      <!-- Status -->
      <div class="col-md-6 mb-3 pb-2">
        <select name="status" class="form-control form-select">
          <option value="">-- Select Status--</option>
          <option value="ACTIVE" <#if status?has_content && status=='ACTIVE'>selected</#if>>Active</option>
          <option value="INACTIVE" <#if status?has_content && status=='INACTIVE'>selected</#if>>Inactive</option>
        </select>
      </div>

      <!-- Package -->
      <div class="col-md-6 mb-3 pb-2">
        <select class="form-control form-select" name="pack" id="pack">
          <option value="">-- Select Package--</option>
          <#if packages?has_content>
            <#list packages as c>
              <option value="${c.configId?if_exists}" <#if pack?has_content && pack=='${c.configId?if_exists}'> selected </#if>>
                ${c.configValue?capitalize?if_exists}
              </option>
            </#list>
          </#if>
        </select>
      </div>

      <!-- Category -->
      <div class="col-md-6 mb-3 pb-2">
        <#assign categorization = util.getConfigs("categorization", "name")>
        <#if categorization?has_content>
          <select name="category" class="form-control form-select">
            <option value="">-- Select Categories--</option>
            <#list categorization as c>
              <option value="${c.configId?if_exists}" <#if category?has_content && category=='${c.configId?if_exists}'> selected </#if>>
                ${c.configValue?capitalize?if_exists}
              </option>
            </#list>
          </select>
        </#if>
      </div>

      <!-- Weight From / To -->
      <div class="col-md-6 mb-3 pb-2">
        <div class="d-flex gap-2">
          <input type="number" class="form-control" name="from" placeholder="From (kg)" <#if from?has_content>value="${from?if_exists}"</#if>>
          <span class="align-self-center fw-bold">→</span>
          <input type="number" class="form-control" name="to" placeholder="To (kg)" <#if to?has_content>value="${to?if_exists}"</#if>>
        </div>
      </div>

      <!-- Submit Btn -->
      <div class="col-md-6 mb-3 pb-2">
        <button type="submit" class="btn btn-primary w-100">
          Search
        </button>
      </div>

    </div>
  </form>
</div>

<div class="mt-5">
  <h2 class="mb-4">Students List</h2>

  <div class="table-responsive">
    <table class="table table-striped table-bordered">
      <thead class="table-dark">
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
            <tr <#if c.status=="INACTIVE"> class="absent" </#if>>
              <td><a href="${baseUrl?if_exists}/customer/viewCustomer/${c.id?if_exists}">${c.id?if_exists}</a></td>
              <td>${c.name?if_exists}</td>
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
              <td>
                <a href="${baseUrl?if_exists}/customer/deleteCustomer/${c.id?if_exists}" class="btn btn-danger">Deactivate</a>
                <a href="${baseUrl?if_exists}/customer/editCustomer/${c.id?if_exists}" class="btn btn-primary">Edit</a>
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

<#include "footer.ftl">