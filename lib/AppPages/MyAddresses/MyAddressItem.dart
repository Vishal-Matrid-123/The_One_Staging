import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:untitled2/AppPages/ShippingxxxScreen/AddressForm.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Widgets/CustomButton.dart';
import 'package:untitled2/new_apis_func/presentation_layer/provider_class/provider_contracter.dart';
import 'package:untitled2/utils/utils/colors.dart';
import 'package:untitled2/utils/utils/general_functions.dart';

class MyAddressItem extends StatefulWidget {
  MyAddressItem({
    Key? key,
    // required this.isLoading,
    required this.guestId,
    required this.boolVal,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.companyEnabled,
    required this.companyRequired,
    required this.countryEnabled,
    required this.countryId,
    required this.countryName,
    required this.stateProvinceEnabled,
    required this.cityEnabled,
    required this.cityRequired,
    required this.company,
    required this.city,
    required this.streetAddressEnabled,
    required this.streetAddressRequired,
    required this.address1,
    required this.streetAddress2Enabled,
    required this.streetAddress2Required,
    required this.zipPostalCodeEnabled,
    required this.zipPostalCodeRequired,
    required this.zipPostalCode,
    required this.phoneEnabled,
    required this.phoneRequired,
    required this.phoneNumber,
    required this.faxEnabled,
    required this.faxRequired,
    required this.faxNumber,
    required this.id,
    required this.callback,
    required this.myState,
  }) : super(key: key);
  bool boolVal;

  // String buttonName;
  String firstName;
  String lastName;
  String email;
  bool companyEnabled;
  bool companyRequired;
  bool countryEnabled;
  int countryId;
  String countryName;
  bool stateProvinceEnabled;
  bool cityEnabled;
  bool cityRequired;
  String company;
  String city;
  bool streetAddressEnabled;
  bool streetAddressRequired;
  String address1;
  bool streetAddress2Enabled;
  bool streetAddress2Required;
  bool zipPostalCodeEnabled;
  bool zipPostalCodeRequired;
  dynamic zipPostalCode;
  bool phoneEnabled;
  bool phoneRequired;
  String phoneNumber;
  bool faxEnabled;
  bool faxRequired;
  dynamic faxNumber;
  int id;
  String guestId;
  VoidCallback callback, myState;

  // var
  @override
  _MyAddressItemState createState() => _MyAddressItemState();
}

class _MyAddressItemState extends State<MyAddressItem> {
  String guestId = "";
  String addressJsonString = "";
  NewApisProvider _apisProvider = NewApisProvider();
  final RefreshController _refreshController = RefreshController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _apisProvider = Provider.of<NewApisProvider>(context, listen: false);
    _apisProvider.getYourAddresses();

    getGuestCustomer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.only(left: 10.0, right: 10.0, top: 6.0, bottom: 6.0),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(right: 8, top: 4),
                          child: Text(
                            widget.firstName + ' ' + widget.lastName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: CustomTextStyle.textFormFieldBold
                                .copyWith(fontSize: 16),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                log('edit clicked');
                                //open popup
                                Navigator.pushReplacement(context,
                                    CupertinoPageRoute(builder: (context) {
                                  return AddressScreen(
                                    uri: 'EditAddress',
                                    isShippingAddress: false,
                                    isEditAddress: true,
                                    firstName: widget.firstName,
                                    lastName: widget.lastName,
                                    email: widget.email,
                                    address1: widget.address1,
                                    countryName: widget.countryName,
                                    city: widget.city,
                                    phoneNumber: widget.phoneNumber,
                                    id: widget.id,
                                    company: widget.company,
                                    faxNumber: widget.faxNumber,
                                    title: 'Edit Address',
                                    btnTitle: 'Save',
                                  );
                                }));
                              },
                              child: const Icon(
                                Icons.edit,
                                color: AppColor.PrimaryAccentColor,
                                size: 24.0,
                              ),
                            ),
                            addHorizontalSpace(10),
                            GestureDetector(
                              onTap: () async {
                                log('delete clicked');
                                // ApiCalls.deleteAddress(
                                //         context,
                                //         ConstantsVar.apiTokken.toString(),
                                //         ConstantsVar.customerID,
                                //         widget.id.toString())
                                //     .then((value) {
                                //   widget.callback();
                                //   widget.myState();
                                // });
                                _apisProvider
                                    .deleteYourAddress(
                                        context: context,
                                        addressId: widget.id.toString())
                                    .whenComplete(() {
                                  _refreshController.requestRefresh();
                                });
                              },
                              child: const Icon(
                                Icons.delete,
                                color: AppColor.PrimaryAccentColor,
                                size: 24.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Utils.getSizedBox(null, 6),
                    AutoSizeText('Email - ' + widget.email),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: AutoSizeText(
                            'Address -' + widget.address1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    AutoSizeText('Phone -' ' ' + widget.phoneNumber),
                    AutoSizeText('Country -' ' ' + widget.countryName),
                    addVerticalSpace(12),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getGuestCustomer() async {
    guestId = ConstantsVar.prefs.getString('guestCustomerID') ?? "";
  }
}
