import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/main.dart';
import 'package:untitled2/new_apis_func/data_layer/new_model/store_model/store_model.dart';

import '../../../../AppPages/HomeScreen/HomeScreen.dart';
import '../../../../Constants/ConstantVariables.dart';
import '../../../../utils/ApiCalls/ApiCalls.dart';
import '../../../data_layer/constant_data/constant_data.dart';
import '../../provider_class/provider_contracter.dart';

class StoreSelectionScreen extends StatefulWidget {
  const StoreSelectionScreen({Key? key, required String screenName})
      : _screenName = screenName,
        super(key: key);
  final String _screenName;

  @override
  State<StoreSelectionScreen> createState() => _StoreSelectionScreenState();
}

class _StoreSelectionScreenState extends State<StoreSelectionScreen> {
  String _id = '';

  @override
  void initState() {
    widget._screenName.toLowerCase().contains('splash')
        ? _checkingStoreSelection()
        : null;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    return GestureDetector(
      onTap: () {
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SafeArea(
        top: true,
        bottom: true,
        maintainBottomViewPadding: true,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            toolbarHeight: 18.w,
            backgroundColor: ConstantsVar.appColor,
            // leading: IconButton(
            //     onPressed: () => Navigator.pushAndRemoveUntil(context,
            //             CupertinoPageRoute(builder: (context) {
            //           return MyHomePage();
            //         }), (route) => false),
            //     icon: Icon(Icons.arrow_back)),
            title: Image.asset(
              'MyAssets/logo.png',
              width: 15.w,
              height: 15.w,
            ),
          ),
          body: SizedBox(
            height: 100.h,
            child: Consumer<NewApisProvider>(
                builder: (_, value, child) =>
                    FlutterSizer(builder: (context, orientation, deviceType) {
                      return SizedBox(
                        width: 100.w,
                        height: 100.h,
                        child: Stack(
                          children: [
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  StoreData(
                                    id: (int.parse(kuStoreId)),
                                    name: 'THE One UAE',
                                    url: kuBaseUrl,
                                  ),
                                  StoreData(
                                    id: (int.parse(kbStoreId)),
                                    name: 'THE One Bahrain',
                                    url: kbBaseUrl,
                                  ),
                                  StoreData(
                                    id: (int.parse(kkStoreId)),
                                    name: 'THE One Kuwait',
                                    url: kkBaseUrl,
                                  ),
                                  StoreData(
                                    id: (int.parse(kqStoreId)),
                                    name: 'THE One Qatar',
                                    url: kqBaseUrl,
                                  ),
                                ]
                                    .map(
                                      (e) =>
                                      Visibility(
                                        visible: e.name.contains('Qatar')?false:true,
                                        child: GestureDetector(
                                                onTap: widget._screenName
                                                        .toLowerCase()
                                                        .contains('splash')
                                                    ? () {
                                                        ApiCalls
                                                            .saveSelectedStore(
                                                                value: e.id
                                                                    .toString());
                                                        Navigator
                                                            .pushAndRemoveUntil(
                                                                context,
                                                                CupertinoPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          MyApp(),
                                                                ),
                                                                (route) => false);
                                                      }
                                                    : () {
                                                  ApiCalls
                                                      .saveSelectedStore(
                                                      value: e.id
                                                          .toString());
                                                        RestartWidget.restartApp(
                                                            context);
                                                      },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              14),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.white
                                                              .withOpacity(0.8),
                                                          offset: const Offset(
                                                              -6.0, -6.0),
                                                          blurRadius: 10.0,
                                                        ),
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(0.2),
                                                          offset: const Offset(
                                                              6.0, 6.0),
                                                          blurRadius: 13.0,
                                                        ),
                                                      ],
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        vertical: 5.w,
                                                        horizontal: 6.w,
                                                      ),
                                                      child: Center(
                                                        child: AutoSizeText(
                                                          e.name,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 3.5.w,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ),
                                    )
                                    .toList(growable: true),
                              ),
                            ),
                            Positioned(
                              top: 1,
                              child: Container(
                                width: 100.w,
                                color: Colors.grey.shade200,
                                padding: EdgeInsets.all(2.h),
                                child: Center(
                                  child: AutoSizeText(
                                    'Select Your Store',
                                    style: TextStyle(
                                        shadows: <Shadow>[
                                          Shadow(
                                            offset: const Offset(1.0, 1.2),
                                            blurRadius: 3.0,
                                            color: Colors.grey.shade300,
                                          ),
                                          Shadow(
                                            offset: const Offset(1.0, 1.2),
                                            blurRadius: 8.0,
                                            color: Colors.grey.shade300,
                                          ),
                                        ],
                                        fontSize: 5.w,
                                        fontWeight: FontWeight.bold),
                                    softWrap: true,
                                  ),
                                ),
                               ),
                            ),
                            Positioned(
                              bottom: 1,
                              child: Container(
                                width: 100.w,
                                color: Colors.grey.shade200,
                                padding: EdgeInsets.all(2.h),
                                child: Center(
                                  child: AutoSizeText(
                                    'Please note\: We currently only offer shipping and delivery within the UAE, Kuwait and Bahrain.',
                                    style: TextStyle(
                                        shadows: <Shadow>[
                                          Shadow(
                                            offset: const Offset(1.0, 1.2),
                                            blurRadius: 3.0,
                                            color: Colors.grey.shade300,
                                          ),
                                          Shadow(
                                            offset: const Offset(1.0, 1.2),
                                            blurRadius: 8.0,
                                            color: Colors.grey.shade300,
                                          ),
                                        ],
                                        fontSize: 3.w,
                                        fontWeight: FontWeight.bold),
                                    softWrap: true,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    })),
          ),
        ),
      ),
    );
  }

  void _checkingStoreSelection() async {
  
    _id = await secureStorage.read(key: kselectedStoreIdKey) ?? '';
    log('store id' + _id);
    setState(() {});
    if (await secureStorage.read(key: kselectedStoreIdKey) == null || _id.isEmpty) {
    } else {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) => MyApp()),
      );
    }
  }
}
