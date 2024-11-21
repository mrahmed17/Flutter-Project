import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hr_and_pms/features/department/model/Department.dart';
import 'package:http/http.dart' as http;

class DepartmentService {
  static const String baseUrl = 'http://localhost:8080/api/departments';

  Future<http.StreamedResponse> sendMultipartRequest(
      String method, String url, Map<String, String> fields, {String? filePath, String fileFieldName = 'photo'}) async {
    var uri = Uri.parse(url);
    var request = http.MultipartRequest(method, uri);
    request.fields.addAll(fields);

    if (filePath != null) {
      var file = await http.MultipartFile.fromPath(fileFieldName, filePath);
      request.files.add(file);
    }
    return request.send();
  }

  // Create a department
  Future<Department?> createDepartment(Department department, {String? photoPath}) async {
    try {
      var response = await sendMultipartRequest(
        'POST',
        '$baseUrl/create',
        {
          'id': department.id.toString(),
          'name': department.name,
          'email': department.email,
          'cell': department.cell,
          'employeeNum': department.employeeNum.toString(),
        },
        filePath: photoPath,
        fileFieldName: 'departmentPhoto',
      );

      if (response.statusCode == 201) {
        var responseData = await response.stream.bytesToString();
        return Department.fromJson(jsonDecode(responseData));
      } else {
        throw Exception('Failed to create department');
      }
    } catch (e) {
      print('Error in createDepartment: $e');
      return null;
    }
  }


  // Future<Department?> createDepartment(Department department, {String? photoPath}) async {
  //   try {
  //     var uri = Uri.parse('$baseUrl/create');
  //     var request = http.MultipartRequest('POST', uri);
  //
  //     request.fields['id'] = department.id.toString();
  //     request.fields['name'] = department.name;
  //     request.fields['email'] = department.email;
  //     request.fields['cell'] = department.cell;
  //     request.fields['employeeNum'] = department.employeeNum.toString();
  //
  //     if (photoPath != null) {
  //       var departmentImage = await http.MultipartFile.fromPath('departmentPhoto', photoPath);
  //       request.files.add(departmentImage);
  //     }
  //
  //     var response = await request.send();
  //
  //     if (response.statusCode == 201) {
  //       var responseData = await response.stream.bytesToString();
  //       return Department.fromJson(jsonDecode(responseData));
  //     } else {
  //       throw Exception('Failed to create department');
  //     }
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }


  // Update department by ID
  Future<Department?> updateDepartment(int id, Department updatedDepartment, {String? photoPath}) async {
    try {
      var uri = Uri.parse('$baseUrl/update/$id');
      var request = http.MultipartRequest('PUT', uri);

      request.fields['id'] = updatedDepartment.id.toString();
      request.fields['name'] = updatedDepartment.name;
      request.fields['email'] = updatedDepartment.email;
      request.fields['cell'] = updatedDepartment.cell;
      request.fields['employeeNum'] = updatedDepartment.employeeNum.toString();

      if (photoPath != null) {
        var departmentImage = await http.MultipartFile.fromPath('departmentPhotos', photoPath);
        request.files.add(departmentImage);
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        return Department.fromJson(jsonDecode(responseData));
      } else {
        throw Exception('Failed to update department');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Delete a department by ID
  Future<bool> deleteDepartmentById(int id) async {
    try {
      var response = await http.delete(Uri.parse('$baseUrl/delete/$id'));

      if (response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Failed to delete department');
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Find departments by name
  Future<List<Department>?> getDepartmentsByName(String name) async {
    try {
      var response = await http.get(Uri.parse('$baseUrl/findByName/$name'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Department.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load departments');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Find departments by branch ID
  Future<List<Department>?> getDepartmentsByBranchId(int branchId) async {
    try {
      var response = await http.get(Uri.parse('$baseUrl/findByBranch/$branchId'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Department.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load departments');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Get all departments
  Future<List<Department>?> getAllDepartments() async {
    try {
      var response = await http.get(Uri.parse('$baseUrl/all'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Department.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load departments');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Get department by ID
  Future<Department?> getDepartmentById(int id) async {
    try {
      var response = await http.get(Uri.parse('$baseUrl/find/$id'));

      if (response.statusCode == 200) {
        return Department.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Department not found');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }


  // Find departments by minimum employee count
  Future<List<Department>?> getDepartmentsByMinEmployeeCount(int minEmployeeCount) async {
    try {
      var response = await http.get(Uri.parse('$baseUrl/findByMinEmployeeCount/$minEmployeeCount'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Department.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load departments');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Find departments by maximum employee count
  Future<List<Department>?> getDepartmentsByMaxEmployeeCount(int maxEmployeeCount) async {
    try {
      var response = await http.get(Uri.parse('$baseUrl/findByMaxEmployeeCount/$maxEmployeeCount'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Department.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load departments');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Find department by email
  Future<Department?> getDepartmentByEmail(String email) async {
    try {
      var response = await http.get(Uri.parse('$baseUrl/findByEmail/$email'));

      if (response.statusCode == 200) {
        return Department.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Department not found');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Find departments created within a specific date range
  Future<List<Department>?> getDepartmentsByCreatedAtRange(DateTime startDate, DateTime endDate) async {
    try {
      var response = await http.get(Uri.parse('$baseUrl/findByCreatedAtRange?startDate=$startDate&endDate=$endDate'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Department.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load departments');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Count departments by branch ID
  Future<int> countDepartmentsByBranchId(int branchId) async {
    try {
      var response = await http.get(Uri.parse('$baseUrl/countByBranch/$branchId'));

      if (response.statusCode == 200) {
        return int.parse(response.body);
      } else {
        throw Exception('Failed to count departments');
      }
    } catch (e) {
      print(e);
      return 0;
    }
  }

  // Find departments with no employees
  Future<List<Department>?> getDepartmentsWithNoEmployees() async {
    try {
      var response = await http.get(Uri.parse('$baseUrl/findWithNoEmployees'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Department.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load departments');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Find departments updated after a specific date
  Future<List<Department>?> getDepartmentsUpdatedAfter(DateTime updateDate) async {
    try {
      var response = await http.get(Uri.parse('$baseUrl/findUpdatedAfter?updateDate=$updateDate'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Department.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load departments');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
