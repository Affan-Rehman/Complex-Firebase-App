import 'package:cloud_firestore/cloud_firestore.dart';


  Future getUser(String email) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      final snapshot = await users.doc(email).get();
      final data = snapshot.data() as Map<String, dynamic>;
      return data;
    } catch (e) {
      return 'Error fetching user';
    }
  }

