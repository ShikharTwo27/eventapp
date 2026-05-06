import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:connectivity_plus/connectivity_plus.dart';

import 'offline_service.dart';

class ApiService {

  static const String baseUrl =
      "http://localhost:5000/api/incidents";



  // CHECK INTERNET
  static Future<bool>
  hasInternet() async {

    final connectivityResult =
    await Connectivity()
        .checkConnectivity();

    return connectivityResult
    != ConnectivityResult.none;
  }



  // GET INCIDENTS
  static Future<List<dynamic>>
  getIncidents() async {

    final response =
    await http.get(
      Uri.parse(baseUrl),
    );

    if (response.statusCode == 200) {

      return jsonDecode(
          response.body);

    } else {

      throw Exception(
          "Failed to load incidents");
    }
  }



  // CREATE INCIDENT
  static Future<String>
  createIncident({

    required String title,
    required String description,
    required String category,
    required String priority,
    required String location,

  }) async {

    bool online =
    await hasInternet();



    // OFFLINE SAVE
    if (!online) {

      await OfflineService
          .saveOfflineIncident({

        "title": title,
        "description":
        description,
        "category": category,
        "priority": priority,
        "location": location,
      });

      return "Saved Offline";
    }



    // ONLINE SAVE
    final response =
    await http.post(

      Uri.parse(
          "$baseUrl/create"),

      headers: {

        "Content-Type":
        "application/json"
      },

      body: jsonEncode({

        "title": title,
        "description":
        description,
        "category": category,
        "priority": priority,
        "location": location,
      }),
    );

    if (response.statusCode == 201) {

      return "Saved Online";

    } else {

      throw Exception(
          "Failed to create incident");
    }
  }



  // UPDATE STATUS
  static Future<void>
  updateIncidentStatus({

    required String id,
    required String status,

  }) async {

    final response =
    await http.put(

      Uri.parse(
          "$baseUrl/update-status/$id"),

      headers: {

        "Content-Type":
        "application/json"
      },

      body: jsonEncode({

        "status": status
      }),
    );

    if (response.statusCode != 200) {

      throw Exception(
          "Failed to update status");
    }
  }



  // DELETE INCIDENT
  static Future<void>
  deleteIncident(String id) async {

    final response =
    await http.delete(

      Uri.parse(
          "$baseUrl/delete/$id"),
    );

    if (response.statusCode != 200) {

      throw Exception(
          "Failed to delete incident");
    }
  }



  // DASHBOARD COUNTS
  static Future<Map<String, int>>
  getDashboardCounts() async {

    final incidents =
    await getIncidents();

    int total =
    incidents.length;

    int resolved = incidents
        .where((incident) =>
    incident["status"] ==
        "Resolved")
        .length;

    int active = incidents
        .where((incident) =>
    incident["status"] !=
        "Resolved")
        .length;

    int critical = incidents
        .where((incident) =>
    incident["priority"] ==
        "Critical")
        .length;

    return {

      "total": total,
      "active": active,
      "resolved": resolved,
      "critical": critical,
    };
  }
}