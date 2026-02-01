<#include "home.ftl" />

<div class="container" style="margin-top:50px;">
  <div class="row">
    <div class="col-md-10 col-md-offset-1 col-lg-8 col-lg-offset-2">

      <div class="panel panel-default">
        <div class="panel-heading" style="background:#222;color:#f0ad4e;">
          <h3 class="panel-title text-uppercase">Create Coach</h3>
        </div>

        <div class="panel-body">
          <form action="/customer/addCustomer" method="post">

            <!-- Hidden Fields -->
            <input type="hidden" name="id"
                   value="<#if customer??>${customer.id?if_exists}</#if>" />
            <input type="hidden" name="role"
                   value="ROLE_COACH" />
            <input type="hidden" name="pack"
                   value="28" />
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
                  <input type="tel" name="phone" class="form-control"
                         placeholder="Enter phone number"
                         value="<#if customer??>${customer.phone?if_exists}</#if>" pattern="[0-9]{10}" title="Enter a valid 10-digit mobile number"
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

               <!-- Address -->
              <div class="col-md-6">
                <div class="form-group">
                  <label class="control-label">Address</label>
                  <textarea name="address" class="form-control" rows="3"
                            placeholder="Enter full address"><#if customer??>${customer.address?if_exists}</#if></textarea>
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
            </div>

            <hr>

            <!-- Actions -->
            <div class="text-right">
              <button type="submit" class="btn btn-success">
                Save Coach
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