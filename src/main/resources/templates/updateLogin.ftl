<#include "home.ftl">

<div class="container-fluid" style="height:100vh;">
    <div class="row">

        <div class="col-md-6 col-sm-6 col-xs-10" style="float:none;">

            <div class="panel panel-primary">
                <div class="panel-heading text-center">
                    <h3 class="panel-title">Create Login</h3>
                </div>

                <div class="panel-body">

                    <!-- Login Form -->
                    <form action="${baseUrl?if_exists}/login/updateLoginSetup" method="post">

                        <#if user?has_content>
                            <input type="hidden" name="id" value="<#if user?has_content>${user.id?if_exists}</#if>" />
                            <input type="hidden" name="customerId" value="<#if user?has_content>${user.customerId?if_exists}</#if>" />
                        </#if>

                        <!-- Username -->
                        <div class="form-group">
                            <label>Username</label>
                            <input type="text"
                                   name="username"
                                   class="form-control"
                                   placeholder="Enter username"
                                   value="<#if user?has_content>${user.username?if_exists}</#if>"
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
                                       class="form-control"
                                       placeholder="Enter password"
                                       autocomplete="new-password"
                                       required>

                                <span class="input-group-btn">
                                    <button class="btn btn-default" type="button" id="togglePassword">
                                        <span class="glyphicon glyphicon-eye-open"></span>
                                    </button>
                                </span>
                            </div>

                        </div>

                        <input type="hidden" name="enabled" value="true">

                        <button class="btn btn-primary btn-block btn-lg" type="submit">Login</button>

                    </form>

                </div>
            </div>

        </div>

    </div>
</div>

<#include "footer.ftl">

<!-- Password Show/Hide Script -->
<script>
    document.getElementById("togglePassword").addEventListener("click", function() {
let input = document.getElementById("passwordInput");
let icon = this.querySelector("span");

if (input.type === "password") {
input.type = "text";
icon.classList.remove("glyphicon-eye-open");
icon.classList.add("glyphicon-eye-close");
} else {
input.type = "password";
icon.classList.remove("glyphicon-eye-close");
icon.classList.add("glyphicon-eye-open");
}
    });
</script>