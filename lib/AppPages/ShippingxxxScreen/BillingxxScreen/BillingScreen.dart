import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/models/OrderSummaryResponse.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Widgets/CustomButton.dart';

import '../../../new_apis_func/data_layer/constant_data/constant_data.dart';
import '../../../new_apis_func/presentation_layer/provider_class/provider_contracter.dart';
import '../../../utils/utils/general_functions.dart';
import '../AddressForm.dart';
import '../AddressItem.dart';

class BillingDetails extends StatefulWidget {
  const BillingDetails({Key? key}) : super(key: key);

  @override
  _BillingDetailsState createState() => _BillingDetailsState();
}

class _BillingDetailsState extends State<BillingDetails>
    with WidgetsBindingObserver {
  var eController = TextEditingController();
  bool showLoading = false;
  bool showAddresses = false;

  NewApisProvider _apiProvider = NewApisProvider();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _apiProvider = Provider.of<NewApisProvider>(context, listen: false);
    _apiProvider.getBillingAddress();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        // final _apiProvider =
        //     Provider.of<NewApisProvider>(context, listen: false);
        // _apiProvider.getBillingAddress();
        break;

      case AppLifecycleState.paused:
        break;

      case AppLifecycleState.inactive:
        break;

      case AppLifecycleState.detached:
        break;
    }
  }

  bool isLoading = false;

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
        body: Consumer<NewApisProvider>(
          builder: (_, value, child) => value.loading == true
              ? const Center(
                  child: SpinKitRipple(
                    size: 40,
                    color: ConstantsVar.appColor,
                  ),
                )
              : value.isBillingScreenError == false
                  ? SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Card(
                            elevation: 3,
                            child: SizedBox(
                              width: 100.w,
                              child: Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: AutoSizeText(
                                    'Billing Details'.toUpperCase(),
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
                            ),
                          ),
                          Visibility(
                              visible: value.existingAddresses.isEmpty
                                  ? false
                                  : true,
                              child: addVerticalSpace(12.0)),
                          Visibility(
                            visible:
                                value.existingAddresses.isEmpty ? false : true,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                  margin: const EdgeInsets.only(left: 10.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: AutoSizeText(
                                      'Select a Billing Address',
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
                                  )),
                            ),
                          ),

                          /************** Show Address List ******************/
                          Visibility(
                            visible:
                                value.existingAddresses.isEmpty ? false : true,
                            child: ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              children: List.generate(
                                  value.existingAddresses.length,
                                  (index) => AddressItem(
                                        buttonName: "Bill To This Address",
                                        firstName: value
                                            .existingAddresses[index].firstName,
                                        lastName: value
                                            .existingAddresses[index].lastName,
                                        email: value
                                            .existingAddresses[index].email,
                                        companyEnabled: value
                                            .existingAddresses[index]
                                            .companyEnabled,
                                        companyRequired: value
                                            .existingAddresses[index]
                                            .companyRequired,
                                        countryEnabled: value
                                            .existingAddresses[index]
                                            .countryEnabled,
                                        countryId: value
                                            .existingAddresses[index].countryId,
                                        countryName: value
                                            .existingAddresses[index]
                                            .countryName,
                                        stateProvinceEnabled: value
                                            .existingAddresses[index]
                                            .stateProvinceEnabled,
                                        cityEnabled: value
                                            .existingAddresses[index]
                                            .cityEnabled,
                                        cityRequired: value
                                            .existingAddresses[index]
                                            .cityRequired,
                                        city:
                                            value.existingAddresses[index].city,
                                        streetAddressEnabled: value
                                            .existingAddresses[index]
                                            .streetAddressEnabled,
                                        streetAddressRequired: value
                                            .existingAddresses[index]
                                            .streetAddressRequired,
                                        address1: value
                                            .existingAddresses[index].address1,
                                        streetAddress2Enabled: value
                                            .existingAddresses[index]
                                            .streetAddress2Enabled,
                                        streetAddress2Required: value
                                            .existingAddresses[index]
                                            .streetAddress2Required,
                                        zipPostalCodeEnabled: value
                                            .existingAddresses[index]
                                            .zipPostalCodeEnabled,
                                        zipPostalCodeRequired: value
                                            .existingAddresses[index]
                                            .zipPostalCodeRequired,
                                        zipPostalCode: value
                                            .existingAddresses[index]
                                            .zipPostalCode,
                                        phoneEnabled: value
                                            .existingAddresses[index]
                                            .phoneEnabled,
                                        phoneRequired: value
                                            .existingAddresses[index]
                                            .phoneRequired,
                                        phoneNumber: value
                                            .existingAddresses[index]
                                            .phoneNumber,
                                        faxEnabled: value
                                            .existingAddresses[index]
                                            .faxEnabled,
                                        faxRequired: value
                                            .existingAddresses[index]
                                            .faxRequired,
                                        faxNumber: value
                                            .existingAddresses[index].faxNumber,
                                        id: value.existingAddresses[index].id,
                                        callback: (String value) {},
                                        guestId: "",
                                        // isLoading: isLoading,
                                      )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 40.0,
                              bottom: 10,
                            ),
                            child: SizedBox(
                                // margin: EdgeInsets.only(left: 10.0),
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: AutoSizeText(
                                    'Or Add a New Billing Address',
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
                                )),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  textStyle: TextStyle(
                                      fontSize: 26.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                onPressed: () async {
                                  Navigator.push(context,
                                      CupertinoPageRoute(builder: (context) {
                                    return AddressScreen(
                                      uri: 'AddSelectNewBillingAddress',
                                      isShippingAddress: false,
                                      isEditAddress: false,
                                      firstName: '',
                                      lastName: '',
                                      email: '',
                                      address1: '',
                                      countryName: '',
                                      city: '',
                                      phoneNumber: '',
                                      id: 0,
                                      faxNumber: '',
                                      company: '',
                                      title: 'billing address',
                                      btnTitle: 'Continue',
                                    );
                                  }));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50.0),
                                  child: Container(
                                    height: 5.h,
                                    decoration: BoxDecoration(
                                        color: ConstantsVar.appColor,
                                        borderRadius:
                                            BorderRadius.circular(6.0)),
                                    child: Center(
                                      child: AutoSizeText(
                                        'Add New Address',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 4.w),
                                      ),
                                    ),
                                  ),
                                ),
                              )),

                          /**************** Show order summary here ****************/
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Card(
                                color: Colors.white60,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Center(
                                      child: AutoSizeText(
                                        'Order Summary',
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
                                )),
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(4.0),
                              itemCount: value.orderedList.length,
                              itemBuilder: (context, index) {
                                return cartItemView(value.orderedList[index]);
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                              "",
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
                                          value.orderSummaryTotal.shipping == ""
                                              ? 'During Checkout '
                                              : value.orderSummaryTotal.shipping
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
                                    child: Visibility(
                                      visible: true,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Visibility(
                                            visible: value.orderSummaryTotal
                                                        .orderTotalDiscount ==
                                                    null
                                                ? false
                                                : true,
                                            child: const AutoSizeText(
                                              'Discount:',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: value.orderSummaryTotal
                                                        .orderTotalDiscount ==
                                                    null
                                                ? false
                                                : true,
                                            child: AutoSizeText(
                                              value.orderSummaryTotal
                                                  .orderTotalDiscount
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
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
                                              "No Tax info available",
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
                                    child: Visibility(
                                      visible: true,
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
                                                    .orderTotal
                                                    .toString(),
                                            style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          /******************* Show cart summary ********************/
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
                                await _apiProvider.getBillingAddress(),
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
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
                          .copyWith(fontSize: 16),
                    ),
                  ),
                  Utils.getSizedBox(null, 6),
                  AutoSizeText(
                    "SKU : ${item.sku}",
                    style: CustomTextStyle.textFormFieldRegular
                        .copyWith(color: Colors.grey, fontSize: 15),
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
