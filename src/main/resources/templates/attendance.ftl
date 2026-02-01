<#include "home.ftl">

<!-- Filter / Add attendance -->
<div class="col-xs-12">
    <h2>Find Attendance</h2>

    <form action="/attendance" method="get" class="row">

        <div class="col-md-3">
            <@inputCustomers
    label="Customer"
    name="name"
    defaultId=customerId?has_content?then(customerId, "")
    defaultValue=customerIdInput?has_content?then(customerIdInput, "")
    lookupFunction="openCustomerLookup()" />
        </div>

        <div class="col-md-3 form-group"><label for="from">From</label>
            <input type="date"
                   name="from"
                   class="form-control"
                   <#if from?has_content>value="${from}"</#if>>
        </div>

        <div class="col-md-3 form-group"><label for="to">To</label>
            <input type="date"
                   name="to"
                   class="form-control"
                   <#if to?has_content>value="${to}"</#if>>
        </div>

        <div class="col-md-3 form-group"><label for="">&nbsp;</label>
            <button type="submit" class="btn btn-primary btn-block">
                Find Attendance
            </button>
        </div>

    </form>
</div>

<hr>

<!-- Attendance Table -->
<div class="col-xs-12">
    <h2>Attendance Sheet</h2>

    <div class="table-responsive">
        <table id="matchTable" class="table table-bordered attendance-table">
            <thead class="thead-dark">
                <tr>
                    <th>Id</th>
                    <th>Person Name</th>

                    <#if days?has_content>
                        <#list days as day>
                            <th class="vertical-text">
                                ${day?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}
                            </th>
                        </#list>
                    </#if>
                </tr>
            </thead>

            <tbody>
                <#if dates?has_content>
                    <#list dates as key, atts>
                        <tr>
                            <td><a href="${baseUrl?if_exists}/attendance/history/${key.id!}">${key.id!}</a></td>
                            <td>
                                <b>
                                    <a href="${baseUrl?if_exists}/customer/viewCustomer/${key.id!}"
                                       target="_blank">
                                        ${key.name!}
                                    </a>
                                </b>
                            </td>

                            <#list days as day>
                                <#assign valid = "N">

                                <#list atts as att>
                                    <#if att.date == day>
                                        <#assign valid = "Y">
                                    </#if>
                                </#list>

                                <#if valid == "Y">
                                    <td class="present text-center">
                                        <span class="text-success">&#10004;</span>
                                    </td>
                                <#else>
                                    <td class="text-center">
                                        <span class="text-danger">&#10008;</span>
                                    </td>
                                </#if>
                            </#list>
                        </tr>
                    </#list>
                </#if>
            </tbody>
        </table>
    </div>
</div>

<#include "footer.ftl">
