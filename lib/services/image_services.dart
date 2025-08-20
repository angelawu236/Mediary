import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ImageService extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  String? _photoUrl;
  String? get photoUrl => _photoUrl;

  /// Call once after login (or on app start if already logged in)
  Future<void> loadPhotoUrl() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    final doc = await _firestore.collection('users').doc(uid).get();
    _photoUrl = doc.data()?['photoUrl'] as String?;
    notifyListeners();
  }

  /// Pick image -> upload to Storage -> save https URL in Firestore -> notify UI
  Future<void> pickAndUploadPhoto() async {
    try {
      final x = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 768,
        imageQuality: 85,
      );
      if (x == null) return;

      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      // 👉 Replace with your bucket from Firebase Console (Storage)
      final storage = FirebaseStorage.instanceFor(
        app: Firebase.app(),
        bucket: 'YOUR_BUCKET_NAME.appspot.com',
      );

      final ref = storage.ref()
          .child('users')
          .child(uid)
          .child('profile.jpg');

      final bytes = await x.readAsBytes();
      await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));

      // If this throws again, the upload didn’t land in this bucket.
      final url = await ref.getDownloadURL();

      await _firestore.collection('users').doc(uid)
          .set({'photoUrl': url}, SetOptions(merge: true));

      _photoUrl = url;
      notifyListeners();
    } catch (e) {
      debugPrint('Image upload failed: $e');
    }
  }
}

