import 'package:flutter/material.dart';
import 'package:hr_and_pms/features/advanceSalary/model/AdvanceSalary.dart';
import 'package:hr_and_pms/features/advanceSalary/service/AdvanceSalaryService.dart';
import 'package:hr_and_pms/features/leave/model/RequestStatus.dart';

class AdvanceSalaryManagementScreen extends StatefulWidget {
  const AdvanceSalaryManagementScreen({Key? key}) : super(key: key);

  @override
  State<AdvanceSalaryManagementScreen> createState() =>
      _AdvanceSalaryManagementScreenState();
}

class _AdvanceSalaryManagementScreenState
    extends State<AdvanceSalaryManagementScreen> {
  final AdvanceSalaryService _advanceSalaryService = AdvanceSalaryService();

  late Future<List<AdvanceSalary>> _pendingRequests;

  @override
  void initState() {
    super.initState();
    _fetchPendingRequests();
  }

  void _fetchPendingRequests() {
    setState(() {
      _pendingRequests = _advanceSalaryService.getPendingSalaryRequests();
    });
  }

  Future<void> _approveRequest(int id) async {
    try {
      await _advanceSalaryService.approveAdvanceSalary(id);
      _showSnackBar('Advance salary request approved successfully');
      _fetchPendingRequests();
    } catch (e) {
      _showSnackBar('Failed to approve request: $e');
    }
  }

  Future<void> _rejectRequest(int id) async {
    try {
      await _advanceSalaryService.getRejectedAdvanceSalary(id);
      _showSnackBar('Advance salary request rejected successfully');
      _fetchPendingRequests();
    } catch (e) {
      _showSnackBar('Failed to reject request: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advance Salary Management'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<AdvanceSalary>>(
        future: _pendingRequests,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No pending advance salary requests',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final requests = snapshot.data!;
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(
                    'Employee: ${request.user?.name ?? 'N/A'}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Amount: \$${request.advanceAmount?.toStringAsFixed(2) ?? '0.00'}'),
                      Text('Reason: ${request.reason ?? 'No reason provided'}'),
                      Text('Date: ${request.advanceDate != null ? request.advanceDate!.toLocal().toString().split(' ')[0] : 'N/A'}'),
                      Text('Status: ${request.status?.toShortString() ?? 'PENDING'}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check_circle, color: Colors.green),
                        onPressed: () => _approveRequest(request.id ?? 0),
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () => _rejectRequest(request.id ?? 0),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:hr_and_pms/features/advanceSalary/model/AdvanceSalary.dart';
// import 'package:hr_and_pms/features/advanceSalary/service/AdvanceSalaryService.dart';
//
// class AdvanceSalaryManagementScreen extends StatefulWidget {
//   const AdvanceSalaryManagementScreen({Key? key}) : super(key: key);
//
//   @override
//   _AdvanceSalaryManagementScreenState createState() => _AdvanceSalaryManagementScreenState();
// }
//
// class _AdvanceSalaryManagementScreenState extends State<AdvanceSalaryManagementScreen> {
//   final AdvanceSalaryService _advanceSalaryService = AdvanceSalaryService();
//   List<AdvanceSalary> _pendingRequests = [];
//   List<AdvanceSalary> _filteredRequests = [];
//   DateTime? _startDate;
//   DateTime? _endDate;
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchPendingRequests();
//   }
//
//   /// Fetch pending advance salary requests
//   Future<void> _fetchPendingRequests() async {
//     setState(() => _isLoading = true);
//     try {
//       final pendingRequests = await _advanceSalaryService.getPendingSalaryRequests();
//       setState(() {
//         _pendingRequests = pendingRequests;
//         _filteredRequests = pendingRequests; // Default to show all pending requests
//       });
//     } catch (e) {
//       _showSnackBar('Failed to load advance salary requests: $e');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   Future<void> _approveRequest(int? id) async {
//     if (id == null) {
//       _showSnackBar('Invalid request: ID is null');
//       return;
//     }
//     try {
//       await _advanceSalaryService.approveAdvanceSalary(id);
//       _showSnackBar('Advance salary request approved successfully');
//       _fetchPendingRequests(); // Refresh the list
//     } catch (e) {
//       _showSnackBar('Failed to approve request: $e');
//     }
//   }
//
//   Future<void> _rejectRequest(int? id) async {
//     if (id == null) {
//       _showSnackBar('Invalid request: ID is null');
//       return;
//     }
//     try {
//       await _advanceSalaryService.getRejectedAdvanceSalary(id);
//       _showSnackBar('Advance salary request rejected successfully');
//       _fetchPendingRequests();
//     } catch (e) {
//       _showSnackBar('Failed to reject request: $e');
//     }
//   }
//
//   /// Filter requests by date range
//   Future<void> _filterRequestsByDateRange() async {
//     if (_startDate == null || _endDate == null) {
//       _showSnackBar('Please select a valid date range');
//       return;
//     }
//
//     setState(() => _isLoading = true);
//     try {
//       final filtered = _pendingRequests.where((request) {
//         final requestDate = request.advanceDate ?? DateTime.now();
//         return requestDate.isAfter(_startDate!) && requestDate.isBefore(_endDate!);
//       }).toList();
//       setState(() {
//         _filteredRequests = filtered;
//       });
//     } catch (e) {
//       _showSnackBar('Failed to filter requests: $e');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   }
//
//   Future<void> _selectDateRange() async {
//     final DateTimeRange? picked = await showDateRangePicker(
//       context: context,
//       initialDateRange: (_startDate != null && _endDate != null)
//           ? DateTimeRange(start: _startDate!, end: _endDate!)
//           : DateTimeRange(start: DateTime.now(), end: DateTime.now().add(const Duration(days: 7))),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() {
//         _startDate = picked.start;
//         _endDate = picked.end;
//       });
//       _filterRequestsByDateRange();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Advance Salary Management'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.filter_alt),
//             onPressed: _selectDateRange,
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: _filteredRequests.isEmpty
//             ? const Center(child: Text('No pending advance salary requests found'))
//             : ListView.builder(
//           itemCount: _filteredRequests.length,
//           itemBuilder: (context, index) {
//             final request = _filteredRequests[index];
//             return Card(
//               margin: const EdgeInsets.symmetric(vertical: 8),
//               child: ListTile(
//                 title: Text(
//                   '${request.user?.name ?? 'Unknown User'}',
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Amount: \$${request.advanceAmount?.toStringAsFixed(2)}'),
//                     Text('Request Date: ${DateFormat('yyyy-MM-dd').format(request.advanceDate!)}'),
//                     Text('Status: ${request.status!}'),
//                   ],
//                 ),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.check, color: Colors.green),
//                       onPressed: () => _approveRequest(request.id!),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.close, color: Colors.red),
//                       onPressed: () => _rejectRequest(request.id!),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
