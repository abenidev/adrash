import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImagePickerHelper {
  ImagePickerHelper._();

  static Future<File?> pickFromGallery() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    return xFile == null ? null : File(xFile.path);
  }

  static Future<File?> pickFromCamera() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.camera);
    return xFile == null ? null : File(xFile.path);
  }

  static Future<File?> cropImageFile(BuildContext context, File toBeCroppedFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: toBeCroppedFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 70,
      aspectRatio: const CropAspectRatio(ratioX: 9, ratioY: 16),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Photo',
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Theme.of(context).canvasColor,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
        ),
        IOSUiSettings(title: 'Photo'),
        WebUiSettings(context: context),
      ],
    );

    return croppedFile == null ? null : File(croppedFile.path);
  }

  static Future<File?> getSavedImageFile(File pickedImageFile) async {
    Uint8List imageBytes = await pickedImageFile.readAsBytes();
    //save image in app directory
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    String appDirPath = appDocDirectory.path;
    String filePath = '$appDirPath/${DateTime.now().millisecondsSinceEpoch}.jpg';
    File savedFile = File(filePath);
    await savedFile.writeAsBytes(imageBytes);
    return savedFile;
  }

  static Future<void> removeAlreadyExistingPhoto(String photoPath) async {
    if (photoPath.trim() == '') return;
    File toBeRemovedPhoto = File(photoPath);
    await toBeRemovedPhoto.delete();
  }
}
