import 'package:flutter/material.dart';

import '../services/api_service.dart';

class DashboardScreen
extends StatefulWidget {

  const DashboardScreen({
    super.key,
  });

  @override
  State<DashboardScreen>
  createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
extends State<DashboardScreen> {

  bool isLoading = true;

  int total = 0;

  int active = 0;

  int resolved = 0;

  int critical = 0;



  @override
  void initState() {

    super.initState();

    loadDashboard();
  }



  Future<void> loadDashboard()
  async {

    try {

      final data =
      await ApiService
          .getDashboardCounts();

      setState(() {

        total =
        data["total"]!;

        active =
        data["active"]!;

        resolved =
        data["resolved"]!;

        critical =
        data["critical"]!;

        isLoading = false;
      });

    } catch (e) {

      print(e);
    }
  }



  Widget buildCard({

    required String title,

    required int value,

    required IconData icon,

    required Color color,

  }) {

    return Container(

      padding:
      const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(20),

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

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          CircleAvatar(

            radius: 22,

            backgroundColor:
            color.withOpacity(0.12),

            child: Icon(

              icon,

              color: color,

              size: 22,
            ),
          ),

          const Spacer(),

          Text(

            value.toString(),

            style: TextStyle(

              fontSize: 28,

              fontWeight:
              FontWeight.w600,

              color: color,
            ),
          ),

          const SizedBox(height: 6),

          Text(

            title,

            style: TextStyle(

              fontSize: 14,

              color:
              Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFFF4FAF9),

      body: isLoading

          ? const Center(
          child:
          CircularProgressIndicator())

          : SafeArea(

        child: Column(

          children: [

            Container(

              width:
              double.infinity,

              padding:
              const EdgeInsets.all(24),

              decoration:
              const BoxDecoration(

                color:
                Color(0xFF4DB6AC),

                borderRadius:
                BorderRadius.only(

                  bottomLeft:
                  Radius.circular(26),

                  bottomRight:
                  Radius.circular(26),
                ),
              ),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Row(

                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                    children: [

                      const Text(

                        "Dashboard",

                        style: TextStyle(

                          color:
                          Colors.white,

                          fontSize: 26,

                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),

                      Container(

                        padding:
                        const EdgeInsets.all(10),

                        decoration:
                        BoxDecoration(

                          color:
                          Colors.white24,

                          borderRadius:
                          BorderRadius.circular(14),
                        ),

                        child: const Icon(

                          Icons.analytics_outlined,

                          color:
                          Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  const Text(

                    "Overview of emergency incidents and response activity.",

                    style: TextStyle(

                      color:
                      Colors.white70,

                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Container(

                    padding:
                    const EdgeInsets.all(14),

                    decoration:
                    BoxDecoration(

                      color:
                      Colors.white24,

                      borderRadius:
                      BorderRadius.circular(16),
                    ),

                    child: Row(

                      children: [

                        const Icon(

                          Icons.info_outline,

                          color:
                          Colors.white,
                        ),

                        const SizedBox(width: 10),

                        Expanded(

                          child: Text(

                            critical > 0

                                ? "$critical critical incidents require attention."

                                : "No critical incidents currently active.",

                            style:
                            const TextStyle(

                              color:
                              Colors.white,

                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            Expanded(

              child: Padding(

                padding:
                const EdgeInsets.symmetric(

                  horizontal: 16,
                ),

                child: GridView.count(

                  crossAxisCount: 2,

                  crossAxisSpacing: 14,

                  mainAxisSpacing: 14,

                  childAspectRatio: 1,

                  children: [

                    buildCard(

                      title:
                      "Total Incidents",

                      value:
                      total,

                      icon:
                      Icons.warning_amber_rounded,

                      color:
                      const Color(0xFF4DB6AC),
                    ),

                    buildCard(

                      title:
                      "Active Cases",

                      value:
                      active,

                      icon:
                      Icons.pending_actions,

                      color:
                      const Color(0xFFFFB74D),
                    ),

                    buildCard(

                      title:
                      "Resolved",

                      value:
                      resolved,

                      icon:
                      Icons.check_circle_outline,

                      color:
                      const Color(0xFF81C784),
                    ),

                    buildCard(

                      title:
                      "Critical",

                      value:
                      critical,

                      icon:
                      Icons.priority_high,

                      color:
                      const Color(0xFFE57373),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}