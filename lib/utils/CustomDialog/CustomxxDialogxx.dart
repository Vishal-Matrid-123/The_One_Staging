// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:untitled2/AppPages/LoginScreen/LoginScreen.dart';
//
// class LogoutOverlay extends StatefulWidget {
//   const LogoutOverlay({Key? key}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => LogoutOverlayState();
// }
//
// class LogoutOverlayState extends State<LogoutOverlay>
//     with SingleTickerProviderStateMixin {
//   late AnimationController controller;
//   late Animation<double> scaleAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     controller = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 450));
//     scaleAnimation =
//         CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
//
//     controller.addListener(() {
//       setState(() {});
//     });
//
//     controller.forward();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Material(
//         color: Colors.transparent,
//         child: ScaleTransition(
//           scale: scaleAnimation,
//           child: Container(
//               margin: const EdgeInsets.all(20.0),
//               padding: const EdgeInsets.all(15.0),
//               height: 180.0,
//               decoration: ShapeDecoration(
//                   color: const Color.fromRGBO(41, 167, 77, 10),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15.0))),
//               child: Column(
//                 children: <Widget>[
//                   const Expanded(
//                       child: Padding(
//                     padding:
//                         EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
//                     child: Text(
//                       "Are you sure, you want to logout?",
//                       style: TextStyle(color: Colors.white, fontSize: 16.0),
//                     ),
//                   )),
//                   Expanded(
//                       child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: ButtonTheme(
//                             height: 35.0,
//                             minWidth: 110.0,
//                             child: RaisedButton(
//                               color: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(5.0)),
//                               splashColor: Colors.white.withAlpha(40),
//                               child: const Text(
//                                 'Logout',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                     color: Colors.green,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 13.0),
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   Route route = CupertinoPageRoute(
//                                       builder: (context) => const LoginScreen(
//                                             screenKey: '',
//                                           ));
//                                   Navigator.pushReplacement(context, route);
//                                 });
//                               },
//                             )),
//                       ),
//                       Padding(
//                           padding: const EdgeInsets.only(
//                               left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
//                           child: ButtonTheme(
//                               height: 35.0,
//                               minWidth: 110.0,
//                               child: RaisedButton(
//                                 color: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(5.0)),
//                                 splashColor: Colors.white.withAlpha(40),
//                                 child: const Text(
//                                   'Cancel',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       color: Colors.green,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 13.0),
//                                 ),
//                                 onPressed: () {
//                                   setState(() {
//                                     /* Route route = MaterialPageRoute(
//                                           builder: (context) => LoginScreen());
//                                       Navigator.pushReplacement(context, route);
//                                    */
//                                   });
//                                 },
//                               ))),
//                     ],
//                   ))
//                 ],
//               )),
//         ),
//       ),
//     );
//   }
// }
