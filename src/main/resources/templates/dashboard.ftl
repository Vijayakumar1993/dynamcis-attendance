<#include "home.ftl">
<div class="">
    <h2 class="mb-4">Welcome</h2>

    <!-- Cards Row -->
    <div class="row g-4">
        <div class="col-md-4">
            <div class="card p-3 text-center bg-primary text-white">
                <h4 class="padding-top-5">Total Students</h4>
                <h2>${total?default("0")}</h2>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card p-3 text-center bg-success text-white">
                <h4 class="padding-top-5">Present Today</h4>
                <h2>${presents?default("0")}</h2>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card p-3 text-center bg-danger text-white">
                <h4 class="padding-top-5">Absent Today</h4>
                <h2>${absents?default("0")}</h2>
            </div>
        </div>
    </div>

    <!-- Chart Section -->
    <div class="card mt-5 p-4">
        <h4>Attendance Overview</h4>
        <hr>
        <div class="text-center text-muted">
            <p><i>Chart Placeholder</i></p>
        </div>
    </div>

    <!-- Recent Activity Table -->
    <div class="card mt-5 p-4">
        <h4>Recent Attendance</h4>
        <hr>

        <div class="table-responsive">
            <table class="table table-bordered table-striped">
                <thead class="table-dark">
                    <tr>
                        <th>Student</th>
                        <th>Date</th>
                        <th>Status</th>
                    </tr>
                </thead>

                <tbody>
<#if attendance?has_content>
<#list attendance as ls>
   <tr>
                        <td>${ls.name?if_exists}</td>
                        <td>${ls.date?if_exists}</td>
                        <td><span class="text-success">Present</span></td>
                    </tr>
</#list>
</#if>
                </tbody>
            </table>
        </div>
    </div>
</div>
<#include "footer.ftl">