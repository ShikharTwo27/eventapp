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

          "Search & Filter",

          style: TextStyle(

            fontSize: 20,

            fontWeight:
            FontWeight.w600,
          ),
        ),
      ),

      body: isLoading

          ? const Center(
          child:
          CircularProgressIndicator())

          : Padding(

        padding:
        const EdgeInsets.all(14),

        child: Column(

          children: [

            TextField(

              controller:
              searchController,

              decoration:
              InputDecoration(

                hintText:
                "Search incidents",

                hintStyle:
                TextStyle(

                  color:
                  Colors.grey.shade600,
                ),

                prefixIcon:
                const Icon(
                    Icons.search),

                filled: true,

                fillColor:
                Colors.white,

                border:
                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(16),

                  borderSide:
                  BorderSide.none,
                ),
              ),

              onChanged: (value) {

                applyFilters();
              },
            ),

            const SizedBox(height: 14),



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
              InputDecoration(

                labelText:
                "Priority Filter",

                filled: true,

                fillColor:
                Colors.white,

                border:
                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(16),

                  borderSide:
                  BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 16),



            Expanded(

              child:
              filteredIncidents.isEmpty

                  ? const Center(

                child: Text(
                    "No matching incidents"),
              )

                  : ListView.builder(

                itemCount:
                filteredIncidents.length,

                itemBuilder:
                    (context, index) {

                  final incident =
                  filteredIncidents[index];

                  return Container(

                    margin:
                    const EdgeInsets.only(
                        bottom: 12),

                    padding:
                    const EdgeInsets.all(10),

                    decoration:
                    BoxDecoration(

                      color:
                      Colors.white,

                      borderRadius:
                      BorderRadius.circular(18),

                      boxShadow: [

                        BoxShadow(

                          color:
                          Colors.black
                              .withOpacity(0.04),

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
                        vertical: 2,
                      ),

                      leading:
                      CircleAvatar(

                        radius: 24,

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

                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ),

                      title: Text(

                        incident["title"],

                        style:
                        const TextStyle(

                          fontWeight:
                          FontWeight.w600,

                          fontSize: 16,
                        ),
                      ),

                      subtitle: Padding(

                        padding:
                        const EdgeInsets.only(
                            top: 5),

                        child: Text(

                          "${incident["category"]} • ${incident["status"]}",

                          style: TextStyle(

                            color:
                            Colors.grey.shade700,
                          ),
                        ),
                      ),

                      trailing: Text(

                        incident["priority"],

                        style: TextStyle(

                          color:
                          getPriorityColor(

                              incident["priority"]
                          ),

                          fontWeight:
                          FontWeight.w600,
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