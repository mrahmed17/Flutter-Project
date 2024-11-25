//package com.mrahmed.HRandPayrollManagementSystem.restcontroller;
//
//import com.mrahmed.HRandPayrollManagementSystem.entity.PaySlip;
//import com.mrahmed.HRandPayrollManagementSystem.service.PaySlipService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.*;
//
//import java.time.LocalDateTime;
//import java.util.List;
//
//@RestController
//@RequestMapping("/api/payslips")
//@CrossOrigin("*")
//public class PaySlipController {
//
//    @Autowired
//    private PaySlipService paySlipService;
//
//    // Create PaySlip
//    @PostMapping("/create")
//    public ResponseEntity<PaySlip> createPaySlip(
//            @RequestParam Long employeeId,
//            @RequestParam Long managerId,
//            @RequestParam Long salaryId,
//            @RequestParam double totalAmount,
//            @RequestParam String paymentMethod) {
//        PaySlip paySlip = paySlipService.createPaySlip(employeeId, managerId, salaryId, totalAmount, paymentMethod);
//        return ResponseEntity.ok(paySlip);
//    }
//
//    @GetMapping("/{employeeId}")
//    public ResponseEntity<List<PaySlip>> getPayslipsByEmployee(@PathVariable Long employeeId) {
//        List<PaySlip> payslips = paySlipService.getPayslipsByEmployee(employeeId);
//        return ResponseEntity.ok(payslips);
//    }
//
//    @GetMapping("/manager/{managerId}")
//    public ResponseEntity<List<PaySlip>> getPayslipsByManager(@PathVariable Long managerId) {
//        List<PaySlip> payslips = paySlipService.getPayslipsByManager(managerId);
//        return ResponseEntity.ok(payslips);
//    }
//
//    @GetMapping("/status/{status}")
//    public ResponseEntity<List<PaySlip>> getPayslipsByStatus(@PathVariable String status) {
//        List<PaySlip> payslips = paySlipService.getPayslipsByStatus(status);
//        return ResponseEntity.ok(payslips);
//    }
//
//    // Get Payslips by Employee ID and Status
//    @GetMapping("/{employeeId}/status/{status}")
//    public ResponseEntity<List<PaySlip>> getPayslipsByEmployeeAndStatus(
//            @PathVariable Long employeeId,
//            @PathVariable String status) {
//        List<PaySlip> payslips = paySlipService.getPayslipsByEmployeeAndStatus(employeeId, status);
//        return ResponseEntity.ok(payslips);
//    }
//
//    // Get Payslips by Billing Date Range
//    @GetMapping("/date-range")
//    public ResponseEntity<List<PaySlip>> getPayslipsByDateRange(
//            @RequestParam LocalDateTime startDate,
//            @RequestParam LocalDateTime endDate) {
//        List<PaySlip> payslips = paySlipService.findByBillingDateBetween(startDate, endDate);
//        return ResponseEntity.ok(payslips);
//    }
//
//    // Get Payslip by Salary ID
//    @GetMapping("/salary/{salaryId}")
//    public ResponseEntity<PaySlip> getPayslipBySalaryId(@PathVariable Long salaryId) {
//        PaySlip paySlip = paySlipService.getPayslipBySalaryId(salaryId);
//        return ResponseEntity.ok(paySlip);
//    }
//
//    // Get Payslips by Payment Method (e.g., Cash, Bank)
//    @GetMapping("/payment-method/{paymentMethod}")
//    public ResponseEntity<List<PaySlip>> getPayslipsByPaymentMethod(@PathVariable String paymentMethod) {
//        List<PaySlip> payslips = paySlipService.getPayslipsByPaymentMethod(paymentMethod);
//        return ResponseEntity.ok(payslips);
//    }
//
//    // Count Payslips by Status
//    @GetMapping("/count/status/{status}")
//    public ResponseEntity<Long> countPayslipsByStatus(@PathVariable String status) {
//        Long count = paySlipService.countPayslipsByStatus(status);
//        return ResponseEntity.ok(count);
//    }
//}
