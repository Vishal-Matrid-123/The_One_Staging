// ignore_for_file: file_names

import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/ShippingxxxScreen/AddressForm.dart';
// import 'package:untitled2/AppPages/models/OrderSummaryResponse.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Widgets/CustomButton.dart';
// import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';
import 'package:untitled2/utils/utils/colors.dart';
import 'package:untitled2/utils/utils/general_functions.dart';

import '../../new_apis_func/data_layer/constant_data/constant_data.dart';
import '../../new_apis_func/presentation_layer/provider_class/provider_contracter.dart';
// import 'AddressResponse.dart';

class MyAddresses extends StatefulWidget {
  const MyAddresses({Key? key}) : super(key: key);

  @override
  _MyAddressesState createState() => _MyAddressesState();
}

class _MyAddressesState extends State<MyAddresses> with WidgetsBindingObserver {
  var eController = TextEditingController();

  bool _willGo = true;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  NewApisProvider _apiProvider = NewApisProvider();

  @override
  void initState() {
    // context.loaderOverlay.show(
    //     widget: SpinKitRipple(
    //   color: Colors.red,
    //   size: 90,
    // ));
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _apiProvider = Provider.of<NewApisProvider>(context, listen: false);
    _apiProvider.getYourAddresses();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  // void callApiAllAddresses() {
  //   ApiCalls.allAddresses(
  //       ConstantsVar.apiTokken.toString(), guestCustomerId, context)
  //       .then((value) {
  //     print('Resumed>>>  $value');
  //     setState(() {
  //       addressResponse = AllAddressesResponse.fromJson(value);
  //       existingAddress = addressResponse.customeraddresslist.addresses;
  //       print('address>>> $addressResponse');
  //       showAddresses = true;
  //     });
  //   });
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   applifecycleState = state;
  //   print('mystate $applifecycleState');
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       ApiCalls.allAddresses(
  //           ConstantsVar.apiTokken.toString(), guestCustomerId, context)
  //           .then((value) {
  //         print('Resumed>>>  $value');
  //         setState(() {
  //           addressResponse = AllAddressesResponse.fromJson(value);
  //           existingAddress = addressResponse.customeraddresslist.addresses;
  //           print('address>>> $addressResponse');
  //           showAddresses = true;
  //         });
  //       });
  //       break;
  //
  //     case AppLifecycleState.paused:
  //       break;
  //
  //     case AppLifecycleState.inactive:
  //       break;
  //
  //     case AppLifecycleState.detached:
  //       break;
  //   }
  // }

  bool isLoading = false;

  // void _showLoadingIndicator() {
  //   print('isloading');
  //   setState(() {
  //     isLoading = true;
  //   });
  //   Future.delayed(const Duration(milliseconds: 1000), () {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     print(isLoading);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willGo ? null : () async => false,
      child: SafeArea(
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
                : value.isError == false
                    ? Stack(children: [
                        Column(
                          children: <Widget>[
                            Visibility(
                                visible: value.addresses.isEmpty ? false : true,
                                child: addVerticalSpace(12.0)),
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: TextStyle(
                                        fontSize: 26.dp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  onPressed: () async {
                                    Route route = CupertinoPageRoute(
                                        builder: (context) => AddressScreen(
                                              uri: 'MyAccountAddAddress',
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
                                              company: '',
                                              faxNumber: '',
                                              title: 'Add a new address',
                                              btnTitle: 'Add new address',
                                            ));

                                    Navigator.pushReplacement(context, route);
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
                                              color: Colors.white,
                                              fontSize: 4.w),
                                        ),
                                      ),
                                    ),
                                  ),
                                )),

                            /************** Show Address List ******************/
                            Expanded(
                              child: Visibility(
                                visible: value.addresses.isEmpty ? false : true,
                                child: SizedBox(
                                  height: 85.h,
                                  child: SmartRefresher(
                                    onRefresh: _onLoading,
                                    header: const ClassicHeader(),
                                    controller: _refreshController,
                                    child: ListView(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      children: List.generate(
                                        value.addresses.length,
                                        (index) {
                                          return Container(
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
                                                height: 25.h,
                                                margin: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  bottom: 3.2,
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
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
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: <Widget>[
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            8,
                                                                        top: 4),
                                                                child:
                                                                    AutoSizeText(
                                                                  value
                                                                          .addresses[
                                                                              index]
                                                                          .firstName +
                                                                      ' ' +
                                                                      value
                                                                          .addresses[
                                                                              index]
                                                                          .lastName,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  softWrap:
                                                                      true,
                                                                  style: CustomTextStyle
                                                                      .textFormFieldBold
                                                                      .copyWith(
                                                                          fontSize:
                                                                              16),
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: <
                                                                    Widget>[
                                                                  GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      // await FirebaseAnalytics.instance.log(name: 'screen_view_',parameters: {'screen_name':'Edit and Add Address Screen'});
                                                                      //open popup
                                                                      Navigator.pushReplacement(
                                                                          context,
                                                                          CupertinoPageRoute(builder:
                                                                              (context) {
                                                                        return AddressScreen(
                                                                          uri:
                                                                              'EditAddress',
                                                                          isShippingAddress:
                                                                              false,
                                                                          isEditAddress:
                                                                              true,
                                                                          firstName: value
                                                                              .addresses[index]
                                                                              .firstName,
                                                                          lastName: value
                                                                              .addresses[index]
                                                                              .lastName,
                                                                          email: value
                                                                              .addresses[index]
                                                                              .email,
                                                                          address1: value
                                                                              .addresses[index]
                                                                              .address1,
                                                                          countryName: value
                                                                              .addresses[index]
                                                                              .countryName,
                                                                          city: value
                                                                              .addresses[index]
                                                                              .city,
                                                                          phoneNumber: value
                                                                              .addresses[index]
                                                                              .phoneNumber,
                                                                          id: value
                                                                              .addresses[index]
                                                                              .id,
                                                                          company:
                                                                              value.addresses[index].company ?? '',
                                                                          faxNumber:
                                                                              value.addresses[index].faxNumber ?? '',
                                                                          title:
                                                                              'Edit Address',
                                                                          btnTitle:
                                                                              'Save Address',
                                                                        );
                                                                      }));
                                                                    },
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .edit,
                                                                      color: AppColor
                                                                          .PrimaryAccentColor,
                                                                      size:
                                                                          24.0,
                                                                    ),
                                                                  ),
                                                                  addHorizontalSpace(
                                                                      10),
                                                                  GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      setState(() =>
                                                                          _willGo =
                                                                              false);
                                                                      log('delete clicked');
                                                                      // ApiCalls.deleteAddress(
                                                                      //     context,
                                                                      //     ConstantsVar
                                                                      //         .apiTokken
                                                                      //         .toString(),
                                                                      //     ConstantsVar
                                                                      //         .prefs
                                                                      //         .getString(
                                                                      //         'userId')!,
                                                                      //     value.addresses[
                                                                      //     index]
                                                                      //         .id
                                                                      //         .toString())
                                                                      //     .then(
                                                                      //         (value) {

                                                                      _apiProvider
                                                                          .deleteYourAddress(
                                                                              context: context,
                                                                              addressId: value.addresses[index].id.toString())
                                                                          .whenComplete(() {
                                                                        _refreshController
                                                                            .requestRefresh();

                                                                        setState(() =>
                                                                            _willGo =
                                                                                true);
                                                                      });
                                                                    },
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .delete,
                                                                      color: AppColor
                                                                          .PrimaryAccentColor,
                                                                      size:
                                                                          24.0,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          Utils.getSizedBox(
                                                              null, 6),
                                                          AutoSizeText(
                                                              'Email - ' +
                                                                  value
                                                                      .addresses[
                                                                          index]
                                                                      .email),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: <Widget>[
                                                              Flexible(
                                                                child:
                                                                    AutoSizeText(
                                                                  'Address - ' +
                                                                      value
                                                                          .addresses[
                                                                              index]
                                                                          .address1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          AutoSizeText('Phone - ' +
                                                              value
                                                                  .addresses[
                                                                      index]
                                                                  .phoneNumber),
                                                          AutoSizeText('Country - ' +
                                                              value
                                                                  .addresses[
                                                                      index]
                                                                  .countryName),
                                                          addVerticalSpace(12),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Container(child: isLoading ? Loader() : Container()),
                      ])
                    : Center(
                        child: Column(
                          children: [
                            // child: Image.asset(
                            //   'MyAssets/cry_emoji.gif',
                            //   fit: BoxFit.fill,
                            //   width: 50.w,
                            //   height: 25.h,
                            // ),
                            // ),
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
                          ],
                        ),
                      ),
          ),
        ),
      ),
    );
  }

  void _onLoading() async {
    _apiProvider.getYourAddresses();
    _refreshController.refreshCompleted();
  }
}
