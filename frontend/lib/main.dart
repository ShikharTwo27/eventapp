import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/incident_list_screen.dart';
import 'services/api_service.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox("offline_incidents");

  

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'Emergency Response App',

      theme: ThemeData(

        useMaterial3: true,

        primaryColor:
        const Color(0xFF4DB6AC),

        scaffoldBackgroundColor:
        const Color(0xFFF4FAF9),

        colorScheme:
        ColorScheme.fromSeed(

          seedColor:
          const Color(0xFF4DB6AC),
        ),

        appBarTheme:
        const AppBarTheme(

          backgroundColor:
          Color(0xFF4DB6AC),

          foregroundColor:
          Colors.white,

          elevation: 0,

          centerTitle: true,
        ),

        elevatedButtonTheme:
        ElevatedButtonThemeData(

          style:
          ElevatedButton.styleFrom(

            backgroundColor:
            const Color(0xFF4DB6AC),

            foregroundColor:
            Colors.white,

            elevation: 2,

            padding:
            const EdgeInsets.symmetric(

              vertical: 15,
            ),

            shape:
            RoundedRectangleBorder(

              borderRadius:
              BorderRadius.circular(15),
            ),
          ),
        ),

        inputDecorationTheme:
        InputDecorationTheme(

          filled: true,

          fillColor: Colors.white,

          contentPadding:
          const EdgeInsets.symmetric(

            horizontal: 20,
            vertical: 18,
          ),

          border:
          OutlineInputBorder(

            borderRadius:
            BorderRadius.circular(15),

            borderSide:
            BorderSide.none,
          ),

          enabledBorder:
          OutlineInputBorder(

            borderRadius:
            BorderRadius.circular(15),

            borderSide:
            BorderSide.none,
          ),

          focusedBorder:
          OutlineInputBorder(

            borderRadius:
            BorderRadius.circular(15),

            borderSide:
            const BorderSide(

              color:
              Color(0xFF4DB6AC),

              width: 2,
            ),
          ),
        ),

        cardTheme:
        CardThemeData(

          elevation: 2,

          shadowColor:
          Colors.black12,

          shape:
          RoundedRectangleBorder(

            borderRadius:
            BorderRadius.circular(20),
          ),
        ),
      ),

      home:
      const IncidentListScreen(),
    );
  }
}