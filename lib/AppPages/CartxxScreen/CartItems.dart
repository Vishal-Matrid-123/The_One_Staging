import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/AppPages/StreamClass/NewPeoductPage/NewProductScreen.dart';
import 'package:untitled2/Widgets/CustomButton.dart';
import 'package:untitled2/new_apis_func/presentation_layer/events_handlers/firebase_events.dart';
import 'package:untitled2/new_apis_func/presentation_layer/provider_class/provider_contracter.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';

import '../../new_apis_func/data_layer/constant_data/constant_data.dart';

class CartItem extends StatefulWidget {
  String unitPrice;

  CartItem(
      {Key? key,
      required this.unitPrice,
      required this.quantity2,
      required this.id,
      required this.itemID,
      required this.imageUrl,
      required this.title,
      required this.sku,
      required this.price,
      required this.quantity,
      required this.updateUi,
      required this.reload,
      required this.productId})
      : super(key: key);
  final int itemID;
  final String productId;
  final String imageUrl;
  final String title;
  final String sku;
  final String price;
  int quantity, quantity2;
  final VoidCallback updateUi, reload;
  final String id;

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => NewProductDetails(
                      productId: widget.productId.toString(),
                      screenName: 'Cart Screen2',
                    )));
      },
      child: SizedBox(
        height: 24.h,
        child: Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Row(
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.only(
                          right: 8, left: 8, top: 8, bottom: 8),
                      width: 80,
                      height: 80,
                      child: CachedNetworkImage(
                        imageUrl: widget.imageUrl,
                        fit: BoxFit.cover,
                      )),
                  Expanded(
                    child: Container(
                      height: 23.h,
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          AutoSizeText(
                            widget.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: CustomTextStyle.textFormFieldSemiBold
                                .copyWith(fontSize: 16),
                          ),
                          // Utils.getSizedBox(null, 6),
                          AutoSizeText(
                            "SKU : ${widget.sku}",
                            style: CustomTextStyle.textFormFieldRegular
                                .copyWith(color: Colors.grey, fontSize: 15),
                          ),
                          // Utils.getSizedBox(null, 6),
                          AutoSizeText(
                            widget.unitPrice,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: AutoSizeText(
                                  widget.price,
                                  overflow: TextOverflow.ellipsis,
                                  style: CustomTextStyle.textFormFieldBlack
                                      .copyWith(color: Colors.green),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    InkWell(
                                      radius: 36,
                                      onTap: () async {
                                        final _provider =
                                            Provider.of<NewApisProvider>(
                                                context,
                                                listen: false);
                                        _provider.getCurrency();
                                        FirebaseEvents.initialize(
                                                context: context)
                                            .sendRemoveFromCartData(
                                          currency: _provider.currency,
                                          value: double.parse(
                                            widget.unitPrice.replaceAll(
                                                RegExp(r'[^0-9]'), ''),
                                          ).floorToDouble(),
                                          items: [
                                            AnalyticsEventItem(
                                              itemId: widget.itemID.toString(),
                                              price: double.parse(
                                                widget.unitPrice.replaceAll(
                                                    RegExp(r'[^0-9]'), ''),
                                              ),
                                            ),
                                          ],
                                        );
                                        // print('SomeOne Tap on Me');
                                        // print(widget.id);

                                        if (widget.quantity < 1) {
                                          Fluttertoast.showToast(
                                              msg: 'Quantity cannot be zero.'
                                                  ' The product will be removed from cart');

                                          ApiCalls.deleteCartItem(
                                            baseUrl: await ApiCalls
                                                .getSelectedStore(),
                                            itemID: widget.itemID,
                                            storeId: await ApiCalls
                                                .getSelectedStore(),
                                            ctx: context,
                                          ).then((value) async {
                                            //TODO need to refresh the data in the cart
                                            ApiCalls.readCounter(
                                                context: context);
                                            widget.updateUi;
                                          });
                                        } else {
                                          setState(() {
                                            widget.quantity =
                                                widget.quantity - 1;

                                            print('${widget.quantity}');
                                          });
                                          ApiCalls.updateCart(
                                            baseUrl: await ApiCalls
                                                .getSelectedStore(),
                                            quantity: '${widget.quantity}',
                                            itemId: widget.itemID,
                                            storeId: await secureStorage.read(
                                                    key: kselectedStoreIdKey) ??
                                                '1',
                                          ).then((value) async {
                                            ApiCalls.readCounter(
                                                context: context);
                                            widget.updateUi();
                                            widget.reload();
                                          });
                                        }
                                      },
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(6.0)),
                                        // color: Colors.red,
                                        child: const Icon(
                                          Icons.remove,
                                          size: 24,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Container(
                                      color: Colors.grey.shade200,
                                      padding: const EdgeInsets.only(
                                          bottom: 2, right: 12, left: 12),
                                      child: AutoSizeText(
                                        "${widget.quantity2}",
                                        style: CustomTextStyle
                                            .textFormFieldSemiBold,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    InkWell(
                                      radius: 36,
                                      onTap: () async {
                                        print('SomeOne Tap on Me');

                                        SchedulerBinding.instance!
                                            .addPostFrameCallback(
                                                (timeStamp) async {
                                          setState(() {
                                            widget.quantity =
                                                widget.quantity + 1;
                                          });
                                          ApiCalls.updateCart(
                                            baseUrl: await ApiCalls
                                                .getSelectedStore(),
                                            quantity: '${widget.quantity}',
                                            itemId: widget.itemID,
                                            storeId: await secureStorage.read(
                                                    key: kselectedStoreIdKey) ??
                                                '1',
                                          ).then((value) async {
                                            widget.reload();
                                            ApiCalls.readCounter(
                                                context: context);
                                          });
                                        });
                                        print('${widget.quantity}');
                                        // });
                                      },
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(6.0)),
                                        child: const Icon(
                                          Icons.add,
                                          size: 22,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    flex: 100,
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                radius: 36,
                onTap: () async {
                  // showpopup();
                  ApiCalls.deleteCartItem(
                    baseUrl: await ApiCalls.getSelectedStore(),
                    itemID: widget.itemID,
                    storeId:
                        await secureStorage.read(key: kselectedStoreIdKey) ??
                            '1',
                    ctx: context,
                  ).then((value) async {
                    ApiCalls.readCounter(context: context);
                    widget.reload();

                    Fluttertoast.showToast(msg: 'Removed from Cart');
                  });
                  final _provider =
                      Provider.of<NewApisProvider>(context, listen: false);
                  _provider.getCurrency();
                  FirebaseEvents.initialize(context: context)
                      .sendRemoveFromCartData(
                    currency: _provider.currency,
                    value: double.parse(
                      widget.unitPrice.replaceAll(RegExp(r'[^0-9]'), ''),
                    ).floorToDouble(),
                    items: [
                      AnalyticsEventItem(
                        itemId: widget.itemID.toString(),
                        price: double.parse(
                          widget.unitPrice.replaceAll(RegExp(r'[^0-9]'), ''),
                        ),
                      ),
                    ],
                  );
                },
                child: Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 10, top: 8),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: Colors.black),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
