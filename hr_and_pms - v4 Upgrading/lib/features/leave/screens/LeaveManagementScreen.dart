import 'package:flutter/material.dart';
import 'package:hr_and_pms/administration/model/User.dart';
import 'package:hr_and_pms/features/leave/model/Leave.dart';
import 'package:hr_and_pms/features/leave/service/LeaveService.dart';
import 'package:intl/intl.dart';

class LeaveManagementScreen extends StatefulWidget {
  const LeaveManagementScreen({Key? key}) : super(key: key);

  @override
  _LeaveManagementScreenState createState() => _LeaveManagementScreenState();
}

class _LeaveManagementScreenState extends State<LeaveManagementScreen> {
  final LeaveService _leaveService = LeaveService();
  List<Leave> _pendingLeaves = [];
  List<Leave> _filteredLeaves = [];
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPendingLeaves();
  }

  /// Fetch pending leave requests
  Future<void> _fetchPendingLeaves() async {
    setState(() => _isLoading = true);
    try {
      final pendingLeaves = await _leaveService.getAllPendingLeaves();
      setState(() {
        _pendingLeaves = pendingLeaves;
        _filteredLeaves = pendingLeaves; // Default to show all pending leaves
      });
    } catch (e) {
      _showSnackBar('Failed to load pending leaves: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Approve a leave request
  Future<void> _approveLeave(int leaveId) async {
    try {
      await _leaveService.approveLeave(leaveId);
      _showSnackBar('Leave approved successfully');
      _fetchPendingLeaves(); // Refresh the list
    } catch (e) {
      _showSnackBar('Failed to approve leave: $e');
    }
  }

  /// Reject a leave request
  Future<void> _rejectLeave(int leaveId) async {
    try {
      await _leaveService.rejectLeave(leaveId);
      _showSnackBar('Leave rejected successfully');
      _fetchPendingLeaves(); // Refresh the list
    } catch (e) {
      _showSnackBar('Failed to reject leave: $e');
    }
  }

  /// Filter leaves by date range
  Future<void> _filterLeavesByDateRange() async {
    if (_startDate == null || _endDate == null) {
      _showSnackBar('Please select a valid date range');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final filtered = _pendingLeaves.where((leave) {
        final leaveStart = leave.startDate ?? DateTime.now();
        return leaveStart.isAfter(_startDate!) && leaveStart.isBefore(_endDate!);
      }).toList();
      setState(() {
        _filteredLeaves = filtered;
      });
    } catch (e) {
      _showSnackBar('Failed to filter leaves: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Show snackbar notifications
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Display date range picker
  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: (_startDate != null && _endDate != null)
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : DateTimeRange(start: DateTime.now(), end: DateTime.now().add(const Duration(days: 7))),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _filterLeavesByDateRange();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: _selectDateRange,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: _filteredLeaves.isEmpty
            ? const Center(child: Text('No pending leaves found'))
            : ListView.builder(
          itemCount: _filteredLeaves.length,
          itemBuilder: (context, index) {
            final leave = _filteredLeaves[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(
                  '${leave.user?.name ?? 'Unknown'} - ${leave.leaveType ?? 'Unknown'} Leave',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Start Date: ${DateFormat('yyyy-MM-dd').format(leave.startDate!)}'),
                    Text('End Date: ${DateFormat('yyyy-MM-dd').format(leave.endDate!)}'),
                    Text('Reason: ${leave.reason ?? 'No reason provided'}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.greenAccent),
                      onPressed: () => _approveLeave(leave.id!),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.redAccent),
                      onPressed: () => _rejectLeave(leave.id!),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
