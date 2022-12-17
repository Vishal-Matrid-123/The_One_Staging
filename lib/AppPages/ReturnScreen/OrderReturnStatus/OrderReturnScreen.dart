import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/ReturnScreen/OrderReturnStatus/OrderReturStatusResponse.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Widgets/CustomButton.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

import '../../../new_apis_func/data_layer/constant_data/constant_data.dart';

class OrderReturnDetailScreen extends StatefulWidget {
  const OrderReturnDetailScreen({Key? key}) : super(key: key);

  @override
  _OrderReturnDetailScreenState createState() =>
      _OrderReturnDetailScreenState();
}

class _OrderReturnDetailScreenState extends State<OrderReturnDetailScreen> {
  OrderReturnStatusResponse? orderReturnStatusResponse;
  List<ReturnedItem> mList = [];

  bool isLoading = false;
  bool isError = false;

  final colorizeTextStyle =
      TextStyle(fontSize: 6.w, fontWeight: FontWeight.bold);

  final colorizeColors = [
    Colors.lightBlueAccent,
    Colors.grey,
    Colors.black,
    ConstantsVar.appColor,
  ];

  final _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getRetrunableItems();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ConstantsVar.appColor,
            title: InkWell(
              onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => MyHomePage(
                      pageIndex: 0,
                    ),
                  ),
                  (route) => false),
              child: Image.asset(
                'MyAssets/logo.png',
                width: 15.w,
                height: 15.w,
              ),
            ),
            centerTitle: true,
            toolbarHeight: 18.w,
          ),
          body: isLoading
              ? const Center(
                  child: SpinKitRipple(
                    color: Colors.red,
                    size: 90,
                  ),
                )
              : isError
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            kerrorString,
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
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: true,
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                            onPressed: () async => getRetrunableItems(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : mList.isEmpty
                      ? Center(
                          child: AnimatedTextKit(
                            repeatForever: true,
                            animatedTexts: [
                              ColorizeAnimatedText(
                                'No Data Available',
                                textStyle: colorizeTextStyle,
                                colors: colorizeColors,
                              ),
                            ],
                          ),
                        )
                      : SizedBox(
                          height: 100.h,
                          width: 100.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ListTile(
                                title: Center(
                                  child: AutoSizeText(
                                    'RETURN REQUESTS',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 6.w,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: VsScrollbar(
                                  controller: _scrollController,
                                  isAlwaysShown: true,
                                  child: ListView.builder(
                                    controller: _scrollController,
                                    itemCount: mList.length,
                                    itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Card(
                                        shape: const RoundedRectangleBorder(
                                            // borderRadius:
                                            ),
                                        child: Container(
                                          // height: 35.h,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 3.0, vertical: 2),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Center(
                                                child: AutoSizeText(
                                                  '\nRETURN # ' +
                                                      mList[index]
                                                          .id
                                                          .toString()
                                                          .toUpperCase() +
                                                      ' - ' +
                                                      mList[index]
                                                          .returnRequestStatus
                                                          .toString()
                                                          .toUpperCase(),
                                                  // maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                  textDirection:
                                                      TextDirection.ltr,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                  // textAlign: TextAlign.center,
                                                  style: CustomTextStyle
                                                      .textFormFieldBold
                                                      .copyWith(
                                                          fontSize: 5.5.w),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                // height: 40.w,
                                                width: 100.w,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Utils.getSizedBox(null, 3),
                                                    RichText(
                                                      text: TextSpan(
                                                        text: 'Returned Item: ',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 4.w,
                                                          // fontWeight:
                                                          //     FontWeight.bold,
                                                        ),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: mList[index]
                                                                .productName
                                                                .toString()
                                                                .toUpperCase(),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 3.5.w,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,

                                                              // fontWeight:
                                                              //     FontWeight
                                                              //         .bold,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: ' x' +
                                                                mList[index]
                                                                    .quantity
                                                                    .toString()
                                                                    .toUpperCase(),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 3.5.w,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Utils.getSizedBox(null, 6),
                                                    AutoSizeText(
                                                      'Return Reason: ' +
                                                          mList[index]
                                                              .returnReason
                                                              .toString(),
                                                      style: TextStyle(
                                                        fontSize: 4.w,

                                                        // fontWeight:
                                                        //     FontWeight.bold,
                                                      ),
                                                    ),
                                                    Utils.getSizedBox(null, 6),
                                                    AutoSizeText(
                                                      'Return Action: ' +
                                                          mList[index]
                                                              .returnAction,
                                                      style: TextStyle(
                                                        fontSize: 4.w,

                                                        // fontWeight:
                                                        //     FontWeight.bold,
                                                      ),
                                                    ),
                                                    Utils.getSizedBox(null, 6),
                                                    AutoSizeText(
                                                      'Date Requested: ' +
                                                          mList[index]
                                                              .createdOn
                                                              .toIso8601String(),
                                                      style: TextStyle(
                                                        fontSize: 4.w,

                                                        // fontWeight:
                                                        //     FontWeight.bold,
                                                      ),
                                                    ),
                                                    Utils.getSizedBox(null, 20),
                                                    AutoSizeText(
                                                      'Your Comments:\n'
                                                      '${mList[index].comments == null ? '' : mList[index].comments.toString()}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 4.w,

                                                        // fontWeight:
                                                        //     FontWeight.bold,
                                                      ),
                                                    ),
                                                    Utils.getSizedBox(null, 10),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
        ));
  }

  void getRetrunableItems() async {
    setState(() {
      isLoading = true;
      isError = false;
    });
    // log(apiToken.toString() + '<<<<<<UserID>>>>>' + customerId.toString());
    final url = Uri.parse(await ApiCalls.getSelectedStore() +
        'GetReturnRequests?apiToken=${ConstantsVar.prefs.getString(kapiTokenKey)}&customerid=${ConstantsVar.prefs.getString(kcustomerIdKey)}&$kStoreIdVar=${await secureStorage.read(key: kselectedStoreIdKey) ?? "1"}');

    log(url.toString());
    try {
      var response = await get(
        url,
        headers: ApiCalls.header,
      );
      String jsonResult = response.body;
      log(jsonResult);
      if (response.statusCode == 200) {
        if (jsonDecode(jsonResult)["status"].toString().toLowerCase() ==
            kstatusSuccess) {
          setState(() {
            orderReturnStatusResponse =
                OrderReturnStatusResponse.fromJson(jsonDecode(jsonResult));
            mList = orderReturnStatusResponse!.returnrequests.items;
            isError = false;
            isLoading = false;
          });
        } else {
          Fluttertoast.showToast(
            msg: jsonDecode(jsonResult)["Message"],
            toastLength: Toast.LENGTH_LONG,
          );
          isError = true;
          isLoading = false;
          setState(() {});
        }
      } else {
        Fluttertoast.showToast(
          msg: kerrorString + " Status Code: " + response.statusCode.toString(),
          toastLength: Toast.LENGTH_LONG,
        );
        isError = true;
        isLoading = false;
        setState(() {});
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      log(e.toString());
      isError = true;
      isLoading = false;
      setState(() {});
    }
  }
}
