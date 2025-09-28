import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadVideo(String path, Uint8List bytes) async {
    final ref = _storage.ref().child(path);
    final task = await ref.putData(bytes);
    return await ref.getDownloadURL();
  }

  Future<String> uploadThumbnail(String path, Uint8List bytes) async {
    final ref = _storage.ref().child(path);
    final task = await ref.putData(bytes);
    return await ref.getDownloadURL();
  }
}
