<#include "home.ftl">

<form action="${baseUrl?if_exists}/settings/createConfiguration" method="post" class="container mt-4">

    <div class="card shadow-sm p-4">
        <marquee style="color: #d9534f; font-weight: bold;">
            Configuration is a critical part of the business. Please do not change any values without proper knowledge or prior approval.
        </marquee>
        <h2 class="mb-3">Create Configuration</h4>

        <div class="row mb-3">
            <input type="hidden" class="form-control" id="configId" name="configId" placeholder="Enter Config ID" <#if configuration?has_content>value="${configuration.configId?if_exists}"</#if>>
            <div class="col-md-12">
                <label for="configName" class="form-label">Config Name</label>
                <input type="text" class="form-control" id="configName" name="configName" placeholder="Enter Config Name" <#if configuration?has_content>value="${configuration.configName?if_exists}"</#if>>
            </div>
        </div>

        <div class="mb-3">
            <label for="configKey" class="form-label">Config Key</label>
            <input type="text" class="form-control" id="configKey" name="configKey" placeholder="Enter Config Key" <#if configuration?has_content>value="${configuration.configKey?if_exists}"</#if>>
        </div>

        <div class="mb-3">
            <label for="configValue" class="form-label">Config Value</label>
            <input type="text" class="form-control" id="configValue" name="configValue" placeholder="Enter Config Value" <#if configuration?has_content>value="${configuration.configValue?if_exists}"</#if>>
        </div>

        <div class="mb-3">
            <label for="comments" class="form-label">Comments</label>
            <textarea class="form-control" id="comments" name="comments" rows="3" placeholder="Enter Comments"> <#if configuration?has_content>${configuration.comments?if_exists}</#if></textarea>
        </div>

        <div class="text-end">
            <button type="submit" class="btn btn-primary px-4">Save</button>
        </div>
    </div>

</form>

<#include "footer.ftl">