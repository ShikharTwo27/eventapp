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

  final titleController =
  TextEditingController();

  final descriptionController =
  TextEditingController();

  final locationController =
  TextEditingController();


  String selectedCategory =
      "Medical";

  String selectedPriority =
      "Low";


  bool isLoading = false;



  Future<void> submitIncident()
  async {

    if (
    titleController.text.isEmpty ||

        descriptionController
            .text
            .isEmpty ||

        locationController
            .text
            .isEmpty
    ) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
              "Please fill all fields"),
        ),
      );

      return;
    }


    setState(() {

      isLoading = true;
    });


    try {

      String result =
      await ApiService
          .createIncident(

        title:
        titleController.text,

        description:
        descriptionController.text,

        category:
        selectedCategory,

        priority:
        selectedPriority,

        location:
        locationController.text,
      );


      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(result),
        ),
      );

      Navigator.pop(context, true);

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text(
              e.toString()),
        ),
      );
    }


    setState(() {

      isLoading = false;
    });
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title:
        const Text(
            "Report Incident"),
      ),

      body: Padding(

        padding:
        const EdgeInsets.all(16),

        child:
        SingleChildScrollView(

          child: Column(

            children: [

              TextField(

                controller:
                titleController,

                decoration:
                const InputDecoration(

                  labelText:
                  "Incident Title",
                ),
              ),

              const SizedBox(height: 15),

              TextField(

                controller:
                descriptionController,

                maxLines: 4,

                decoration:
                const InputDecoration(

                  labelText:
                  "Description",
                ),
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField(

                value:
                selectedCategory,

                items: [

                  "Medical",
                  "Fire",
                  "Security",
                  "Accident"

                ].map((category) {

                  return DropdownMenuItem(

                    value: category,

                    child:
                    Text(category),
                  );

                }).toList(),

                onChanged: (value) {

                  setState(() {

                    selectedCategory =
                    value!;
                  });
                },

                decoration:
                const InputDecoration(

                  labelText:
                  "Category",
                ),
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField(

                value:
                selectedPriority,

                items: [

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
                },

                decoration:
                const InputDecoration(

                  labelText:
                  "Priority",
                ),
              ),

              const SizedBox(height: 15),

              TextField(

                controller:
                locationController,

                decoration:
                const InputDecoration(

                  labelText:
                  "Location",
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(

                width:
                double.infinity,

                height: 50,

                child: ElevatedButton(

                  onPressed:
                  isLoading
                      ? null
                      : submitIncident,

                  child: isLoading

                      ? const CircularProgressIndicator(
                    color:
                    Colors.white,
                  )

                      : const Text(
                          "Submit Incident"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}