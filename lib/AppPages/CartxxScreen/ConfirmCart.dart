// // import 'package:connectivity/connectivity.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:untitled2/Constants/ConstantVariables.dart';
// import 'package:untitled2/utils/utils/colors.dart';
//
// class ConfirmCart extends StatefulWidget {
//   @override
//   _ConfirmCartState createState() => _ConfirmCartState();
// }
//
// class _ConfirmCartState extends State<ConfirmCart> {
//   bool connectionStatus = true;
//   var customerId;
//
//   @override
//   void initState() {
//     super.initState();
//     customerId = ConstantsVar.customerID;
//
//     ConstantsVar.subscription = ConstantsVar.connectivity.onConnectivityChanged
//         .listen((ConnectivityResult result) {
//       if (result == ConnectivityResult.mobile ||
//           result == ConnectivityResult.wifi) {
//         ConstantsVar.showSnackbar(context, ' Internet connection found.', 5);
//         setState(() {
//           connectionStatus = true;
//         });
//       } else {
//         ConstantsVar.showSnackbar(context,
//             'No Internet connection found. Please check your connection', 5);
//         setState(() {
//           connectionStatus = false;
//         });
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       top: true,
//       child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: AppColor.PrimaryAccentColor,
//             title: Text("Confirm"),
//           ),
//           body: FutureBuilder<String>(
//             future: apiCallToFetchAllAddress(), // async work
//             builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
//               switch (snapshot.connectionState) {
//                 case ConnectionState.waiting:
//                   return Text('Loading....');
//                 default:
//                   if (snapshot.hasError)
//                     return Text('Error: ${snapshot.error}');
//                   else
//                     return Text('Result: ${snapshot.data}');
//               }
//             },
//           )),
//     );
//   }
//
//   Future<String> apiCallToFetchAllAddress() async {
//     // if (connectionStatus == true) {
//     //   ApiCalls.applyCoupon(ConstantsVar.apiTokken.toString(),
//     //           ConstantsVar.customerID, 'SVRGS-95')
//     //       .then((value) {
//     //     setState(() {});
//     //   });
//     // } else {}
//
//     return '';
//   }
// }
