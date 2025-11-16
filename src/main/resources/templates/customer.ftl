<#include "home.ftl" />

<div class="container mt-4">

   <div class="panel panel-primary">
        <div class="panel-heading">Student's Details</div>
      <div class="panel-body">

            <form action="/customer/createCustomer" method="post">

                <input type="hidden" name="id" value="<#if customer??>${customer.id?if_exists}</#if>" />
                <!-- Name -->
                <div class="mb-3">
                    <label class="form-label">Full Name</label>
                    <input type="text" name="name" class="form-control" placeholder="Enter full name" value="<#if customer??>${customer.name?if_exists}</#if>" required>
                </div>

                <!-- Age -->
                <div class="mb-3">
                    <label class="form-label">Phone Number</labPel>
                    <input type="text" name="phone" class="form-control" placeholder="Enter Phone Number"  value="<#if customer??>${customer.phone?if_exists}</#if>"  required>
                </div>

                <!-- Gender -->
                <div class="mb-3">
                    <label class="form-label">Gender</label>
                    <select name="gender" class="form-control form-select" required>
                        <option value="">-- Select --</option>
                        <option>Male</option>
                        <option>Female</option>
                        <option>Other</option>
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
                    <textarea name="address" class="form-control" rows="3" placeholder="Enter full address" ><#if customer??>${customer.name?if_exists}</#if></textarea>
                </div>

                <!-- Submit Button -->
                <button type="submit" class="btn btn-success w-100">Submit</button>

            </form>

        </div>
    </div>
</div>

<#include "footer.ftl" />