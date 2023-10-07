import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:payment_tracking/models/category.dart';
import 'package:payment_tracking/models/income_stream.dart';
import 'package:payment_tracking/models/payment.dart';
import 'package:payment_tracking/models/payment_method.dart';

class DataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

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

}