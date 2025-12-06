<#include "home.ftl" />

<div class=" mt-4">
   <div class="panel panel-primary">
        <div class="panel-heading">Student's Details</div>
      <div class="panel-body">

            <form action="/customer/addCustomer" method="post">

                <input type="hidden" name="id" value="<#if customer??>${customer.id?if_exists}</#if>" />

     <#if userLogin?has_content>
                    <input type="hidden" name="createdBy" value="${userLogin.id?if_exists}" />
    </#if>
<input type="hidden" id="createdDate" name="createdDate" class="form-control" required value="${.now?string('yyyy-MM-dd')}">
                <!-- Name -->
                <div class="mb-3">
                    <label class="form-label">Full Name</label>
                    <input type="text" name="name" class="form-control" placeholder="Enter full name" value="<#if customer??>${customer.name?if_exists}</#if>" required>
                </div>
                <!-- GuradianName -->
                <div class="mb-3">
                    <label class="form-label">Guardian / Father / Spouse Name</label>
                    <input type="text"
                           name="guardianName"
                           class="form-control"
                           placeholder="Enter Guardian / Father / Spouse Name"
                           value="<#if customer??>${customer.guardianName?if_exists}</#if>"
                           required> </div>
                <!-- Age -->
                <div class="mb-3">
                    <label class="form-label">Phone Number</label>
                    <input type="text" name="phone" class="form-control" placeholder="Enter Phone Number"  value="<#if customer??>${customer.phone?if_exists}</#if>"  required>
                </div>

                <!-- Gender -->
                <div class="mb-3">
                    <label class="form-label">Gender</label>
                    <select name="gender" class="form-control form-select" required>
                        <option value="">-- Select --</option>
                        <option value="male" <#if customer?has_content><#if customer.gender=='male'> selected </#if></#if>>Male</option>
                        <option value="female"  <#if customer?has_content><#if customer.gender=='female'> selected </#if></#if>>Female</option>
                        <option value="other"  <#if customer?has_content><#if customer.gender=='other'> selected </#if></#if>>Other</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label">Package</label>
                    <select class="form-control" name="pack" id="pack" required>
                    <option value="">-- Select --</option>
                        <#if packages?has_content>
                            <#list packages as c>
<#if c?has_content>
                                <option value="${c.configId?if_exists}" <#if customer?has_content><#if customer.pack?if_exists=='${c.configId?if_exists}'> selected </#if></#if>>${c.configValue?capitalize?if_exists}</option>
</#if>
                            </#list>
                        </#if>
                    </select>
                </div>
 <div class="mb-3">
                    <label class="form-label">Team</label>
                    <select class="form-control" name="team" id="pack">
                    <option value="">-- Select Team--</option>
<#assign categorization = util.getConfigs("categorization", "name")>
                        <#if categorization?has_content>
                            <#list packages as c>
<#if c?has_content>
                                <option value="${c.configId?if_exists}" <#if customer?has_content><#if customer.pack?if_exists=='${c.configId?if_exists}'> selected </#if></#if>>${c.configValue?capitalize?if_exists}</option>
</#if>
                            </#list>
                        </#if>
                    </select>
                </div>

                <!-- Email -->
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-control" placeholder="Enter email"  value="<#if customer??>${customer.email?if_exists}</#if>"  required>
                </div>

                <!-- Address -->
                <div class="mb-3">
                    <label class="form-label">Address</label>
                    <textarea name="address" class="form-control" rows="3" placeholder="Enter full address" ><#if customer??>${customer.address?if_exists}</#if></textarea>
                </div>

                <div class="mb-3">
                      <label for="joiningDate" class="form-label">Joined Date</label>
                      <input type="date" id="joiningDate" name="joiningDate" class="form-control" required value="<#if customer??>${customer.joiningDate?if_exists}<#else>${.now?string('yyyy-MM-dd')}</#if>">
                </div>

                <div class="mb-3">
                      <label for="dob" class="form-label">Date of Birth</label>
                      <input type="date" id="dob" name="dob" class="form-control" required value="<#if customer??>${customer.dob?if_exists}</#if>">
                </div>

                <div class="mb-3">
                    <label class="form-label">Weight</label>
                    <input type="text" name="weight" class="form-control" placeholder="Enter Phone Number"  value="<#if customer??>${customer.weight?if_exists}</#if>"  required>
                </div>


 <!-- Status -->
                <div class="mb-3">
                    <label class="form-label">Status</label>
                    <select name="status" class="form-control form-select" required>
                        <option value="ACTIVE" <#if customer?has_content><#if customer.status=='ACTIVE'> selected </#if></#if>>Active</option>
                        <option value="INACTIVE"  <#if customer?has_content><#if customer.status=='INACTIVE'> selected </#if></#if>>Inactive</option>
                    </select>
                </div>
                <!-- Submit Button -->
                <button type="submit" class="btn btn-success w-100">Submit</button>

            </form>

        </div>
    </div>
</div>

<#include "footer.ftl" />