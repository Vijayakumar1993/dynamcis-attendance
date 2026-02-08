<#include "home.ftl" />
    <!-- Lead Card -->
    <div class="panel panel-primary">
        <div class="panel-heading">
            <h3 class="panel-title">Lead Management & Follow-up</h3>
        </div>

        <div class="panel-body">

            <!-- Lead Basic Info -->
            <div class="well well-sm">
                <div class="row">
                    <div class="col-sm-4"><strong>Name:</strong> ${lead.name}</div>
                    <div class="col-sm-4"><strong>Phone:</strong><@watsapp "+91${lead.phone}" /><a href="tel:+91${lead.phone}">📞${lead.phone}</a></div>
                    <div class="col-sm-4"><strong>Email:</strong> ${lead.email}</div>
                </div>
            </div>

            <!-- Follow-up Form -->
            <form action="${baseUrl?if_exists}/lead-management/updateLead" method="post" class="form-horizontal">

                <input type="hidden" name="leadId" value="${lead.id}"/>
                <input type="hidden" name="followUpId" value="<#if latest??>${latest.id?if_exists}</#if>"/>

                <!-- Interest & Source -->
                <div class="form-group">
                    <label class="col-sm-3 control-label">Interest Level</label>
                    <div class="col-sm-3">
                        <select name="interest" class="form-control" required>
                        <option value="">-- Select --</option>
                        <#assign lst = util.getConfigs("lead-interest", "name")>
                        <#list lst as ls>
                          <option <#if latest?has_content && latest.interest?? && latest.interest.configId?if_exists == ls.configId?if_exists>selected</#if> value="${ls.configId}">
                            ${ls.configValue?capitalize}
                          </option></#list>
                        </select>
                    </div>

                    <label class="col-sm-3 control-label">Lead Source</label>
                    <div class="col-sm-3">
                        <select name="source" class="form-control" required>
                         <option value="">-- Select --</option>
                        <#assign lst = util.getConfigs("lead-source", "name")>
                        <#list lst as ls>
                          <option  <#if latest?has_content  && latest.source?? && latest.source.configId?if_exists == ls.configId?if_exists>selected</#if> value="${ls.configId}">
                            ${ls.configValue?capitalize}
                          </option></#list>
                        </select>
                    </div>
                </div>

                <!-- Status & Priority -->
                <div class="form-group">
                    <label class="col-sm-3 control-label">Current Status</label>
                    <div class="col-sm-3">
                        <select name="status" class="form-control" required>
                            <option value="">-- Select --</option>
                        <#assign lst = util.getConfigs("lead-status", "name")>
                        <#list lst as ls>
                          <option  <#if latest?has_content && latest.status??  && latest.status.configId?if_exists == ls.configId?if_exists>selected</#if> value="${ls.configId}">
                            ${ls.configValue?capitalize}
                          </option></#list>
                        </select>
                    </div>

                    <label class="col-sm-3 control-label">Priority</label>
                    <div class="col-sm-3">
                        <select name="priority" class="form-control" required>
                            <option value="">-- Select --</option>
                        <#assign lst = util.getConfigs("lead-priority", "name")>
                        <#list lst as ls>
                          <option  <#if latest?has_content && latest.priority??  && latest.priority.configId?if_exists == ls.configId?if_exists>selected</#if> value="${ls.configId}">
                            ${ls.configValue?capitalize}
                          </option></#list>
                        </select>
                    </div>
                </div>

                <!-- Expected Join & Budget -->
                <div class="form-group">
                    <label class="col-sm-3 control-label">Expected Join Date</label>
                    <div class="col-sm-3">
                        <input type="date" name="expectedJoinDate" class="form-control"  <#if latest?has_content>value="${latest.expectedJoinDate?if_exists}"</#if>/>
                    </div>

                    <label class="col-sm-3 control-label">Budget Range</label>
                    <div class="col-sm-3">
                        <select name="budget" class="form-control" required>
                            <option value="">-- Select --</option>
                        <#assign lst = util.getConfigs("lead-priority", "name")>
                        <#list lst as ls>
                          <option  <#if latest?has_content && latest.budgetRange?? && latest.budgetRange.configId?if_exists == ls.configId?if_exists>selected</#if> value="${ls.configId}">
                            ${ls.configValue?capitalize}
                          </option></#list>
                        </select>
                    </div>
                </div>

                <!-- Next Call & Preferred Time -->
                <div class="form-group">
                    <label class="col-sm-3 control-label">Next Follow-up Date</label>
                    <div class="col-sm-3">
                        <input type="date" name="nextCallDate" class="form-control" <#if latest?has_content>value="${latest.nextCallDate?if_exists}"</#if>/>
                    </div>

                    <label class="col-sm-3 control-label">Preferred Call Time</label>
                    <div class="col-sm-3">
                        <select name="callTime" class="form-control" required>
                            <option value="">-- Select --</option>
                        <#assign lst = util.getConfigs("lead-time", "name")>
                        <#list lst as ls>
                          <option  <#if latest?has_content  && latest.preferredCallTime?? && latest.preferredCallTime.configId?if_exists == ls.configId?if_exists>selected</#if> value="${ls.configId}">
                            ${ls.configValue?capitalize}
                          </option>
                    </#list>
                        </select>
                    </div>
                </div>

                <!-- Call Summary -->
                <div class="form-group">
                    <label class="col-sm-3 control-label">Call Summary</label>
                    <div class="col-sm-9">
                        <textarea name="comments" rows="4" class="form-control"
                                  placeholder="Customer interested in weekend batch, asked about fee..." required><#if latest?has_content>${latest.comments?if_exists}</#if></textarea>
                    </div>
                </div>

                <!-- Submit Button -->
                <div class="form-group">
                    <div class="col-sm-offset-3 col-sm-9">
                        <button class="btn btn-success">
                            Save Follow-up
                        </button>
                    </div>
                </div>

            </form>

            <hr/>

            <!-- Call History Timeline -->
<#if callHistoryList?has_content>
            <h4 class="text-primary">Call History Timeline</h4>



                <#if callHistoryList?size == 0>
                    <p class="text-muted">No follow-ups yet.</p>
                <#else>
                    <#list callHistoryList as call>

                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <strong>${call.callDate}</strong>
                                <span class="pull-right">
                                    <#if call.id??><a class="btn btn-xs btn-danger" href="${baseUrl?if_exists}/lead-management/deleteLead/${call.id?if_exists}">Delete</a></#if>
                                    <#if call.id??><a class="btn btn-xs btn-primary" href="${baseUrl?if_exists}/lead-management/viewFollowUp/${call.id?if_exists}">Edit</a></#if>
                                </span>
                            </div>
                            <div class="panel-body">
                                <p><strong>Status:</strong><#if call.status??>${call.status.configValue?if_exists}</#if></p>
                                <p><strong>Interest:</strong><#if call.interest??>${call.interest.configValue?if_exists}</#if></p>
                                <p><strong>Next Follow-up:</strong> ${call.nextCallDate?if_exists}</p>
                                <p><strong>Call Time:</strong> <#if call.preferredCallTime??>${call.preferredCallTime.configValue?if_exists}</#if></p>
                                <p><strong>Budget:</strong> <#if call.budgetRange??>${call.budgetRange.configValue?if_exists}</#if></p>
                                <p><strong>Comment:</strong> ${call.comments?if_exists}</p>
                                <p><strong>Created By:</strong> <#if call.createdBy??>${call.createdBy.name?if_exists}</#if></p>
                            </div>
                        </div>

                    </#list>
                </#if>
            </#if>

        </div>
    </div>
<#include "footer.ftl" />
