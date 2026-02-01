<#include "home.ftl" />

<div class="container mt-5">
  <div class="row justify-content-center">
    <div class="col-lg-12 col-xl-12">

      <div class="card shadow-sm">
        <div class="card-header bg-primary text-white">
          <h2 class="mb-0">Person Details</h2>
        </div>

        <div class="card-body">
          <form action="/customer/addCustomer" method="post">

            <!-- Hidden Fields -->
            <input type="hidden" name="id"
                   value="<#if customer??>${customer.id?if_exists}</#if>" />
            <input type="hidden" name="role"
                   value="ROLE_STUDENT" />

            <#if userLogin?has_content>
              <input type="hidden" name="createdBy"
                     value="${userLogin.id?if_exists}" />
            </#if>

            <input type="hidden" name="createdDate"
                   value="${.now?string('yyyy-MM-dd')}">

            <div class="row">

              <!-- Full Name -->
              <div class="col-md-6">
                <div class="form-group">
                  <label>Full Name <span class="text-danger">*</span></label>
                  <input type="text" name="name" class="form-control"
                         placeholder="Enter full name"
                         value="<#if customer??>${customer.name?if_exists}</#if>"
                         required>
                </div>
              </div>

              <!-- Guardian -->
              <div class="col-md-6">
                <div class="form-group">
                  <label>Guardian / Father <span class="text-danger">*</span></label>
                  <input type="text" name="guardianName" class="form-control"
                         placeholder="Enter guardian name"
                         value="<#if customer??>${customer.guardianName?if_exists}</#if>"
                         required>
                </div>
              </div>

              <!-- Phone -->
              <div class="col-md-6">
                <div class="form-group">
                  <label>Phone Number <span class="text-danger">*</span></label>
                  <input type="tel" name="phone" class="form-control"
                         placeholder="Enter phone number"
                         value="<#if customer??>${customer.phone?if_exists}</#if>" pattern="[0-9]{10}" title="Enter a valid 10-digit mobile number"
                         required>
                </div>
              </div>

              <!-- Gender -->
              <div class="col-md-6">
                <div class="form-group">
                  <label>Gender <span class="text-danger">*</span></label>
                  <select name="gender" class="form-control" required>
                    <option value="">-- Select --</option>
                    <option value="male"
                      <#if customer?has_content && customer.gender == 'male'>selected</#if>>
                      Male
                    </option>
                    <option value="female"
                      <#if customer?has_content && customer.gender == 'female'>selected</#if>>
                      Female
                    </option>
                    <option value="other"
                      <#if customer?has_content && customer.gender == 'other'>selected</#if>>
                      Other
                    </option>
                  </select>
                </div>
              </div>

              <!-- Package -->
              <div class="col-md-6">
                <div class="form-group">
                  <label>Package <span class="text-danger">*</span></label>
                  <select name="pack" class="form-control" required>
                    <option value="">-- Select --</option>
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
              </div>

              <!-- Category -->
              <div class="col-md-6">
                <div class="form-group">
                  <label>Category</label>
                  <select name="category" class="form-control">
                    <option value="">-- Select Category --</option>
                    <#assign categorization = util.getConfigs("categorization", "name")>
                    <#list categorization as c>
                      <option value="${c.configId}"
                        <#if customer?has_content && customer.category?if_exists == c.configId?string>selected</#if>>
                        ${c.configValue?capitalize}
                      </option>
                    </#list>
                  </select>
                </div>
              </div>

              <!-- Team -->
              <div class="col-md-6">
                <div class="form-group">
                  <label>Team <span class="text-danger">*</span></label>
                  <select name="teamId" class="form-control" required>
                    <option value="">-- Select Team --</option>
                    <#assign teams = util.teams()>
                    <#list teams as c>
                      <option value="${c.id}"
<#if customer?has_content>
                        <#if customer.team?has_content && customer.team.id?if_exists == c.id?if_exists>selected</#if>
</#if>
>
                        ${c.teamName?capitalize}
                      </option>
                    </#list>
                  </select>
                </div>
              </div>

              <!-- Email -->
              <div class="col-md-6">
                <div class="form-group">
                  <label>Email <span class="text-danger">*</span></label>
                  <input type="email" name="email" class="form-control"
                         placeholder="Enter email"
                         value="<#if customer??>${customer.email?if_exists}</#if>"
                         required>
                </div>
              </div>

              <!-- Address -->
              <div class="col-md-12">
                <div class="form-group">
                  <label>Address</label>
                  <textarea name="address" class="form-control" rows="3"
                            placeholder="Enter full address"><#if customer??>${customer.address?if_exists}</#if></textarea>
                </div>
              </div>

              <!-- Joined Date -->
              <div class="col-md-6">
                <div class="form-group">
                  <label>Joined Date <span class="text-danger">*</span></label>
                  <input type="date" name="joiningDate" class="form-control"
                         value="<#if customer??>${customer.joiningDate?if_exists}<#else>${.now?string('yyyy-MM-dd')}</#if>"
                         required>
                </div>
              </div>

              <!-- DOB -->
              <div class="col-md-6">
                <div class="form-group">
                  <label>Date of Birth <span class="text-danger">*</span></label>
                  <input type="date" name="dob" class="form-control"
                         value="<#if customer??>${customer.dob?if_exists}</#if>"
                         required>
                </div>
              </div>

              <!-- Weight -->
              <div class="col-md-6">
                <div class="form-group">
                  <label>Weight (kg)</label>
                  <input type="text" name="weight" class="form-control"
                         placeholder="Enter weight"
                         value="<#if customer??>${customer.weight?if_exists}</#if>">
                </div>
              </div>

              <!-- Status -->
              <div class="col-md-6">
                <div class="form-group">
                  <label>Status <span class="text-danger">*</span></label>
                  <select name="status" class="form-control" required>
                    <option value="ACTIVE"
                      <#if customer?has_content && customer.status == 'ACTIVE'>selected</#if>>
                      Active
                    </option>
                    <option value="INACTIVE"
                      <#if customer?has_content && customer.status == 'INACTIVE'>selected</#if>>
                      Inactive
                    </option>
                  </select>
                </div>
              </div>

            </div>

            <hr>

            <!-- Actions -->
            <div class="text-right">
              <button type="submit" class="btn btn-success px-4">
                Save Student
              </button>
              <a href="/customer/viewCustomers" class="btn btn-secondary px-4 ml-2">
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