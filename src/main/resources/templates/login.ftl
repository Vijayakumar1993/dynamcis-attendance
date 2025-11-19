<#include "home.ftl">
<div class="container d-flex justify-content-center align-items-center vh-100">

    <div class="card shadow-lg border-0 w-100" style="max-width: 520px;">
        <div class="card-body p-5">

            <h1 class="text-center mb-4 fw-bold">Welcome Back</h1>
            <p class="text-center text-muted mb-4">Please sign in to continue</p>

            <form action="/doLogin" method="post">

                <div class="mb-4">
                    <label class="form-label">Username</label>
                    <input type="text" name="username" class="form-control form-control-lg"
                           placeholder="Enter your username" required>
                </div>

                <div class="mb-4">
                    <label class="form-label">Password</label>
                    <input type="password" name="password" class="form-control form-control-lg"
                           placeholder="Enter your password" required>
                </div>

                <button class="btn btn-primary w-100 btn-lg" type="submit">Login</button>

            </form>

        </div>
    </div>

</div>
<#include "footer.ftl">