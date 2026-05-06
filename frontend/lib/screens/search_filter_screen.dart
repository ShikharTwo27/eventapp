import 'package:flutter/material.dart';

import '../services/api_service.dart';

class SearchFilterScreen
extends StatefulWidget {

  const SearchFilterScreen({
    super.key,
  });

  @override
  State<SearchFilterScreen>
  createState() =>
      _SearchFilterScreenState();
}

class _SearchFilterScreenState
extends State<SearchFilterScreen> {

  List incidents = [];

  List filteredIncidents = [];

  bool isLoading = true;

  final searchController =
  TextEditingController();

  String selectedPriority =
      "All";



  @override
  void initState() {

    super.initState();

    fetchIncidents();
  }



  Future<void> fetchIncidents()
  async {

    try {

      final data =
      await ApiService
          .getIncidents();

      setState(() {

        incidents = data;

        filteredIncidents = data;

        isLoading = false;
      });

    } catch (e) {

      print(e);
    }
  }



  void applyFilters() {

    List temp = incidents;



    // SEARCH
    if (searchController
        .text
        .isNotEmpty) {

      temp = temp.where((incident) {

        return incident["title"]
            .toLowerCase()
            .contains(

          searchController.text
              .toLowerCase(),
        );

      }).toList();
    }



    // PRIORITY FILTER
    if (selectedPriority
        != "All") {

      temp = temp.where((incident) {

        return incident["priority"]
        == selectedPriority;

      }).toList();
    }



    setState(() {

      filteredIncidents = temp;
    });
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

        title:
        const Text(
            "Search & Filter"),
      ),

      body: isLoading

          ? const Center(
          child:
          CircularProgressIndicator())

          : Padding(

        padding:
        const EdgeInsets.all(16),

        child: Column(

          children: [

            TextField(

              controller:
              searchController,

              decoration:
              const InputDecoration(

                hintText:
                "Search incidents",

                prefixIcon:
                Icon(Icons.search),
              ),

              onChanged: (value) {

                applyFilters();
              },
            ),

            const SizedBox(height: 15),



            DropdownButtonFormField(

              value:
              selectedPriority,

              items: [

                "All",
                "Low",
                "Medium",
                "High",
                "Critical"

              ].map((priority) {

                return DropdownMenuItem(

                  value: priority,

                  child:
                  Text(priority),
                );

              }).toList(),

              onChanged: (value) {

                setState(() {

                  selectedPriority =
                  value!;
                });

                applyFilters();
              },

              decoration:
              const InputDecoration(

                labelText:
                "Priority Filter",
              ),
            ),

            const SizedBox(height: 20),



            Expanded(

              child:
              filteredIncidents.isEmpty

                  ? const Center(

                child: Text(
                    "No Matching Incidents"),
              )

                  : ListView.builder(

                itemCount:
                filteredIncidents.length,

                itemBuilder:
                    (context, index) {

                  final incident =
                  filteredIncidents[index];

                  return Card(

                    child: ListTile(

                      leading:
                      CircleAvatar(

                        backgroundColor:
                        getPriorityColor(

                            incident["priority"]
                        ),

                        child: Text(

                          incident["priority"][0],

                          style:
                          const TextStyle(

                            color:
                            Colors.white,
                          ),
                        ),
                      ),

                      title: Text(
                          incident["title"]),

                      subtitle: Text(

                          "${incident["category"]} • ${incident["status"]}"
                      ),

                      trailing: Text(

                        incident["priority"],

                        style: TextStyle(

                          color:
                          getPriorityColor(

                              incident["priority"]
                          ),

                          fontWeight:
                          FontWeight.bold,
                        ),
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