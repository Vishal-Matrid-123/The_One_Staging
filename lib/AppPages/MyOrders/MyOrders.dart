import 'dart:convert';
import 'dart:io' show Platform;

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:progress_loading_button/progress_loading_button.dart';
import 'package:provider/provider.dart';
// import 'package:untitled2/AppPages/CartxxScreen/ConstantVariables.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/MyAccount/MyAccount.dart';
import 'package:untitled2/AppPages/ReturnScreen/ReturnScreen.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Widgets/CustomButton.dart';
import 'package:untitled2/new_apis_func/presentation_layer/provider_class/provider_contracter.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';

import '../../new_apis_func/data_layer/constant_data/constant_data.dart';
import 'OrderDetails.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({Key? key, required this.isFromWeb}) : super(key: key);
  final bool isFromWeb;

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> with WidgetsBindingObserver {
  var apiToken;
  var customerId;
  var orders = {};
  var orderDate;

  bool isVisible = true;

  var _apiProvider = NewApisProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiProvider = Provider.of<NewApisProvider>(context, listen: false);
    _apiProvider.getMyOrders();
    WidgetsBinding.instance?.addObserver(this);
  }

  var _color;
  bool _willGo = true;

  @override
  Widget build(BuildContext context) {
    Future<bool> _willGoBack() async {
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => const MyAccount()),
          (route) => false);
      setState(() {
        _willGo = true;
      });
      return _willGo;
    }

    return WillPopScope(
      onWillPop: _willGo ? _willGoBack : () async => false,
      child: SafeArea(
          top: true,
          bottom: true,
          maintainBottomViewPadding: true,
          child: Scaffold(
            appBar: AppBar(
              leading: Platform.isAndroid
                  ? InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const MyAccount()),
                            (route) => false);
                      },
                      child: const Icon(Icons.arrow_back))
                  : InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const MyAccount()),
                            (route) => false);
                      },
                      child: const Icon(Icons.arrow_back_ios)),
              backgroundColor: ConstantsVar.appColor,
              toolbarHeight: 18.w,
              centerTitle: true,
              title: InkWell(
                onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => MyApp(),
                    ),
                    (route) => false),
                child: Image.asset(
                  'MyAssets/logo.png',
                  width: 15.w,
                  height: 15.w,
                ),
              ),
            ),
            body: Consumer<NewApisProvider>(
              builder: (_, value, child) => value.loading == true
                  ? const Center(
                      child: SpinKitRipple(
                        size: 40,
                        color: ConstantsVar.appColor,
                      ),
                    )
                  : value.isMyOrderScreenError == false
                      ? value.orders.isEmpty
                          ? SizedBox(
                              width: 100.w,
                              height: 70.h,
                              child: Center(
                                child: AnimatedTextKit(
                                  repeatForever: true,
                                  animatedTexts: [
                                    ColorizeAnimatedText(
                                      'No Orders Here',
                                      textStyle: colorizeTextStyle,
                                      colors: colorizeColors,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : SizedBox(
                              width: 100.w,
                              height: 100.h,
                              child: Stack(
                                children: [
                                  SizedBox(
                                    width: 100.w,
                                    height: 100.h,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: SizedBox(
                                            width: 100.w,
                                            child: Center(
                                              child: AutoSizeText(
                                                'MY ORDERS',
                                                style: TextStyle(
                                                    shadows: <Shadow>[
                                                      Shadow(
                                                        offset: const Offset(
                                                            1.0, 1.2),
                                                        blurRadius: 3.0,
                                                        color: Colors
                                                            .grey.shade300,
                                                      ),
                                                      Shadow(
                                                        offset: const Offset(
                                                            1.0, 1.2),
                                                        blurRadius: 8.0,
                                                        color: Colors
                                                            .grey.shade300,
                                                      ),
                                                    ],
                                                    fontSize: 5.w,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: isVisible,
                                          child: Expanded(
                                            child: ListView(
                                              children: List.generate(
                                                value.orders.length,
                                                (index) {
                                                  if (value.orders.isEmpty) {
                                                    return Container(
                                                        child: const AutoSizeText(
                                                            'No Orders found.'));
                                                  } else {
                                                    orderDate =
                                                        '${value.orders[index].createdOn}';
                                                    var resultDate = orderDate
                                                        .toString()
                                                        .replaceAll('T', '  ')
                                                        .toString()
                                                        .splitBefore('.');
                                                    if (value.orders[index]
                                                        .orderStatus
                                                        .toString()
                                                        .contains('Pending')) {
                                                      _color =
                                                          Colors.amberAccent;
                                                    } else if (value
                                                        .orders[index]
                                                        .orderStatus
                                                        .toString()
                                                        .contains(
                                                            'Cancelled')) {
                                                      _color = Colors.red;
                                                    } else {
                                                      _color = Colors.green;
                                                    }

                                                    return Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 4.0),
                                                      child: Card(
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                                // borderRadius:
                                                                ),
                                                        child: Container(
                                                          // height: 35.h,
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      3.0,
                                                                  vertical: 2),
                                                          child: Container(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Center(
                                                                  child:
                                                                      AutoSizeText(
                                                                    '\nORDER NUMBER\n ' +
                                                                        value
                                                                            .orders[index]
                                                                            .customOrderNumber
                                                                            .toString()
                                                                            .toUpperCase(),
                                                                    // maxLines: 1,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    textDirection:
                                                                        TextDirection
                                                                            .ltr,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    softWrap:
                                                                        true,
                                                                    // textAlign: TextAlign.center,
                                                                    style: CustomTextStyle
                                                                        .textFormFieldBold
                                                                        .copyWith(
                                                                            fontSize:
                                                                                5.5.w),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),
                                                                Container(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          10),
                                                                  height: 30.w,
                                                                  width: 100.w,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      RichText(
                                                                        text:
                                                                            TextSpan(
                                                                          text:
                                                                              'Order Status: ',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                5.w,
                                                                            // fontWeight:
                                                                            //     FontWeight.bold,
                                                                          ),
                                                                          children: <
                                                                              TextSpan>[
                                                                            TextSpan(
                                                                              text: value.orders[index].orderStatus.toString().toUpperCase(),
                                                                              style: TextStyle(
                                                                                color: _color,
                                                                                fontSize: 5.w,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Utils.getSizedBox(
                                                                          null,
                                                                          3),
                                                                      AutoSizeText(
                                                                        'Order Date: ' +
                                                                            resultDate,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              5.w,
                                                                        ),
                                                                      ),
                                                                      Utils.getSizedBox(
                                                                          null,
                                                                          3),
                                                                      AutoSizeText(
                                                                        'Order Total: ' +
                                                                            value.orders[index].orderTotal,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              5.w,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 15,
                                                                ),
                                                                Container(
                                                                  color: ConstantsVar
                                                                      .appColor,
                                                                  width: 100.w,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          8.0,
                                                                      vertical:
                                                                          8.0,
                                                                    ),
                                                                    child:
                                                                        LoadingButton(
                                                                      type: LoadingButtonType
                                                                          .Flat,
                                                                      loadingWidget:
                                                                          const SpinKitCircle(
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            30,
                                                                      ),
                                                                      color: ConstantsVar
                                                                          .appColor,
                                                                      defaultWidget:
                                                                          AutoSizeText(
                                                                        'Details'
                                                                            .toUpperCase(),
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              4.4.w,
                                                                        ),
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        log('${value.orders[index].customOrderNumber.toString()}');
                                                                        await getOderDetails(
                                                                                orderid: value.orders[index].id.toString(),
                                                                                apiToekbn: apiToken,
                                                                                customerId: customerId)
                                                                            .then(
                                                                          (_value) =>
                                                                              Navigator.push(
                                                                            context,
                                                                            CupertinoPageRoute(
                                                                              builder: (context) => OrderDetails(
                                                                                orderNumber: '\nORDER  # ${value.orders[index].customOrderNumber.toString()}',
                                                                                orderProgress: value.orders[index].orderStatus.toString(),
                                                                                orderTotal: 'Order Total: ' + value.orders[index].orderTotal,
                                                                                orderDate: 'Order Date: ' + resultDate,
                                                                                color: _color,
                                                                                resultas: _value,
                                                                                orderId: value.orders[index].id.toString(),
                                                                                apiToken: apiToken,
                                                                                customerId: customerId,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                                const Visibility(
                                                                  visible:
                                                                      false,
                                                                  child:
                                                                      SizedBox(
                                                                    height: 15,
                                                                  ),
                                                                ),
                                                                Visibility(
                                                                  visible:
                                                                      false,
                                                                  child:
                                                                      Container(
                                                                    color: ConstantsVar
                                                                        .appColor,
                                                                    width:
                                                                        100.w,
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .symmetric(
                                                                        horizontal:
                                                                            8.0,
                                                                        vertical:
                                                                            8.0,
                                                                      ),
                                                                      child:
                                                                          LoadingButton(
                                                                        type: LoadingButtonType
                                                                            .Flat,
                                                                        loadingWidget:
                                                                            const SpinKitCircle(
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              30,
                                                                        ),
                                                                        color: ConstantsVar
                                                                            .appColor,
                                                                        defaultWidget:
                                                                            AutoSizeText(
                                                                          'Return'
                                                                              .toUpperCase(),
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                4.4.w,
                                                                          ),
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          Navigator
                                                                              .push(
                                                                            context,
                                                                            CupertinoPageRoute(
                                                                              builder: (context) => ReturnScreen(
                                                                                orderId: orders['customerorders']['Orders'][index]['Id'].toString(),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              AutoSizeText(
                                kerrorString,
                                style: TextStyle(shadows: <Shadow>[
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
                                ], fontSize: 18, fontWeight: FontWeight.bold),
                                softWrap: true,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              ElevatedButton(
                                onPressed: () async =>
                                    await _apiProvider.getMyOrders(),
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        ),
            ),
          )),
    );
  }

  Future getOderDetails({
    required String orderid,
    required String apiToekbn,
    required String customerId,
  }) async {
    log('Order Id =====>>>>>>> ' + orderid);

    final uri = Uri.parse(await ApiCalls.getSelectedStore() +
        "GetCustomerOrderDetail?apiToken=${ConstantsVar.prefs.getString(kapiTokenKey)}&customerId=${ConstantsVar.prefs.getString(kcustomerIdKey)}&orderid=$orderid&$kStoreIdVar=${await secureStorage.read(key: kselectedStoreIdKey) ?? "1"}");
    log(uri);
    var response = await get(uri, headers: ApiCalls.header);

    try {
      var result = jsonDecode(response.body);
      log(response.body);

      return result;
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  final colorizeTextStyle =
      TextStyle(fontSize: 6.w, fontWeight: FontWeight.bold);

  final colorizeColors = [
    Colors.lightBlueAccent,
    Colors.grey,
    Colors.black,
    ConstantsVar.appColor,
  ];
}
