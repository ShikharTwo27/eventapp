import 'package:hive/hive.dart';

class OfflineService {

  static final box =
  Hive.box("offline_incidents");



  // SAVE OFFLINE INCIDENT
  static Future<void>
  saveOfflineIncident(

      Map<String, dynamic> incident
      ) async {

    await box.add(incident);
  }



  // GET OFFLINE INCIDENTS
  static List getOfflineIncidents() {

    return box.values.toList();
  }



  // CLEAR OFFLINE INCIDENTS
  static Future<void>
  clearOfflineIncidents() async {

    await box.clear();
  }
}