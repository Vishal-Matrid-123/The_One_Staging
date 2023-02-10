import 'dart:convert';
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
import 'package:untitled2/AppPages/PaymentMethods/payment_methods.dart';
import 'package:untitled2/AppPages/models/OrderSummaryResponse.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Widgets/CustomButton.dart';
import 'package:untitled2/new_apis_func/data_layer/constant_data/constant_data.dart';
import 'package:untitled2/new_apis_func/presentation_layer/provider_class/provider_contracter.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';

class SelectShippingZone extends StatefulWidget {
  const SelectShippingZone({Key? key}) : super(key: key);

  @override
  State<SelectShippingZone> createState() {
    return _SelectShippingZoneState();
  }
}

class _SelectShippingZoneState extends State<SelectShippingZone> {
  var _apiProvider = NewApisProvider();
  String selectedValue = "";
  String zoneId = "1";
  List<ZoneModel> zoneModelList = [];
  bool nextVisible = false;
  bool orderSummaryVisible = false;
  bool spinVisible = false;

  @override
  void initState() {
    _apiProvider = Provider.of<NewApisProvider>(context, listen: false);
    _apiProvider.getShippingZones();
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
          body: buildPage(context),
        ));
  }

  Widget buildPage(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
                  'Shipping Zone'.toUpperCase(),
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
                    ? Padding(
                      padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10.0),
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: AutoSizeText(
                                'Select a Shipping Zone',
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
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 1.h, 0, 0),
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: Colors.white,
                              child: Container(
                                  margin: const EdgeInsets.only(
                                    left: 5,
                                    right: 5,
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
                                            0, 3.h, 0, nextVisible == true ? 0 : 3.h),
                                        child: Container(
                                          height: 9.h,
                                          width: 100.w,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.all(8.0),
                                            child:
                                                DropdownButtonHideUnderline(
                                              child: ButtonTheme(
                                                alignedDropdown: true,
                                                padding: EdgeInsets.only(top: 20.h),
                                                child: DropdownButton2(
                                                  dropdownMaxHeight: 50.h,
                                                  hint: Center(
                                                    child: AutoSizeText(
                                                      'Select your Area',
                                                      style: TextStyle(
                                                        fontSize: 4.7.w,
                                                        color:
                                                            Theme.of(context)
                                                                .hintColor,
                                                      ),
                                                    ),
                                                  ),
                                                  items: value.zoneModelList
                                                      .map(
                                                        (item) =>
                                                            DropdownMenuItem<
                                                                String>(
                                                          value:
                                                              "${item.key}",
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  AutoSizeText(
                                                                    item.zoneName,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize: item.zoneName.length > 30 ?  item.zoneName.length > 33 ? 3.4.w : 4.3.w : 4.5.w,
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment.end,
                                                                      children: [
                                                                        AutoSizeText(
                                                                          "${item.shippingCharge}",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize: 4.5.w,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Divider()
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                                  selectedItemBuilder:
                                                      (context) {
                                                    return value.zoneModelList
                                                        .map(
                                                          (e) => Center(
                                                            child:
                                                                AutoSizeText(
                                                              e.zoneName
                                                                  .replaceAll(
                                                                      "   ",
                                                                      ""),
                                                              style:
                                                                  TextStyle(
                                                                fontSize:
                                                                    4.45.w,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                        .toList();
                                                  },
                                                  value:
                                                      selectedValue.isNotEmpty
                                                          ? selectedValue
                                                          : null,
                                                  onChanged: (value) async {
                                                    setState(() {
                                                      orderSummaryVisible =
                                                          false;
                                                      spinVisible = false;
                                                    });
                                                    await saveZoneID(value!)
                                                        .then((value) {
                                                      selectShippingZone(
                                                              zoneId)
                                                          .whenComplete(() {
                                                            setState(() {
                                                              spinVisible = true;
                                                            });
                                                            return _apiProvider
                                                                  .getOrderSummary()
                                                                  .whenComplete(
                                                                      () {
                                                                setState(() {
                                                                  orderSummaryVisible =
                                                                      true;
                                                                  nextVisible =
                                                                      true;
                                                                });
                                                              });
                                                          });
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                              visible: nextVisible,
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.fromLTRB(
                                                        0, 4.h, 0, 2.h),
                                                child: Container(
                                                  color:
                                                      ConstantsVar.appColor,
                                                  width: 100.w,
                                                  child: Center(
                                                    child: LoadingButton(
                                                      width: 100.w,
                                                      loadingWidget:
                                                          const SpinKitCircle(
                                                        color: Colors.white,
                                                        size: 30,
                                                      ),
                                                      onPressed: () async {
                                                        CustomProgressDialog
                                                            _dialog =
                                                            CustomProgressDialog(
                                                          context,
                                                          loadingWidget:
                                                              const SpinKitRipple(
                                                            color:
                                                                Colors.red,
                                                            size: 40,
                                                          ),
                                                          dismissable:
                                                              false,
                                                        );
                                                        _dialog.show();
                                                        await Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    1000),
                                                            () {
                                                          Navigator
                                                              .pushReplacement(
                                                            context,
                                                            CupertinoPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      PaymentMethodxx(isPaymentFail: false, failWarning: '',),
                                                            ),
                                                          ).whenComplete(
                                                              () => _dialog
                                                                  .dismiss());
                                                        });
                                                      },
                                                      defaultWidget:
                                                          AutoSizeText(
                                                        "Next",
                                                        style: TextStyle(
                                                            fontSize: 5.w,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                            color: Colors
                                                                .white),
                                                      ),
                                                      color: ConstantsVar
                                                          .appColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ],
                                  )),
                            ),
                          ),
                          orderSummaryVisible == false
                              ? Visibility(
                                  visible: spinVisible,
                                  child: const Center(
                                    child: SpinKitRipple(
                                      size: 40,
                                      color: ConstantsVar.appColor,
                                    ),
                                  ),
                                )
                              : Visibility(
                                  visible: orderSummaryVisible,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(top: 30.0),
                                    child: Card(
                                        color: Colors.white60,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: AutoSizeText(
                                              'Order Summary',
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
                                        )),
                                  ),
                                ),
                          Visibility(
                            visible: orderSummaryVisible,
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics:
                                    const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(8.0),
                                itemCount: value.orderedList.length,
                                itemBuilder: (context, index) {
                                  return cartItemView(
                                      value.orderedList[index]);
                                }),
                          ),
                          Visibility(
                            visible: orderSummaryVisible,
                            child: Card(
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
                                                "No Infor available",
                                            style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 15,
                                                fontWeight:
                                                    FontWeight.bold),
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
                                                fontWeight:
                                                    FontWeight.bold),
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
                                                fontWeight:
                                                    FontWeight.bold),
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
                                                fontWeight:
                                                    FontWeight.bold),
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
                                                fontWeight:
                                                    FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                                  await _apiProvider.getShippingZones(),
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

  Future<String> saveZoneID(Object value) async {
    setState(() {
      selectedValue = value as String;
      zoneId = _apiProvider
          .zoneModelList[int.parse(selectedValue == "" ? "0" : selectedValue)]
          .zoneId;
    });
    log("zoneId $zoneId");
    return zoneId;
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

  Future<void> selectShippingZone(String zoneId) async {
    String _baseUrl = await ApiCalls.getSelectedStore();
    CustomProgressDialog _progressDialog = CustomProgressDialog(context,
        loadingWidget: const SpinKitRipple(
          color: ConstantsVar.appColor,
          size: 40,
        ),
        dismissable: false);
    _progressDialog.show();
    final uri = Uri.parse(_baseUrl.replaceAll(
            "apisSecondVer", "ApisSecondVer") +
        kselect_shipping_zone_url +
        "apiToken=${ConstantsVar.prefs.getString(kapiTokenKey)}&CustomerId=${ConstantsVar.prefs.getString(kcustomerIdKey)}&$kStoreIdVar=${await secureStorage.read(key: kselectedStoreIdKey) ?? "1"}&zoneId=$zoneId");
    log("SelectShippingZone Url :- ${uri.toString()}");

    try {
      var response = await http.get(uri, headers: {
        'Cookie': '.Nop.Customer=${ConstantsVar.prefs.getString(kguidKey)}',
      }).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          Fluttertoast.showToast(msg: "Connection Timeout.\nPlease try again.");
          return http.Response('Error', 408);
        },
      );
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['Status'].toString().toLowerCase() ==
            kstatusFailed) {
          _progressDialog.dismiss();
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['Message'].toString());
        } else {
          _progressDialog.dismiss();
          Fluttertoast.showToast(
              msg: jsonDecode(response.body)['Message'].toString());
          log("Select Shipping Zones Api " + response.body);
        }
      } else {
        _progressDialog.dismiss();
        Fluttertoast.showToast(
            msg: '$kerrorString\nStatus code${response.statusCode}');
      }
    } on Exception catch (e) {
      _progressDialog.dismiss();
      ConstantsVar.excecptionMessage(e);
      log(e.toString());
    }
  }
}

class ZoneModel {
  int key;
  String zoneId;
  String zoneName;
  String shippingCharge;

  ZoneModel(this.key, this.zoneId, this.zoneName, this.shippingCharge);
}