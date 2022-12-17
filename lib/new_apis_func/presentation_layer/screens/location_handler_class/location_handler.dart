// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:provider/provider.dart';
// import 'package:untitled2/new_apis_func/data_layer/constant_data/constant_data.dart';
// import 'package:untitled2/new_apis_func/presentation_layer/provider_class/provider_contracter.dart';
//
// import '../../../../Constants/ConstantVariables.dart';
//
// class LocationHandler extends StatefulWidget {
//   const LocationHandler({Key? key}) : super(key: key);
//
//   @override
//   State<LocationHandler> createState() => _LocationHandlerState();
// }
//
// class _LocationHandlerState extends State<LocationHandler>
//     with WidgetsBindingObserver {
//   bool isLocation = false;
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     switch (state) {
//       case AppLifecycleState.resumed:
//         log("resume");
//
//     }
//   }
//
//   NewApisProvider _provider = NewApisProvider();
//
//   @override
//   void initState() {
//     WidgetsBinding.instance;
//     _provider = Provider.of<NewApisProvider>(context, listen: false);
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     ThemeData theme = Theme.of(context);
//     return SafeArea(
//       bottom: true,
//       top: true,
//       child: Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           toolbarHeight: width * 0.18,
//           backgroundColor: ConstantsVar.appColor,
//           title: Image.asset(
//             'MyAssets/logo.png',
//             width: width * 0.15,
//             height: width * 0.15,
//           ),
//         ),
//         body: Consumer<NewApisProvider>(
//           builder: (ctx, value, _) => SizedBox(
//               height: height,
//               width: width,
//               child: Stack(
//                 children: [
//                   Positioned(
//                     top: 5,
//                     left: 10,
//                     right: 10,
//                     child: AutoSizeText(
//                       "Please allow us following permissions:",
//                       textAlign: TextAlign.start,
//                       style: TextStyle(
//                         letterSpacing: 1,
//                         height: 2,
//                         fontWeight: FontWeight.bold,
//                         fontSize: width * 0.05,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                       top: height * 0.06,
//                       left: 10,
//                       right: 10,
//                       child: Material(
//                         elevation: 2,
//                         child: SwitchListTile.adaptive(
//                           dense: true,
//                           title: Row(
//                             children: [
//                               Image.asset(
//                                 "mapsIcons/loc.png",
//                                 width: 30,
//                                 height: 30,
//                               ),
//                               const SizedBox(
//                                 width: 10,
//                               ),
//                               Text("Location",
//                                   textAlign: TextAlign.start,
//                                   style: TextStyle(
//                                       height: 1,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: width * 0.04)),
//                             ],
//                           ),
//                           value: value.isSwitchVal,
//                           onChanged: (bool value) {
//                             final _provider = Provider.of<NewApisProvider>(
//                                 context,
//                                 listen: false);
//                             _provider.changeSwitchValue(value: value);
//                           },
//                         ),
//                       )),
//                   Align(
//                     alignment: Alignment.bottomCenter,
//                     child: IgnorePointer(
//                       ignoring: value.isSwitchVal == false ? true : false,
//                       child: AppButton(
//                         color: value.isSwitchVal == true
//                             ? ConstantsVar.appColor
//                             : Colors.grey,
//                         width: width,
//                         height: width * 0.13,
//                         onTap: () async {
//                           log("Ji");
//                           await _provider.getLocation(context: context);
//                         },
//                         child: Text(
//                           "Allow Permission",
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: width * 0.04,
//                               fontWeight: FontWeight.w500),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: width * 0.135,
//                     right: 5,
//                     left: 5,
//                     child: AutoSizeText(
//                       klocationScreenTag,
//                       textAlign: TextAlign.start,
//                       style: TextStyle(
//                         height: 1,
//                         fontWeight: FontWeight.bold,
//                         fontSize: width * 0.04,
//                       ),
//                     ),
//                   ),
//                 ],
//               )),
//         ),
//       ),
//     );
//   }
// }
