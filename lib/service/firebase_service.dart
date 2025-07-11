import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:recording_app/model/cage_data.dart';
import '../model/recording_data.dart';
import '../model/user_data.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'recording';

  //Mengambil data recording ayam dari firestore
  Stream<List<RecordingData>> getRecordingsStream(
    int id_periode,
    String email,
  ) {
    return _firestore
        .collection(_collectionName)
        .doc('data')
        .collection(email)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  //Memasukkan data recording ke model/fcr_data
                  .map((doc) => RecordingData.fromJson(doc.data()))
                  .where((doc) => doc.id_periode == id_periode)
                  .toList()..sort((a, b) => a.umur.compareTo(b.umur)),
        );
  }

  //Mengambil data berat ayam dari firestore
  Stream<List<FlSpot>> getWeightStream(int id_periode, String email) {
    return _firestore
        .collection(_collectionName)
        .doc('data')
        .collection(email)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  //Memasukkan data berat ayam ke model/fcr_data
                  .map((doc) => RecordingData.fromJson(doc.data()))
                  .where((doc) => doc.id_periode == id_periode)
                  .map(
                    (doc) =>
                        //Memasukkan data umur dan berat ayam ke FlSpot
                        FlSpot(doc.umur.toDouble(), doc.beratAyam.toDouble()),
                  )
                  .toList()
                ..sort((a, b) => a.x.compareTo(b.x)),
        );
  }

  //Menambahkan data recording ayam ke firestore
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

  //Mengambil data kandang dari firestore
  Future<CageData> getCage(String email) async {
    try {
      final doc =
          await _firestore
              .collection(_collectionName)
              .doc('kandang')
              .collection(email)
              .get();

      if (doc.docs.isNotEmpty) {
        return CageData.fromJson(doc.docs.first.data());
      }

      // Return a default user with all required fields
      return CageData(idKandang: 0, type: '', capacity: 0, address: '');
    } catch (e) {
      throw Exception('Failed to get cage: $e');
    }
  }

  //Mengambil data user/peternak dari firestore
  Future<UserData> getUser(String email) async {
    try {
      final doc =
          await _firestore
              .collection(_collectionName)
              .doc('user')
              .collection(email)
              .get();

      if (doc.docs.isNotEmpty) {
        final userData = UserData.fromJson(doc.docs.first.data());
        return userData;
      }

      final defaultUser = UserData(
        email: email,
        username: '',
        phone: '',
        address: '',
      );

      return defaultUser;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }
}
