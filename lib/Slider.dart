import 'dart:core';
import 'dart:developer';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:play_kit/play_kit.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:untitled2/new_apis_func/data_layer/constant_data/constant_data.dart';
import 'package:untitled2/new_apis_func/presentation_layer/events_handlers/facebook_events.dart';
import 'package:untitled2/new_apis_func/presentation_layer/events_handlers/firebase_events.dart';
import 'package:untitled2/new_apis_func/presentation_layer/provider_class/provider_contracter.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';

import 'Constants/ConstantVariables.dart';

class SliderClass extends StatefulWidget {
  final double productPrice;

  SliderClass({
    Key? key,
    required this.images,
    required this.largeImage,
    required this.context,
    required this.productId,
    required this.discountPercentage,
    required this.overview,
    required this.productUrl,
    required this.apiToken,
    required this.customerId,
    required this.productName,
    required this.senderName,
    required this.recevierName,
    required this.senderEmail,
    required this.receiverEmail,
    required this.message,
    required this.attributeId,
    // required this.myKey,
    required this.isWishlisted,
    required this.isGiftCard,
    required VoidCallback setState,
    required this.productPrice,
    required this.categoryId
  }) : super(key: key);
  final List<String> images;
  final List<String> largeImage;
  BuildContext context;
  final String discountPercentage;
  final String productId;
  bool isWishlisted, isGiftCard;
  final String productName,
      customerId,
      apiToken,
      productUrl,
      overview,
      senderName,
      recevierName,
      senderEmail,
      receiverEmail,
      message,
      attributeId, categoryId;

  @override
  _SliderClassState createState() => _SliderClassState();
}

class _SliderClassState extends State<SliderClass> {
  late ScreenshotController myKey;
  final Color? _color = ConstantsVar.appColor;
  bool _isLiked = false;
  String bogoCatId = '';

  @override
  initState() {
    myKey = ScreenshotController();
    _isLiked = widget.isWishlisted;
    setState(() {});
    final provider = Provider.of<NewApisProvider>(context,listen:false);
    provider.setBogoCategoryValue();
    setState(() {
      bogoCatId = provider.bogoValue;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliderImages(widget.images, widget.largeImage, widget.context,
        widget.discountPercentage, widget.productId,
        productUrl: widget.productUrl,
        customerId: widget.customerId,
        apiToken: widget.apiToken,
        overview: widget.overview,
        productName: widget.productName,
        isWishlisted: widget.isWishlisted);
  }

  Widget SliderImages(
    List<String> images,
    List<String> largeImage,
    BuildContext context,
    String discountPercentage,
    String productId, {
    required String overview,
    required String productUrl,
    required String apiToken,
    required String customerId,
    required String productName,
    required bool isWishlisted,
  }) {
    ThemeData theme = Theme.of(context);
    return SizedBox(
      height: 52.h,
      width: 85.w,
      child: Stack(
        children: [
          Center(
            child: Container(
              // padding: EdgeInsets.all(0),
              child: Center(
                child: Screenshot(
                  controller: myKey,
                  child: CarouselSlider.builder(
                    enableAutoSlider: images.length > 1 ? true : false,
                    unlimitedMode: true,
                    viewportFraction: 1,
                    slideBuilder: (index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.w),
                        child: Hero(
                          tag: 'ProductImage$productId',
                          transitionOnUserGestures: true,
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => ImageDialog(
                                  imageUrl: images[index],
                                ),
                              );
                            },
                            child: CachedNetworkImage(
                              errorWidget: (context, error, _) => Center(
                                child: AutoSizeText(
                                  kerrorString,
                                  style: TextStyle(
                                    fontSize: 4.w,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                              fit: BoxFit.fill,
                              imageUrl: images[index],
                              placeholder: (context, reason) => const Center(
                                child: SpinKitRipple(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    slideTransform: const DefaultTransform(),
                    slideIndicator: CircularSlideIndicator(
                        padding: EdgeInsets.only(top: 4.w),
                        alignment: Alignment.bottomCenter,
                        currentIndicatorColor: Colors.black),
                    itemCount: images.length,
                  ),
                ),
              ),
            ),
          ),
          Consumer<NewApisProvider>(
            builder:(ctx,val,_)=>!widget.categoryId.contains(val.bogoValue) || val.bogoValue.isEmpty? Visibility(
              visible:
              widget.discountPercentage != ''
                  ? true
                  : false,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      width: 14.w,
                      height: 14.w,
                      child: Stack(
                        children: [
                          Image.asset(
                            'MyAssets/plaincircle.png',
                            width: 15.w,
                            height: 15.w,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              widget.discountPercentage,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 4.8.w,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
              ),
            ):Padding(
              padding: const EdgeInsets.all(4.0),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: 14.w,
                    height: 14.w,
                    child: Image.asset(
                      'MyAssets/bogo_logo.jpeg',
                      width: 15.w,
                      height: 15.w,
                    ),
                  )),
            ),
          ),
          Visibility(
            visible: true,
            child: Positioned(
              top: 1,
              right: .1,
              child: Row(
                children: [
                  Card(
                    elevation: 10,
                    shape: const CircleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 6, left: 6, bottom: 4, right: 4),
                      child: Center(
                        child: LikeButton(
                          bubblesSize: 15,
                          circleSize: 20,
                          onTap: (isLiked) async {
                            _isLiked == false
                                ? checkGiftCard()
                                : await ApiCalls.removeFromWishlist(
                                    productId: productId,
                                    baseurl: await ApiCalls.getSelectedStore(),
                                    storeId: await secureStorage.read(
                                            key: kselectedStoreIdKey) ??
                                        '1',
                                    context: context,
                                  ).then((value) =>
                                    setState(() => _isLiked = value));

                            return _isLiked;
                          },
                          // size: IconTheme.of(context).size! + 4,
                          circleColor: const CircleColor(
                            start: ConstantsVar.appColor,
                            end: ConstantsVar.appColor,
                          ),
                          isLiked: _isLiked,
                          bubblesColor: const BubblesColor(
                            dotPrimaryColor: ConstantsVar.appColor,
                            dotSecondaryColor: Colors.green,
                          ),
                          // isLiked: isWishlisted,
                          likeBuilder: (bool isLiked) {
                            return Center(
                              child: Icon(
                                FontAwesomeIcons.solidHeart,
                                color: isLiked ? _color : Colors.grey,
                                size: IconTheme.of(context).size!,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await myKey.capture().then((image) async {
                        if (image != null) {
                          final directory =
                              await getApplicationDocumentsDirectory();
                          final imagePath =
                              await File('${directory.path}/image.png')
                                  .create();
                          await imagePath.writeAsBytes(image).whenComplete(
                              () async => await Share.shareFiles(
                                  [imagePath.path],
                                  text: 'View product: $productUrl'));
                          print(image);

                          /// Share Plugin

                        }
                      });
                    },
                    child: const Card(
                      elevation: 10,
                      shape: CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 7.0, right: 9, left: 7, bottom: 7),
                        child: Center(
                          child: Icon(
                            Icons.share,
                            color: ConstantsVar.appColor,
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
    );
  }

  void checkGiftCard() async {
    if (widget.isGiftCard == true) {
      if (widget.recevierName.isEmpty ||
          widget.recevierName == '' ||
          widget.receiverEmail.isEmpty ||
          widget.receiverEmail == '' ||
          widget.senderEmail.isEmpty ||
          widget.senderEmail == '' ||
          widget.senderName.isEmpty ||
          widget.senderName == '') {
        Fluttertoast.showToast(
            msg:
                'Please check following fields: Recipient Name,\nRecipient Email,\nSender Name,\nSender Email,\nTHE Special On Gift Card UAE.');
      } else {
        await ApiCalls.addToWishlist(
          productId: widget.productId,
          baseUrl: await ApiCalls.getSelectedStore(),
          storeId: await secureStorage.read(key: kselectedStoreIdKey) ?? '1',
          context: context,
          senderName: widget.senderName,
          receiverEmail: widget.receiverEmail,
          msg: widget.message,
          receiverName: widget.recevierName,
          senderEmail: widget.senderEmail,
          attributeId: widget.attributeId,
          itemQuantity:  (widget.categoryId.contains(bogoCatId) && bogoCatId.isNotEmpty) ? '2' : '1',
        ).then((value) => setState(() => _isLiked = value));
        final _provider = Provider.of<NewApisProvider>(
          context,
          listen: false,
        );

        _provider.getCurrency();
        log(_provider.currency);

        final _fireEvent = FirebaseEvents.initialize(context: context);
        _fireEvent
            .sendAddToWishlistData(
              currency: _provider.currency,
              itemName: widget.productName,
              itemId: widget.productId,
              price: widget.productPrice,
            )
            .whenComplete(
              () => log(
                "Firebase Event Complete",
              ),
            );

        final _fbEvent = FacebookEvents();
        _fbEvent
            .sendAddToWishlistData(
              currency: _provider.currency,
              productName: widget.productName,
              productId: widget.productId,
              price: widget.productPrice,
            )
            .whenComplete(
              () => log(
                "Facebook wishlist event complete",
              ),
            );
      }
    } else {
      // final _wishlistProvider =
      //     Provider.of<FirebaseAnalytics>(context, listen: false);
      // await _wishlistProvider.logAddToWishlist(items: [
      //   AnalyticsEventItem(
      //     itemName: widget.productName,
      //     itemId: widget.productId.toString(),
      //     price: widget.productPrice,
      //     quantity: 1,
      //     currency: 'AED',
      //   )
      // ], currency: 'AED');

      await ApiCalls.addToWishlist(
        productId: widget.productId,
        baseUrl: await ApiCalls.getSelectedStore(),
        storeId: await secureStorage.read(key: kselectedStoreIdKey) ?? '1',
        context: context,
        senderName: '',
        receiverEmail: '',
        msg: '',
        receiverName: '',
        senderEmail: '',
        attributeId: '',
        itemQuantity: (widget.categoryId.contains(bogoCatId) && bogoCatId.isNotEmpty) ? '2' : '1',
      ).then((value) => setState(() => _isLiked = value));
      final _provider = Provider.of<NewApisProvider>(
        context,
        listen: false,
      );

      _provider.getCurrency();
      log(_provider.currency);

      final _fireEvent = FirebaseEvents.initialize(context: context);
      _fireEvent
          .sendAddToWishlistData(
            currency: _provider.currency,
            itemName: widget.productName,
            itemId: widget.productId,
            price: widget.productPrice,
          )
          .whenComplete(
            () => log(
              "Firebase Event Complete",
            ),
          );

      final _fbEvent = FacebookEvents();
      _fbEvent
          .sendAddToWishlistData(
            currency: _provider.currency,
            productName: widget.productName,
            productId: widget.productId,
            price: widget.productPrice,
          )
          .whenComplete(
            () => log(
              "Facebook wishlist event complete",
            ),
          );
    }
  }
}

class ImageDialog extends StatelessWidget {
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: PlayContainer(
        blur: 20,
        width: 105.w,
        height: 100.h,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PhotoView(
            imageProvider: NetworkImage(imageUrl),
          ),
        ),
      ),
    );
  }

  const ImageDialog({Key? key, required this.imageUrl}) : super(key: key);
}
