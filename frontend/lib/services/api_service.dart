import 'dart:convert';

import 'package:http/http.dart'
as http;

import 'offline_service.dart';

class ApiService {

  static const String baseUrl =
      "http://127.0.0.1:5000/api/incidents";



  // CREATE INCIDENT
  static Future<bool>
  createIncident({

    required String title,

    required String description,

    required String category,

    required String priority,

    required String location,

  }) async {

    try {

      final response =
      await http.post(

        Uri.parse(
            "$baseUrl/create"),

        headers: {

          "Content-Type":
          "application/json",
        },

        body: jsonEncode({

          "title": title,

          "description":
          description,

          "category":
          category,

          "priority":
          priority,

          "location":
          location,
        }),
      );

      print(response.statusCode);

      print(response.body);

      if (response.statusCode
      == 201) {

        return true;
      }

      return false;

    } catch (e) {

      print(e);

      await OfflineService
          .saveOfflineIncident({

        "title": title,

        "description":
        description,

        "category":
        category,

        "priority":
        priority,

        "location":
        location,
      });

      return true;
    }
  }



  // GET INCIDENTS
  static Future<List>
  getIncidents() async {

    final response =
    await http.get(
      Uri.parse(baseUrl),
    );

    return jsonDecode(
        response.body);
  }



  // UPDATE STATUS
  static Future<void>
  updateIncidentStatus({

    required String id,

    required String status,

  }) async {

    await http.put(

      Uri.parse(
          "$baseUrl/update-status/$id"),

      headers: {

        "Content-Type":
        "application/json",
      },

      body: jsonEncode({

        "status": status,
      }),
    );
  }



  // DELETE INCIDENT
  static Future<void>
  deleteIncident(
      String id) async {

    await http.delete(

      Uri.parse(
          "$baseUrl/delete/$id"),
    );
  }



  // DASHBOARD COUNTS
  static Future<Map<String, int>>
  getDashboardCounts() async {

    final incidents =
    await getIncidents();

    int total =
    incidents.length;

    int active =
    incidents.where((i) {

      return i["status"]
      != "Resolved";

    }).length;

    int resolved =
    incidents.where((i) {

      return i["status"]
      == "Resolved";

    }).length;

    int critical =
    incidents.where((i) {

      return i["priority"]
      == "Critical";

    }).length;

    return {

      "total": total,

      "active": active,

      "resolved": resolved,

      "critical": critical,
    };
  }
}