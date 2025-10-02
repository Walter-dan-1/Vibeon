import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../../services/storage_service.dart';
import '../../../services/firestore_service.dart';
import '../../../core/models/post_model.dart';
import 'package:uuid/uuid.dart';

class UploadScreen extends StatefulWidget { const UploadScreen({super.key}); @override State<UploadScreen> createState() => _UploadScreenState(); }
class _UploadScreenState extends State<UploadScreen> {
  final _caption=TextEditingController(); final _tags=TextEditingController(); bool _uploading=false; String? _status; String? _fileName;
  @override Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Upload')), body: Padding(padding: const EdgeInsets.all(16.0), child: Column(children: [
      TextField(controller: _caption, decoration: const InputDecoration(labelText: 'Caption')),
      TextField(controller: _tags, decoration: const InputDecoration(labelText: 'Tags (comma separated)')),
      const SizedBox(height:12),
      ElevatedButton(onPressed: _uploading?null:() async {
        final result = await FilePicker.platform.pickFiles(type: FileType.video, withData: true);
        if (result==null) return; final file=result.files.first; final bytes=file.bytes; if (bytes==null) return setState(()=>_status='No bytes'); setState(()=>_uploading=true); try {
          final storage = Provider.of<StorageService>(context, listen:false);
          final fs = Provider.of<FirestoreService>(context, listen:false);
          final id = const Uuid().v4();
          final path='uploads/videos/\$id_\${file.name}';
          final url = await storage.uploadVideo(path, Uint8List.fromList(bytes));
          final post = PostModel(id:id, ownerId:'', mediaUrl:url, caption:_caption.text.trim(), tags:_tags.text.split(',').map((s)=>s.trim()).where((s)=>s.isNotEmpty).toList(), likes:0, views:0, createdAt: DateTime.now());
          await fs.createPost(post);
          setState(()=>_status='Uploaded');
        } catch(e){ setState(()=>_status='Upload error: \$e'); } finally { setState(()=>_uploading=false); }
      }, child: const Text('Pick video & upload')),
      if (_fileName!=null) Text('Selected: \$_fileName'),
      if (_status!=null) Padding(padding: const EdgeInsets.only(top:8), child: Text(_status!)),
    ],),),);
  }
}
