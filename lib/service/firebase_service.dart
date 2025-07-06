import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/recording_data.dart';
import '../model/user_data.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'recording';

  // In firebase_service.dart
  Stream<List<RecordingData>> getRecordingsStream(int id_periode, String email) {
    return _firestore
        .collection(_collectionName)
        .doc('data')
        .collection(email)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => RecordingData.fromJson(doc.data()))
        // .takeWhile((doc) => doc.id_periode == id_periode)
        .where((doc) => doc.id_periode == id_periode)
        .toList());
  }

  Future addRecording(RecordingData recording, String email) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc('data')
          .collection(email)
          .add(recording.toJson());
    } catch (e) {
      throw Exception('Failed to add recording: $e');
    }
  }

  Future<User> getUsers(String email) async {
    try {
      final doc = await _firestore
          .collection(_collectionName)
          .doc('user')
          .collection(email)
          .get();

      if (doc.docs.isNotEmpty) {
        return User.fromJson(doc.docs.first.data());
      }
      
      // Return a default user with all required fields
      return User(
        email: email,
        username: '',
        picture: '',
        name: Name(first: '', last: ''),
        gender: '',
        phone: '',
        location: '',
        address: '',
        password: null,
        role: null,
        id: null,
        createdAt: null,
        updatedAt: null,
      );
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  // Get a single recording by ID
  Future<List<RecordingData?>> getRecording(String id_periode, String email) async {
    try {
      final idPeriode = id_periode;
      final doc = await _firestore
          .collection(_collectionName)
          .doc('data')
          .collection(email)
          .get();

      if (doc.size > 0) {
        List<RecordingData> recordings = <RecordingData>[];
        for (var item in doc.docs) {
          if (item.data()['id_periode'] != idPeriode) {
            continue;
          }
          recordings.add(RecordingData.fromJson(item.data()));
        }
        return recordings;
      }
      return [];
    } catch (e) {
      throw Exception('Failed to get recording: $e');
    }
  }
}
