import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:payment_tracking/models/payment.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Payment>> query(
    String ?paymentMethodId,
    String ?categoryId,
    DateTime start,
    DateTime end
  ) async {
    try {
      List<Payment> out = [];
      // Timestamp startStamp = start.millisecondsSinceEpoch as Timestamp;
      // Timestamp endStamp = end.millisecondsSinceEpoch as Timestamp;
      QuerySnapshot querySnapshot = await _db.collection('payment')
      .where("paymentMethodId", isEqualTo: paymentMethodId)
      .where("categoryId", isEqualTo: categoryId)
      .where("date", isGreaterThanOrEqualTo: start)
      .where("date", isLessThanOrEqualTo: end)
      .get();

      for (var doc in querySnapshot.docs) {
        print('<!-- doc.id --!>');
        print(doc.id);
        final id = doc.id;
        final data = doc.data() as Map;
        Payment payment = Payment(
          id: id,
          date: data["date"], 
          recipient: data["recipient"], 
          amount: data["amount"], 
          paymentMethodId: data["paymentMethodId"], 
          categoryId: data["categoryId"]
        );
        out.add(payment);
      }

      return out;
    } catch (e) {
      print("<!!! -- Error querying: $e -- !!!>");
      return [];
    }
  }

  Future<dynamic> insertUser(user) async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('users')
        .where("email", isEqualTo: user["email"])
        .get();

      print('<!-- querySnapshot.docs[0] --!>');
      print(querySnapshot.docs[0]);
        
      if (querySnapshot.docs.isEmpty) {
        return await _db
          .collection("users")
          .add(user)
          .then(
            (DocumentReference documentSnapshot) => {
                print("<??? -- User Inserted: ${documentSnapshot.id} -- ???>"),
                documentSnapshot.id
            },
            onError: (e) => print("<!!! -- Error completing: $e -- !!!>"),
        );
      } else {
        final doc = querySnapshot.docs[0];
        return doc.id;
      }
    } catch (err) {
      print("<!!! -- Error querying: $err -- !!!>");
    }
  }

}