import 'package:flutter/material.dart';

import '../services/api_service.dart';

class ReportIncidentScreen
extends StatefulWidget {

  const ReportIncidentScreen({
    super.key,
  });

  @override
  State<ReportIncidentScreen>
  createState() =>
      _ReportIncidentScreenState();
}

class _ReportIncidentScreenState
extends State<ReportIncidentScreen> {

  final formKey =
  GlobalKey<FormState>();

  final titleController =
  TextEditingController();

  final descriptionController =
  TextEditingController();

  final locationController =
  TextEditingController();

  String category = "Medical";

  String priority = "Low";

  bool isLoading = false;



  Future<void> submitIncident()
  async {

    if (!formKey.currentState!
        .validate()) {

      return;
    }

    setState(() {

      isLoading = true;
    });

    try {

      final response =
      await ApiService
          .createIncident(

        title:
        titleController.text,

        description:
        descriptionController.text,

        category:
        category,

        priority:
        priority,

        location:
        locationController.text,
      );

      if (response == true) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(

            content:
            Text(
                "Incident Reported"),
          ),
        );

        Navigator.pop(context, true);
      }

    } catch (e) {

      print(e);
    }

    setState(() {

      isLoading = false;
    });
  }



  Widget buildLabel(String text) {

    return Padding(

      padding:
      const EdgeInsets.only(

        bottom: 8,
      ),

      child: Text(

        text,

        style: TextStyle(

          fontSize: 15,

          fontWeight:
          FontWeight.w500,

          color:
          Colors.grey.shade800,
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFFF4FAF9),

      appBar: AppBar(

        backgroundColor:
        const Color(0xFF4DB6AC),

        title:
        const Text(
            "Report Incident"),
      ),

      body: SingleChildScrollView(

        padding:
        const EdgeInsets.all(16),

        child: Form(

          key: formKey,

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              Container(

                width:
                double.infinity,

                padding:
                const EdgeInsets.all(20),

                decoration: BoxDecoration(

                  color: Colors.white,

                  borderRadius:
                  BorderRadius.circular(20),

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

                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    const Text(

                      "Incident Information",

                      style: TextStyle(

                        fontSize: 20,

                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 22),



                    buildLabel(
                        "Incident Title"),

                    TextFormField(

                      controller:
                      titleController,

                      validator: (value) {

                        if (value == null ||
                            value.isEmpty) {

                          return
                          "Enter incident title";
                        }

                        return null;
                      },

                      decoration:
                      const InputDecoration(

                        hintText:
                        "Enter title",
                      ),
                    ),

                    const SizedBox(height: 18),



                    buildLabel(
                        "Description"),

                    TextFormField(

                      controller:
                      descriptionController,

                      maxLines: 4,

                      validator: (value) {

                        if (value == null ||
                            value.isEmpty) {

                          return
                          "Enter description";
                        }

                        return null;
                      },

                      decoration:
                      const InputDecoration(

                        hintText:
                        "Describe incident",
                      ),
                    ),

                    const SizedBox(height: 18),



                    buildLabel(
                        "Location"),

                    TextFormField(

                      controller:
                      locationController,

                      validator: (value) {

                        if (value == null ||
                            value.isEmpty) {

                          return
                          "Enter location";
                        }

                        return null;
                      },

                      decoration:
                      const InputDecoration(

                        hintText:
                        "Enter location",
                      ),
                    ),

                    const SizedBox(height: 18),



                    buildLabel(
                        "Category"),

                    DropdownButtonFormField(

                      value: category,

                      decoration:
                      const InputDecoration(),

                      items: [

                        "Medical",
                        "Fire",
                        "Crime",
                        "Accident"

                      ].map((item) {

                        return DropdownMenuItem(

                          value: item,

                          child: Text(item),
                        );

                      }).toList(),

                      onChanged: (value) {

                        setState(() {

                          category =
                          value!;
                        });
                      },
                    ),

                    const SizedBox(height: 18),



                    buildLabel(
                        "Priority"),

                    DropdownButtonFormField(

                      value: priority,

                      decoration:
                      const InputDecoration(),

                      items: [

                        "Low",
                        "Medium",
                        "High",
                        "Critical"

                      ].map((item) {

                        return DropdownMenuItem(

                          value: item,

                          child: Text(item),
                        );

                      }).toList(),

                      onChanged: (value) {

                        setState(() {

                          priority =
                          value!;
                        });
                      },
                    ),

                    const SizedBox(height: 28),



                    SizedBox(

                      width:
                      double.infinity,

                      height: 54,

                      child: ElevatedButton(

                        onPressed:
                        isLoading

                            ? null

                            : submitIncident,

                        child: isLoading

                            ? const SizedBox(

                          height: 22,
                          width: 22,

                          child:
                          CircularProgressIndicator(

                            color:
                            Colors.white,

                            strokeWidth: 2,
                          ),
                        )

                            : const Text(

                          "Submit Report",

                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}