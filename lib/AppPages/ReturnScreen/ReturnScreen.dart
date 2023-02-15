import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:menu_button/menu_button.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:progress_loading_button/progress_loading_button.dart';
import 'package:untitled2/AppPages/CustomLoader/CustomDialog/CustomDialog.dart';
import 'package:untitled2/AppPages/HomeScreen/HomeScreen.dart';
import 'package:untitled2/AppPages/StreamClass/NewPeoductPage/NewProductScreen.dart';
import 'package:untitled2/Constants/ConstantVariables.dart';
import 'package:untitled2/Widgets/CustomButton.dart';
import 'package:untitled2/new_apis_func/data_layer/constant_data/constant_data.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';

import 'RetrunResponse.dart';

class ReturnScreen extends StatefulWidget {
  String orderId;

  ReturnScreen({
    Key? key,
    required this.orderId,
  }) : super(key: key);

  @override
  _ReturnScreenState createState() => _ReturnScreenState();
}

class _ReturnScreenState extends State<ReturnScreen> {
  RetrunOrderResponse? returnResponse;
  List<ReturnableItem> itemList = [];
  List<AvailableReturn> reasonList = [], actionList = [];
  final colorizeTextStyle =
      TextStyle(fontSize: 6.w, fontWeight: FontWeight.bold);

  final colorizeColors = [
    Colors.lightBlueAccent,
    Colors.grey,
    Colors.black,
    ConstantsVar.appColor,
  ];

  var _scrollController;

  List<ReturnableItem> mList = [];
  int lenght = 0;
  var _commentController;

  String apiToken = '', customerId = '';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _commentController = TextEditingController();
    getRetrunableItems();
  }

  String _reason = 'Please select a reason for returning item\(s\)',
      _action = 'Please select an action';
  int _reasonId = 0, _actionId = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true
      ,
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
        body: returnResponse == null
            ? Container(
                child: const Center(
                  child: const SpinKitRipple(
                    color: Colors.red,
                    size: 90,
                  ),
                ),
              )
            : itemList.length == 0
                ? Container(
                    child: Center(
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
                    ),
                  )
                : Container(
                    height: 100.h,
                    width: 100.w,
                    child: ListView(
                      controller: _scrollController,
                      children: [
                        ListTile(
                          title: Center(
                            child: AutoSizeText(
                              'RETURN ITEM(S) FROM ORDER #${widget.orderId}',
                              maxLines: 1,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 6.w,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: itemList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Card(
                                  shape: const RoundedRectangleBorder(),
                                  child: Container(
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
                                            '\Sr. no. \# ' +
                                                (index + 1)
                                                    .toString()
                                                    .toUpperCase(),
                                            textAlign: TextAlign.center,
                                            textDirection: TextDirection.ltr,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: true,
                                            style: CustomTextStyle
                                                .textFormFieldBold
                                                .copyWith(fontSize: 5.5.w),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) =>
                                                    NewProductDetails(
                                                  screenName:
                                                      'Return Order Screen',
                                                  productId: itemList[index]
                                                      .productId
                                                      .toString(),
                                                ),
                                              ),
                                            );
                                          },
                                          onLongPress: () {
                                            Fluttertoast.showToast(
                                              msg: itemList[index]
                                                  .productName
                                                  .toString()
                                                  .toUpperCase(),
                                              toastLength: Toast.LENGTH_LONG,
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
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
                                                Utils.getSizedBox(
                                                  null,
                                                  3,
                                                ),
                                                Container(
                                                  child: RichText(
                                                    text: TextSpan(
                                                      text: 'Name: ',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 4.w,
                                                      ),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text: itemList[index]
                                                              .productName
                                                              .toString()
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 4.w,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Utils.getSizedBox(null, 6),
                                                Container(
                                                    child: AutoSizeText(
                                                  'Total Quantity: ' +
                                                      itemList[index]
                                                          .quantity
                                                          .toString(),
                                                  style: TextStyle(
                                                    fontSize: 4.w,
                                                  ),
                                                )),
                                                Utils.getSizedBox(null, 20),
                                                Container(
                                                  width: 100.w,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      AutoSizeText(
                                                        'Price: ' +
                                                            '${itemList[index].unitPrice == null ? '' : itemList[index].unitPrice.toString()}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 4.w,
                                                        ),
                                                      ),
                                                      Column(
                                                        children: [
                                                          const Text(
                                                              'Select Quantity'),
                                                          CustomDropDown(
                                                            mList: mList,
                                                            returnableItem:
                                                                itemList[index],
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Utils.getSizedBox(null, 10),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Card(
                          elevation: 1,
                          child: ListTile(
                            title: Center(
                              child: AutoSizeText(
                                'WHY ARE YOU RETURNING THESE ITEMS\?',
                                maxLines: 1,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 5.w,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Utils.getSizedBox(
                          null,
                          15,
                        ),
                        AutoSizeText(
                          'RETURN REASON:',
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 3.w,
                          ),
                        ),
                        Utils.getSizedBox(
                          null,
                          8,
                        ),
                        MenuButton<String>(
                          divider: Container(
                            width: 10.w,
                            child: const Divider(
                              thickness: 2,
                              color: Colors.black,
                            ),
                          ),
                          scrollPhysics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (value) {
                            return Container(
                              height: 30,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 16),
                              child: Text(value.toString()),
                            );
                          },
                          topDivider: true,
                          items: List.generate(reasonList.length,
                              (_index) => reasonList[_index].name),
                          onItemSelected: (value) {
                            if (mounted) _reason = '';
                            _reason = value;
                            _reasonId = 0;
                            for (AvailableReturn element in reasonList) {
                              if (element.name == _reason) {
                                _reasonId = element.id;
                                break;
                              }
                            }
                            print('Reason Id >>>>>>>>' + _reasonId.toString());
                            setState(() {});
                          },
                          child: normalChildButton(
                            _reason,
                          ),
                        ),
                        Utils.getSizedBox(
                          null,
                          15,
                        ),
                        AutoSizeText(
                          'RETURN ACTION:',
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 3.w,
                          ),
                        ),
                        Utils.getSizedBox(
                          null,
                          8,
                        ),
                        MenuButton<String>(
                          crossTheEdge: true,
                          scrollPhysics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (value) {
                            return Container(
                              height: 40,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 16),
                              child: Text(value.toString()),
                            );
                          },
                          topDivider: true,
                          items: List.generate(actionList.length,
                              (_index) => actionList[_index].name),
                          onItemSelected: (value) {
                            if (mounted) _action = '';
                            _action = value;
                            _actionId = 0;
                            for (AvailableReturn element in actionList) {
                              if (element.name == _action) {
                                _actionId = element.id;
                                break;
                              }
                            }
                            print('Action Id >>>>>>' + _actionId.toString());
                            setState(() {});
                          },
                          child: normalChildButton(
                            _action,
                          ),
                        ),
                        Utils.getSizedBox(
                          null,
                          15,
                        ),
                        AutoSizeText(
                          'COMMENTS:',
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 3.w,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Card(
                            child: Container(
                              width: 100.w,
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _commentController,
                                maxLines: 4,
                                decoration: editBoxDecoration(),
                              ),
                            ),
                          ),
                        ),
                        LoadingButton(
                            color: ConstantsVar.appColor,
                            defaultWidget: Text('Submit'.toUpperCase()),
                            type: LoadingButtonType.Raised,
                            borderRadius: 0,
                            loadingWidget: const SpinKitCircle(
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () async {
                              lenght = mList.length;
                              if (mList.isNotEmpty &&
                                  _actionId != 0 &&
                                  _reasonId != 0) {
                                var requestModel = {
                                  'Items': mList,
                                  'ReturnRequestReasonId': _reasonId,
                                  'ReturnRequestActionId': _actionId,
                                  'Comments': _commentController.text,
                                };
                                var body = {
                                  'apiToken': ConstantsVar.prefs
                                          .getString(kapiTokenKey) ??
                                      "",
                                  'customerid': ConstantsVar.prefs
                                          .getString(kcustomerIdKey) ??
                                      "",
                                  'orderid': widget.orderId,
                                  'requestmodel': jsonEncode(requestModel),
                                  kStoreIdVar: await secureStorage.read(
                                          key: kselectedStoreIdKey) ??
                                      "1"
                                };
                                setState(() {});

                                submitRequest(body: body);
                              } else {
                                if (_actionId == 0) {
                                  Fluttertoast.showToast(
                                    msg:
                                        'Please select any action for the item(s).',
                                    toastLength: Toast.LENGTH_LONG,
                                  );
                                }
                                if (_reasonId == 0) {
                                  Fluttertoast.showToast(
                                    msg:
                                        'Please select reason of returning the item(s).',
                                    toastLength: Toast.LENGTH_LONG,
                                  );
                                }

                                if (mList.length == 0) {
                                  Fluttertoast.showToast(
                                    msg:
                                        'Your return request has not been submitted because you haven\'t chosen any items.',
                                    toastLength: Toast.LENGTH_LONG,
                                  );
                                }
                              }
                            })
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget normalChildButton(String _name) => SizedBox(
        width: 93,
        height: 60,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 11),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                  child: Text(_name == null ? '' : _name,
                      overflow: TextOverflow.ellipsis)),
              const SizedBox(
                width: 12,
                height: 17,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  void getRetrunableItems() async {
    final url = Uri.parse(await ApiCalls.getSelectedStore() +
        'GetReturnRequestForm?apiToken=${ConstantsVar.prefs.getString(kapiTokenKey)}&customerid=${ConstantsVar.prefs.getString(kcustomerIdKey)}&orderId=${widget.orderId}&$kStoreIdVar=${await secureStorage.read(key: kselectedStoreIdKey) ?? "1"}');
    log(url.toString());

    try {
      var response = await get(url);
      if (response.statusCode == 200) {
        if (jsonDecode(response.body)["Status"].toString().toLowerCase() ==
            kstatusSuccess) {
          returnResponse = RetrunOrderResponse.fromJson(
            jsonDecode(response.body),
          );
          itemList = returnResponse!.returnrequestform.items;
          reasonList = returnResponse!.returnrequestform.availableReturnReasons;
          actionList = returnResponse!.returnrequestform.availableReturnActions;
          setState(() {});
        } else {
          Fluttertoast.showToast(
            msg: kerrorString +
                "\n" +
                jsonDecode(response.body)["Message"].toString(),
            toastLength: Toast.LENGTH_LONG,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: kerrorString + " Status Code: " + response.statusCode.toString(),
          toastLength: Toast.LENGTH_LONG,
        );
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }

  InputDecoration editBoxDecoration() {
    return const InputDecoration(
      border: InputBorder.none,
      counterText: '',
      hintText: 'Your Comments....',
    );
  }

  void showSucessDialog(String _message) {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialogBox(
            descriptions: _message,
            text: 'Not Go',
            img: 'MyAssets/logo.png',
            isOkay: true,
          );
        });
  }

  void submitRequest({required Map<String, String> body}) async {
    final _url =
        Uri.parse(await ApiCalls.getSelectedStore() + 'SubmitReturnRequest?');
    print(_url);
    log(jsonEncode(body));
    try {
      var response = await post(_url, body: body);
      print('${response.request}' + '${response.statusCode}');
      jsonDecode(response.body)['Status'].toString().toLowerCase() !=
              kstatusSuccess
          ? showSucessDialog(jsonDecode(response.body)['Message'])
          : showSucessDialog(jsonDecode(response.body)['Message']);
      print('\n' + response.body);
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
    }
  }
}

class CustomDropDown extends StatefulWidget {
  final ReturnableItem returnableItem;
  List<ReturnableItem> mList;

  CustomDropDown({
    Key? key,
    required this.returnableItem,
    required this.mList,
  }) : super(key: key);

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  int _quantity = 0;

  @override
  Widget build(BuildContext context) {
    return MenuButton<int>(
      divider: Container(
        width: 10.w,
        child: const Divider(
          thickness: 2,
          color: Colors.black,
        ),
      ),
      scrollPhysics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (value) {
        return Container(
          height: 30,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16),
          child: Text(value.toString()),
        );
      },
      topDivider: true,
      items:
          List.generate(widget.returnableItem.quantity + 1, (_index) => _index),
      toggledChild: Container(
        child: Container(
          height: 2.w,
          child: Text(_quantity.toString()),
        ),
      ),
      onItemSelected: (value) {
        _quantity = value;
        if (mounted) if (value == 0) {
          for (ReturnableItem element in widget.mList) {
            if (element.productName == widget.returnableItem.productName) {
              widget.mList.remove(element);
              break;
            }
          }
        } else {
          var name = widget.returnableItem.productName;
          var seName = widget.returnableItem.productSeName;
          var id = widget.returnableItem.productId;
          var attributeInfo = widget.returnableItem.attributeInfo;
          var price = widget.returnableItem.unitPrice;
          if (widget.mList.isNotEmpty && _quantity != value) {
            for (ReturnableItem element in widget.mList) {
              if (element.productId == id && element.productName == name) {
                ReturnableItem item = ReturnableItem(
                    quantity: value,
                    productId: id,
                    productSeName: seName,
                    unitPrice: price,
                    attributeInfo: attributeInfo,
                    id: id,
                    productName: name);

                element = item;
                widget.mList.remove(element);
                widget.mList.add(element);
                break;
              }
            }
          } else {
            ReturnableItem item = ReturnableItem(
                quantity: value,
                productId: id,
                productSeName: seName,
                unitPrice: price,
                attributeInfo: attributeInfo,
                id: id,
                productName: name);
            for (ReturnableItem element in widget.mList) {
              if (element.productName == name && element.id == id) {
                widget.mList.remove(element);
                break;
              }
            }
            widget.mList.add(item);
          }
        }

        _quantity = value;
        Fluttertoast.showToast(
          msg: _quantity.toString(),
        );
        setState(() {});
        print(jsonEncode(widget.mList.length));
      },
      child: normalChildButton(
        _quantity.toString(),
      ),
    );
  }

  Widget normalChildButton(String _name) => SizedBox(
        width: 93,
        height: 30,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 11),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                  child: Text(_name == null ? '' : _name,
                      overflow: TextOverflow.ellipsis)),
              const SizedBox(
                width: 12,
                height: 17,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
