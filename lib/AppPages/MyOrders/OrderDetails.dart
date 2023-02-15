import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:untitled2/AppPages/CartxxScreen/CartScreen2.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/ReturnScreen/ReturnScreen.dart';
import 'package:untitled2/AppPages/StreamClass/NewPeoductPage/NewProductScreen.dart';
import 'package:untitled2/AppPages/WebxxViewxx/PaymentWebView.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Widgets/CustomButton.dart';
import 'package:untitled2/new_apis_func/data_layer/constant_data/constant_data.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/utils/general_functions.dart';

class OrderDetails extends StatefulWidget {
  OrderDetails({
    Key? key,
    required this.orderNumber ,
    required this.orderDate,
    required this.orderProgress,
    required this.orderTotal,
    required this.color,
    required this.resultas,
    required this.apiToken,
    required this.customerId,
    required this.orderId,
  }) : super(key: key);
  final String orderNumber,
      orderDate,
      orderProgress,
      orderTotal,
      apiToken,
      customerId,
      orderId;

  Color color;
  dynamic resultas;

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails>
    with WidgetsBindingObserver {
  String firstName = '';

  String email = '';

  String lastName = '';

  String address1 = '';
  bool isRetryPayment = false;
  var phoneNumber = '';
  var city = '';
  var countryName = '';

  // dynamic resultas = {};
  bool isPickUpStore = false;
  var sFirstName = '';

  var sLastName = '';

  var sEmail = '';
  var sPhone = '';

  var sAddress1 = '';

  var sCity = '';

  var scountryName = '';

  String sCountryName = '';
  String shippingMethod = '';
  String shippingStatus = '';

  String subTotal = '';

  String taxPrice = '';
  String totalPrice = '';

  var shipping = '';
  bool isReturnAvail = false;

  bool isError = false;

  String _errorMessage = '';

  var isAddressAvailable = true;

  Widget orderItem({
    required String productId,
    required String imageUrl,
    required String title,
    required String sku,
    required String unitPrice,
    required String price,
    required String quantity,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => NewProductDetails(
                      productId: productId.toString(),
                      screenName: 'Order Details',
                    )));
      },
      child: Stack(
        children: <Widget>[
          Container(
            height: 20.h,
            margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(.1),
                borderRadius: const BorderRadius.all(Radius.circular(16))),
            child: Row(
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.only(
                        right: 8, left: 8, top: 8, bottom: 8),
                    width: 80,
                    height: 80,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                    )),
                Expanded(
                  child: Container(
                    height: 19.h,
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(right: 8, top: 4),
                          child: AutoSizeText(
                            'Name: ' + title,
                            softWrap: true,
                            style: CustomTextStyle.textFormFieldSemiBold
                                .copyWith(fontSize: 3.8.w),
                          ),
                        ),
                        Utils.getSizedBox(null, 4),
                        Flexible(
                          child: AutoSizeText(
                            "SKU : $sku",
                            style: CustomTextStyle.textFormFieldRegular
                                .copyWith(color: Colors.grey, fontSize: 15),
                          ),
                        ),
                        Utils.getSizedBox(null, 3),
                        Flexible(
                          child: AutoSizeText(
                            'Unit Price: ' + unitPrice,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Utils.getSizedBox(null, 3),
                        Flexible(
                          child: AutoSizeText(
                            'Sub Total: ' + price,
                            overflow: TextOverflow.ellipsis,
                            style: CustomTextStyle.textFormFieldBlack
                                .copyWith(color: Colors.green),
                          ),
                        ),
                        Utils.getSizedBox(null, 3),
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              AutoSizeText(
                                'Quantity: ' + quantity,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 3.5.w),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  flex: 100,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    log(widget.resultas);

    if (widget.orderProgress.contains('Pending')) {
      setState(() => widget.color = Colors.amberAccent);
    } else if (widget.orderProgress.contains('Cancelled')) {
      setState(() => widget.color = Colors.red);
    } else {
      setState(() => widget.color = Colors.green);
    }

    if (widget.resultas!['ResponseData'] != null) {
      setState(() {
        isError = false;
        firstName = widget.resultas!['ResponseData']['orderDetailsModel']
                ['BillingAddress']['FirstName'] ??
            '';
        lastName = widget.resultas!['ResponseData']['orderDetailsModel']
            ['BillingAddress']['LastName'];
        address1 = widget.resultas!['ResponseData']['orderDetailsModel']
            ['BillingAddress']['Address1'];
        phoneNumber = widget.resultas!['ResponseData']['orderDetailsModel']
            ['BillingAddress']['PhoneNumber'];
        countryName = widget.resultas!['ResponseData']['orderDetailsModel']
            ['BillingAddress']['CountryName'];
        email = widget.resultas!['ResponseData']['orderDetailsModel']
            ['BillingAddress']['Email'];
        city = widget.resultas!['ResponseData']['orderDetailsModel']
            ['BillingAddress']['City'];
        isPickUpStore = widget.resultas!['ResponseData']['orderDetailsModel']
            ['PickUpInStore'];
        shippingMethod = widget.resultas!['ResponseData']['orderDetailsModel']
            ['ShippingMethod'];
        shippingStatus = widget.resultas!['ResponseData']['orderDetailsModel']
            ['ShippingStatus'];
        shipping = widget.resultas!['ResponseData']['orderDetailsModel']
            ['OrderShipping'];
        taxPrice = widget.resultas!['ResponseData']['orderDetailsModel']['Tax'];
        totalPrice =
            widget.resultas!['ResponseData']['orderDetailsModel']['OrderTotal'];
        subTotal = widget.resultas!['ResponseData']['orderDetailsModel']
            ['OrderSubtotal'];
        isRetryPayment = widget.resultas!['ResponseData']['RetryButton'];
        isReturnAvail = widget.resultas!['ResponseData']['orderDetailsModel']
            ['IsReturnRequestAllowed'];
        if (isPickUpStore == true) {
        } else {
          sFirstName = widget.resultas!['ResponseData']['orderDetailsModel']
              ['ShippingAddress']['FirstName'];
          sFirstName == ''
              ? setState(() => sFirstName = '')
              : setState(() => sFirstName = sFirstName);
          sLastName = widget.resultas!['ResponseData']['orderDetailsModel']
              ['ShippingAddress']['LastName'];

          sAddress1 = widget.resultas!['ResponseData']['orderDetailsModel']
              ['ShippingAddress']['Address1'];
          sPhone = widget.resultas!['ResponseData']['orderDetailsModel']
              ['ShippingAddress']['PhoneNumber'];
          sCountryName = widget.resultas!['ResponseData']['orderDetailsModel']
              ['ShippingAddress']['CountryName'];
          sEmail = widget.resultas!['ResponseData']['orderDetailsModel']
              ['ShippingAddress']['Email'];
          sCity = widget.resultas!['ResponseData']['orderDetailsModel']
              ['ShippingAddress']['City'];
          sAddress1 == ''
              ? setState(() => sAddress1 = '')
              : setState(() => sAddress1 = sAddress1);
          sPhone == ''
              ? setState(() => sPhone = '')
              : setState(() => sPhone = sPhone);
          sCountryName == ''
              ? setState(() => sCountryName = '')
              : setState(() => sCountryName = sCountryName);
          sEmail == ''
              ? setState(() => sEmail = '')
              : setState(() => sEmail = sEmail);
          sCity == ''
              ? setState(() => sCity = '')
              : setState(() => sCity = sCity);
          sAddress1 == '' ||
                  sCity == '' ||
                  sEmail == '' ||
                  sCountryName == '' ||
                  sPhone == '' ||
                  sAddress1 == '' ||
                  sLastName == ''
              ? setState(() => isAddressAvailable = false)
              : setState(() => isAddressAvailable = true);
        }
      });
    } else {
      setState(() {
        isError = true;
        _errorMessage = widget.resultas['error'].toString();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ConstantsVar.appColor,
          centerTitle: true,
          toolbarHeight: 18.w,
          title: InkWell(
            child: Image.asset(
              'MyAssets/logo.png',
              width: 15.w,
              height: 15.w,
            ),
            onTap: () =>
                Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(
              builder: (context) {
                return MyApp();
              },
            ), (route) => false),
          ),
        ),
        body: isError
            ? SizedBox(
                height: 60.h,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 30.w,
                        height: 30.w,
                        child: ClipOval(
                          child: Image.asset(
                            'MyAssets/logo.png',
                          ),
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          text: 'Something went wrong\!.\n',
                          style: TextStyle(
                            fontSize: 4.5.w,
                            fontWeight: FontWeight.bold,
                          ),
                          children: <InlineSpan>[
                            // TextSpan(
                            //   text: 'Possible cause:',
                            //
                            //   style: TextStyle(
                            //     fontSize: 12,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                            // TextSpan(
                            //   text: _errorMessage,
                            //   style: TextStyle(
                            //     fontSize: 12,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox(
                width: 100.w,
                height: 100.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.white60,
                      width: 100.w,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(4.5.w),
                          child: AutoSizeText(
                            'My Order Details'.toUpperCase(),
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
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Visibility(
                        visible: widget
                                    .resultas!['ResponseData']
                                        ['orderDetailsModel']['Items']
                                    .length ==
                                0
                            ? false
                            : true,
                        child: ListView(
                          children: [
                            SizedBox(
                              width: 100.w,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Center(
                                        child: AutoSizeText(
                                          widget.orderNumber,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true,
                                          style: CustomTextStyle
                                              .textFormFieldBold
                                              .copyWith(fontSize: 5.5.w),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 3.0, vertical: 20),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          height: 25.w,
                                          width: 100.w,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                child: RichText(
                                                  text: TextSpan(
                                                      text: 'Order Status: ',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 5.w,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                            text: widget
                                                                .orderProgress
                                                                .toUpperCase(),
                                                            style: TextStyle(
                                                                color: widget
                                                                    .color,
                                                                fontSize: 5.w,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))
                                                      ]),
                                                ),
                                              ),
                                              Utils.getSizedBox(null, 3),
                                              SizedBox(
                                                width: 100.w,
                                                child: AutoSizeText(
                                                  widget.orderDate,
                                                  style: TextStyle(
                                                    fontSize: 5.w,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: widget.resultas!['ResponseData']
                                          ['orderDetailsModel']['PaymentMethod']
                                      .toString()
                                      .contains("CyberSource")
                                  ? true
                                  : false,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: AppButton(
                                    color: ConstantsVar.appColor,
                                    child: SizedBox(
                                      width: 100.w,
                                      height: 2.7.h,
                                      child: Center(
                                        child: AutoSizeText(
                                          widget.orderProgress
                                                  .contains('Pending')
                                              ? 'Retry Payment'.toUpperCase()
                                              : 're-order'.toUpperCase(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 4.4.w,
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
                                      widget.orderProgress.contains('Pending')
                                          ? repayment()
                                          : reorder();
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Container(
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
                                    child: AutoSizeText(
                                      'Price Details',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 5.w,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AutoSizeText(
                                          'Sub-Total:',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 5.w,
                                          ),
                                        ),
                                        AutoSizeText(
                                          subTotal,
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 5.w,
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
                                        AutoSizeText(
                                          'Shipping:',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 5.w,
                                          ),
                                        ),
                                        AutoSizeText(
                                          shipping ??
                                              'No Shipping Available for now ',
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 5.w,
                                              color: Colors.green,
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
                                        AutoSizeText(
                                          'Tax 5%:',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 5.w,
                                          ),
                                        ),
                                        AutoSizeText(
                                          taxPrice ?? ' ',
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 5.w,
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
                                        AutoSizeText(
                                          'Order Total:',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 5.w,
                                          ),
                                        ),
                                        AutoSizeText(
                                          totalPrice ?? '',
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 5.w,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              child: Container(
                                color: Colors.white60,
                                width: 100.w,
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(3.5.w),
                                    child: AutoSizeText(
                                      'PRODUCT\(S\)'.toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 5.5.w,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.white60,
                              child: ListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: List.generate(
                                    widget
                                                .resultas!['ResponseData']
                                                    ['orderDetailsModel']
                                                    ['Items']
                                                .length ==
                                            0
                                        ? 0
                                        : widget
                                            .resultas!['ResponseData']
                                                ['orderDetailsModel']['Items']
                                            .length, (index) {
                                  var title = widget.resultas!['ResponseData']
                                          ['orderDetailsModel']['Items'][index]
                                      ['ProductName'];
                                  String productId = widget
                                      .resultas!['ResponseData']
                                          ['orderDetailsModel']['Items'][index]
                                          ['ProductId']
                                      .toString();

                                  String sku = widget.resultas!['ResponseData']
                                          ['orderDetailsModel']['Items'][index]
                                      ['Sku'];
                                  String unitPrice =
                                      widget.resultas!['ResponseData']
                                              ['orderDetailsModel']['Items']
                                          [index]['UnitPrice'];
                                  String price =
                                      widget.resultas!['ResponseData']
                                              ['orderDetailsModel']['Items']
                                          [index]['SubTotal'];
                                  String quantity = widget
                                      .resultas!['ResponseData']
                                          ['orderDetailsModel']['Items'][index]
                                          ['Quantity']
                                      .toString();
                                  String id = widget.resultas!['ResponseData']
                                          ['orderDetailsModel']['Items'][index]
                                          ['ProductId']
                                      .toString();

                                  String imageUrl =
                                      widget.resultas!['ResponseData']
                                          ['PictureList'][id];
                                  print(imageUrl);
                                  setState(() {});
                                  return orderItem(
                                      productId: productId,
                                      title: title,
                                      sku: sku,
                                      unitPrice: unitPrice,
                                      price: price,
                                      quantity: quantity,
                                      imageUrl: imageUrl);
                                }),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Card(
                              child: Container(
                                color: Colors.white60,
                                width: 100.w,
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(3.5.w),
                                    child: AutoSizeText(
                                      'Billing address'.toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 5.5.w,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 10.0,
                                  right: 10.0,
                                  top: 6.0,
                                  bottom: 6.0),
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: Colors.white,
                                child: Container(
                                  height: 25.h,
                                  margin: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    bottom: 3.2,
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    right: 8, top: 4),
                                                child: AutoSizeText(
                                                  firstName + ' ' + lastName,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                  style: CustomTextStyle
                                                      .textFormFieldBold
                                                      .copyWith(
                                                    fontSize: 4.w,
                                                  ),
                                                ),
                                              ),
                                              Utils.getSizedBox(null, 6),
                                              Container(
                                                  child: AutoSizeText(
                                                'Email - ' + email,
                                                style: TextStyle(
                                                  fontSize: 4.w,
                                                ),
                                              )),
                                              Container(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Flexible(
                                                      child: AutoSizeText(
                                                        'Address -' + address1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 4.w,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                  child: AutoSizeText(
                                                'Phone -' + ' ' + phoneNumber,
                                                style: TextStyle(
                                                  fontSize: 4.w,
                                                ),
                                              )),
                                              Container(
                                                child: AutoSizeText(
                                                  'Country -' +
                                                      ' ' +
                                                      countryName,
                                                  style: TextStyle(
                                                    fontSize: 4.w,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: AutoSizeText(
                                                  'City -' + ' ' + city,
                                                  style: TextStyle(
                                                    fontSize: 4.w,
                                                  ),
                                                ),
                                              ),
                                              addVerticalSpace(12),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: !isPickUpStore,
                              child: Card(
                                child: Container(
                                  color: Colors.white60,
                                  width: 100.w,
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(3.5.w),
                                      child: AutoSizeText(
                                        'Shipping address'.toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 5.5.w,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Stack(
                              children: [
                                Visibility(
                                  visible: !isPickUpStore,
                                  child: Visibility(
                                    visible: isAddressAvailable,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 10.0,
                                          right: 10.0,
                                          top: 6.0,
                                          bottom: 6.0),
                                      child: Card(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        color: Colors.white,
                                        child: Container(
                                          height: 24.h,
                                          margin: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            bottom: 3.2,
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Container(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 8,
                                                                top: 4),
                                                        child: AutoSizeText(

                                                              ' ' +
                                                              '${sFirstName ?? 'No Info Available'}  ${sLastName  ?? '' }',
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          softWrap: true,
                                                          style: CustomTextStyle
                                                              .textFormFieldBold
                                                              .copyWith(
                                                                  fontSize:
                                                                      4.w),
                                                        ),
                                                      ),
                                                      Utils.getSizedBox(
                                                          null, 6),
                                                      Container(
                                                          child: AutoSizeText(
                                                        'Email - ${sEmail ?? 'No Info Available'}' ,
                                                        style: TextStyle(
                                                          fontSize: 4.w,
                                                        ),
                                                      )),
                                                      Container(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Flexible(
                                                              child:
                                                                  AutoSizeText(
                                                                'Address - ${sAddress1?? 'No Info Available'}',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        4.w),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        child: AutoSizeText(
                                                          'Phone - ${sPhone?? 'No Info Available'}' ,
                                                          style: TextStyle(
                                                            fontSize: 4.w,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                          child: AutoSizeText(
                                                        'Country - ${sCountryName?? 'No Info Available'}',
                                                        style: TextStyle(
                                                          fontSize: 4.w,
                                                        ),
                                                      )),
                                                      Container(
                                                          child: AutoSizeText(
                                                        'City - ${sCity?? 'No Info Available'}' ,
                                                        style: TextStyle(
                                                          fontSize: 4.w,
                                                        ),
                                                      )),
                                                      addVerticalSpace(12),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: !isAddressAvailable,
                                  child: Card(
                                    child: SizedBox(
                                      width: 100.w,
                                      child: Padding(
                                        padding: EdgeInsets.all(3.8.w),
                                        child: Center(
                                          child: AutoSizeText(
                                            'No Shipping Address',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 4.w,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Card(
                              child: Container(
                                color: Colors.white60,
                                width: 100.w,
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(3.8.w),
                                    child: AutoSizeText(
                                      'Shipping Method'.toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 5.5.w,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              child: Container(
                                color: Colors.white60,
                                width: 100.w,
                                child: Padding(
                                  padding: EdgeInsets.all(3.5.w),
                                  child: Center(
                                    child: AutoSizeText(
                                      shippingMethod ?? 'No Shipping Method Used.'
                                          ,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 4.w,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              child: Container(
                                color: Colors.white60,
                                width: 100.w,
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(3.8.w),
                                    child: AutoSizeText(
                                      'Shipping Status'.toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 5.5.w,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              child: Container(
                                color: Colors.white60,
                                width: 100.w,
                                child: Padding(
                                  padding: EdgeInsets.all(3.5.w),
                                  child: Center(
                                    child: AutoSizeText(
                                      shippingStatus,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 4.w,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: isReturnAvail,
                              child: GestureDetector(
                                onTap: () async {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => ReturnScreen(
                                        orderId: widget.orderId.toString(),
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  child: Container(
                                    color: Colors.white60,
                                    width: 100.w,
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(3.8.w),
                                        child: AutoSizeText(
                                          'Return'.toUpperCase(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 5.5.w,
                                          ),
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
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> reorder() async {
    final uri = Uri.parse(await ApiCalls.getSelectedStore() +
        'CustomerReOrder?OrderId=${widget.orderId}&CustomerId=${ConstantsVar.prefs.getString(kcustomerIdKey)}&apiToken=${ConstantsVar.prefs.getString(kapiTokenKey)}&$kStoreIdVar=${await secureStorage.read(key: kselectedStoreIdKey) ?? "1"}');
    try {
      var response = await get(uri, headers: {
        'Cookie': '.Nop.Customer=${ConstantsVar.prefs.getString(kguidKey)}'
      });

      if (response.statusCode == 200) {
        if (!jsonDecode(response.body)['Status']
            .toString()
            .contains('Success')) {
          Fluttertoast.showToast(msg: jsonDecode(response.body)['Message']);
        } else {
          log(response.body);
          List<dynamic> _msg = jsonDecode(response.body)['Message'];
          if (_msg.isNotEmpty) {
            Fluttertoast.showToast(
                msg: List<String>.from(_msg.map((e) => e)).toList().join("\n"));
          } else {}
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => const CartScreen2(
                otherScreenName: '',
                isOtherScren: false,
              ),
            ),
          );
          log(response.body);
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status code${response.statusCode}');
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  repayment() async {
    // final String paymentUrl = BuildConfig.base_url +
    //     'apis/RePayment?OrderId=${widget.orderId}&CustomerId=${widget.customerId}&apiToken=${widget.apiToken}';

    String baseUrl = await ApiCalls.getSelectedStore();
    String customerId =
        await ConstantsVar.prefs.getString(kcustomerIdKey) ?? "";
    String apiToken = await ConstantsVar.prefs.getString(kapiTokenKey) ?? "";
    String storeId = await secureStorage.read(key: kselectedStoreIdKey) ?? '1';
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
        builder: (context) => PaymentPage(
          baseUrl: baseUrl + "RePayment?OrderId=${widget.orderId}&",
          apiToken: apiToken,
          storeId: storeId,
          customerId: customerId,
          paymentMethod: storeId == kqStoreId ? 'Payments.QNB' : 'Payments.CyberSource',
          isRepayment: true,
        ),
      ),
    );
  }
}
