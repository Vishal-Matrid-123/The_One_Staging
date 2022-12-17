import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled2/new_apis_func/presentation_layer/events_handlers/event_init.dart';

class FirebaseEvents {
  late final FirebaseAnalytics _analytics;

  FirebaseEvents.initialize({required BuildContext context}) {
    _analytics = EventsInitializer().returnFirebaseAnalytics(context: context);
  }

  Future<void> sendAddToCart(
      {required String currency,
      required String itemName,
      required String itemId,
      required double price,
      String? categoryName}) async {
    await _analytics.logAddToCart(
      items: [
        AnalyticsEventItem(
          itemName: itemName,
          itemId: itemId,
          price: price,
          itemListName: categoryName ?? "",
          quantity: 1,
        ),
      ],
      currency: currency,
      value: price,
    );
  }

  Future<void> sendAddToWishlistData({
    required String currency,
    required String itemName,
    required String itemId,
    required double price,
    String? categoryName,
  }) async {
    await _analytics.logAddToWishlist(
      items: [
        AnalyticsEventItem(
          itemName: itemName,
          itemId: itemId,
          price: price,
          itemListName: categoryName ?? "",
          quantity: 1,
        ),
      ],
      currency: currency,
      value: price,
    );
  }

  Future<void> sendLoginData() async {
    await _analytics.logLogin(loginMethod: 'THE One Mobile App Account.');
  }

  Future<void> sendBeginCheckout({
    required double value,
    required String currency,
    required List<AnalyticsEventItem> items,
  }) async {
    await _analytics.logBeginCheckout(
      value: value,
      currency: currency,
      items: items,
    );
  }

  Future<void> sendRemoveFromCartData({
    required double value,
    required String currency,
    required List<AnalyticsEventItem> items,
  }) async {
    await _analytics.logRemoveFromCart(
      value: value,
      currency: currency,
      items: items,
    );
  }

  Future<void> sendScreenViewData({
    required String screenName,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
    );
  }

  Future<void> sendSearchData({required String searchTerm}) async {
    await _analytics.logSearch(
      searchTerm: searchTerm,
    );
  }

  Future<void> sendViewCartData({
    required double value,
    required String currency,
    required List<AnalyticsEventItem> items,
  }) async {
    await _analytics.logViewCart(
      value: value,
      currency: currency,
      items: items,
    );
  }

  Future<void> sendViewItemData({
    required double value,
    required String currency,
    required List<AnalyticsEventItem> items,
  }) async {
    await _analytics.logViewItem(
      value: value,
      currency: currency,
      items: items,
    );
  }

  Future<void> sendViewItemsListData({
    required String itemListName,
    required String itemListId,
    required List<AnalyticsEventItem> items,
  }) async {
    await _analytics.logViewItemList(
      items: items,
      itemListName: itemListName,
      itemListId: itemListId,
    );
  }

  Future<void> sendViewSearchResultData({
    required String searchTerm,
  }) async {
    await _analytics.logViewSearchResults(
      searchTerm: searchTerm,
    );
  }
}
