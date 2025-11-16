<#include "home.ftl">
<div class="container mt-5">
    <h2 class="mb-4">Customer List</h2>

    <div class="table-responsive">
        <table class="table table-striped table-bordered">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Phone</th>
                    <th>Email</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <#if customers?? && customers?size gt 0>
                    <#list customers as c>
                        <tr>
                            <td>${c.id}</td>
                            <td>${c.name}</td>
                            <td>${c.phone}</td>
                            <td>${c.email}</td>
                            <td>
               <a href="${baseUrl}/deleteCustomer/${c.id}" class="btn btn-danger">Delete</a>
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