<#include "home.ftl">

<div class="container my-5">
  <h2 class="mb-4">Student  Form</h2>
            <form action="/customer/findCustomers" method="post">

              <div class="row">

        <!-- Name -->
        <div class="col-md-6 mb-3">
            <input type="text" name="name" class="form-control"
                   placeholder="Full Name"
                   value="<#if customer??>${customer.name?if_exists}</#if>">
        </div>

        <!-- Phone -->
        <div class="col-md-6 mb-3">
            <input type="text" name="phone" class="form-control"
                   placeholder="Phone Number"
                   value="<#if customer??>${customer.phone?if_exists}</#if>">
        </div>

        <!-- Gender -->
        <div class="col-md-6 mb-3">
            <select name="gender" class="form-control form-select">
                <option value="">Gender</option>
                <option value="male" <#if customer?has_content && customer.gender == "male">selected</#if>>Male</option>
                <option value="female" <#if customer?has_content && customer.gender == "female">selected</#if>>Female</option>
                <option value="other" <#if customer?has_content && customer.gender == "other">selected</#if>>Other</option>
            </select>
        </div>

        <!-- Email -->
        <div class="col-md-6 mb-3">
            <input type="email" name="email" class="form-control"
                   placeholder="Email"
                   value="<#if customer??>${customer.email?if_exists}</#if>">
        </div>

        <!-- Status -->
        <div class="col-md-6 mb-3">
            <select name="status" class="form-control form-select">
                <option value="">Status</option>
                <option value="ACTIVE" <#if customer?has_content && customer.status=='ACTIVE'>selected</#if>>Active</option>
                <option value="INACTIVE" <#if customer?has_content && customer.status=='INACTIVE'>selected</#if>>Inactive</option>
            </select>
        </div>

        <!-- Submit Btn -->
        <div class="col-md-6 mb-3">
            <button type="submit" class="btn btn-primary w-100">
                Search
            </button>
        </div>

    </div>
            </form>
</div>

<div class="container mt-5">
    <h2 class="mb-4">Customer List</h2>

    <div class="table-responsive">
        <table class="table table-striped table-bordered">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Gender</th>
                    <th>Phone</th>
                    <th>Email</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <#if customers?? && customers?size gt 0>
                    <#list customers as c>
                        <tr <#if c.status=="INACTIVE"> class="absent" </#if>>
                            <td>${c.id?if_exists}</td>
                            <td>${c.name?if_exists}</td>
                            <td>${c.gender?if_exists}</td>
                            <td>${c.phone?if_exists}</td>
                            <td>${c.email?if_exists}</td>
                            <td>
               <a href="${baseUrl?if_exists}/customer/deleteCustomer/${c.id?if_exists}" class="btn btn-danger">Delete</a>
               <a href="${baseUrl?if_exists}/customer/viewCustomer/${c.id?if_exists}" class="btn btn-primary">Edit</a>
</td>
                        </tr>
                    </#list>
                <#else>
                    <tr>
                        <td colspan="5" class="text-center text-muted">
                            No customers found.
                        </td>
                    </tr>
                </#if>
            </tbody>
        </table>
    </div>
</div>
<#include "footer.ftl">