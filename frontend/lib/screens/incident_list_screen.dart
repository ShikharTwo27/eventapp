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



  Future<void> fetchIncidents()
  async {

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
        return const Color(0xFFE57373);

      case "High":
        return const Color(0xFFFFB74D);

      case "Medium":
        return const Color(0xFFFFD54F);

      default:
        return const Color(0xFF81C784);
    }
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFFF4FAF9),

      appBar: AppBar(

        backgroundColor:
        const Color(0xFF4DB6AC),

        toolbarHeight: 65,

        title: const Text(

          "Emergency Incidents",

          style: TextStyle(

            fontSize: 20,

            fontWeight:
            FontWeight.w600,
          ),
        ),

        actions: [

          IconButton(

            icon:
            const Icon(Icons.search),

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

            icon:
            const Icon(Icons.grid_view_rounded),

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

        backgroundColor:
        const Color(0xFF4DB6AC),

        elevation: 2,

        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),

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

          : ListView.builder(

        padding:
        const EdgeInsets.symmetric(

          horizontal: 14,
          vertical: 12,
        ),

        itemCount:
        incidents.length,

        itemBuilder:
            (context, index) {

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

            child: Container(

              margin:
              const EdgeInsets.only(
                  bottom: 12),

              padding:
              const EdgeInsets.all(10),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius:
                BorderRadius.circular(18),

                boxShadow: [

                  BoxShadow(

                    color:
                    Colors.black.withOpacity(0.04),

                    blurRadius: 6,

                    offset:
                    const Offset(0, 2),
                  ),
                ],
              ),

              child: ListTile(

                contentPadding:
                const EdgeInsets.symmetric(

                  horizontal: 8,
                  vertical: 4,
                ),

                leading: CircleAvatar(

                  radius: 26,

                  backgroundColor:
                  getPriorityColor(
                      incident["priority"]),

                  child: Text(

                    incident["priority"][0],

                    style: const TextStyle(

                      color:
                      Colors.white,

                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ),

                title: Text(

                  incident["title"],

                  style: const TextStyle(

                    fontSize: 17,

                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                subtitle: Padding(

                  padding:
                  const EdgeInsets.only(
                      top: 6),

                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Text(

                        incident["category"],

                        style: TextStyle(

                          color:
                          Colors.grey.shade700,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(

                        "Status: ${incident["status"]}",

                        style: TextStyle(

                          color:
                          Colors.grey.shade600,

                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                trailing: Text(

                  incident["priority"],

                  style: TextStyle(

                    color:
                    getPriorityColor(
                        incident["priority"]),

                    fontWeight:
                    FontWeight.w600,

                    fontSize: 15,
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