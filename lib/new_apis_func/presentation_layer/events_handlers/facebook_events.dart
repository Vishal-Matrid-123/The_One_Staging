import 'dart:developer';

import 'package:facebook_app_events/facebook_app_events.dart';

import 'event_init.dart';

class FacebookEvents {
  final FacebookAppEvents _facebookEvents =
      EventsInitializer().returnFacebookEvent();

  Future<void> sendAddToCartEvent(
      {required String productId,
      required String type,
      required String currency,
      required double price}) async {
    _facebookEvents.logAddToCart(
      id: productId,
      type: type,
      currency: currency,
      price: price,
    );
  }

  Future<void> sendScreenViewData(
      {required String type, required String id}) async {
    _facebookEvents.logViewContent(
      type: type,
      id: id,
    );
  }

  Future<void> sendSearchData({required String keyword}) async {
    _facebookEvents.logEvent(
      name: 'Search',
      parameters: {
        'Content ID': keyword,
        'Content Type': 'Product Searching',
        'ValueToSum': '',
      },
    ).then((value) => log('Search Event'));
  }

  Future<void> sendSubscribeData({
    required String productId,
  }) async {
    _facebookEvents.logEvent(
      name: 'Subscribe Product',
      parameters: {
        'Content ID': productId,
        'Content Type': 'Product Subscribing',
        'ValueToSum': '',
      },
    );
  }

  Future<void> sendAddToWishlistData(
      {required String productName,
      required String productId,
      required String currency,
      required double price}) async {
    _facebookEvents.logAddToWishlist(
      id: productId,
      type: "product_wishlist",
      currency: currency,
      price: price,
      content: {
        "product_name": productName,
      },
    );
  }

  Future<void> sendInitiateCheckoutData(
      {required double totalPrice, required String currency}) async {
    _facebookEvents.logInitiatedCheckout(
      totalPrice: totalPrice,
      currency: currency,
    );
  }
}
