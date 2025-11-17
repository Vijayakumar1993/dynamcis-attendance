<#include "home.ftl">
<h3 class="text-center">Receive Payment</h3>
<hr>

<form action="${baseUrl}/payment/completePayment" method="post" class="container">

    <!-- Hidden field -->
    <input type="hidden" name="customerId"
           value="<#if customer?has_content>${customer.id}</#if>"/>

    <div class="row">

        <!-- Column 1 -->
        <div class="col-md-6">

            <!-- Customer Name -->
            <div class="form-group">
                <label>Customer</label>
                <input type="text" class="form-control"
                       value="<#if customer?has_content>${customer.name}</#if>" readonly>
            </div>

            <!-- Amount -->
            <div class="form-group">
                <label>Amount</label>
                <input type="number" name="amount" class="form-control"
                       placeholder="Enter amount" required>
            </div>
<div class="form-group">
                <label>Tenure</label>
                <input type="number" name="tenure" class="form-control"
                       placeholder="Enter Tenure" required>
            </div>
        </div>

        <!-- Column 2 -->
        <div class="col-md-6">

            <!-- Payment Date -->
            <div class="form-group">
                <label>Payment Date</label>
                <input type="date" name="paymentDate" class="form-control"  required value="${.now?string('yyyy-MM-dd')}">
            </div>

            <!-- Payment Mode -->
            <div class="form-group">
                <label>Payment Mode</label>
                <select name="paymentMethod" class="form-control" required>
                    <option value="">Select</option>
                    <option>Cash</option>
                    <option>UPI</option>
                    <option>Bank Transfer</option>
                    <option>Card</option>
                </select>
            </div>
 <div class="form-group">
        <label>Remarks</label>
        <textarea name="remarks" class="form-control" rows="3"
                  placeholder="Optional"></textarea>
    </div>
        </div>

    </div>


    <!-- Submit -->
    <button type="submit" class="btn btn-primary btn-block">
        Submit Payment
    </button>

</form>

<#include "footer.ftl">