<#include "home.ftl">
<div class="container-fluid" style="height:100vh;">
    <div class="row" >

        <div class="col-md-6 col-sm-6 col-xs-10" style="float:none;">

            <div class="panel panel-primary">
                <div class="panel-heading text-center">
                    <h3 class="panel-title">Create Login</h3>
                </div>

                <div class="panel-body">


                    <!-- Login Form -->
                    <form action="${baseUrl?if_exists}/login/createLoginSetup" method="post">

<#if customer?has_content>
    <input type="hidden" name="customerId" value="${customer.id?if_exists}" />
</#if>
                        <div class="form-group">
                            <label>Username</label>
                            <input type="text"
                                   name="username"
                                   class="form-control"
                                   placeholder="Enter username"
                                  value="<#if customer?has_content>${customer.name?if_exists}</#if>"
                                   required>
                        </div>

                        <div class="form-group">
                            <label>Password</label>
                            <input type="password"
                                   name="password"
                                   class="form-control"
                                   placeholder="Enter password"
                                    autocomplete="off"
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