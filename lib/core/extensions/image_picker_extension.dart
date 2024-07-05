import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickImage(bool fromGallery) async {
    if (fromGallery) {
      return await _pickImageFromGallery();
    } else {
      return await _pickImageFromCamera();
    }
  }

  Future<String?> _pickImageFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    return pickedFile?.path;
  }

  Future<String?> _pickImageFromCamera() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);
    return pickedFile?.path;
  }
}
