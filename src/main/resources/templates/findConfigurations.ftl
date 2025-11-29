<#include "home.ftl">
<marquee style="color: #d9534f; font-weight: bold;">
                Configuration is a critical part of the business. Please do not change any values without proper knowledge or prior approval.
            </marquee>
            <h2 class="mb-3">Configuration List</h2>
            <table class="table table-bordered table-striped table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>Config ID</th>
                        <th>Config Name</th>
                        <th>Config Key</th>
                        <th>Config Value</th>
                        <th>Comments</th>
                        <th>Actions</th>
                    </tr>
                </thead>

                <tbody>
                <#if configList?has_content>
                    <#list configList as cfg>
                        <tr>
                            <td>${cfg.configId}</td>
                            <td>${cfg.configName}</td>
                            <td>${cfg.configKey}</td>
                            <td>${cfg.configValue}</td>
                            <td>${cfg.comments}</td>

                            <td>
                                <a href="${baseUrl}/settings/editConfig/${cfg.configId}" class="btn btn-sm btn-primary">Edit</a>
                                <a href="${baseUrl}/settings/deleteConfig/${cfg.configId}" class="btn btn-sm btn-danger"
                                   onclick="return confirm('Are you sure?');">Delete</a>
                            </td>
                        </tr>
                    </#list>
                <#else>
                        <tr>
                            <td colspan="6" class="text-center text-muted">No Records Found</td>
                        </tr>
                </#if>
                </tbody>
            </table>
<#include "footer.ftl">