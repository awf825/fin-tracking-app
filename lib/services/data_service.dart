import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:payment_tracking/models/payment.dart';

class DataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Map<String, List<dynamic>>> loadAll() async {
    try {
      Map<String, List<Object?>> finalMap = {};
      finalMap["payments"] = await getPayments();
      finalMap["categories"] = await getPaymentMethods();
      finalMap["streams"] = await getCategories();
      finalMap["paymentMethods"] = await getStreams();
      return finalMap;
    } catch (e) {
      print("<!!! -- Error loading all data: $e -- !!!>");
      return {};
    }
  }

  Future<List<Object?>> getPayments() async {
    // Get docs from collection reference
    List out = [];
    QuerySnapshot querySnapshot = await _db.collection('payment').get();
    for (final doc in querySnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      out.add(data);
    }
    return out;
  }

  Future<List<Object?>> getPaymentMethods() async {
    List out = [];
    QuerySnapshot querySnapshot = await _db.collection('paymentMethod').get();
    for (final doc in querySnapshot.docs) {
      final data = doc.data() as Map;
      data['id'] = doc.id;
      out.add(data);
    }
    return out;
  }

  Future<List<Object?>> getCategories() async {
    List out = [];
    QuerySnapshot querySnapshot = await _db.collection('category').get();
    for (final doc in querySnapshot.docs) {
      final data = doc.data() as Map;
      data['id'] = doc.id;
      out.add(data);
    }
    return out;
  }

  Future<List<Object?>> getStreams() async {
    List out = [];
    QuerySnapshot querySnapshot = await _db.collection('stream').get();
    for (final doc in querySnapshot.docs) {
      final data = doc.data() as Map;
      data['id'] = doc.id;
      out.add(data);
    }
    return out;
  } 

}