import 'package:flutter/material.dart';

import '../services/api_service.dart';

class DashboardScreen
extends StatefulWidget {

  const DashboardScreen({super.key});

  @override
  State<DashboardScreen>
  createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
extends State<DashboardScreen> {

  bool isLoading = true;

  Map<String, int> counts = {};



  @override
  void initState() {

    super.initState();

    fetchDashboardData();
  }



  Future<void>
  fetchDashboardData() async {

    try {

      final data =
      await ApiService
          .getDashboardCounts();

      setState(() {

        counts = data;
        isLoading = false;
      });

    } catch (e) {

      print(e);
    }
  }



  Widget buildCard({

    required String title,
    required int count,
    required Color color,

  }) {

    return Container(

      width: double.infinity,

      margin:
      const EdgeInsets.only(
          bottom: 15),

      padding:
      const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: color,

        borderRadius:
        BorderRadius.circular(15),
      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Text(

            title,

            style: const TextStyle(

              color: Colors.white,

              fontSize: 18,

              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(

            count.toString(),

            style: const TextStyle(

              color: Colors.white,

              fontSize: 32,

              fontWeight:
              FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title:
        const Text("Admin Dashboard"),
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

            buildCard(

              title:
              "Total Incidents",

              count:
              counts["total"]!,

              color: Colors.blue,
            ),

            buildCard(

              title:
              "Active Incidents",

              count:
              counts["active"]!,

              color: Colors.orange,
            ),

            buildCard(

              title:
              "Resolved Incidents",

              count:
              counts["resolved"]!,

              color: Colors.green,
            ),

            buildCard(

              title:
              "Critical Incidents",

              count:
              counts["critical"]!,

              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}