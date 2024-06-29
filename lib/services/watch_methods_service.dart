import 'package:group_project/constants/apple_watch_methods_enums.dart';
import 'package:group_project/main.dart';

class WatchMethodsService {
  static void sendTemplatesToWatch() async {
    final allWorkoutTemplatesInJson = objectBox.workoutTemplateService
        .getAllWorkoutTemplates()
        .map((workoutTemplate) => workoutTemplate.toJson())
        .toList();
    await AppleWatchMethods.channel
        .invokeMethod(AppleWatchMethods.flutterToWatch, {
      "method": AppleWatchMethods.sendTemplatesToWatch,
      "data": allWorkoutTemplatesInJson,
    });
  }
}
