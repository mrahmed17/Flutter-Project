// import 'package:flutter/material.dart';
// import 'package:hr_and_pms/features/advanceSalary/model/AdvanceSalary.dart';
// import 'package:hr_and_pms/features/advanceSalary/service/AdvanceSalaryService.dart';
// import 'package:hr_and_pms/features/leave/model/RequestStatus.dart';
// import 'package:intl/intl.dart';
//
// class AdvanceSalaryStatusScreen extends StatefulWidget {
//   final int userId; // User ID to filter applications
//
//   const AdvanceSalaryStatusScreen({Key? key, required this.userId}) : super(key: key);
//
//   @override
//   State<AdvanceSalaryStatusScreen> createState() => _AdvanceSalaryStatusScreenState();
// }
//
// class _AdvanceSalaryStatusScreenState extends State<AdvanceSalaryStatusScreen> {
//   late Future<List<AdvanceSalary>> _advanceSalaryList;
//   RequestStatus _selectedStatus = RequestStatus.pending; // Default status is "Pending"
//
//   @override
//   void initState() {
//     super.initState();
//     _advanceSalaryList = _fetchAdvanceSalaries();
//   }
//
//   Future<List<AdvanceSalary>> _fetchAdvanceSalaries() async {
//     return await AdvanceSalaryService().getAdvanceSalariesByStatus(
//       widget.userId,
//       _selectedStatus,
//     );
//   }
//
//   // Method to handle status change (filtering)
//   void _onStatusChanged(RequestStatus status) {
//     setState(() {
//       _selectedStatus = status;
//       _advanceSalaryList = _fetchAdvanceSalaries(); // Refresh the list based on selected status
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Advance Salary Status'),
//         backgroundColor: Colors.teal,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Dropdown to select status
//             DropdownButton<RequestStatus>(
//               value: _selectedStatus,
//               onChanged: (RequestStatus? newStatus) {
//                 if (newStatus != null) {
//                   _onStatusChanged(newStatus);
//                 }
//               },
//               items: RequestStatus.values.map((RequestStatus status) {
//                 return DropdownMenuItem<RequestStatus>(
//                   value: status,
//                   child: Text(status.toShortString()),
//                 );
//               }).toList(),
//             ),
//             const SizedBox(height: 16),
//
//             // FutureBuilder to fetch and display the list of applications based on status
//             Expanded(
//               child: FutureBuilder<List<AdvanceSalary>>(
//                 future: _advanceSalaryList,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return const Center(child: Text('No applications found.'));
//                   } else {
//                     final applications = snapshot.data!;
//                     return ListView.builder(
//                       itemCount: applications.length,
//                       itemBuilder: (context, index) {
//                         final application = applications[index];
//                         return Card(
//                           margin: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: ListTile(
//                             title: Text('Amount: ${application.advanceAmount}'),
//                             subtitle: Text(
//                                 'Status: ${application.status.toShortString()}\nDate: ${DateFormat.yMMMd().format(application.advanceDate)}'),
//                             trailing: Icon(
//                               application.status == RequestStatus.pending
//                                   ? Icons.pending
//                                   : application.status == RequestStatus.approved
//                                   ? Icons.check_circle
//                                   : Icons.cancel,
//                               color: application.status == RequestStatus.pending
//                                   ? Colors.orange
//                                   : application.status == RequestStatus.approved
//                                   ? Colors.green
//                                   : Colors.red,
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
