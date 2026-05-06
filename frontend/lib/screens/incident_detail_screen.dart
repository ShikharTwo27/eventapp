import 'package:flutter/material.dart';

import '../services/api_service.dart';

class IncidentDetailScreen
extends StatefulWidget {

  final Map incident;

  const IncidentDetailScreen({

    super.key,
    required this.incident,
  });

  @override
  State<IncidentDetailScreen>
  createState() =>
      _IncidentDetailScreenState();
}

class _IncidentDetailScreenState
extends State<IncidentDetailScreen> {

  bool isLoading = false;


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



  Future<void> updateStatus(
      String status) async {

    setState(() {

      isLoading = true;
    });

    try {

      await ApiService
          .updateIncidentStatus(

        id: widget.incident["_id"],
        status: status,
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content:
          Text("Status Updated"),
        ),
      );

      Navigator.pop(context, true);

    } catch (e) {

      print(e);
    }

    setState(() {

      isLoading = false;
    });
  }



  Future<void> deleteIncident() async {

    setState(() {

      isLoading = true;
    });

    try {

      await ApiService.deleteIncident(
          widget.incident["_id"]);

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
          Text("Incident Deleted"),
        ),
      );

      Navigator.pop(context, true);

    } catch (e) {

      print(e);
    }

    setState(() {

      isLoading = false;
    });
  }



  @override
  Widget build(BuildContext context) {

    final incident =
    widget.incident;

    return Scaffold(

      appBar: AppBar(

        title:
        const Text("Incident Details"),
      ),

      body: Padding(

        padding:
        const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Text(

              incident["title"],

              style: const TextStyle(

                fontSize: 24,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Text(
                "Category: ${incident["category"]}"),

            const SizedBox(height: 10),

            Text(
                "Location: ${incident["location"]}"),

            const SizedBox(height: 10),

            Text(
                "Status: ${incident["status"]}"),

            const SizedBox(height: 10),

            Text(

              "Priority: ${incident["priority"]}",

              style: TextStyle(

                color: getPriorityColor(
                    incident["priority"]),

                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const Text(

              "Description",

              style: TextStyle(

                fontSize: 18,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
                incident["description"]),

            const Spacer(),

            if (isLoading)

              const Center(
                child:
                CircularProgressIndicator(),
              )

            else

              Column(

                children: [

                  SizedBox(

                    width: double.infinity,

                    child: ElevatedButton(

                      onPressed: () {

                        updateStatus(
                            "Resolved");
                      },

                      child: const Text(
                          "Mark Resolved"),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(

                    width: double.infinity,

                    child: ElevatedButton(

                      style:
                      ElevatedButton.styleFrom(

                        backgroundColor:
                        Colors.red,
                      ),

                      onPressed:
                      deleteIncident,

                      child: const Text(
                          "Delete Incident"),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}