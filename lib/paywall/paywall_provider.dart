// access_control.dart
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/foundation.dart';
// 1. Import Firestore
import 'package:cloud_firestore/cloud_firestore.dart';

// Your enum
enum AccessState { loading, offline, accessGranted, accessDenied }

class AccessControl extends ChangeNotifier {
  AccessState accessState = AccessState.loading;

  Future<void> initialize() async {
    // 1. --- Check connectivity ---
    final connectivityResult = await (Connectivity().checkConnectivity());
    // if (connectivityResult.any((element) => element == ConnectivityResult.none)) {
    //   accessState = AccessState.offline;
    // }
     {
      // 2. --- If online, check Firestore ---
      try {
        // Get the single document from Firestore
        final doc = await FirebaseFirestore.instance
            .collection('config') // The collection you created
            .doc('paywall')       // The document you created
            .get();

        bool isPayallEnabled = false;
        if (doc.exists && doc.data() != null) {
          // Get the boolean flag from the document
          isPayallEnabled = doc.data()!['isEnabled'] ?? false;
          print('is payable = ${doc.data()}');
        }



        accessState = isPayallEnabled
            ? AccessState.accessGranted
            : AccessState.accessDenied;

      } catch (e) {
        // Fail-safe: if Firestore fails, deny access
        print('Firestore error: $e');
        accessState = AccessState.accessDenied;
      }
    }

    // 3. --- Notify all listeners (like go_router) ---
    notifyListeners();
  }
}