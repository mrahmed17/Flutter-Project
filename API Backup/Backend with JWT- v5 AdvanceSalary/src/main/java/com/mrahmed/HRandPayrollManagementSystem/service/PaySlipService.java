package com.mrahmed.HRandPayrollManagementSystem.service;

import com.mrahmed.HRandPayrollManagementSystem.entity.PaySlip;
import com.mrahmed.HRandPayrollManagementSystem.entity.User;
import com.mrahmed.HRandPayrollManagementSystem.entity.Salary;
import com.mrahmed.HRandPayrollManagementSystem.repository.PaySlipRepository;
import com.mrahmed.HRandPayrollManagementSystem.repository.UserRepository;
import com.mrahmed.HRandPayrollManagementSystem.repository.SalaryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class PaySlipService {

    @Autowired
    private PaySlipRepository paySlipRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private SalaryRepository salaryRepository;

    // Create PaySlip
    public PaySlip createPaySlip(Long employeeId, Long managerId, Long salaryId, double totalAmount, String paymentMethod) {
        User paidBy = userRepository.findById(managerId).orElseThrow(() -> new RuntimeException("Manager not found"));
        User receivedBy = userRepository.findById(employeeId).orElseThrow(() -> new RuntimeException("Employee not found"));
        Salary salary = salaryRepository.findById(salaryId).orElseThrow(() -> new RuntimeException("Salary not found"));

        PaySlip paySlip = new PaySlip();
        paySlip.setTotalAmount(totalAmount);
        paySlip.setBillingDate(LocalDateTime.now());  // Set the billing date to the current date
        paySlip.setPaymentMethod(paymentMethod);
        paySlip.setStatus("PAID");  // Set initial status as "PAID"
        paySlip.setPaidBy(paidBy);
        paySlip.setReceivedBy(receivedBy);
        paySlip.setSalary(salary);

        return paySlipRepository.save(paySlip);  // Save the pay slip to the database
    }

    // Get Payslips by Employee ID
    public List<PaySlip> getPayslipsByEmployee(Long employeeId) {
        return paySlipRepository.findByReceivedById(employeeId);
    }

    // Get Payslips by Manager ID
    public List<PaySlip> getPayslipsByManager(Long managerId) {
        return paySlipRepository.findByPaidById(managerId);
    }

    // Get Payslips by Status
    public List<PaySlip> getPayslipsByStatus(String status) {
        return paySlipRepository.findByStatus(status);
    }

    // Get Payslips by Billing Date Range
    public List<PaySlip> findByBillingDateBetween(LocalDateTime startDate, LocalDateTime endDate) {
        return paySlipRepository.findByBillingDateBetween(startDate, endDate);
    }

    // Get Payslip by Salary ID
    public PaySlip getPayslipBySalaryId(Long salaryId) {
        return paySlipRepository.findBySalaryId(salaryId).orElseThrow(() -> new RuntimeException("Payslip not found"));
    }

    // Get Payslips by Payment Method (e.g., Cash, Bank)
    public List<PaySlip> getPayslipsByPaymentMethod(String paymentMethod) {
        return paySlipRepository.findByPaymentMethod(paymentMethod);
    }

    // findByReceivedByIdAndStatus
    public List<PaySlip> getPayslipsByEmployeeAndStatus(Long employeeId, String status) {
        return paySlipRepository.findByReceivedByIdAndStatus(employeeId, status);
    }


    // Count Payslips by Status
    public Long countPayslipsByStatus(String status) {
        return paySlipRepository.countByStatus(status);
    }
}
