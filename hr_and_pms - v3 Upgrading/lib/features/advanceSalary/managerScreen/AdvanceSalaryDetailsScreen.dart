// import 'package:flutter/material.dart';
// import 'package:hr_and_pms/features/advanceSalary/model/AdvanceSalary.dart';
// import 'package:hr_and_pms/features/advanceSalary/service/AdvanceSalaryService.dart';
//
// class AdvanceSalaryDetailsScreen extends StatefulWidget {
//   const AdvanceSalaryDetailsScreen({Key? key}) : super(key: key);
//
//   @override
//   _AdvanceSalaryDetailsScreenState createState() => _AdvanceSalaryDetailsScreenState();
// }
//
// class _AdvanceSalaryDetailsScreenState extends State<AdvanceSalaryDetailsScreen> {
//   late AdvanceSalary application;
//   bool isLoading = true;
//   final AdvanceSalaryService _advanceSalaryService = AdvanceSalaryService();  // Instance of the service
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final  applicationId = ModalRoute.of(context)!.settings.arguments as int;
//     _fetchApplicationDetails(applicationId);
//   }
//
//   Future<void> _fetchApplicationDetails(int applicationId) async {
//     try {
//       application = await _advanceSalaryService.getAdvanceSalaryById(applicationId);
//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to fetch application details: $e')),
//       );
//     }
//   }
//
//   // Function to approve the application
//   Future<void> _approveApplication() async {
//     try {
//       await _advanceSalaryService.updateAdvanceSalary(application.id, 'APPROVED');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Application approved')),
//       );
//       Navigator.pop(context); // Navigate back after approval
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to approve application: $e')),
//       );
//     }
//   }
//
//   // Function to reject the application
//   Future<void> _rejectApplication() async {
//     try {
//       await _advanceSalaryService.updateAdvanceSalary(application.id, 'REJECTED');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Application rejected')),
//       );
//       Navigator.pop(context);  // Navigate back after rejection
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to reject application: $e')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Advance Salary Details'),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Employee: ${application.user.name}', style: Theme.of(context).textTheme.titleLarge),
//             const SizedBox(height: 8),
//             Text('Amount: \$${application.advanceAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
//             const SizedBox(height: 8),
//             Text('Reason: ${application.reason}', style: TextStyle(fontSize: 16)),
//             const SizedBox(height: 8),
//             Text('Date: ${application.advanceDate.toLocal()}', style: TextStyle(fontSize: 16)),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ElevatedButton(
//                   onPressed: _approveApplication,
//                   child: const Text('Approve'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green, // Updated to 'backgroundColor'
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: _rejectApplication,
//                   child: const Text('Reject'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red, // Updated to 'backgroundColor'
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
