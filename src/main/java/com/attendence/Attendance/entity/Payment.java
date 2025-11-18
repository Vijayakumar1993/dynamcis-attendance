package com.attendence.Attendance.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

import java.time.LocalDate;

@Entity
public class Payment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long paymentId;
    private Long customerId;
    private LocalDate paymentDate;
    private Long tenure;
    private String paymentMethod;
    private String remarks;
    private Long amount;
    private Long balance;
    private String status;

    public Payment(){}
    public Payment(Long paymentId, Long customerId, LocalDate paymentDate, Long tenure, String paymentMethod, String remarks, Long amount, Long balance) {
        this.paymentId = paymentId;
        this.customerId = customerId;
        this.paymentDate = paymentDate;
        this.tenure = tenure;
        this.paymentMethod = paymentMethod;
        this.remarks = remarks;
        this.amount = amount;
        this.balance = balance;
    }

    public Long getPaymentId() {
        return paymentId;
    }

    public void setPaymentId(Long paymentId) {
        this.paymentId = paymentId;
    }

    public Long getCustomerId() {
        return customerId;
    }

    public void setCustomerId(Long customerId) {
        this.customerId = customerId;
    }

    public LocalDate getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(LocalDate paymentDate) {
        this.paymentDate = paymentDate;
    }

    public Long getTenure() {
        return tenure;
    }

    public void setTenure(Long tenure) {
        this.tenure = tenure;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public Long getAmount() {
        return amount;
    }

    public void setAmount(Long amount) {
        this.amount = amount;
    }

    public Long getBalance() {
        return balance;
    }

    public void setBalance(Long balance) {
        this.balance = balance;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Payment{" +
                "paymentId=" + paymentId +
                ", customerId=" + customerId +
                ", paymentDate=" + paymentDate +
                ", tenure=" + tenure +
                ", paymentMethod='" + paymentMethod + '\'' +
                ", remarks='" + remarks + '\'' +
                ", amount=" + amount +
                ", balance=" + balance +
                '}';
    }
}
