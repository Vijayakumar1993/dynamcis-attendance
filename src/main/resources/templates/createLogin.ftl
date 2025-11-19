<#include "home.ftl">
<div class="container-fluid" style="height:100vh;">
    <div class="row" style="height:100%; display:flex; justify-content:center; align-items:center;">

        <div class="col-md-4 col-sm-6 col-xs-10" style="float:none;">

            <div class="panel panel-primary">
                <div class="panel-heading text-center">
                    <h3 class="panel-title">Login</h3>
                </div>

                <div class="panel-body">


                    <!-- Login Form -->
                    <form action="{baseUrl}/login/createLoginSetup" method="post">

<#if customer?has_content>
    <input type="hidden" name="customerId" value="${customer.id?if_exists}" />
</#if>
                        <div class="form-group">
                            <label>Username</label>
                            <input type="text"
                                   name="username"
                                   class="form-control"
                                   placeholder="Enter username"
                                   required>
                        </div>

                        <div class="form-group">
                            <label>Password</label>
                            <input type="password"
                                   name="password"
                                   class="form-control"
                                   placeholder="Enter password"
                                   required>
                        </div>

                        <button class="btn btn-primary btn-block btn-lg" type="submit">Login</button>

                    </form>

                </div>
            </div>

        </div>

    </div>
</div>
<#include "footer.ftl">