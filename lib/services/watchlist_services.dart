import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mediary/models/media_model.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class WatchListService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Map to hold media items keyed by a unique ID (e.g., title)
  late Map<String, MediaModel> mediaMap;


  // Read media items from Firestore
  Future<bool> fetchMediaFromFirestore(String uid, String category) async {
    try {
      final snapshot = await _db
          .collection('users')
          .doc(uid)
          .collection('media')
          .where('category', isEqualTo: category)
          .orderBy('index')
          .get();

      mediaMap = {
        for (var doc in snapshot.docs)
          doc.id: MediaModel.fromJson(doc.data())
      };

      return true;
    } catch (e) {
      print('Error fetching media from Firestore: $e');
      return false;
    }
  }

  // Store media items in Firestore, here "String" would have to be the media's category.
  Future<bool> storeMedia(Map<String, MediaModel> mediaToStore) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      print('No authenticated user found');
      return false;
    }

    try {
      await _db.collection('users').doc(uid).set({}, SetOptions(merge: true));

      for (final entry in mediaToStore.entries) {
        final media = entry.value;
        final id = media.id;

        await _db
            .collection('users')
            .doc(uid)
            .collection('media')
            .doc(id.toString())
            .set(media.toJson());

        print('Stored media $id: ${media.toJson()}');
      }

      return true;
    } catch (e) {
      print('Error storing media in Firestore: $e');
      return false;
    }
  }
}
