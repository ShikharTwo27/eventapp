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
        return const Color(0xFFE57373);

      case "High":
        return const Color(0xFFFFB74D);

      case "Medium":
        return const Color(0xFFFFD54F);

      default:
        return const Color(0xFF81C784);
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

        id:
        widget.incident["_id"],

        status: status,
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

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



  Future<void> deleteIncident()
  async {

    setState(() {

      isLoading = true;
    });

    try {

      await ApiService
          .deleteIncident(

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



  Widget buildInfoTile({

    required IconData icon,

    required String title,

    required String value,

  }) {

    return Container(

      margin:
      const EdgeInsets.only(
          bottom: 14),

      padding:
      const EdgeInsets.all(16),

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

      child: Row(

        children: [

          CircleAvatar(

            radius: 22,

            backgroundColor:
            const Color(0xFF4DB6AC)
                .withOpacity(0.12),

            child: Icon(

              icon,

              color:
              const Color(0xFF4DB6AC),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(

                  title,

                  style: TextStyle(

                    color:
                    Colors.grey.shade600,

                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 4),

                Text(

                  value,

                  style: const TextStyle(

                    fontSize: 16,

                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {

    final incident =
    widget.incident;

    return Scaffold(

      backgroundColor:
      const Color(0xFFF4FAF9),

      appBar: AppBar(

        backgroundColor:
        const Color(0xFF4DB6AC),

        title:
        const Text(
            "Incident Details"),
      ),

      body: isLoading

          ? const Center(
          child:
          CircularProgressIndicator())

          : SingleChildScrollView(

        padding:
        const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Container(

              width:
              double.infinity,

              padding:
              const EdgeInsets.all(22),

              decoration: BoxDecoration(

                color:
                const Color(0xFF4DB6AC),

                borderRadius:
                BorderRadius.circular(22),
              ),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(

                    incident["title"],

                    style:
                    const TextStyle(

                      color:
                      Colors.white,

                      fontSize: 24,

                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Container(

                    padding:
                    const EdgeInsets.symmetric(

                      horizontal: 12,
                      vertical: 6,
                    ),

                    decoration:
                    BoxDecoration(

                      color:
                      Colors.white24,

                      borderRadius:
                      BorderRadius.circular(14),
                    ),

                    child: Text(

                      incident["priority"],

                      style:
                      const TextStyle(

                        color:
                        Colors.white,

                        fontWeight:
                        FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),



            buildInfoTile(

              icon:
              Icons.category_outlined,

              title:
              "Category",

              value:
              incident["category"],
            ),

            buildInfoTile(

              icon:
              Icons.location_on_outlined,

              title:
              "Location",

              value:
              incident["location"],
            ),

            buildInfoTile(

              icon:
              Icons.info_outline,

              title:
              "Status",

              value:
              incident["status"],
            ),

            buildInfoTile(

              icon:
              Icons.description_outlined,

              title:
              "Description",

              value:
              incident["description"],
            ),

            const SizedBox(height: 24),



            SizedBox(

              width:
              double.infinity,

              height: 52,

              child: ElevatedButton(

                onPressed: () {

                  updateStatus(
                      "Resolved");
                },

                child: const Text(

                  "Mark as Resolved",

                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),



            SizedBox(

              width:
              double.infinity,

              height: 52,

              child: ElevatedButton(

                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  const Color(0xFFE57373),
                ),

                onPressed:
                deleteIncident,

                child: const Text(

                  "Delete Incident",

                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}