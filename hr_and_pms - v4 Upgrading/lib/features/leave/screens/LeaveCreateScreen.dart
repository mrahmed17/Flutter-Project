import 'package:flutter/material.dart';
import 'package:hr_and_pms/administration/service/AuthService.dart';
import 'package:hr_and_pms/features/leave/model/Leave.dart';
import 'package:hr_and_pms/features/leave/model/LeaveType.dart';
import 'package:hr_and_pms/features/leave/model/RequestStatus.dart';
import 'package:hr_and_pms/features/leave/service/LeaveService.dart';

class LeaveCreateScreen extends StatefulWidget {
  @override
  _LeaveCreateScreenState createState() => _LeaveCreateScreenState();
}

class _LeaveCreateScreenState extends State<LeaveCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _startDate;
  DateTime? _endDate;
  String? _reason;
  LeaveType? _leaveType;

  final LeaveService _leaveService = LeaveService();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveLeaveRequest() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // Ensure start and end dates are valid
      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select both start and end dates')),
        );
        return;
      }

      if (_startDate!.isAfter(_endDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Start date cannot be after end date')),
        );
        return;
      }

      // Create the leave model
      final user = await AuthService().getUser();
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to fetch user details')),
        );
        return;
      }

      Leave leave = Leave(
        startDate: _startDate,
        endDate: _endDate,
        reason: _reason,
        leaveType: _leaveType,
        requestStatus: RequestStatus.PENDING, // Default to pending
        user: user,
        requestDate: DateTime.now(),
      );

      try {
        // Call the leave service to save the leave
        await _leaveService.applyLeave(leave, user.id!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Leave request submitted successfully')),
        );

        // Navigate back after successful submission
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit leave request: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request Leave')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Reason'),
                onSaved: (value) => _reason = value,
                validator: (value) =>
                value?.isEmpty ?? true ? 'Please enter a reason' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Start Date'),
                subtitle: Text(
                  _startDate != null
                      ? _startDate!.toLocal().toString().split(' ')[0]
                      : 'Select Start Date',
                ),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _startDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      _startDate = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('End Date'),
                subtitle: Text(
                  _endDate != null
                      ? _endDate!.toLocal().toString().split(' ')[0]
                      : 'Select End Date',
                ),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _endDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      _endDate = picked;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<LeaveType>(
                value: _leaveType,
                onChanged: (LeaveType? newValue) {
                  setState(() {
                    _leaveType = newValue;
                  });
                },
                items: LeaveType.values.map<DropdownMenuItem<LeaveType>>(
                        (LeaveType value) {
                      return DropdownMenuItem<LeaveType>(
                        value: value,
                        child: Text(value.toShortString()),
                      );
                    }).toList(),
                decoration: const InputDecoration(labelText: 'Leave Type'),
                validator: (value) =>
                value == null ? 'Please select a leave type' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveLeaveRequest,
                child: const Text('Submit Leave Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
