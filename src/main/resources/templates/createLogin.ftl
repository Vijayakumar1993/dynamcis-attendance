<#include "home.ftl">

<div class="container">
  <div class="row">
    <div class="col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3">

      <!-- ================= PANEL ================= -->
      <div class="panel panel-primary login-panel">

        <div class="panel-heading text-center">
          <h3 class="panel-title">
            <span class="glyphicon glyphicon-user"></span>
            &nbsp; Create Login
          </h3>
        </div>

        <div class="panel-body">

          <form action="${baseUrl?if_exists}/login/createLoginSetup" method="post">

            <#if customer?has_content>
              <input type="hidden" name="customerId" value="${customer.id?if_exists}">
            </#if>

            <input type="hidden" name="role"
                   value="ROLE_STUDENT" />
            <!-- Username -->
            <div class="form-group">
              <label>Username</label>
              <input type="text"
                     name="username"
                     class="form-control input-lg"
                     placeholder="Enter username"
                     value="<#if customer?has_content>${customer.name?if_exists}</#if>"
                     autocomplete="off"
                     required>
            </div>

            <!-- Password -->
            <div class="form-group">
              <label>Password</label>

              <div class="input-group">
                <input type="password"
                       name="password"
                       id="passwordInput"
                       class="form-control input-lg"
                       placeholder="Enter password"
                       autocomplete="new-password"
                       required>

                <span class="input-group-btn">
                  <button class="btn btn-default btn-lg"
                          type="button"
                          id="togglePassword"
                          title="Show / Hide Password">
                    <span class="glyphicon glyphicon-eye-open"></span>
                  </button>
                </span>
              </div>
            </div>

            <!-- Action -->
            <div class="form-group">
              <button class="btn btn-primary btn-lg btn-block" type="submit">
                <span class="glyphicon glyphicon-ok"></span>
                &nbsp; Create Login
              </button>
            </div>

          </form>

        </div>
      </div>
      <!-- ================= /PANEL ================= -->

    </div>
  </div>
</div>

<#include "footer.ftl">
