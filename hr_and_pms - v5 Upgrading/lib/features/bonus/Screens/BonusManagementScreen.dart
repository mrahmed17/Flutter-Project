import 'package:flutter/material.dart';
import 'package:hr_and_pms/features/bonus/model/Bonus.dart';
import 'package:hr_and_pms/features/bonus/service/BonusService.dart'; // Ensure BonusService is available

class BonusManagementScreen extends StatefulWidget {
  @override
  _BonusManagementScreenState createState() => _BonusManagementScreenState();
}

class _BonusManagementScreenState extends State<BonusManagementScreen> {
  final BonusService _bonusService = BonusService();
  List<Bonus> _bonuses = [];
  bool _isLoading = false;
  String _statusMessage = '';
  DateTime _startDate = DateTime.now().subtract(Duration(days: 30));
  DateTime _endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadBonuses();
  }

  // Method to fetch bonuses
  Future<void> _loadBonuses() async {
    setState(() {
      _isLoading = true;
      _statusMessage = '';
    });

    try {
      List<Bonus> bonuses = await _bonusService.getBonusesBetweenDates(_startDate, _endDate);
      setState(() {
        _bonuses = bonuses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error loading bonuses.';
        _isLoading = false;
      });
    }
  }

  // Date picker for start date
  Future<void> _selectStartDate() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ) ?? _startDate;

    if (picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
      _loadBonuses();
    }
  }

  // Date picker for end date
  Future<void> _selectEndDate() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now(),
    ) ?? _endDate;

    if (picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
      _loadBonuses();
    }
  }

  // Method to handle bonus deletion
  Future<void> _deleteBonus(int bonusId) async {
    final bool success = await _bonusService.deleteBonus(bonusId);
    if (success) {
      setState(() {
        _bonuses.removeWhere((bonus) => bonus.id == bonusId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bonus deleted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting bonus')),
      );
    }
  }

  // Method to handle bonus update (just a placeholder for actual implementation)
  Future<void> _updateBonus(Bonus bonus) async {
    // You could navigate to a screen where the bonus can be updated
    // Here we are just showing a Snackbar for simplicity
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bonus update functionality is under development')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bonus Management'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Date Filters
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    onPressed: _selectStartDate,
                    child: Text(
                      'Start Date: ${_startDate.toLocal().toString().split(' ')[0]}',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    onPressed: _selectEndDate,
                    child: Text(
                      'End Date: ${_endDate.toLocal().toString().split(' ')[0]}',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Loading and Status Message
            if (_isLoading)
              Center(child: CircularProgressIndicator()),
            if (_statusMessage.isNotEmpty)
              Center(child: Text(_statusMessage, style: TextStyle(color: Colors.red))),

            // Bonus List
            Expanded(
              child: _bonuses.isEmpty
                  ? Center(child: Text('No bonuses found for the selected dates'))
                  : ListView.builder(
                itemCount: _bonuses.length,
                itemBuilder: (context, index) {
                  Bonus bonus = _bonuses[index];
                  return Card(
                    elevation: 4.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      title: Text('Bonus: \$${bonus.bonusAmount?.toStringAsFixed(2)}'),
                      subtitle: Text(
                        'Date: ${bonus.bonusDate?.toLocal().toString().split(' ')[0]} \nType: ${bonus.bonusType}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      trailing: PopupMenuButton<int>(
                        icon: Icon(Icons.more_vert, color: Colors.teal),
                        onSelected: (option) {
                          if (option == 1) {
                            _updateBonus(bonus);
                          } else if (option == 2) {
                            _deleteBonus(bonus.id!);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: Text('Update Bonus'),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: Text('Delete Bonus'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
