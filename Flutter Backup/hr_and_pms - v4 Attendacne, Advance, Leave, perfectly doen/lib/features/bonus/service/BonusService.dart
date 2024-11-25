import 'dart:convert';
import 'package:hr_and_pms/features/bonus/model/Bonus.dart';
import 'package:http/http.dart'
    as http; // Make sure to define the User model in Flutter
import 'package:intl/intl.dart';

class BonusService {
  static const String baseUrl =
      'http://localhost:8080/api/bonuses'; // Replace with your backend API URL

  // Method to create a bonus
  Future<Bonus?> createBonus(Bonus bonus) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(bonus.toJson()),
      );

      if (response.statusCode == 200) {
        return Bonus.fromJson(json.decode(response.body));
      } else {
        // Handle error here
        return null;
      }
    } catch (e) {
      print("Error creating bonus: $e");
      return null;
    }
  }

  // Method to update an existing bonus
  Future<Bonus?> updateBonus(int id, Bonus bonus) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(bonus.toJson()),
      );

      if (response.statusCode == 200) {
        return Bonus.fromJson(json.decode(response.body));
      } else {
        // Handle error here
        return null;
      }
    } catch (e) {
      print("Error updating bonus: $e");
      return null;
    }
  }

  // Method to delete a bonus
  Future<bool> deleteBonus(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/delete/$id'));

      return response.statusCode == 200;
    } catch (e) {
      print("Error deleting bonus: $e");
      return false;
    }
  }

  // Method to get a bonus by ID
  Future<Bonus?> getBonusById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/find/$id'));

      if (response.statusCode == 200) {
        return Bonus.fromJson(json.decode(response.body));
      } else {
        // Handle error here
        return null;
      }
    } catch (e) {
      print("Error fetching bonus by ID: $e");
      return null;
    }
  }

  // Method to get bonuses for a specific user
  Future<List<Bonus>> getBonusesByUser(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/$userId'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((bonusJson) => Bonus.fromJson(bonusJson)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching bonuses for user: $e");
      return [];
    }
  }

  // Method to get the total bonus for a user
  Future<double> getTotalBonusForUser(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/total/user/$userId'));

      if (response.statusCode == 200) {
        return double.parse(response.body);
      } else {
        return 0.0;
      }
    } catch (e) {
      print("Error fetching total bonus for user: $e");
      return 0.0;
    }
  }

  // Method to get bonuses between two dates
  Future<List<Bonus>> getBonusesBetweenDates(
      DateTime startDate, DateTime endDate) async {
    try {
      final String startDateStr =
          DateFormat('yyyy-MM-ddTHH:mm:ss').format(startDate);
      final String endDateStr =
          DateFormat('yyyy-MM-ddTHH:mm:ss').format(endDate);

      final response = await http.get(
        Uri.parse(
            '$baseUrl/between?startDate=$startDateStr&endDate=$endDateStr'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((bonusJson) => Bonus.fromJson(bonusJson)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching bonuses between dates: $e");
      return [];
    }
  }

  // Method to get the total bonus for a specific month and year
  Future<double> getTotalBonusForMonth(int month, int year) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/monthly/$month/$year'),
      );

      if (response.statusCode == 200) {
        return double.parse(response.body);
      } else {
        return 0.0;
      }
    } catch (e) {
      print("Error fetching total bonus for month: $e");
      return 0.0;
    }
  }

  // Method to count bonuses for a user in a specific year
  Future<int> countBonusesForUserInYear(int userId, int year) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/count/user/$userId/year/$year'),
      );

      if (response.statusCode == 200) {
        return int.parse(response.body);
      } else {
        return 0;
      }
    } catch (e) {
      print("Error counting bonuses for user in year: $e");
      return 0;
    }
  }
}
