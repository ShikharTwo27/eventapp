import 'package:flutter/material.dart';

import '../services/api_service.dart';

import 'report_incident_screen.dart';
import 'incident_detail_screen.dart';
import 'dashboard_screen.dart';
import 'search_filter_screen.dart';

class IncidentListScreen extends StatefulWidget {

  const IncidentListScreen({super.key});

  @override
  State<IncidentListScreen> createState() =>
      _IncidentListScreenState();
}

class _IncidentListScreenState
    extends State<IncidentListScreen> {

  List incidents = [];

  bool isLoading = true;


  @override
  void initState() {

    super.initState();

    fetchIncidents();
  }



  Future<void> fetchIncidents() async {

    try {

      final data =
      await ApiService.getIncidents();

      setState(() {

        incidents = data;
        isLoading = false;
      });

    } catch (e) {

      print(e);
    }
  }



  Color getPriorityColor(
      String priority) {

    switch (priority) {

      case "Critical":
        return Colors.red;

      case "High":
        return Colors.orange;

      case "Medium":
        return Colors.amber;

      default:
        return Colors.green;
    }
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
            "Emergency Incidents"),

        actions: [

          IconButton(

            icon: const Icon(Icons.search),

            onPressed: () {

              Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (_) =>
                  const SearchFilterScreen(),
                ),
              );
            },
          ),

          IconButton(

            icon: const Icon(
                Icons.dashboard),

            onPressed: () {

              Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (_) =>
                  const DashboardScreen(),
                ),
              );
            },
          ),
        ],
      ),



      floatingActionButton:
      FloatingActionButton(

        backgroundColor: Colors.red,

        child: const Icon(Icons.add),

        onPressed: () async {

          final result =
          await Navigator.push(

            context,

            MaterialPageRoute(

              builder: (_) =>
              const ReportIncidentScreen(),
            ),
          );

          if (result == true) {

            fetchIncidents();
          }
        },
      ),



      body: isLoading

          ? const Center(
          child:
          CircularProgressIndicator())

          : incidents.isEmpty

          ? const Center(
          child:
          Text("No Incidents Found"))

          : ListView.builder(

        itemCount: incidents.length,

        itemBuilder: (context, index) {

          final incident =
          incidents[index];

          return GestureDetector(

            onTap: () async {

              final result =
              await Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (_) =>
                      IncidentDetailScreen(
                        incident: incident,
                      ),
                ),
              );

              if (result == true) {

                fetchIncidents();
              }
            },

            child: Card(

              elevation: 5,

              margin:
              const EdgeInsets.all(10),

              shape:
              RoundedRectangleBorder(

                borderRadius:
                BorderRadius.circular(15),
              ),

              child: ListTile(

                contentPadding:
                const EdgeInsets.all(12),

                leading: CircleAvatar(

                  radius: 28,

                  backgroundColor:
                  getPriorityColor(
                      incident["priority"]),

                  child: Text(

                    incident["priority"][0],

                    style: const TextStyle(

                      color: Colors.white,

                      fontWeight:
                      FontWeight.bold,

                      fontSize: 20,
                    ),
                  ),
                ),

                title: Text(

                  incident["title"],

                  style: const TextStyle(

                    fontWeight:
                    FontWeight.bold,

                    fontSize: 18,
                  ),
                ),

                subtitle: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    const SizedBox(height: 5),

                    Text(
                        incident["category"]),

                    const SizedBox(height: 5),

                    Text(
                      "Status: ${incident["status"]}",
                    ),
                  ],
                ),

                trailing: Text(

                  incident["priority"],

                  style: TextStyle(

                    color: getPriorityColor(
                        incident["priority"]),

                    fontWeight:
                    FontWeight.bold,

                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}