<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login / Signup</title>
<link rel="icon" type="image/x-icon" href="/images/logo.ico">
<link rel="stylesheet"
      href="${baseUrl}/css/bootstrap_login.min.css">
<link rel="stylesheet" href="${baseUrl}/css/custom.css">
</head>
<body>
<#if errorMessage?has_content>
<div id="errorAlert"
     class="alert alert-danger"
     style="position: fixed; top: 20px; right: 20px; z-index: 9999; min-width: 250px;">
    ${errorMessage}
</div>

<script>
    // Hide after 5 seconds
    setTimeout(function() {
$("#errorAlert").fadeOut("slow");
}, 5000);
</script>
</#if>
<div class="container vh-100 d-flex justify-content-center align-items-center">
  <div class="card shadow w-100" style="max-width: 900px;">
    <div class="row g-0">
      <!-- Left Column: New User / Info -->
      <div class="col-md-6 d-none d-md-flex flex-column justify-content-center align-items-center bg-primary text-white p-5">
<img src="${baseUrl?if_exists}/images/logo.png" alt="Logo" style="height:100px; width:auto;">
        <h2 class="fw-bold" style="color: yellow !important"><#assign titleList = util.getConfigs("title", "name")>
<#if titleList?has_content>
    <#-- Get first element's configValue -->
    ${titleList?first.configValue?if_exists}
</#if></h2>
        <p class="mt-3 text-center">
   <#assign titleList = util.getConfigs("title", "welcome_msg")>
<#if titleList?has_content>
    <#-- Get first element's configValue -->
    ${titleList?first.configValue?if_exists}
</#if>
</p>
      </div>

      <!-- Right Column: Login Form -->
      <div class="col-md-6 p-5">
        <h1 class="text-center mb-4 fw-bold">Welcome</h1>
        <p class="text-center text-muted mb-4">Please sign in to continue</p>

        <form action="/doLogin" method="post">

          <div class="mb-3">
            <label class="form-label">Username</label>
            <input type="text" name="username" class="form-control form-control-lg" placeholder="Enter your username" required>
          </div>

          <div class="mb-3">
            <label class="form-label">Password</label>
            <input type="password" name="password" class="form-control form-control-lg" placeholder="Enter your password" required>
          </div>

          <button class="btn btn-primary w-100 btn-lg" type="submit">Login</button>

       <div class="text-center mt-3">
    <a href="#"
       class="text-decoration-none"
       data-bs-toggle="modal"
       data-bs-target="#supportModal">
        Need Help?
    </a>
</div>



        </form>

      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<!-- ================= SUPPORT MODAL ================= -->
<div class="modal fade" id="supportModal" tabindex="-1" aria-labelledby="supportModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">

            <!-- Header -->
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="supportModalLabel">
                     Need Help?
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>

         <div class="modal-body">

    <div class="text-center">
        <h4 class="text-primary" style="font-weight: 600;">
            Need Help Accessing Your Account?
        </h4>
        <p class="text-muted" style="font-size: 14px;">
            We are here to assist you.
        </p>
    </div>

    <p style="font-size: 15px; line-height: 1.6;">
        We request you to connect with our
        <strong>
            <#assign titleList = util.getConfigs("title", "name")>
            <#if titleList?has_content>
                ${titleList?first.configValue?if_exists}
            </#if>
            Team
        </strong>
        to enable your user access or reset your password.
    </p>

    <p style="font-size: 15px; line-height: 1.6;">
        Our team will be happy to assist you and ensure a smooth experience.
        We truly value your presence and are delighted to have you as part of our community.
    </p>

    <div class="text-center">
        <#assign titleList = util.getConfigs("title", "website")>
        <#if titleList?has_content>
            <a href="${titleList?first.configValue?if_exists}"
               target="_blank"
               class="btn btn-primary btn-block"
               style="padding: 10px 15px; font-size: 15px;">
                Contact Our Support Team
            </a>
        </#if>
    </div>

</div>


            <!-- Footer -->
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    Close
                </button>
            </div>

        </div>
    </div>
</div>

</body>
</html>
