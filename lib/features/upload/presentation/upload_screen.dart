import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../../services/storage_service.dart';
import '../../../services/firestore_service.dart';
import '../../../core/models/post_model.dart';
import 'package:uuid/uuid.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String? _fileName;
  bool _uploading = false;
  String? _status;
  final _caption = TextEditingController();
  final _tags = TextEditingController();

  Future<void> _pickAndUpload() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video, withData: true);
    if (result == null) return;
    final file = result.files.first;
    setState(()=> _fileName = file.name);
    final bytes = file.bytes;
    if (bytes == null) return setState(()=> _status = 'No file bytes');
    setState(()=> _uploading = true; _status = 'Uploading...');
    try {
      final storage = Provider.of<StorageService>(context, listen: false);
      final fs = Provider.of<FirestoreService>(context, listen: false);
      final id = const Uuid().v4();
      final path = 'uploads/videos/\$id_\${file.name}';
      final url = await storage.uploadVideo(path, Uint8List.fromList(bytes));
      // thumbnail placeholder - same as media for now
      final thumbnail = url;
      final post = PostModel(
        id: id,
        ownerId: '', // replace with auth uid when available
        mediaUrl: url,
        thumbnailUrl: thumbnail,
        caption: _caption.text.trim(),
        tags: _tags.text.split(',').map((s)=>s.trim()).where((s)=>s.isNotEmpty).toList(),
        likes: 0,
        views: 0,
        createdAt: DateTime.now(),
      );
      await fs.createPost(post);
      setState(()=> _status = 'Uploaded');
    } catch (e) {
      setState(()=> _status = 'Upload error: \$e');
    } finally {
      setState(()=> _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _caption, decoration: const InputDecoration(labelText: 'Caption')),
            TextField(controller: _tags, decoration: const InputDecoration(labelText: 'Tags (comma separated)')),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _uploading ? null : _pickAndUpload, child: const Text('Pick video & upload')),
            const SizedBox(height: 12),
            if (_fileName != null) Text('Selected: \$_fileName'),
            if (_status != null) Padding(padding: const EdgeInsets.only(top:8), child: Text(_status!)),
          ],
        ),
      ),
    );
  }
}
