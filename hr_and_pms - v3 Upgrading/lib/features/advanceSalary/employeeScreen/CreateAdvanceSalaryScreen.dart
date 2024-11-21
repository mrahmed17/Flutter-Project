// import 'package:flutter/material.dart';
// import 'package:hr_and_pms/features/advanceSalary/model/AdvanceSalary.dart';
// import 'package:hr_and_pms/features/advanceSalary/service/AdvanceSalaryService.dart';
// import 'package:hr_and_pms/features/leave/model/RequestStatus.dart';
// import 'package:intl/intl.dart';
//
// import '../../../administration/model/User.dart';
//
// class CreateAdvanceSalaryScreen extends StatefulWidget {
//   const CreateAdvanceSalaryScreen({Key? key}) : super(key: key);
//
//   @override
//   State<CreateAdvanceSalaryScreen> createState() => _CreateAdvanceSalaryScreenState();
// }
//
// class _CreateAdvanceSalaryScreenState extends State<CreateAdvanceSalaryScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _advanceSalaryController = TextEditingController();
//   final TextEditingController _reasonController = TextEditingController();
//   DateTime _selectedDate = DateTime.now();
//   bool _isSubmitting = false;
//   late Future<List<AdvanceSalary>> _advanceSalaryList;
//
//   @override
//   void initState() {
//     super.initState();
//     _advanceSalaryList = _fetchAdvanceSalaries();
//   }
//
//   Future<List<AdvanceSalary>> _fetchAdvanceSalaries() async {
//     // Replace with actual user ID and service call
//     final userId = 1; // Mock user ID
//     return await AdvanceSalaryService().getAdvanceSalaries(userId);
//   }
//
//   Future<void> _applyForAdvanceSalary() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() {
//       _isSubmitting = true;
//     });
//
//     try {
//       final user = User.empty(); // Replace with the actual logged-in user
//
//       final advanceSalary = AdvanceSalary(
//         id: 0, // ID will be assigned by the backend
//         advanceAmount: double.parse(_advanceSalaryController.text),
//         reason: _reasonController.text,
//         advanceDate: _selectedDate,
//         user: user,
//         status: RequestStatus.pending,
//       );
//
//       // Send the application
//       await AdvanceSalaryService().createAdvanceSalary(advanceSalary);
//
//       _showSnackBar('Advance Salary application submitted successfully!', Colors.green);
//       _clearForm();
//       setState(() {
//         _advanceSalaryList = _fetchAdvanceSalaries(); // Refresh the list
//       });
//     } catch (e) {
//       _showSnackBar('Failed to submit application. Please try again.', Colors.red);
//     } finally {
//       setState(() {
//         _isSubmitting = false;
//       });
//     }
//   }
//
//   void _showSnackBar(String message, Color color) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: color),
//     );
//   }
//
//   void _clearForm() {
//     _advanceSalaryController.clear();
//     _reasonController.clear();
//     setState(() {
//       _selectedDate = DateTime.now();
//     });
//   }
//
//   Future<void> _showOptionsMenu() async {
//     await showMenu<String>(
//       context: context,
//       position: RelativeRect.fromLTRB(300, 100, 0, 0),
//       items: [
//         const PopupMenuItem<String>(
//           value: 'history',
//           child: Text('View History'),
//         ),
//         const PopupMenuItem<String>(
//           value: 'settings',
//           child: Text('Settings'),
//         ),
//       ],
//       initialValue: 'history',
//     ).then((value) {
//       if (value == 'history') {
//         // Navigate to history screen or show a dialog
//       } else if (value == 'settings') {
//         // Show settings dialog or options
//       }
//     });
//   }
//
//   Future<void> _pickDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Advance Salary Application'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.more_vert),
//             onPressed: _showOptionsMenu,
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Apply for Advance Salary',
//                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: _advanceSalaryController,
//                       decoration: const InputDecoration(labelText: 'Amount'),
//                       keyboardType: TextInputType.number,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter the amount';
//                         }
//                         final parsedValue = double.tryParse(value);
//                         if (parsedValue == null || parsedValue <= 0) {
//                           return 'Enter a valid amount';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       controller: _reasonController,
//                       decoration: const InputDecoration(labelText: 'Reason'),
//                       maxLines: 3,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please provide a reason';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             'Advance Date: ${DateFormat.yMMMd().format(_selectedDate)}',
//                             style: const TextStyle(fontSize: 16),
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: () => _pickDate(context),
//                           icon: const Icon(Icons.calendar_today),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 24),
//                     Center(
//                       child: _isSubmitting
//                           ? const CircularProgressIndicator()
//                           : ElevatedButton(
//                         onPressed: _applyForAdvanceSalary,
//                         child: const Text('Submit Application'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),
//               FutureBuilder<List<AdvanceSalary>>(
//                 future: _advanceSalaryList,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return const Center(child: Text('No applications found.'));
//                   } else {
//                     return ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: snapshot.data!.length,
//                       itemBuilder: (context, index) {
//                         final application = snapshot.data![index];
//                         return Card(
//                           margin: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: ListTile(
//                             title: Text('Amount: ${application.advanceAmount}'),
//                             subtitle: Text(
//                                 'Status: ${application.status.toShortString()}'),
//                           ),
//                         );
//                       },
//                     );
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
