import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';
import 'package:untitled2/AppPages/AppWishlist/ShareResponse.dart';
import 'package:untitled2/AppPages/AppWishlist/WishlistResponse.dart';
import 'package:untitled2/AppPages/CustomLoader/CustomDialog/CustomDialog.dart';
// import 'package:untitled2/AppPages/CartxxScreen/ConstantVariables.dart';
import 'package:untitled2/AppPages/SearchPage/SearchCategoryResponse/SearchCategoryResponse.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';

class CartCounter extends ChangeNotifier with DiagnosticableTreeMixin {
  int _bagdgeNumber = 0;

  bool _isLocationPermit = false;

  String _productID = '';
  String _categoryId = '';
  String _title = '';
  List<SearchCategories> _searchCategoryList = [];
  List<WishlistItem> _wishlistItems = [];
  bool _isVisible = true;
  SharedResposnse? _shareWishlist;

  SharedResposnse get shareWishlist => _shareWishlist!;

  int get badgeNumber => _bagdgeNumber;

  List<WishlistItem> get wishlistItems => _wishlistItems;

  String get productID => _productID;

  String get categoryID => _categoryId;

  String get title => _title;

  bool get isVisible => _isVisible;

  List<SearchCategories> get searchCategoryList => _searchCategoryList;

  void changeCounter(String cartCounter) {
    _bagdgeNumber = int.parse(cartCounter);
    notifyListeners();
  }

  void getProductID(String productID) {
    _productID = productID;
    notifyListeners();
  }

  void getCategoryID(String categoryID) {
    _categoryId = categoryID;
    notifyListeners();
  }

  void getTitle(String title) {
    _title = title;
    notifyListeners();
  }

  // void getSearchCategory({required String customerId}) async {
  //   log('Search Screen CustomerId for categories:- $customerId');
  //   _isVisible = true;
  //   _isVisible = true;
  //   _searchCategoryList = await ApiCalls.getSearchCategory(customerId: '');
  //   _isVisible = false;
  //   notifyListeners();
  // }

  void getWishlist({required String baseUrl, required String storeid}) async {
    _isVisible = true;
    _wishlistItems =
        await ApiCalls.getWishlist(baseUrl: baseUrl, storeId: storeid);
    _isVisible = false;
    notifyListeners();
  }

  void shareMyWishlist(
      {required String baseUrl,
      required String storeId,
      required String message,
      required String customerEmail,
      required String friendEmail,
      required BuildContext ctx}) async {
    CustomProgressDialog _progressDialog = CustomProgressDialog(
      ctx,
      loadingWidget: const SpinKitRipple(
        color: Colors.red,
        size: 30,
      ),
    );
    _progressDialog.show();
    var response = await ApiCalls.shareWishlist(
        customerEmail: customerEmail,
        friendEmail: friendEmail,
        baseUrl: baseUrl,
        storeId: storeId,
        message: message);
    log(response);
    if (response.toString() == 'Nothing Here') {
      Fluttertoast.showToast(
        msg: 'Something Went Wrong. Please try again!',
        toastLength: Toast.LENGTH_LONG,
      );
      _progressDialog.dismiss();
    } else {
      jsonDecode(response)['status'].toString() != 'Failed'
          ? okay(ctx: ctx)
          : showDialog(
              context: ctx,
              builder: (ctx) => CustomDialogBox(
                descriptions: 'Sharing Failed!\n' +
                    jsonDecode(response)['Message'].toString(),
                text: 'Not Go',
                img: 'MyAssets/logo.png',
                isOkay: false,
              ),
            );

      _progressDialog.dismiss();
    }
    notifyListeners();
  }

  void deleteWishlist(
      {required String baseUrl,
      required String storeId,
      required BuildContext ctx}) async {
    CustomProgressDialog _progressDialog = CustomProgressDialog(
      ctx,
      loadingWidget: const SpinKitRipple(
        color: Colors.red,
        size: 30,
      ),
    );
    _progressDialog.show();
    var response = await ApiCalls.deleteWishlist(
      baseUrl: baseUrl,
      storeId: storeId,
    );
    log(response);
    if (response.toString() == 'Nothing Here') {
      Fluttertoast.showToast(
        msg: 'Something Went Wrong. Please try again!',
        toastLength: Toast.LENGTH_LONG,
      );
      _progressDialog.dismiss();
    } else {
      jsonDecode(response)['status'].toString() != 'Failed'
          ? _resetWishlist(baseUrl: baseUrl, storeId: storeId)
          : showDialog(
              context: ctx,
              builder: (ctx) => CustomDialogBox(
                descriptions: 'Can\'t delete Wishlist!\n' +
                    jsonDecode(response)['Message'].toString(),
                text: 'Not Go',
                img: 'MyAssets/logo.png',
                isOkay: false,
              ),
            );

      _progressDialog.dismiss();
    }
    notifyListeners();
  }

  _resetWishlist({required String baseUrl, required String storeId}) {
    Fluttertoast.showToast(
        msg: 'Wishlist Deleted', toastLength: Toast.LENGTH_LONG);
    getWishlist(baseUrl: baseUrl, storeid: storeId);
  }

  void okay({required BuildContext ctx}) {
    Fluttertoast.showToast(msg: 'Wishlist Shared!');
    Navigator.pop(ctx);
  }
}
