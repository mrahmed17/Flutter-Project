import 'dart:convert';
import 'package:hr_and_pms/features/bonus/model/Bonus.dart';
import 'package:http/http.dart' as http;

class BonusService {
  static const String baseUrl = 'http://localhost:8080/api/bonuses'; // Replace with your backend API URL

  // Method to create a new bonus
  Future<Bonus> createBonus(Bonus bonus) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(bonus.toJson()),
      );

      if (response.statusCode == 200) {
        return Bonus.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create bonus');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Method to update an existing bonus
  Future<Bonus> updateBonus(int id, Bonus updatedBonus) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedBonus.toJson()),
      );

      if (response.statusCode == 200) {
        return Bonus.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update bonus');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Method to get the total bonus for a user
  Future<double> getTotalBonusForUser(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/total/$userId'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body).toDouble();
      } else {
        throw Exception('Failed to load total bonus');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Method to get the latest bonus for a specific user
  Future<Bonus> getLatestBonusForUser(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/latest/$userId'),
      );

      if (response.statusCode == 200) {
        return Bonus.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load latest bonus');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Method to get bonuses between a date range
  Future<List<Bonus>> getBonusesBetweenDates(DateTime startDate, DateTime endDate) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/between?startDate=${startDate.toIso8601String()}&endDate=${endDate.toIso8601String()}'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Bonus.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load bonuses between dates');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Method to calculate leave bonus deduction (bonus deduction for unpaid leave days)
  Future<double> calculateLeaveBonusDeduction(int leaveDays) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/leave/$leaveDays'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body).toDouble();
      } else {
        throw Exception('Failed to calculate leave bonus deduction');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
