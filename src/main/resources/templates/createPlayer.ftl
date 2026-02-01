<#include "home.ftl" />

<div class="container" style="margin-top:50px;">
  <div class="row">
    <div class="col-md-10 col-md-offset-1 col-lg-8 col-lg-offset-2">

      <div class="panel panel-default">
        <div class="panel-heading" style="background:#222;color:#f0ad4e;">
          <h3 class="panel-title text-uppercase">Create Player</h3>
        </div>

        <div class="panel-body">
          <form action="/customer/addCustomer" method="post">

            <input type="hidden" name="pack"
                   value="28" />
            <!-- Hidden Fields -->
            <input type="hidden" name="id"
                   value="<#if customer??>${customer.id?if_exists}</#if>" />
            <input type="hidden" name="role"
                   value="ROLE_PLAYER" />
            <input type="hidden" name="status"
                   value="ACTIVE" />
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
                  <label class="control-label">
                    Full Name <span class="text-danger">*</span>
                  </label>
                  <input type="text" name="name" class="form-control"
                         placeholder="Enter full name"
                         value="<#if customer??>${customer.name?if_exists}</#if>"
                         required>
                </div>
              </div>

              <!-- Guardian -->
              <div class="col-md-6">
                <div class="form-group">
                  <label class="control-label">
                    Guardian / Father <span class="text-danger">*</span>
                  </label>
                  <input type="text" name="guardianName" class="form-control"
                         placeholder="Enter guardian name"
                         value="<#if customer??>${customer.guardianName?if_exists}</#if>"
                         required>
                </div>
              </div>

              <!-- Phone -->
              <div class="col-md-6">
                <div class="form-group">
                  <label class="control-label">
                    Phone Number <span class="text-danger">*</span>
                  </label>
                  <input type="text" name="phone" class="form-control"
                         placeholder="Enter phone number"
                         value="<#if customer??>${customer.phone?if_exists}</#if>"
                         required>
                </div>
              </div>

              <!-- Gender -->
              <div class="col-md-6">
                <div class="form-group">
                  <label class="control-label">
                    Gender <span class="text-danger">*</span>
                  </label>
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
              </div>

              <!-- Team -->
              <div class="col-md-6">
                <div class="form-group">
                  <label class="control-label">Team <span class="text-danger">*</span></label>
                  <select name="teamId" class="form-control" required>
                    <option value="">-- Select Team --</option>
                    <#assign teams = util.teams()>
                    <#list teams as c>
                      <option value="${c.id}"
                        <#if customer?has_content && customer.team?if_exists == c.id?string>selected</#if>>
                        ${c.teamName?capitalize}
                      </option>
                    </#list>
                  </select>
                </div>
              </div>

              <!-- Email -->
              <div class="col-md-6">
                <div class="form-group">
                  <label class="control-label">
                    Email <span class="text-danger">*</span>
                  </label>
                  <input type="email" name="email" class="form-control"
                         placeholder="Enter email"
                         value="<#if customer??>${customer.email?if_exists}</#if>"
                         required>
                </div>
              </div>

              <!-- Address -->
              <div class="col-md-6">
                <div class="form-group">
                  <label class="control-label">Address</label>
                  <textarea name="address" class="form-control" rows="3"
                            placeholder="Enter full address"><#if customer??>${customer.address?if_exists}</#if></textarea>
                </div>
              </div>

              <!-- Category -->
              <div class="col-md-6">
                <div class="form-group">
                  <label class="control-label">Category <span class="text-danger">*</span></label>
                  <select name="category" class="form-control" required>
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

              <!-- DOB -->
              <div class="col-md-6">
                <div class="form-group">
                  <label class="control-label">
                    Date of Birth <span class="text-danger">*</span>
                  </label>
                  <input type="date" name="dob" class="form-control"
                         value="<#if customer??>${customer.dob?if_exists}</#if>"
                         required>
                </div>
              </div>

              <!-- Weight -->
              <div class="col-md-6">
                <div class="form-group">
                  <label class="control-label">
                    Weight (kg)
                  </label>
                  <input type="text" name="weight" class="form-control"
                         placeholder="Enter weight"
                         value="<#if customer??>${customer.weight?if_exists}</#if>"
                         >
                </div>
              </div>

            </div>

            <hr>

            <!-- Actions -->
            <div class="text-right">
              <button type="submit" class="btn btn-success">
                Save Player
              </button>
              <a href="/customer/viewCustomers" class="btn btn-default">
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