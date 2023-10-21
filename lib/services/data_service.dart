import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:payment_tracking/models/category.dart';
import 'package:payment_tracking/models/income_stream.dart';
import 'package:payment_tracking/models/payment.dart';
import 'package:payment_tracking/models/payment_method.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class DataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> loadAllTransactionsFromPlaid(User? _currentUser) async {
    final resp = await http.get(
      Uri.parse('http://localhost:8000/api/transactions').replace(queryParameters: {
        'uid': _currentUser!.uid
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return jsonDecode(resp.body);
  }

  Future<Map<String, dynamic>> loadAllAccountsFromPlaid(User? _currentUser) async {
    final resp = await http.get(
      Uri.parse('http://localhost:8000/api/accounts').replace(queryParameters: {
        'uid': _currentUser!.uid
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return jsonDecode(resp.body);
  }

  Future<Map<String, dynamic>> loadAllItemsFromPlaid(User? _currentUser) async {
    final resp = await http.get(
      Uri.parse('http://localhost:8000/api/item').replace(queryParameters: {
        'uid': _currentUser!.uid
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return jsonDecode(resp.body);
  }

  Future<Map<String, List<dynamic>>> loadAll() async {
    try {
      List<Payment> paymentData = await getPayments();
      List<Category> categoryData = await getCategories();
      List<IncomeStream> streamData = await getStreams();
      List<PaymentMethod> paymentMethodData = await getPaymentMethods();

      for (var payment in paymentData) {
        var categoryString = categoryData.firstWhere((cat) => cat.id == payment.categoryId);
        payment.setCategory(categoryString);
        var paymentMethodString = paymentMethodData.firstWhere((method) => method.id == payment.paymentMethodId);
        payment.setPaymentMethod(paymentMethodString);
      }

      Map<String, List<dynamic>> allData = {
        "payments": paymentData,
        "categories": categoryData,
        "streams": streamData,
        "paymentMethods": paymentMethodData
      };
      return allData;
    } catch (e) {
      print("<!!! -- Error loading all data: $e -- !!!>");
      return {};
    }
  }

  Future<List<Payment>> getPayments() async {
    List<Payment> out = [];
    QuerySnapshot querySnapshot = await _db.collection('payment').get();

    for (var doc in querySnapshot.docs) {
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
  }

  Future<List<PaymentMethod>> getPaymentMethods() async {
    List<PaymentMethod> out = [];
    QuerySnapshot querySnapshot = await _db.collection('paymentMethod').get();

    for (var doc in querySnapshot.docs) {
      final id = doc.id;
      final data = doc.data() as Map;
      PaymentMethod paymentMethod = PaymentMethod(
        id: id,
        name: data["name"]
      );
      out.add(paymentMethod);
    }

    return out;
  }

  Future<List<Category>> getCategories() async {
    List<Category> out = [];
    QuerySnapshot querySnapshot = await _db.collection('category').get();

    for (var doc in querySnapshot.docs) {
      final id = doc.id;
      final data = doc.data() as Map;
      Category category = Category(
        id: id,
        name: data["name"], 
        description: data["description"], 
      );
      out.add(category);
    }

    return out;
  }

  Future<List<IncomeStream>> getStreams() async {
    List<IncomeStream> out = [];
    QuerySnapshot querySnapshot = await _db.collection('stream').get();

    for (var doc in querySnapshot.docs) {
      final id = doc.id;
      final data = doc.data() as Map;
      IncomeStream category = IncomeStream(
        id: id,
        name: data["name"], 
        institution: data["institution"], 
        monthlyTotal: data["monthly_total"],
        yearlyTotal: data["yearly_total"]
      );
      out.add(category);
    }

    return out;
  } 

  Future<String?> addPayment(Payment payment) async {
    try {
      final docRef = _db
        .collection("payment")
        .withConverter(
          fromFirestore: Payment.fromFirestore,
          toFirestore: (payment, options) => payment.toFirestore(),
        )
        .doc();
      await docRef.set(payment);
      return docRef.id;
    } catch (e) {
      print("<!!! -- Error writing payment doc: $e -- !!!>");
      return null;
    }
  }

  Future updatePayment(Payment payment) async {
    await _db.collection('payment').doc(payment.id).update({
      "paymentMethodId": payment.paymentMethodId,
      "categoryId": payment.categoryId,
      "recipient": payment.recipient,
      "amount": payment.amount
    });
  }

  Future<String?> addCategory(Category category) async {
    try {
      final docRef = _db
        .collection("category")
        .withConverter(
          fromFirestore: Category.fromFirestore,
          toFirestore: (category, options) => category.toFirestore(),
        )
        .doc();
      await docRef.set(category);
      return docRef.id;
    } catch (e) {
      print("<!!! -- Error writing category doc: $e -- !!!>");
      return null;
    }
  }

  Future<String?> addPaymentMethod(PaymentMethod paymentMethod) async {
    try {
      final docRef = _db
        .collection("paymentMethod")
        .withConverter(
          fromFirestore: PaymentMethod.fromFirestore,
          toFirestore: (paymentMethod, options) => paymentMethod.toFirestore(),
        )
        .doc();
      await docRef.set(paymentMethod);
      return docRef.id;
    } catch (e) {
      print("<!!! -- Error writing paymentMethod doc: $e -- !!!>");
      return null;
    }
  }

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