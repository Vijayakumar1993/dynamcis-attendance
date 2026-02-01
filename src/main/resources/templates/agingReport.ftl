<#include "home.ftl">

<div class="row">
    <div class="col-lg-12">

        <div class="panel panel-default fee-panel">

            <div class="panel-heading clearfix">
                <h4 class="panel-title pull-left">
                    Fee Pending Report
                </h4>
            </div>

            <!-- Tabs -->
            <ul class="nav nav-tabs fee-tabs">
                <li class="active">
                    <a data-toggle="tab" href="#priorThirtyDays">
                        Due Soon
                        <span class="badge badge-info">
                            ${priorThirtyDays?size!0}
                        </span>
                    </a>
                </li>
                <li>
                    <a data-toggle="tab" href="#thirty">
                        0–30 Days
                        <span class="badge badge-warning">
                            ${thirtyDays?size!0}
                        </span>
                    </a>
                </li>
                <li>
                    <a data-toggle="tab" href="#sixty">
                        30–60 Days
                        <span class="badge badge-danger">
                            ${sixtyDays?size!0}
                        </span>
                    </a>
                </li>
                <li>
                    <a data-toggle="tab" href="#ninety">
                        60–90 Days
                        <span class="badge badge-danger">
                            ${nintyDays?size!0}
                        </span>
                    </a>
                </li>
                <li>
                    <a data-toggle="tab" href="#other">
                        90+ Days
                        <span class="badge badge-danger">
                            ${otherDays?size!0}
                        </span>
                    </a>
                </li>
            </ul>

            <!-- Content -->
            <div class="tab-content padding-15">
                <@feeTable id="priorThirtyDays" list=priorThirtyDays active=true />
                <@feeTable id="thirty" list=thirtyDays />
                <@feeTable id="sixty" list=sixtyDays />
                <@feeTable id="ninety" list=nintyDays />
                <@feeTable id="other" list=otherDays />
            </div>

        </div>
    </div>
</div>

<#include "footer.ftl">
