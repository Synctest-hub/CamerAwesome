import 'package:camera_app/drivable_camera.dart';
import 'package:camerawesome/camerawesome_plugin.dart';

import 'common.dart';

main() {
  patrol('Concurrent > Basic run', ($) async {
    await $.pumpWidgetAndSettle(
      DrivableCamera(
        sensors: [
          Sensor.position(SensorPosition.back),
          Sensor.position(SensorPosition.front)
        ],
        saveConfig: SaveConfig.photoAndVideo(
          photoPathBuilder: () => tempPath('single_photo_back.jpg'),
          videoPathBuilder: () => tempPath('single_video_back.mp4'),
        ),
      ),
    );
    await allowPermissionsIfNeeded($);

    await $.pumpAndSettle(duration: const Duration(seconds: 5));
  });
}