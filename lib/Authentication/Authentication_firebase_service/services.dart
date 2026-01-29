import 'package:cloud_firestore/cloud_firestore.dart';

class AuthServices{
  Future<String?> getUserByEmailId (String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('students')
          .where('email', isEqualTo: email).limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        var data = querySnapshot.docs.first.data() as Map<String, dynamic>;
        return data['generatedId'];
      } else {
        print("No student found with email: $email");
        return null;
      }
    }
    catch(e){
      print(e);
    }
    return null;
  }

}