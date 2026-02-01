<#include "home.ftl">

<marquee style="color:#d9534f;font-weight:bold;">
    Configuration is a critical part of the business. Please do not change any values without proper knowledge or prior approval.
</marquee>

<h2 class="mb-3">Configuration List</h2>

<#if configList?has_content>

    <#-- Group by configName -->
    <#assign groupedConfigs = {} />
    <#list configList as cfg>
        <#if !groupedConfigs[cfg.configName]?has_content>
            <#assign groupedConfigs = groupedConfigs + { (cfg.configName) : [cfg] } />
        <#else>
            <#assign groupedConfigs = groupedConfigs + { (cfg.configName) : groupedConfigs[cfg.configName] + [cfg] } />
        </#if>
    </#list>

    <#-- Render Groups -->
    <#list groupedConfigs?keys as configName>
        <div class="panel panel-default">
            <div class="panel-heading">
                <strong>${configName?capitalize}

<#assign cfgName ="" />
<#assign cfgKey ="" />
                <#list groupedConfigs[configName] as cfg>
<#assign cfgName ="${configName}" />
<#assign cfgKey ="${cfg.configKey}" />
                </#list>
<form method="get" action="${baseUrl?if_exists}/settings" method="post" target="_blank" class="pull-right">
    <input type="hidden" name="configName" value="${cfgName?if_exists}" />
    <input type="hidden" name="configKey" value="${cfgKey?if_exists}" />
    <button type="submit" class="btn btn-xs btn-danger"><span class="glyphicon glyphicon-plus pull-right"/></button>
</form>
</strong>
            </div>

            <div class="panel-body">
                <#list groupedConfigs[configName] as cfg>
                    <div class="row" style="padding:6px 0;border-bottom:1px solid #eee;">
                        <div class="col-sm-3 text-muted">
                            <strong>${cfg.configKey}</strong>
                        </div>

                        <div class="col-sm-4">
                            ${cfg.configValue}
                        </div>

                        <div class="col-sm-3 text-muted">
                            ${cfg.comments!'-'}
                        </div>

                        <div class="col-sm-2 text-right">
                            <a href="${baseUrl}/settings/editConfig/${cfg.configId}"
                               class="btn btn-xs btn-primary">Edit</a>
                            <a href="${baseUrl}/settings/deleteConfig/${cfg.configId}"
                               class="btn btn-xs btn-danger"
                               onclick="return confirm('Are you sure?');">Delete</a>
                        </div>
                    </div>
                </#list>
            </div>
        </div>
    </#list>

<#else>
    <div class="alert alert-info text-center">
        No configuration records found.
    </div>
</#if>

<#include "footer.ftl">
