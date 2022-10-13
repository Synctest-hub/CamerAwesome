import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/controllers/capture_controller.dart';
import 'package:camerawesome/models/media_capture.dart';

import 'camera_setup.dart';

class PictureCameraController extends CaptureController {
  ExifPreferences? exifPreferences;

  PictureCameraController._({
    required super.cameraSetup,
    this.exifPreferences,
  }) {
    if (exifPreferences != null) {
      updateExifPreferences(exifPreferences!);
    }
  }

  static Future<PictureCameraController> create({
    required CameraSetup cameraSetup,
    ExifPreferences? exifPreferences,
  }) async {
    // We can't use async on constructors or factories, so we make a
    // kind of factory using a static method
    final creation = PictureCameraController._(
      cameraSetup: cameraSetup,
      exifPreferences: exifPreferences,
    );

    if (exifPreferences != null) {
      await creation.updateExifPreferences(exifPreferences);
    }
    return creation;
  }

  /// Photos taken are in JPEG format. [filePath] must end with .jpg
  ///
  /// You can listen to [cameraSetup.mediaCaptureStream] to get updates
  /// of the photo capture (capturing, success/failure)
  Future<String> takePhoto(String filePath) async {
    if (!filePath.endsWith(".jpg")) {
      throw ("You can only capture .jpg files with CamerAwesome");
    }
    cameraSetup.setMediaCapture(MediaCapture.capturing(filePath: filePath));
    try {
      await CamerawesomePlugin.takePhoto(filePath);
      cameraSetup.setMediaCapture(MediaCapture.success(filePath: filePath));
    } on Exception catch (e) {
      cameraSetup.setMediaCapture(
          MediaCapture.failure(filePath: filePath, exception: e));
    }
    return filePath;
  }

  /// Use this to determine if you want to save the GPS location with the picture
  /// as Exif data or not
  Future<void> updateExifPreferences(ExifPreferences preferences) async {
    await CamerawesomePlugin.setExifPreferences(preferences);
  }
}