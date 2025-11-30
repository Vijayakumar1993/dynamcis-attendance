<#include "home.ftl">


<form action="${baseUrl}/payment/completePayment" method="post" class="container">

<h2 class="text-center">Receive Payment</h2>
    <!-- Hidden field -->
<#if payment?has_content>
    <input type="hidden" name="paymentId"
           value="${payment.paymentId?if_exists}"/>
</#if>
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
                <input type="number" name="amount" min="0" class="form-control"
                       placeholder="Enter amount" value="<#if payment?has_content>${payment.amount?if_exists?replace(",", "")}<#else>${amount?if_exists?replace(",", "")}</#if>" required>
            </div>
<div class="form-group">
                <label>Tenure</label>
                <input type="number" name="tenure" class="form-control"
                       placeholder="Enter Tenure" value="<#if payment?has_content>${payment.tenure?if_exists}<#else>${tenure?if_exists}</#if>"  required>
            </div>
            <!-- Amount -->
 <div class="form-group">
                <label>Payment Mode</label>
                <select name="paymentMethod" class="form-control" required>
                    <option  value="">Select</option>
                    <option <#if payment?has_content><#if payment.paymentMethod=="cash">selected</#if></#if> value="cash">Cash</option>
                    <option <#if payment?has_content><#if payment.paymentMethod=="upi">selected</#if></#if>  value="upi">UPI</option>
                    <option <#if payment?has_content><#if payment.paymentMethod=="banktransfer">selected</#if></#if>  value="banktransfer">Bank Transfer</option>
                    <option <#if payment?has_content><#if payment.paymentMethod=="card">selected</#if></#if>  value="card">Card</option>
                </select>
            </div>
 <!-- Close Payment Checkbox -->
            <div class="form-group">
                <div class="checkbox">
                    <label>
                        <input type="checkbox" name="closePayment" value="true" checked>
                        <strong>Close Previous Payments</strong>
                    </label>
                </div>
            </div>
        </div>

        <!-- Column 2 -->
        <div class="col-md-6">

            <!-- Payment Date -->
            <div class="form-group">
                <label>Payment Date</label>
                <input type="date" name="paymentDate" class="form-control" required  value="<#if payment?has_content>${payment.paymentDate?if_exists}<#else>${.now?string('yyyy-MM-dd')}</#if>" >
            </div>

            <!-- Payment Mode -->
            <div class="form-group">
                <label>Balance</label>
                <input type="number" name="balance" min="0" class="form-control"
                       placeholder="Enter amount" required value="<#if payment?has_content>${payment.balance?if_exists?replace(",", "")}<#else>0</#if>" >
            </div>

             <div class="form-group">
                    <label>Remarks</label>
                    <textarea name="remarks" class="form-control"
                              placeholder="Optional"><#if payment?has_content>${payment.remarks?if_exists}</#if></textarea>
                </div>

                <div class="form-group">
                <label>Payment Status</label>
                <select name="status" class="form-control" required>
                    <option <#if payment?has_content><#if payment.status=="open">selected</#if></#if> value="open">Open</option>
                    <option <#if payment?has_content><#if payment.status=="close">selected</#if></#if>  value="close">Close</option>
                </select>
            </div>
        </div>

        </div>
<div class="form-group">
            <button type="submit" class="btn btn-primary btn-block">
                Submit Payment
            </button>
        </div>
    </div>
</form>

<#include "footer.ftl">