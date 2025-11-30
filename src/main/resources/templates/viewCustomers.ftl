<#include "home.ftl">
<div class="col-md-12 col-sm-12 col-lg-12 col-xs-12">
<h2 class="mb-4">

<#if customer.status=='INACTIVE'>
<span style="color:#ff0500">&#10008;</span>
<#else>
 <span style="color: #00ff04">&#10004;</span>
</#if>&nbsp;${customer.name?capitalize?if_exists} Details
  <#if admin_access><a href="/customer/editCustomer/${customer.id?if_exists}" class="btn btn-default btn-xs pull-right"  style="margin-right: 2px">Edit</a></#if>
    </h2>
   <div class="col-md-6">
      <div class="row mb-3">
         <div class="col-sm-4 font-weight-bold">ID</div>
         <div class="col-sm-8">${customer.id?if_exists}</div>
      </div>
      <div class="row mb-3">
         <div class="col-sm-4 font-weight-bold">Name</div>
         <div class="col-sm-8 text-capitalize">${customer.name?if_exists}</div>
      </div>
      <div class="row mb-3">
         <div class="col-sm-4 font-weight-bold">Guardian / Father / Spouse</div>
         <div class="col-sm-8 text-capitalize">${customer.guardianName?if_exists}</div>
      </div>
      <#if pack?has_content>
      <div class="row mb-3">
         <div class="col-sm-4 font-weight-bold">Package</div>
         <div class="col-sm-8 text-capitalize">${pack.configValue?if_exists}</div>
      </div>
      </#if>
      <div class="row mb-3">
         <div class="col-sm-4 font-weight-bold">Phone</div>
         <div class="col-sm-8">${customer.phone?if_exists}</div>
      </div>
      <div class="row mb-3">
         <div class="col-sm-4 font-weight-bold">Email</div>
         <div class="col-sm-8">${customer.email?if_exists}</div>
      </div>
   </div>
   <div class="col-md-6">
     <div class="row mb-3">
         <div class="col-sm-4 font-weight-bold">Gender</div>
         <div class="col-sm-8">${customer.gender?if_exists?capitalize}</div>
      </div>

 <div class="row mb-3">
         <div class="col-sm-4 font-weight-bold">Address</div>
         <div class="col-sm-8">${customer.address?if_exists}</div>
      </div>

      <div class="row mb-3">
         <div class="col-sm-4 font-weight-bold">Joined Date</div>
         <div class="col-sm-8">
            ${customer.joiningDate?if_exists?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}
         </div>
      </div>
      <#if customer.renewalDate?has_content>
      <div class="row mb-3">
         <div class="col-sm-4 font-weight-bold">Renewel Date</div>
         <div class="col-sm-8">
            ${customer.renewalDate?if_exists?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}
         </div>
      </div>
      </#if>
      <#if customer.createdDate?has_content>
      <div class="row mb-3">
         <div class="col-sm-4 font-weight-bold">Created Date</div>
         <div class="col-sm-8">
            ${customer.createdDate?if_exists?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}
         </div>
      </div>
      </#if>
      <div class="row mb-3">
         <div class="col-sm-4 font-weight-bold">Created By</div>
         <div class="col-sm-8">${customer.createdBy?if_exists}</div>
      </div>
   </div>
</div>
<div class="col-md-12 col-sm-12 col-lg-12 col-xs-12">
 <h2>Securities
        <#if admin_access>
          <a href="/login/createLogin/${customer.id?if_exists}" class="btn btn-default btn-xs pull-right" style="margin-right: 2px">Create Login</a>
        </#if>
      </h2>
  <!-- Nav tabs -->
  <ul class="nav nav-tabs">
    <li class="active"><a href="#loginDetails" data-toggle="tab"><b>User Login Details</b></a></li>
    <li><a href="#roles" data-toggle="tab"><b>Roles</b></a></li>
  </ul>

  <!-- Tab panes -->
  <div class="tab-content" style="margin-top:15px;">

    <!-- Tab 1: User Login Details -->
    <div class="tab-pane fade in active  table-responsive" id="loginDetails">

      <table class="table table-bordered table-striped table-hover">
        <thead>
          <tr class="info">
            <th>Id</th>
            <th>User name</th>
            <th>Enabled</th>
            <th>Update</th>
          </tr>
        </thead>
        <tbody>
          <#if users?has_content>
            <#list users as p>
              <tr>
                <td>${p.id?if_exists}</td>
                <td>${p.username?if_exists}</td>
                <td<#if p.enabled?default(false)> class="present" <#else> class="absent" </#if>>
                  <#if p.enabled?default(false)> Yes <#else> No </#if>
                </td>
                <td>
                  <a href="${baseUrl?if_exists}/login/updateLogin/${p.id?if_exists}" class="btn btn-primary">Update</a>
                  <#if admin_access>
                    <a href="${baseUrl?if_exists}/login/removeLogin/${p.id?if_exists}" class="btn btn-danger">Remove</a>
                  </#if>
                </td>
              </tr>
            </#list>
          <#else>
            <tr>
              <td colspan="4" class="text-center text-danger">No Logins found</td>
            </tr>
          </#if>
        </tbody>
      </table>
    </div>

    <!-- Tab 2: Roles -->
    <div class="tab-pane fade  table-responsive" id="roles">
<#assign roleCustomerId = customer.id?if_exists>
        <#assign roles = util.getAuthorites("${roleCustomerId}") />
<#if roles?has_content>
      <table class="table table-bordered table-striped table-hover">
        <thead>
          <tr class="info">
            <th>Id</th>
            <th>Student Name</th>
            <th>User Name</th>
            <th>Authority</th>
            <th>Add Role</th>
            <th>Remove Role</th>
          </tr>
        </thead>
        <tbody>
          <#if roles?has_content>
            <#list roles as r>
              <tr>
                <td>${r.id?if_exists}</td>
                <td>${customer.name?if_exists}</td>
                <td>${r.username?if_exists}</td>
                <td>${r.authority?if_exists}</td>
                <td>
            <form action="${baseUrl?if_exists}/authorities/createAuthority" method="post">
         <div class="d-flex align-items-center gap-2">
            <select name="role" class="form-control form-select" required>
                <option value="">-- Select --</option>
                <option value="ROLE_USER" <#if gender?has_content && gender == "ROLE_USER">selected</#if>>User</option>
                <option value="ROLE_ADMIN" <#if gender?has_content && gender == "ROLE_ADMIN">selected</#if>>Admin</option>
            </select>

            <input type="hidden" name="username" value="${r.username?if_exists}">
            <input type="hidden" name="customerId" value="${roleCustomerId}">

            <input type="submit" class="btn btn-success" value="Add"/>
        </div>
    </form>
            </td>
                <td> <a href="${baseUrl?if_exists}/authorities/deleteAuthority/${r.id?if_exists}/${roleCustomerId}" class="btn btn-danger">Remove</a></td>
              </tr>
            </#list>
          <#else>
            <tr>
              <td colspan="3" class="text-center text-danger">No Roles found</td>
            </tr>
          </#if>
        </tbody>
      </table>
</#if>
    </div>

  </div>
</div>

<div class="col-md-12 col-sm-12 col-lg-12 col-xs-12 table-responsive">
   <#if admin_access>
   <h2>Payment List <#if admin_access>
      <a href="/payment/receivePayment/${customer.id?if_exists}" class="btn btn-default btn-xs pull-right">Receive Payment</a></#if>
      </h2>
   <table class="table table-bordered table-striped table-hover">
      <thead>
         <tr class="info">
            <th>Payment Id</th>
            <th>Amount</th>
            <th>Balance</th>
            <th>Payment Date</th>
            <th>Mode</th>
            <th>Tenure (Months)</th>
            <th>Status</th>
            <th>Remarks</th>
            <th>Update</th>
         </tr>
      </thead>
      <tbody>
         <#if payments?has_content>
         <#list payments as p>
         <tr>
            <td>${p.paymentId?if_exists}</td>
            <td>₹${p.amount?if_exists}</td>
            <td>₹${p.balance?if_exists}</td>
            <td>${p.paymentDate?if_exists?if_exists?date("yyyy-MM-dd")?string("EEE, MMM d yyyy")}</td>
            <td>${p.paymentMethod?if_exists?capitalize}</td>
            <td>${p.tenure?if_exists}</td>
            <td>${p.status?if_exists}</td>
            <td>${p.remarks!""}</td>
            <td>
               <a href="${baseUrl?if_exists}/payment/receivePayment/${customer.id?if_exists}?paymentId=${p.paymentId?if_exists}" class="btn btn-primary">Update</a>
               <a href="${baseUrl?if_exists}/payment/removePayment/${p.paymentId?if_exists}?customerId=${customer.id?if_exists}" class="btn btn-danger">Remove</a>
            </td>
         </tr>
         </#list>
         <#else>
         <tr>
            <td colspan="8" class="text-center text-danger">No payments found</td>
         </tr>
         </#if>
      </tbody>
   </table>
   </#if>
</div>
.
<div class="col-md-12 col-sm-12 col-lg-12 col-xs-12  table-responsive">
   <h2>Documents <a class="btn btn-default btn-xs  pull-right" data-toggle="modal" style="margin-right: 2px" data-target="#myModal">Upload Document </a>
     </h2>
   <table class="table table-bordered table-striped table-hover">
      <thead>
         <tr class="info">
            <th>Id</th>
            <th>Document Type</th>
            <th>Remarks</th>
            <th>Document</th>
         </tr>
      </thead>
      <tbody>
         <#if docs?has_content>
         <#list docs as p>
         <tr>
            <td>${p.documentId?if_exists}</td>
            <td>

<#assign docType = p.documentType?if_exists>
<#assign updatedDocType = util.getConfig(docType)>
${updatedDocType.configValue?if_exists}
</td>
<td>${p.comments?if_exists}</td>
            <td>

      <a class="btn btn-default" data-toggle="modal" style="margin-right: 2px" data-target="#viewModel_${p.documentId?if_exists}">View</a>
<a href="${baseUrl?if_exists}/documents/download/${p.documentId?if_exists}" class="btn btn-primary">Download</a>
    <a href="${baseUrl?if_exists}/documents/deleteDocument/${p.documentId?if_exists}/${customer.id?if_exists}" class="btn btn-danger">Remove</a>

<!-- view model -->
<div class="modal fade" id="viewModel_${p.documentId?if_exists}" tabindex="-1" role="dialog">
      <div class="modal-dialog" role="document">
         <div class="modal-content">
            <!-- Header -->
            <div class="modal-header">
               <h4 class="modal-title"><b>${updatedDocType.configValue?if_exists}</b>

</h4>
               <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <!-- Body -->
            <div class="modal-body">
            <div class="card">
              <img src="data:image/png;base64,${Base64UtilEncoder.encodeToString(p.document)}"
                 class="img-fluid img-thumbnail" />
              <div class="card-body">
                <p class="card-text"><strong>${p.comments?if_exists}</strong></p>
              </div>
            </div>
            </div>
            <!-- Footer -->
            <div class="modal-footer">
                <span class="pull-left"><b>Note:</b> View only support images alone, kinldy download for other documents.</span>
               <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
         </div>
      </div>
   </div>
<!--end view model -->
</td>
         </tr>
         </#list>
         <#else>
         <tr>
            <td colspan="3" class="text-center text-danger">No Documents found</td>
         </tr>
         </#if>
      </tbody>
   </table>
</div>
<!-- model popup -->
<!-- The Modal -->
<form action="/documents/upload" method="post" enctype="multipart/form-data" class="mt-3">
   <div class="modal fade" id="myModal" tabindex="-1" role="dialog">
      <div class="modal-dialog" role="document">
         <div class="modal-content">
            <!-- Header -->
            <div class="modal-header">
               <h4 class="modal-title">Document Upload</h4>
               <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <!-- Body -->
            <div class="modal-body">
               <select class="form-control" name="documentType" id="documentType" required>
                  <option value="">-- Select Document--</option>
                  <#if documents?has_content>
                  <#list documents as c>
                  <option value="${c.configId?if_exists}">${c.configValue?capitalize?if_exists}</option>
                  </#list>
                  </#if>
               </select>
               <input type="hidden" name="customerId" value="${customer.id?if_exists}">
              <div class="mb-3">
                <input type="file" name="file" class="form-control mb-2" required>
            </div>
                <div class="mb-3">
                    <textarea name="comments" class="form-control" rows="3" placeholder="Enter Comments...!"></textarea>
                </div>
            </div>
            <!-- Footer -->
            <div class="modal-footer">
               <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
               <button type="submit" class="btn btn-primary">Save</button>
            </div>
         </div>
      </div>
   </div>
</form>
<!-- end model popup -->
<#include "footer.ftl">