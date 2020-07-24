import 'package:fit_kit/fit_kit.dart';
import 'package:permission_handler/permission_handler.dart';

class GoogleFitService {

  DateTime _lastSync = DateTime.now();

  get lastSync => _lastSync;

  Future<List<FitData>> readFitData() async {
    List<FitData> data = [];
    try {
      final activityPermission = await Permission.activityRecognition.request();
      final permissions = await FitKit.requestPermissions(DataType.values);

      print(activityPermission);
      print(permissions);

      if (permissions && (activityPermission == PermissionStatus.granted)) {

        final weight = await FitKit.readLast(DataType.WEIGHT);
        final steps  = await FitKit.readLast(DataType.STEP_COUNT);
        final height = await FitKit.readLast(DataType.HEIGHT);

        data.add(weight);
        data.add(steps);
        data.add(height);
        _lastSync = DateTime.now();

        return data;
      } else {
        // await FitKit.requestPermissions(DataType.values);
        // await Permission.activityRecognition.request();
        readFitData();
        return null;
      }
    } on UnsupportedException catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<List<List<FitData>>> readAllFitData() async {
    List<List<FitData>> data = [];
    try {
      final activityPermission = await Permission.activityRecognition.request();
      final permissions = await FitKit.requestPermissions(DataType.values);
      print(DataType.values);
      if (permissions && (activityPermission == PermissionStatus.granted)) {
        for (DataType type in DataType.values) {
          final results = await FitKit.read(
            type,
            dateFrom: DateTime.now().subtract(Duration(days: 5)),
            dateTo: DateTime.now(),
          );

          data.add(results);
        }
      }
      return data;
    } catch (e) {
      print(e.toString());
      return data;
    }
  }
}
