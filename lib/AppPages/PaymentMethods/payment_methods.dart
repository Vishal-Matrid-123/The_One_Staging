import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:progress_loading_button/progress_loading_button.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/WebxxViewxx/PaymentWebView.dart';
import 'package:untitled2/AppPages/models/OrderSummaryResponse.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Widgets/CustomButton.dart';
import 'package:untitled2/new_apis_func/data_layer/constant_data/constant_data.dart';
import 'package:untitled2/new_apis_func/presentation_layer/provider_class/provider_contracter.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';

class PaymentMethodxx extends StatefulWidget {
  const PaymentMethodxx({Key? key, required this.isPaymentFail, required this.failWarning}) : super(key: key);

  final bool isPaymentFail;
  final String failWarning;

  @override
  State<PaymentMethodxx> createState() {
    return _PaymentMethodxxState();
  }
}

class _PaymentMethodxxState extends State<PaymentMethodxx> {
  var _apiProvider = NewApisProvider();
  List<bool> selector = [false];
  int selectedValue = 0;
  bool isPaymentFail = true;

  @override
  void initState() {
    _apiProvider = Provider.of<NewApisProvider>(context, listen: false);
    _apiProvider.getPaymentMethods().whenComplete(() {
      setState(() {
        selector =
            List.generate(_apiProvider.paymentMethods.length, (index) => false);
      });
      log("$selector");
    });
    _apiProvider.getOrderSummary();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      maintainBottomViewPadding: true,
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 18.w,
            backgroundColor: ConstantsVar.appColor,
            title: InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => MyHomePage(
                        pageIndex: 0,
                      ),
                    ),
                    (route) => false);
              },
              child: Image.asset(
                'MyAssets/logo.png',
                width: 15.w,
                height: 15.w,
              ),
            ),
            centerTitle: true,
          ),
          body: buildPage(context)),
    );
  }

  Widget buildPage(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Card(
            child: SizedBox(
              width: 100.w,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Center(
                    child: AutoSizeText(
                  'Payment Method'.toUpperCase(),
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
                  ], fontSize: 5.w, fontWeight: FontWeight.bold),
                )),
              ),
            ),
          ),
          Consumer<NewApisProvider>(
            builder: (_, value, child) => value.loading == true
                ? const Center(
                    child: SpinKitRipple(
                      size: 40,
                      color: ConstantsVar.appColor,
                    ),
                  )
                : value.isSelectShippingZonesScreenError == false
                    ? SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(left: 10.0),
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: AutoSizeText(
                                    'Select a Payment Method',
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
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: isPaymentFail,
                                child: Visibility(
                                    visible: widget.isPaymentFail,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: AutoSizeText(widget.failWarning, textAlign: TextAlign.center,style: TextStyle(fontSize: 4.5.w, color: Colors.red),),
                                    )),
                              ),
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: value.paymentMethods.length ?? 0,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isPaymentFail = false;
                                      });
                                      if (index == 0) {
                                        for (int i = 1;
                                            i < value.paymentMethods.length;
                                            i++) {
                                          setState(() {
                                            selector[index] = true;
                                            selector[index + i] = false;
                                          });
                                        }
                                      } else if (index ==
                                          value.paymentMethods.length - 1) {
                                        for (int i = 1;
                                            i < value.paymentMethods.length;
                                            i++) {
                                          setState(() {
                                            selector[index] = true;
                                            selector[index - i] = false;
                                          });
                                        }
                                      } else if (index > 0 &&
                                          index <
                                              value.paymentMethods.length - 1) {
                                        for (int i = 1; i < index + 1; i++) {
                                          setState(() {
                                            selector[index] = true;
                                            selector[index - i] = false;
                                          });
                                        }
                                        for (int i = 1;
                                            i <
                                                value.paymentMethods.length -
                                                    index;
                                            i++) {
                                          setState(() {
                                            selector[index] = true;
                                            selector[index + i] = false;
                                          });
                                        }
                                      }
                                      setState(() {
                                        selectedValue = index;
                                      });
                                      log("$selector");
                                      log("$index");
                                    },
                                    child: Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      color: Colors.white,
                                      child: Container(
                                          margin: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            bottom: 3.2,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 1.h, 0, 1.h),
                                                child: SizedBox(
                                                  height: 15.h,
                                                  width: 85.w,
                                                  child: FittedBox(
                                                    child: Image.network(value
                                                        .paymentMethods[index]
                                                        .logoUrl),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 1.h),
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 5.w,
                                                          right: 12.w),
                                                      child: Container(
                                                        height: 3.h,
                                                        width: 3.h,
                                                        decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black)),
                                                        child: Center(
                                                          child: Container(
                                                            height: 2.h,
                                                            width: 2.h,
                                                            decoration: BoxDecoration(
                                                                color: selector[
                                                                        index]
                                                                    ? ConstantsVar
                                                                        .appColor
                                                                    : Colors
                                                                        .transparent,
                                                                shape: BoxShape
                                                                    .circle,
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .transparent)),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    AutoSizeText(
                                                      value
                                                          .paymentMethods[index]
                                                          .name,
                                                      style: TextStyle(
                                                          fontSize: 5.w),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 1.h),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    AutoSizeText(
                                                      value
                                                          .paymentMethods[index]
                                                          .description,
                                                      style: TextStyle(
                                                          fontSize: 2.5.w),
                                                      maxLines: 2,
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          )),
                                    ),
                                  );
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 2.h, 0, 1.h),
                                child: Container(
                                  color: ConstantsVar.appColor,
                                  width: 100.w,
                                  child: Center(
                                    child: LoadingButton(
                                      width: 100.w,
                                      loadingWidget: const SpinKitCircle(
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                      onPressed: () async {
                                        CustomProgressDialog _dialog =
                                            CustomProgressDialog(
                                          context,
                                          loadingWidget: const SpinKitRipple(
                                            color: Colors.red,
                                            size: 40,
                                          ),
                                          dismissable: false,
                                        );
                                        _dialog.show();
                                        String baseUrl =
                                            await ApiCalls.getSelectedStore();
                                        String customerId = ConstantsVar.prefs
                                                .getString(kcustomerIdKey) ??
                                            "";
                                        String apiToken = ConstantsVar.prefs
                                                .getString(kapiTokenKey) ??
                                            "";
                                        String storeId =
                                            await secureStorage.read(
                                                    key: kselectedStoreIdKey) ??
                                                '1';
                                        if (selector.every((e) => e == false)) {
                                          Fluttertoast.showToast(
                                              msg:
                                                  'Please select a Payment Method first',
                                              toastLength: Toast.LENGTH_LONG);
                                          _dialog.dismiss();
                                        } else {
                                          _dialog.dismiss();
                                          await Future.delayed(
                                              const Duration(
                                                  milliseconds: 1000), () async {
                                             Navigator.pushReplacement(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) =>
                                                    PaymentPage(
                                                      baseUrl: baseUrl.replaceAll(
                                                          '/apisSecondVer',
                                                          '') +
                                                          'AppCustomerSecondVer/CreateCustomerOrder?',
                                                      storeId: storeId,
                                                      customerId: customerId,
                                                      apiToken: apiToken,
                                                      paymentMethod: value
                                                          .paymentMethods[
                                                      selectedValue]
                                                          .paymentMethodSystemName,
                                                      isRepayment: false,
                                                    ),
                                              ),
                                            )    ;
                                       

                                          });
                                        }
                                      },
                                      defaultWidget: AutoSizeText(
                                        'Confirm'.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 5.w,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      color: ConstantsVar.appColor,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Card(
                                    color: Colors.white60,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: AutoSizeText(
                                          'Order Summary',
                                          style: TextStyle(
                                              shadows: <Shadow>[
                                                Shadow(
                                                  offset:
                                                      const Offset(1.0, 1.2),
                                                  blurRadius: 3.0,
                                                  color: Colors.grey.shade300,
                                                ),
                                                Shadow(
                                                  offset:
                                                      const Offset(1.0, 1.2),
                                                  blurRadius: 8.0,
                                                  color: Colors.grey.shade300,
                                                ),
                                              ],
                                              fontSize: 5.w,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.all(8.0),
                                  itemCount: value.orderedList.length,
                                  itemBuilder: (context, index) {
                                    return cartItemView(
                                        value.orderedList[index]);
                                  }),
                              Card(
                                elevation: 10,
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFEEEEEE),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const AutoSizeText(
                                              'Sub-Total:',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 15,
                                              ),
                                            ),
                                            AutoSizeText(
                                              value.orderSummaryTotal.subTotal
                                                      .toString() ??
                                                  "No Info available",
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const AutoSizeText(
                                              'Shipping:',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 15,
                                              ),
                                            ),
                                            AutoSizeText(
                                              value.orderSummaryTotal
                                                          .shipping ==
                                                      ""
                                                  ? 'During Checkout'
                                                  : value.orderSummaryTotal
                                                      .shipping
                                                      .toString(),
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 15,
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const AutoSizeText(
                                              'Discount:',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 14,
                                              ),
                                            ),
                                            AutoSizeText(
                                              value.orderSummaryTotal
                                                      .orderTotalDiscount ??
                                                  "No Info available",
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4.0, right: 4.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const AutoSizeText(
                                              'Tax 5%:',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 14,
                                              ),
                                            ),
                                            AutoSizeText(
                                              value.orderSummaryTotal.tax ??
                                                  "No Info available",
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const AutoSizeText(
                                              'Total:',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 14,
                                              ),
                                            ),
                                            AutoSizeText(
                                              value.orderSummaryTotal
                                                          .orderTotal ==
                                                      ""
                                                  ? 'During Checkout'
                                                  : value.orderSummaryTotal
                                                      .orderTotal,
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                                  await _apiProvider.getPaymentMethods(),
                              child: const Text("Retry"),
                            ),
                          ],
                        ),
                      ),
          )
        ],
      ),
    );
  }

  Card cartItemView(OrderedItems item) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: Row(
          children: <Widget>[
            Container(
                margin:
                    const EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                width: 80,
                height: 80,
                child: CachedNetworkImage(
                  imageUrl: item.picture.imageUrl,
                  fit: BoxFit.cover,
                )),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(right: 8, top: 4),
                      child: AutoSizeText(
                        item.picture.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: CustomTextStyle.textFormFieldSemiBold
                            .copyWith(fontSize: 3.w),
                      ),
                    ),
                    Utils.getSizedBox(null, 6),
                    AutoSizeText(
                      "SKU : ${item.sku}",
                      style: CustomTextStyle.textFormFieldRegular
                          .copyWith(color: Colors.grey, fontSize: 2.8.w),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: AutoSizeText(
                            item.unitPrice,
                            overflow: TextOverflow.ellipsis,
                            style: CustomTextStyle.textFormFieldBlack
                                .copyWith(color: Colors.green),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                color: Colors.grey.shade200,
                                padding: const EdgeInsets.only(
                                    bottom: 2, right: 12, left: 12),
                                child: AutoSizeText(
                                  "${item.quantity}",
                                  style: CustomTextStyle.textFormFieldSemiBold,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
