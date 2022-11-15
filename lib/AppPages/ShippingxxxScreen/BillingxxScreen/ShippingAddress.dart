import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:progress_loading_button/progress_loading_button.dart';
import 'package:provider/provider.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/models/OrderSummaryResponse.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Widgets/CustomButton.dart';
import 'package:untitled2/new_apis_func/data_layer/constant_data/constant_data.dart';
import 'package:untitled2/new_apis_func/presentation_layer/events_handlers/facebook_events.dart';
import 'package:untitled2/new_apis_func/presentation_layer/events_handlers/firebase_events.dart';
import 'package:untitled2/new_apis_func/presentation_layer/provider_class/provider_contracter.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/utils/general_functions.dart';

import '../../WebxxViewxx/PaymentWebView.dart';
import '../AddressItem.dart';
import '../ShippingPage.dart';

class ShippingAddress extends StatefulWidget {
  const ShippingAddress({Key? key}) : super(key: key);

  @override
  _ShippingAddressState createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddress> {
  bool isChecked = false, isVisible = true;
  String _id = "";
  String paymentUrl = '';

  var addressString = "";
  bool isSelected = false;
  var selectedVal = '';

  var _apiProvider = NewApisProvider();

  @override
  void initState() {
    super.initState();
    _apiProvider = Provider.of<NewApisProvider>(context, listen: false);
    _apiProvider.getShippingDetails();
    //           paymentUrl = BuildConfig.base_url +
    //               'AppCustomer/CreateCustomerOrder?apiToken=${ConstantsVar.apiTokken.toString()}&CustomerId=$id&PaymentMethod=Payments.CyberSource';
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
                            )),
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
          body: buildStack(context)),
    );
  }

  Widget buildStack(BuildContext context) {
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
                  'Shipping Details'.toUpperCase(),
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
                : value.isShippingDetailsScreenError == false
                    ? SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 100.w,
                                child: Center(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RoundCheckBox(
                                        size: 30,
                                        onTap: (selected) {
                                          setState(() {
                                            isChecked
                                                ? isChecked = selected!
                                                : isChecked = selected!;

                                            isVisible
                                                ? isVisible = false
                                                : isVisible = true;
                                          });
                                        },
                                        isChecked: isChecked,
                                        checkedWidget: const Icon(
                                          Icons.check,
                                          size: 25,
                                          color: ConstantsVar.appColor,
                                        ),
                                        uncheckedWidget: null,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 3.w),
                                        child: AutoSizeText(
                                          'Click & Collect',
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
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: AutoSizeText(
                                  ConstantsVar.stringShipping,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontSize: 3.8.w,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: isChecked,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: ListView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    children: List.generate(
                                      value.pickupPoints.length,
                                      (index) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: LoadingButton(
                                          color: Colors.white,
                                          defaultWidget: AutoSizeText(
                                              value.pickupPoints[index].name,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 4.6.w,
                                                  color: Colors.black)),
                                          width: 100.w,
                                          height: 18.w,
                                          onPressed: () async {
                                            await ApiCalls
                                                    .addAndSelectShippingAddress(
                                                        value
                                                            .pickupPoints[index]
                                                            .id)
                                                .then(
                                              (_value) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => Dialog(
                                                    alignment: Alignment.center,
                                                    child: SizedBox(
                                                      height: 20.h,
                                                      child: Stack(
                                                        children: [
                                                          Align(
                                                            alignment: Alignment
                                                                .topCenter,
                                                            child: SizedBox(
                                                              width: 80.w,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                  16.0,
                                                                ),
                                                                child:
                                                                    AutoSizeText(
                                                                  'This will lead you to payment page.',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  softWrap:
                                                                      true,
                                                                  style: TextStyle(
                                                                      shadows: <
                                                                          Shadow>[
                                                                        Shadow(
                                                                          offset: const Offset(
                                                                              1.0,
                                                                              1.2),
                                                                          blurRadius:
                                                                              3.0,
                                                                          color: Colors
                                                                              .grey
                                                                              .shade300,
                                                                        ),
                                                                        Shadow(
                                                                          offset: const Offset(
                                                                              1.0,
                                                                              1.2),
                                                                          blurRadius:
                                                                              8.0,
                                                                          color: Colors
                                                                              .grey
                                                                              .shade300,
                                                                        ),
                                                                      ],
                                                                      fontSize:
                                                                          5.w,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: RichText(
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              text: TextSpan(
                                                                text:
                                                                    'You have selected:\n',
                                                                style: TextStyle(
                                                                    shadows: <
                                                                        Shadow>[
                                                                      Shadow(
                                                                        offset: const Offset(
                                                                            1.0,
                                                                            1.2),
                                                                        blurRadius:
                                                                            3.0,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade300,
                                                                      ),
                                                                      Shadow(
                                                                        offset: const Offset(
                                                                            1.0,
                                                                            1.2),
                                                                        blurRadius:
                                                                            8.0,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade300,
                                                                      ),
                                                                    ],
                                                                    fontSize:
                                                                        5.w,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
                                                                children: <
                                                                    TextSpan>[
                                                                  TextSpan(
                                                                    text: value
                                                                        .pickupPoints[
                                                                            index]
                                                                        .name,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          3.w,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            bottom: 5,
                                                            left: 12.w,
                                                            child: TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                              child:
                                                                  AutoSizeText(
                                                                'Cancel'
                                                                    .toUpperCase(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                              bottom: 5,
                                                              right: 15.w,
                                                              child: TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  String
                                                                      baseUrl =
                                                                      await ApiCalls
                                                                          .getSelectedStore();
                                                                  String
                                                                      customerId =
                                                                      ConstantsVar
                                                                              .prefs
                                                                              .getString(kcustomerIdKey) ??
                                                                          "";
                                                                  String
                                                                      apiToken =
                                                                      ConstantsVar
                                                                              .prefs
                                                                              .getString(kapiTokenKey) ??
                                                                          "";
                                                                  String
                                                                      storeId =
                                                                      await secureStorage.read(
                                                                              key: kselectedStoreIdKey) ??
                                                                          '1';

                                                                  _apiProvider
                                                                      .getCurrency();

                                                                  // log()
                                                                  final _fireEvent =
                                                                      FirebaseEvents.initialize(
                                                                          context:
                                                                              context);
                                                                  _fireEvent.sendBeginCheckout(
                                                                      value: double.parse(
                                                                            value.orderSummaryTotal.subTotal.replaceAll(RegExp(r'[^0-9]'),
                                                                                ''),
                                                                          ) ??
                                                                          0.0,
                                                                      currency: value.currency,
                                                                      items: List.generate(
                                                                        value
                                                                            .orderedList
                                                                            .length,
                                                                        (index) =>
                                                                            AnalyticsEventItem(
                                                                          itemName: value
                                                                              .orderedList[index]
                                                                              .productName,
                                                                          itemId: value
                                                                              .orderedList[index]
                                                                              .productId
                                                                              .toString(),
                                                                          price: double.parse(
                                                                                value.orderedList[index].subTotal.replaceAll(RegExp(r'[^0-9]'), ''),
                                                                              ) ??
                                                                              double.parse(
                                                                                value.orderedList[index].subTotal.replaceAll(RegExp(r'[^0-9]'), ''),
                                                                              ),
                                                                        ),
                                                                      ));
                                                                  FacebookEvents()
                                                                      .sendInitiateCheckoutData(
                                                                    totalPrice:
                                                                        double
                                                                            .parse(
                                                                      value
                                                                          .orderSummaryTotal
                                                                          .subTotal
                                                                          .replaceAll(
                                                                              RegExp(r'[^0-9]'),
                                                                              ''),
                                                                    ),
                                                                    currency:
                                                                        _apiProvider
                                                                            .currency,
                                                                  );

                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    CupertinoPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              PaymentPage(
                                                                        baseUrl:
                                                                            baseUrl.replaceAll('/apisSecondVer', '') +
                                                                                'Appcustomer/CreateCustomerOrder?',
                                                                        storeId:
                                                                            storeId,
                                                                        customerId:
                                                                            customerId,
                                                                        apiToken:
                                                                            apiToken,
                                                                      ),
                                                                    ),
                                                                  );
                                                                },

                                                                // Navigator.push(
                                                                //   context,
                                                                //   CupertinoPageRoute(
                                                                //     builder:
                                                                //         (context) =>
                                                                //         PaymentPage(
                                                                //           paymentUrl:
                                                                //           paymentUrl,
                                                                //         ),
                                                                //   ),
                                                                // ),
                                                                child:
                                                                    AutoSizeText(
                                                                  'Confirm'
                                                                      .toUpperCase(),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .green),
                                                                ),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              addVerticalSpace(12.0),
                              Visibility(
                                visible: value.existingShippingAddresses.isEmpty
                                    ? false
                                    : true,
                                child: Visibility(
                                  visible: isVisible,
                                  child: Visibility(
                                    visible:
                                        value.existingShippingAddresses.isEmpty
                                            ? false
                                            : true,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(left: 10.0),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Center(
                                          child: AutoSizeText(
                                            'Or Select a Shipping Address',
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
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              /************** Show Address List ******************/
                              Visibility(
                                visible: value.existingShippingAddresses.isEmpty
                                    ? false
                                    : true,
                                child: Visibility(
                                  visible: isVisible,
                                  child: ListView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    children: List.generate(
                                      value.existingShippingAddresses.length,
                                      (index) => AddressItem(
                                        buttonName: "Ship To This Address",
                                        firstName: value
                                            .existingShippingAddresses[index]
                                            .firstName,
                                        lastName: value
                                            .existingShippingAddresses[index]
                                            .lastName,
                                        email: value
                                            .existingShippingAddresses[index]
                                            .email,
                                        companyEnabled: value
                                            .existingShippingAddresses[index]
                                            .companyEnabled,
                                        companyRequired: value
                                            .existingShippingAddresses[index]
                                            .companyRequired,
                                        countryEnabled: value
                                            .existingShippingAddresses[index]
                                            .countryEnabled,
                                        countryId: value
                                            .existingShippingAddresses[index]
                                            .countryId,
                                        countryName: value
                                            .existingShippingAddresses[index]
                                            .countryName,
                                        stateProvinceEnabled: value
                                            .existingShippingAddresses[index]
                                            .stateProvinceEnabled,
                                        cityEnabled: value
                                            .existingShippingAddresses[index]
                                            .cityEnabled,
                                        cityRequired: value
                                            .existingShippingAddresses[index]
                                            .cityRequired,
                                        city: value
                                            .existingShippingAddresses[index]
                                            .city,
                                        streetAddressEnabled: value
                                            .existingShippingAddresses[index]
                                            .streetAddressEnabled,
                                        streetAddressRequired: value
                                            .existingShippingAddresses[index]
                                            .streetAddressRequired,
                                        address1: value
                                            .existingShippingAddresses[index]
                                            .address1,
                                        streetAddress2Enabled: value
                                            .existingShippingAddresses[index]
                                            .streetAddress2Enabled,
                                        streetAddress2Required: value
                                            .existingShippingAddresses[index]
                                            .streetAddress2Required,
                                        zipPostalCodeEnabled: value
                                            .existingShippingAddresses[index]
                                            .zipPostalCodeEnabled,
                                        zipPostalCodeRequired: value
                                            .existingShippingAddresses[index]
                                            .zipPostalCodeRequired,
                                        zipPostalCode: value
                                            .existingShippingAddresses[index]
                                            .zipPostalCode,
                                        phoneEnabled: value
                                            .existingShippingAddresses[index]
                                            .phoneEnabled,
                                        phoneRequired: value
                                            .existingShippingAddresses[index]
                                            .phoneRequired,
                                        phoneNumber: value
                                            .existingShippingAddresses[index]
                                            .phoneNumber,
                                        faxEnabled: value
                                            .existingShippingAddresses[index]
                                            .faxEnabled,
                                        faxRequired: value
                                            .existingShippingAddresses[index]
                                            .faxRequired,
                                        faxNumber: value
                                            .existingShippingAddresses[index]
                                            .faxNumber,
                                        id: value
                                            .existingShippingAddresses[index]
                                            .id,
                                        callback: (String value) {},
                                        guestId: _id,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              /**************** Show order summary here ****************/
                              Visibility(
                                visible: isVisible,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 40.0,
                                    bottom: 10,
                                  ),
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: Center(
                                        child: AutoSizeText(
                                          'Or Add a New Shipping Address',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
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
                                      )),
                                ),
                              ),
                              Visibility(
                                visible: isVisible,
                                child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 40),
                                    width: MediaQuery.of(context).size.width,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: TextStyle(
                                            fontSize: 6.w,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      onPressed: () async {
                                        Navigator.pushReplacement(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) {
                                              return const ShippingDetails();
                                            },
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 6.h,
                                        decoration: BoxDecoration(
                                            color: ConstantsVar.appColor,
                                            borderRadius:
                                                BorderRadius.circular(6.0)),
                                        child: Center(
                                          child: AutoSizeText(
                                            'Add New Address',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 4.w),
                                          ),
                                        ),
                                      ),
                                    )),
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
                                                  "No Infor available",
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

                              /******************* Show cart summary ********************/
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
                                  await _apiProvider.getShippingDetails(),
                              child: const Text("Retry"),
                            ),
                          ],
                        ),
                      ),
          ),
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

Future<bool> hideCxt() async {
  return true;
}
