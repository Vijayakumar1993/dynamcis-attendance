<#include "home.ftl" />

<div class="container mt-5">
  <div class="row justify-content-center">
    <div class="col-lg-10">

      <div class="card shadow-sm">
        <div class="card-header bg-primary text-white">
          <h2 class="mb-0">Create Lead</h2>
        </div>

        <div class="card-body">
          <form action="${baseUrl?if_exists}/lead-management/createOrStoreLead" method="post">

            <!-- Hidden Fields -->
            <input type="hidden" name="id"
                   value="<#if customer??>${customer.id?if_exists}</#if>"/>


            <#if userLogin?has_content>
              <input type="hidden" name="createdBy"
                     value="${userLogin.id?if_exists}"/>
            </#if>

            <div class="row">

              <!-- Full Name -->
              <div class="col-md-6 mb-3">
                <label>Full Name *</label>
                <input type="text" name="name" class="form-control"
                       value="<#if customer??>${customer.name?if_exists}</#if>"
                       required>
              </div>

              <!-- Phone -->
              <div class="col-md-6 mb-3">
                <label>Phone Number *</label>
                <input type="tel" name="phone" class="form-control"
                       value="<#if customer??>${customer.phone?if_exists}</#if>"
                       pattern="[0-9]{10}"
                       required>
              </div>

              <!-- Email -->
              <div class="col-md-6 mb-3">
                <label>Email</label>
                <input type="email" name="email" class="form-control"
                       value="<#if customer??>${customer.email?if_exists}</#if>">
              </div>

              <!-- Gender -->
              <div class="col-md-6 mb-3">
                <label>Gender *</label>
                <select name="gender" class="form-control" required>
                  <option value="">-- Select --</option>
                  <option value="male"
                    <#if customer?has_content && customer.gender == 'male'>selected</#if>>Male</option>
                  <option value="female"
                    <#if customer?has_content && customer.gender == 'female'>selected</#if>>Female</option>
                  <option value="other"
                    <#if customer?has_content && customer.gender == 'other'>selected</#if>>Other</option>
                </select>
              </div>

              <!-- Package -->
              <div class="col-md-12 mb-3">
                <label>Package *</label>
                <select name="pack" class="form-control" required>
                  <option value="">-- Select Package --</option>
                  <#if packages?has_content>
                    <#list packages as c>
                      <option value="${c.configId}"
                        <#if customer?has_content && customer.pack?if_exists == c.configId?string>selected</#if>>
                        ${c.configValue?capitalize}
                      </option>
                    </#list>
                  </#if>
                </select>
              </div>

              <!-- Address -->
              <div class="col-md-12 mb-3">
                <label>Address</label>
                <textarea name="address" class="form-control" rows="3">
<#if customer??>${customer.address?if_exists}</#if></textarea>
              </div>

            </div>

            <hr>

            <div class="text-right">
              <button type="submit" class="btn btn-success px-4">
                Save Lead
              </button>
              <a href="/customer/viewCustomers"
                 class="btn btn-secondary px-4 ml-2">
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
