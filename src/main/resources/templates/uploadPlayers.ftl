<#include "home.ftl" />

<div class="container" style="margin-top:50px;">
  <div class="row">
    <div class="col-md-10 col-md-offset-1 col-lg-8 col-lg-offset-2">

      <div class="panel panel-default">
        <div class="panel-heading" style="background:#222;color:#f0ad4e;">
          <h3 class="panel-title text-uppercase">
            Bulk Upload Players
          </h3>
        </div>

        <div class="panel-body">

          <!-- Instructions -->
          <div class="alert alert-info">
            <strong>Instructions:</strong>
            <ul style="margin-bottom:0;">
              <li>Upload <b>CSV</b> only</li>
              <li>Mandatory columns:
                <code>name, guardianName, phone, gender, team, email, dob</code>
              </li>
              <li>Date format: <code>yyyy-MM-dd</code></li>
              <li>Gender values: <code>male, female, other</code></li>
            </ul>
          </div>

          <!-- Template Download -->
          <div class="text-right" style="margin-bottom:15px;">
            <a href="${baseUrl}/fixture/player-upload-template"
               class="btn btn-warning btn-sm">
              <i class="glyphicon glyphicon-download"></i>
              Download Template
            </a>
          </div>

          <!-- Upload Form -->
          <form method="post"
                action="${baseUrl}/fixture/upload"
                enctype="multipart/form-data">

            <div class="row">

              <!-- Team -->
              <div class="col-md-6">
                <div class="form-group">
                  <label class="control-label">
                    Team <span class="text-danger">*</span>
                  </label>
                  <select name="teamId" class="form-control" required>
                    <option value="">-- Select Team --</option>
                    <#assign teams = util.teams()>
                    <#list teams as t>
                      <option value="${t.id}">
                        ${t.teamName?capitalize}
                      </option>
                    </#list>
                  </select>
                </div>
              </div>

              <!-- Category -->
              <div class="col-md-6">
                <div class="form-group">
                  <label class="control-label">
                    Category <span class="text-danger">*</span>
                  </label>
                  <select name="category" class="form-control" required>
                    <option value="">-- Select Category --</option>
                    <#assign categorization = util.getConfigs("categorization", "name")>
                    <#list categorization as c>
                      <option value="${c.configId}">
                        ${c.configValue?capitalize}
                      </option>
                    </#list>
                  </select>
                </div>
              </div>

              <!-- File -->
              <div class="col-md-12">
                <div class="form-group">
                  <label class="control-label">
                    Upload File <span class="text-danger">*</span>
                  </label>
                  <input type="file"
                         name="file"
                         class="form-control"
                         accept=".csv,.xlsx"
                         required />
                </div>
              </div>

            </div>

            <hr>

            <div class="text-right">
              <button type="submit" class="btn btn-success">
                Upload Players
              </button>
              <a href="/customer/viewCustomers" class="btn btn-default">
                Cancel
              </a>
            </div>

          </form>

          <!-- Upload Result -->
            <hr>
<#if successCount??>
            <div class="alert alert-success">
            <strong>Success Summary</strong><br>
              Successful Records: ${successCount?if_exists}<br>
            </div>
</#if>

<#if failureCount??>
 <div class="alert alert-danger">
            <strong>Failure Summary</strong><br>
        Failed Records: ${failureCount?if_exists}
</div>
</#if>

            <#if errors?has_content>
              <div class="alert alert-danger">
                <strong>Validation Errors</strong>
              </div>

              <div class="table-responsive">
                <table class="table table-bordered table-striped">
                  <thead>
                    <tr>
                      <th>Row No</th>
                      <th>Field</th>
                      <th>Value</th>
                      <th>Error</th>
                    </tr>
                  </thead>
                  <tbody>
                    <#list errors as e>
                      <tr>
                        <td>${e.rowNumber}</td>
                        <td>${e.field}</td>
                        <td>${e.value?if_exists}</td>
                        <td class="text-danger">${e.message}</td>
                      </tr>
                    </#list>
                  </tbody>
                </table>
              </div>
            </#if>

        </div>
      </div>

    </div>
  </div>
</div>

<#include "footer.ftl" />
