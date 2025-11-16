<#include "home.ftl">

<div class="table-responsive">
  <table class="table table-bordered table-striped">
    <thead>
      <tr>
        <th>#</th>
        <th>Name</th>
        <th>Email</th>
        <th>Phone</th>
      </tr>
    </thead>
    <tbody>

<#if customers?has_content>
<#list customers as customer>
      <tr>
        <td>${customer.id?if_exists}</td>
        <td>${customer.name?if_exists}</td>
        <td>${customer.email?if_exists}</td>
        <td>${customer.phone?if_exists}</td>
      </tr>
</#list>
</#if>
    </tbody>
  </table>
</div>
<#include "footer.ftl">