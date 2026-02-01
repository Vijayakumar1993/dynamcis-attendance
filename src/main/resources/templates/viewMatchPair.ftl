<head>
<link rel="icon" type="image/x-icon" href="/images/logo.ico">
</head>
<div class="arena text-center">

    <div class="fight-title animate__animated animate__fadeInDown">
       Ultimate Showdown
    </div>

    <div class="row fighter-wrapper">

        <!-- BLUE CORNER -->
        <div class="col-sm-5 animate__animated animate__fadeInLeft">
            <div class="fighter">

                <div class="fighter-img blue float">
                    <#assign img1 = util.getPhotoByCustomerId(corner1.id?string)! />
                    <#if img1?has_content && img1.document?has_content>
                        <img src="data:image/png;base64,${Base64UtilEncoder.encodeToString(img1.document)}">
                    <#else>
                        <img src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///ywAAAAAAQABAAACAUwAOw==">
                    </#if>
                </div>

                <div class="fighter-name text-primary">
                    ${corner1.name?upper_case}
                </div>

                <div class="stat-strip">
                    <span class="text-primary">${corner1.team.teamName?if_exists}</span>
                </div>
            </div>
        </div>

        <!-- VS -->
        <div class="col-sm-2 hidden-xs animate__animated animate__zoomIn">
            <div class="vs-core float">VS</div>
        </div>

        <!-- RED CORNER -->
        <div class="col-sm-5 animate__animated animate__fadeInRight">
            <div class="fighter">

                <div class="fighter-img red float">
                    <#assign img2 = util.getPhotoByCustomerId(corner2.id?string)! />
                    <#if img2?has_content && img2.document?has_content>
                        <img src="data:image/png;base64,${Base64UtilEncoder.encodeToString(img2.document)}">
                    <#else>
                        <img src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///ywAAAAAAQABAAACAUwAOw==">
                    </#if>
                </div>

                <div class="fighter-name text-danger">
                    ${corner2.name?upper_case}
                </div>

                <div class="stat-strip">
                    <span class="text-danger">${corner2.team.teamName?if_exists}</span>
                </div>
            </div>
        </div>

    </div>
</div>

<#include "footer.ftl">
