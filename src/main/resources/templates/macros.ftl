<#macro inputCustomers label name defaultId defaultValue lookupFunction>
<div class="form-group">
    <label for="${name}">${label?default("Customer")}</label>

    <div class="">
        <div class="col-md-11" style="padding-left:0;">
            <input type="hidden"
                   id="customerId"
                   name="customerId"
                   <#if defaultId?has_content>value="${defaultId}"</#if> />

            <input type="text"
                   id="customerIdInput"
                   name="customerIdInput"
                   class="form-control"
                   placeholder="Enter ${label}"
                   <#if defaultValue?has_content>value="${defaultValue}"</#if>
                   required readonly />
        </div>

        <div class="col-md-1" style="padding-left:0;padding-right:0;">
            <button type="button"
                    class="btn btn-default btn-block"
                    onclick="${lookupFunction}()">
                <span class="glyphicon glyphicon-search"></span>
            </button>
        </div>
    </div>
</div>
</#macro>


<#macro feeTable id list active=false>
<div id="${id}" class="tab-pane fade ${active?string('in active','')}">
    <div class="table-responsive">
        <table class="table table-striped table-bordered table-hover">
            <thead>
            <tr class="active">
                <th>Student</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Payment Date</th>
                <th>Amount</th>
                <th>Balance</th>
            </tr>
            </thead>
            <tbody>
            <#if list?has_content>
                <#list list as customer>
                    <tr>
                        <td>
                            <a href="${baseUrl!''}/customer/viewCustomer/${customer.id}"
                               target="_blank">
                                ${customer.name}
                            </a>
                        </td>
                        <td>${customer.email!''}</td>
                        <td>${customer.phone!''}</td>
                        <td>
                            ${customer.joiningDate?date("yyyy-MM-dd")
?string("dd MMM yyyy")}
                        </td>
                        <td>${customer.amount!0}</td>
                        <td class="text-danger">
                            <strong>${customer.balance!0}</strong>
                        </td>
                    </tr>
                </#list>
            <#else>
                <tr>
                    <td colspan="6" class="text-center text-muted">
                        No records found
                    </td>
                </tr>
            </#if>
            </tbody>
        </table>
    </div>
</div>
</#macro>

<#macro watsapp phone>
<#assign cat = util.getConfig("49")>
<#if cat?has_content>
<#assign msg =  util.encodeMsg(cat.configValue) >
<a
  href="https://wa.me/${phone?if_exists}?if_exists}?text=${msg?if_exists}"
  target="_blank"
  class="whatsapp-btn"
>
  <img
    src="${baseUrl}/images/WhatsApp.svg"
    alt="WhatsApp"
  />
</a>
</#if>
</#macro>


