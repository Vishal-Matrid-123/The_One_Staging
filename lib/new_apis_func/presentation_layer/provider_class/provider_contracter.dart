import 'dart:convert';
import 'dart:developer';

import 'package:app_settings/app_settings.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:untitled2/AppPages/MyAccount/MyAccount.dart';
import 'package:untitled2/AppPages/MyAddresses/AddressResponse.dart';
import 'package:untitled2/AppPages/StreamClass/NewPeoductPage/ProductResponse.dart';
import 'package:untitled2/AppPages/models/AddressResponse.dart';
import 'package:untitled2/AppPages/models/OrderSummaryResponse.dart';
import 'package:untitled2/new_apis_func/data_layer/constant_data/constant_data.dart';
import 'package:untitled2/new_apis_func/data_layer/new_model/main_category_response_models/main_category_response.dart';
import 'package:untitled2/new_apis_func/data_layer/new_model/store_model/store_model.dart';
import 'package:untitled2/new_apis_func/presentation_layer/events_handlers/facebook_events.dart';
import 'package:untitled2/new_apis_func/presentation_layer/events_handlers/firebase_events.dart';
import 'package:untitled2/new_apis_func/presentation_layer/screens/store_selection_screen/store_selection_screen.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';

import '../../../AppPages/HomeScreen/HomeScreen.dart';
import '../../../AppPages/HomeScreen/HomeScreenMain/SearchSuggestions/SearchSuggestion.dart';
import '../../../AppPages/MyAddresses/MyAddresses.dart';
import '../../../AppPages/MyOrders/Response/OrderResponse.dart';
import '../../../AppPages/SearchPage/SearchCategoryResponse/SearchCategoryResponse.dart';
import '../../../AppPages/ShippingxxMethodxx/Responsexx/ShippingxxMethodxxResponse.dart';
import '../../../AppPages/models/ShippingResponse.dart';
import '../../../Constants/ConstantVariables.dart';
import '../../../PojoClass/NetworkModelClass/CartModelClass/CartModel.dart';
import '../../data_layer/new_model/main_category_response_models/main_categoty_list_model.dart';
import '../../data_layer/new_model/new_product_list_response/new_product_list_response.dart';
import '../../data_layer/new_model/new_subcateroy_response/new_subcategory_response.dart';

class NewApisProvider extends ChangeNotifier {
  bool _loading = false;
  bool _isPermanentDenied = false;
  bool _isupdated = false;
  bool _isLocationAllow = false;
  bool _passwordObs = false;
  bool _isError = false;
  bool _isBillingScreenError = false;
  bool _isCartScreenError = false;
  bool _isSubCategoryScreenError = false;
  bool _isProductListScreenError = false;
  bool _isProductDetailScreenError = false;
  bool _isMyOrderScreenError = false;
  bool _isShippingDetailsScreenError = false;
  bool _isShippingMethodScreenError = false;
  bool _isSwitchVal = false;
  int _productCount = 0;

  double _checkoutAmount = 0.0;
  String _currency = "AED";
  String _appVersion = "";
  CartModel? _cartModel;
  List<StoreData> _storeResponse = [];

  Ordertotals _orderSummaryTotal = Ordertotals(
    isEditable: false,
    subTotal: "",
    subTotalDiscount: null,
    shipping: "",
    requiresShipping: false,
    selectedShippingMethod: "",
    hideShippingTotal: false,
    paymentMethodAdditionalFee: null,
    tax: "",
    taxRates: [],
    displayTax: false,
    displayTaxRates: false,
    giftCards: [],
    orderTotalDiscount: "",
    redeemedRewardPoints: 0,
    redeemedRewardPointsAmount: 0,
    willEarnRewardPoints: 0,
    orderTotal: "",
  );

  ProductResponse? _productResponse;
  List<String> _searchSuggestions = [];
  List<NewCategoryListResponse> _categoryList = [];
  List<SubcategoriesData> _subCategoryList = [];
  List<ProductListResponse> _productList = [];
  List<SearchCategories> _searchCategoryList = [];
  List<AddressList> _addresses = [];
  List<OrderedItems> _orderedList = [];
  List<ExistingBillingAddresses> _existingAddresses = [];
  List<ExistingShippingAddress> _existingShippingAddresses = [];
  List<PickupPoint> _pickupPoints = [];
  List<Order> _orders = [];
  List<AnalyticsEventItem> _eventItemsForCheckout = [];
  List<AnalyticsEventItem> _eventItemsForViewCart = [];
  List<AnalyticsEventItem> _eventItemsForItemList = [];

  double get checkoutAmount => _checkoutAmount;

  String get currency => _currency;

  /*Getter Methods*/

  int get productCount => _productCount;

  bool get isLocationAllow => _isLocationAllow;

  bool get isPermanentDenied => _isPermanentDenied;

  bool get isShippingDetailsScreenError => _isShippingDetailsScreenError;

  bool get isProductListScreenError => _isProductListScreenError;

  bool get isProductDetailScreenError => _isProductDetailScreenError;

  bool get isError => _isError;

  bool get passwordObs => _passwordObs;

  bool get isMyOrderScreenError => _isMyOrderScreenError;

  bool get isSubCategoryScreenError => _isSubCategoryScreenError;

  bool get isCartScreenError => _isCartScreenError;

  bool get isBillingScreenError => _isBillingScreenError;

  bool get loading => _loading;

  bool get isShippingMethodScreenError => _isShippingMethodScreenError;

  bool get isSwitchVal => _isSwitchVal;

  bool get isupdated => _isupdated;

  ProductResponse get productResponse => _productResponse!;

  CartModel get cartModel => _cartModel!;

  List<StoreData> get storeResponse => _storeResponse;

  Ordertotals get orderSummaryTotal => _orderSummaryTotal;

  List<NewCategoryListResponse> get categoryList => _categoryList;

  List<SubcategoriesData> get subCategoryList => _subCategoryList;

  List<ShippingMethod> get shippingMethod => _shippingMethod;

  List<Order> get orders => _orders;

  List<ProductListResponse> get productList => _productList;

  List<SearchCategories> get searchCategoryList => _searchCategoryList;

  List<AddressList> get addresses => _addresses;

  List<OrderedItems> get orderedList => _orderedList;

  List<ExistingBillingAddresses> get existingAddresses => _existingAddresses;

  List<ExistingShippingAddress> get existingShippingAddresses =>
      _existingShippingAddresses;

  List<PickupPoint> get pickupPoints => _pickupPoints;

  List<ShippingMethod> _shippingMethod = [];

  List<String> get searchSuggestions => _searchSuggestions;

  List<AnalyticsEventItem> get eventItemsForCheckout => _eventItemsForCheckout;

  List<AnalyticsEventItem> get eventItemsForItemList => _eventItemsForItemList;

  List<AnalyticsEventItem> get eventItemsForViewCart => _eventItemsForViewCart;

  String get appVersion => _appVersion;

  /* Get All Categories Here*/

  Future<void> getCategoryList({
    required String customerId,
    required BuildContext context,
  }) async {
    _loading = true;
    _isError = false;
    _categoryList = [];

    await ApiCalls.getCategory(context,
            customerId: customerId,
            storeId: await secureStorage.read(key: kselectedStoreIdKey) ?? '1',
            baseUrl: await ApiCalls.getSelectedStore())
        .then((value) {
      switch (value) {
        case kerrorString:
          _isError = true;
          break;
        default:
          try {
            final response = NewCategoryResponse.fromJson(jsonDecode(value));
            _categoryList =
                (jsonDecode(response.responseData.replaceAll('\\', '')) as List)
                    .map((e) => NewCategoryListResponse.fromJson(e))
                    .toList();
            /*Firebase Event*/
            final _fireEvent = FirebaseEvents.initialize(context: context);
            _fireEvent
                .sendScreenViewData(
                  screenName: "Home Category",
                )
                .whenComplete(
                  () => log("Firebase Event Complete"),
                );
            /*Facebook events*/
            FacebookEvents().sendScreenViewData(type: "Home Category", id: "");

            _isError = false;
            _loading = false;
          } catch (e) {
            _isError = true;
            _loading = false;
          }

          break;
      }
    });
    _loading = false;

    notifyListeners();
  }

  /* Get Subcategories of individual category here*/

  Future<void> getSubcategoryList(
      {required String catId, required BuildContext context}) async {
    _loading = true;
    _subCategoryList = [];
    _isSubCategoryScreenError = false;
    await ApiCalls.getSubCategories(
            storeId: await secureStorage.read(key: kselectedStoreIdKey) ?? '1',
            baseUrl: await ApiCalls.getSelectedStore(),
            catId: catId)
        .then((value) {
      switch (value) {
        case kerrorString:
          _isSubCategoryScreenError = true;
          break;
        default:
          try {
            final response =
                NewSubcategoryListResponse.fromJson(jsonDecode(value));
            _subCategoryList = response.responseData;

            /*Firebase Event*/
            final _fireEvent = FirebaseEvents.initialize(context: context);
            _fireEvent
                .sendScreenViewData(
                  screenName: "Sub Category Screen",
                )
                .whenComplete(
                  () => log("Firebase Event Complete"),
                );
            /*Facebook events*/
            FacebookEvents()
                .sendScreenViewData(type: "Sub Category Screen", id: catId);

            _isSubCategoryScreenError = false;
            _loading = false;
          } catch (e) {
            _isSubCategoryScreenError = true;
            _loading = false;
          }
          // _isSubCategoryScreenError= false;
          break;
      }
    });
    _loading = false;

    notifyListeners();
  }

  /* Get Products of individual category Here*/

  Future<void> getProductList(
      {required String catId,
      required int pageIndex,
      required bool isLoading}) async {
    isLoading == false ? _loading = true : _loading = false;
    if (isLoading == false) {
      _productList = [];
    }
    _isProductListScreenError = false;
    await ApiCalls.getCategoryById(
      storeId: await secureStorage.read(key: kselectedStoreIdKey) ?? '1',
      baseUrl: await ApiCalls.getSelectedStore(),
      catId: catId,
      pageIndex: pageIndex,
    ).then(
      (value) {
        switch (value) {
          case kerrorString:
            _isProductListScreenError = true;
            break;
          default:
            try {
              final response = NewProductListResponse.fromJson(
                jsonDecode(value),
              );

              if (isLoading == true) {
                _productList.addAll(response.responseData);
              } else {
                _productList = response.responseData;
                _productCount = response.productCount;
              }
              _isProductListScreenError = false;
              _loading = false;
            } catch (e) {
              _isProductListScreenError = true;
              _loading = false;
            }

            break;
        }
      },
    );
    _loading = false;

    notifyListeners();
  }

  /* Get Product details from here*/

  Future<void> getProductDetail(
      {required String productId, required String customerId}) async {
    _loading = true;

    _isProductDetailScreenError = false;

    String _baseUrl = await ApiCalls.getSelectedStore();

    await ApiCalls.getProductData(
            productId,
            _baseUrl,
            await secureStorage.read(key: kselectedStoreIdKey) ?? '1',
            customerId)
        .then(
      (value) {
        switch (value) {
          case kerrorString:
            _isProductDetailScreenError = true;
            break;
          default:
            try {
              _productResponse = ProductResponse.fromJson(jsonDecode(value));
              _isProductDetailScreenError = false;
              _loading = false;
              notifyListeners();
            } catch (e) {
              _loading = false;
              _isProductDetailScreenError = true;
            }

            break;
        }
      },
    );
    _loading = false;

    notifyListeners();
  }

  /*Show cart functionality here*/

  Future<void> showCart() async {
    _loading = true;
    _isCartScreenError = false;
    await ApiCalls.showCart(
      baseUrl: await ApiCalls.getSelectedStore(),
      storeId: await secureStorage.read(key: kselectedStoreIdKey) ?? '1',
    ).then((value) {
      switch (value) {
        case kerrorString:
          _isCartScreenError = true;
          break;
        default:
          try {
            _cartModel = CartModel.fromJson(jsonDecode(value));

            log('Provider cart model>>>>>' + jsonEncode(_cartModel));

            _isCartScreenError = false;
            _loading = false;
          } catch (e) {
            _loading = false;
            _isCartScreenError = true;
          }

          break;
      }
    });

    _loading = false;

    notifyListeners();
  }

  /*Get Search Category*/

  Future<void> getSearchCategory() async {
    _loading = true;

    _isError = false;

    await ApiCalls.getSearchCategory().then((value) {
      switch (value) {
        case kerrorString:
          _isError = true;
          break;
        default:
          try {
            SearchCategoryResponse response =
                SearchCategoryResponse.fromJson(jsonDecode(value));

            log('Provider SearchCategories model>>>>>' + jsonEncode(response));
            _searchCategoryList = response.responseData;

            _isError = false;
            _loading = false;
          } catch (e) {
            _loading = false;
            _isError = true;
          }

          break;
      }
    });

    _loading = false;

    notifyListeners();
  }

  /*Multi Store Api*/

  void getSotreIds() async {
    // _storeResponse ;

// _storeResponse.add();
    _storeResponse.add(StoreData(
        id: (int.parse(kkStoreId)), name: 'THE One Kuwait', url: kkBaseUrl));
    _storeResponse.add(StoreData(
        id: (int.parse(kbStoreId)), name: 'THE One Bahrain', url: kbBaseUrl));
    _storeResponse.add(StoreData(
        id: (int.parse(kqStoreId)), name: 'THE One Qatar', url: kqBaseUrl));

    notifyListeners();
  }

  /*Get your address*/

  void getYourAddresses() async {
    _loading = true;

    _isError = false;
    _addresses = [];
    await ApiCalls.getYourAddresses().then(
      (value) {
        switch (value) {
          case kerrorString:
            Fluttertoast.showToast(msg: kerrorString + '1');
            _isError = true;
            break;
          default:
            try {
              MyAddressResponse _addressResponse =
                  MyAddressResponse.fromJson(jsonDecode(value));

              log('MyAddresses store model>>>>>' +
                  jsonEncode(_addressResponse));

              _addresses = _addressResponse.responseData.addresses;
              _isError = false;
              _loading = false;
            } on Exception catch (e) {
              _loading = false;
              _isError = true;
              Fluttertoast.showToast(msg: kerrorString + '\n' + e.toString());
              ConstantsVar.excecptionMessage(e);
            }

            break;
        }
      },
    );

    _loading = false;

    notifyListeners();
  }

  /*Delete Your Address*/

  Future<void> deleteYourAddress(
      {required BuildContext context, required String addressId}) async {
    _loading = false;

    _isError = false;

    await ApiCalls.deleteAddress(context: context, addressId: addressId).then(
      (value) {
        switch (value) {
          case kerrorString:
            break;
          default:
            Fluttertoast.showToast(
                msg: 'Address Deleted!', toastLength: Toast.LENGTH_LONG);

            break;
        }
      },
    );

    _loading = false;
    _isError = false;
    notifyListeners();
  }

  /*Add new address here*/

  Future<void> addNewAddress(
      {required BuildContext context, required String snippingModel}) async {
    _loading = false;
    _isError = false;

    await ApiCalls.addNewAddress(context: context, snippingModel: snippingModel)
        .then((value) {
      switch (value) {
        case kerrorString:
          break;
        default:
          Fluttertoast.showToast(
              msg: 'Address Added!', toastLength: Toast.LENGTH_LONG);
          Navigator.pushReplacement(context,
              CupertinoPageRoute(builder: (context) => const MyAccount()));
          _loading = false;
          _isError = false;
      }
    });
    notifyListeners();
  }

  /*Edit your address here*/

  Future<void> editAddress({
    required BuildContext context,
    required var addressId,
    required String data,
    required bool isEditAddress,
  }) async {
    _loading = false;
    _isError = false;

    await ApiCalls.editAndSaveAddress(
            context: context,
            addressId: addressId,
            data: data,
            isEditAddress: isEditAddress)
        .then((value) {
      switch (value) {
        case kerrorString:
          break;
        default:
          Fluttertoast.showToast(
              msg: 'Address Edited!', toastLength: Toast.LENGTH_LONG);
          Navigator.pushReplacement(context,
              CupertinoPageRoute(builder: (context) => const MyAddresses()));
          _loading = false;
          _isError = false;
          break;
      }
    });
    notifyListeners();
  }

  /*Order Summary Here*/

  Future<void> getOrderSummary() async {
    await ApiCalls.showOrderSummary().then((value) {
      switch (value) {
        case kerrorString:
          break;
        default:
          OrderSummaryResponse _response =
              OrderSummaryResponse.fromJson(jsonDecode(value));
          _orderedList = _response.ordersummary.items;
          _orderSummaryTotal = _response.ordertotals;
          break;
      }
    });
    notifyListeners();
  }

  /*Apply GiftCard here*/

  Future<void> applyGiftCard({required String giftcardcouponcode}) async {
    log("Hi");
    await ApiCalls.applyGiftCard(giftcardcouponcode: giftcardcouponcode)
        .then((value) {
      switch (value) {
        case kerrorString:
          break;
        case "true":
          Fluttertoast.showToast(msg: "Gift Code applied successfully");
          break;
        case "false":
          Fluttertoast.showToast(
              msg: "Cannot use this code. Something wrong with this code.");
          break;
        default:
      }
    });
    notifyListeners();
  }

  /*Remove GiftCard here*/

  Future<void> removeGiftCard({required String giftcardcouponcode}) async {
    await ApiCalls.removeGiftCard(giftcardcouponcode: giftcardcouponcode)
        .then((value) {
      switch (value) {
        case kerrorString:
          break;
        default:
          break;
      }
    });
    notifyListeners();
  }

  /*Billing Screen Information*/
  Future<void> getBillingAddress() async {
    _loading = true;

    _isBillingScreenError = false;
    _existingAddresses = [];
    _orderedList = [];
    await ApiCalls.getBillingAddress().then((value) {
      switch (value) {
        case kerrorString:
          _loading = false;
          _isBillingScreenError = true;
          break;
        default:
          AddressResponse _response =
              AddressResponse.fromJson(jsonDecode(value));
          _existingAddresses = _response.billingaddresses.existingAddresses;
          log("ExistingBillingAddresses>>>>${jsonEncode(_existingAddresses)}");
          getOrderSummary();
          _loading = false;

          _isBillingScreenError = false;
      }
    });
    notifyListeners();
  }

  /*My Orders Here*/

  Future<void> getMyOrders() async {
    _loading = true;
    _isMyOrderScreenError = false;
    await ApiCalls.getOrder().then((value) {
      switch (value) {
        case kerrorString:
          _isMyOrderScreenError = true;
          break;
        default:
          try {
            MyOrdersResponse _response =
                MyOrdersResponse.fromJson(jsonDecode(value));
            _orders = _response.responseData.orders;
            _isMyOrderScreenError = false;
          } on Exception catch (e) {
            ConstantsVar.excecptionMessage(e);
            _isMyOrderScreenError = true;
          }
          break;
      }
    });
    _loading = false;
    notifyListeners();
  }

  Future<void> getShippingDetails() async {
    _loading = true;
    _isShippingDetailsScreenError = false;
    await ApiCalls.getShippingAddresses().then((value) {
      switch (value) {
        case kerrorString:
          _isShippingDetailsScreenError = true;
          break;
        default:
          try {
            ShippingResponse _response =
                ShippingResponse.fromJson(jsonDecode(value));
            _existingShippingAddresses =
                _response.shippingaddresses.existingAddresses;
            _pickupPoints = _response.shippingaddresses.pickupPoints;
            _isShippingDetailsScreenError = false;
          } on Exception catch (e) {
            ConstantsVar.excecptionMessage(e);
            _isShippingDetailsScreenError = true;
          }
          break;
      }
    });
    _loading = false;
    notifyListeners();
  }

  void getShippingMethods() async {
    _loading = true;
    _isShippingDetailsScreenError = false;
    await ApiCalls.getShippingMethods().then(
      (value) {
        switch (value) {
          case kerrorString:
            _isShippingMethodScreenError = true;
            break;
          default:
            try {
              ShippingMethodsResponse _response =
                  ShippingMethodsResponse.fromJson(jsonDecode(value));
              _shippingMethod = _response.shippingmethods.shippingMethods;

              _isShippingMethodScreenError = false;
            } on Exception catch (e) {
              ConstantsVar.excecptionMessage(e);
              _isShippingMethodScreenError = true;
            }
            break;
        }
      },
    );

    _loading = false;
    notifyListeners();
  }

  /*Search Suggestion Api*/
  void getSearchSuggestions() async {
    log('Search Suggestion Customer Id:- ${ConstantsVar.prefs.getString('guestCustomerID')}');
    final uri = Uri.parse(await ApiCalls.getSelectedStore() +
        'GetActiveCategories?CustId=${ConstantsVar.prefs.getString('guestCustomerID')}&$kStoreIdVar=${await secureStorage.read(key: kselectedStoreIdKey) ?? "1"}');

    try {
      var response = await get(
        uri,
        headers: {
          'Cookie': '.Nop.Customer=${ConstantsVar.prefs.getString(kguidKey)}'
        },
      );
      if (response.statusCode == 200) {
        log('Search Suggestion >>>>>>${jsonDecode(response.body)}');

        if (jsonDecode(response.body)['status'].toString().toLowerCase() ==
            kstatusFailed) {
          Fluttertoast.showToast(
              msg: "$kerrorString Unable to get Search Suggestions.",
              toastLength: Toast.LENGTH_LONG);
        } else {
          var resultMap = jsonDecode(response.body);
          SearchSuggestionResponse _responseSearch =
              SearchSuggestionResponse.fromJson(resultMap);

          for (var searchData in _responseSearch.responseData) {
            _searchSuggestions.add(searchData.name);
          }
        }
      } else {
        Fluttertoast.showToast(
            msg: '$kerrorString Status Code: ${response.statusCode}',
            toastLength: Toast.LENGTH_LONG);
        _searchSuggestions = [];
      }
    } on Exception catch (e) {
      ConstantsVar.excecptionMessage(e);
      _searchSuggestions = [];
    }
    notifyListeners();
  }

  void changePassField() {
    _passwordObs = !_passwordObs;
    notifyListeners();
  }

  /*For checkout event*/
  void setCheckoutPrice({required double amount}) {
    _checkoutAmount = amount;
    notifyListeners();
  }

/*For Checkout events*/
  void getCheckoutItems({required List<OrderedItems> list}) {
    _eventItemsForCheckout = [];

    for (OrderedItems item in list) {
      AnalyticsEventItem _eventItem = AnalyticsEventItem(
          itemName: item.productName,
          itemId: item.productId.toString(),
          quantity: item.quantity,
          discount: item.discount ?? 0.0);
      _eventItemsForCheckout.add(_eventItem);
    }

    notifyListeners();
  }

/*For Cart events*/
  void getViewCartItems({required List<CartItems> list}) {
    _eventItemsForViewCart = [];

    for (CartItems item in list) {
      AnalyticsEventItem _eventItem = AnalyticsEventItem(
          itemName: item.productName,
          itemId: item.productId.toString(),
          quantity: item.quantity,
          discount: int.parse(item.discount) ?? 0.0);
      _eventItemsForViewCart.add(_eventItem);
    }
    notifyListeners();
  }

  /*For Items events*/
  void getViewItemsList({required List<ProductListResponse> list}) {
    _eventItemsForItemList = [];

    for (ProductListResponse item in list) {
      AnalyticsEventItem _eventItem = AnalyticsEventItem(
          itemName: item.name,
          itemId: item.id.toString(),
          quantity: 1,
          discount: int.parse(item.discountedPrice) ?? 0.0);
      _eventItemsForItemList.add(_eventItem);
    }

    notifyListeners();
  }

  void getCurrency() async {
    String storeId = await secureStorage.read(key: kselectedStoreIdKey) ?? "1";

    switch (storeId) {
      case kuStoreId:
        _currency = kuaeCurrency;
        break;
      case kkStoreId:
        _currency = kkuwaitCurrency;
        break;
      case kbStoreId:
        _currency = kbahrainCurrency;
        break;
    }
    notifyListeners();
  }

  void changeSwitchValue({required bool value}) {
    _isSwitchVal = value;
    notifyListeners();
  }

  /*Determine Location Here*/

  /*Snackbar Here*/

  Future<void> getLocation({required BuildContext context}) async {
    log("Hi");
    LocationPermission permission;
    // await Geolocator.requestPermission().whenComplete(() async {
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      //nothing
      await Geolocator.requestPermission().then((val) async {
        await Geolocator.checkPermission().then((value) {
          permission = value;
          if (permission == LocationPermission.whileInUse) {
            getLocation(context: context);
          } else {
            if (permission == LocationPermission.unableToDetermine) {
              showSnackbar(
                message:
                    "Unable to determine action. Please click on Allow Permission",
                lableName: "",
                context: context,
                method: () {},
                duration: const Duration(
                  seconds: 3,
                ),
              );
              _isLocationAllow = false;
              _isPermanentDenied = false;
            }
          }
        });
      });
    } else if (permission == LocationPermission.deniedForever) {
      showSnackbar(
          duration: const Duration(
            seconds: 3,
          ),
          message:
              "Location Permission revoked. Please allow us to use location for better experience. ",
          lableName: "",
          method: () {},
          context: context);
      _isLocationAllow = false;
      _isPermanentDenied = true;
      // _openStoreSelectionScreen(context: context);
    } else if (permission == LocationPermission.unableToDetermine) {
      showSnackbar(
        duration: const Duration(
          seconds: 3,
        ),
        message: "Unable to determine action",
        lableName: "Ask Permission",
        method: () async {
          // await Geolocator.requestPermission();
        },
        context: context,
      );

      _isPermanentDenied = false;
      _isLocationAllow = false;
    } else if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      _isLocationAllow = true;
      _isPermanentDenied = false;
      setLocationFunction(context: context);
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      // Phoenix.rebirth(context);
    }
    // });

    notifyListeners();
  }

  Future<void> showSnackbar(
      {required String message,
      required String lableName,
      required BuildContext context,
      required VoidCallback method,
      required Duration duration}) async {
    final snackBar = SnackBar(
      duration: duration,
      content: AutoSizeText(
        message,
      ),
      shape: const StadiumBorder(),
      behavior: SnackBarBehavior.floating,
      elevation: 10,
      action: SnackBarAction(label: lableName, onPressed: method),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /*Location Check*/
  Future<void> checkLocationPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.whileInUse) {
      _isLocationAllow = true;
      _isPermanentDenied = false;
    } else if (permission == LocationPermission.deniedForever) {
      _isLocationAllow = false;
      _isPermanentDenied = true;
    } else {
      _isLocationAllow = false;
      _isPermanentDenied = false;
    }
    notifyListeners();
  }

  /*Set Store According to lcoation*/
  void setLocationFunction({required BuildContext context}) async {
    log('jegsjhfgjsegfjgse');
    showSnackbar(
        duration: const Duration(
          seconds: 2,
        ),
        message: "Please wait while syncing. It may takes a couple of seconds.",
        lableName: "",
        context: context,
        method: () {});
    if (!await Geolocator.isLocationServiceEnabled()) {
      showSnackbar(
        message:
            "Please enable location service from settings or control center and restart the app.",
        lableName: "Open Settings",
        context: context,
        method: () {
          AppSettings.openLocationSettings();
        },
        duration: const Duration(
          seconds: 8,
        ),
      );
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        // desiredAccuracy: LocationAccuracy.bestForNavigation,
        forceAndroidLocationManager: false,
        timeLimit: null,
      );
      log(position.longitude.toString());

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      log("Country>>>" + placemarks[0].country!);
      String _country = placemarks[0].country ?? "";
      if (_country.toLowerCase().contains("united arab emirates")) {
        await secureStorage.write(key: kselectedStoreIdKey, value: kuStoreId);
        await secureStorage.write(key: kcountryNameKey, value: "THE One UAE");
        SchedulerBinding.instance!.addPostFrameCallback((_) {
          Future.delayed(Duration.zero).whenComplete(() {
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (_) => MyApp(),
              ),
            );
          });
        });
      } else if (_country.toLowerCase().contains("bahrain")) {
        await secureStorage.write(key: kselectedStoreIdKey, value: kbStoreId);
        await secureStorage.write(
            key: kcountryNameKey, value: "THE One Bahrain");
        SchedulerBinding.instance!.addPostFrameCallback((_) {
          Future.delayed(Duration.zero).whenComplete(() {
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (_) => MyApp(),
              ),
            );
          });
        });
      } else if (_country.toLowerCase().contains("kuwait")) {
        await secureStorage.write(key: kselectedStoreIdKey, value: kkStoreId);
        await secureStorage.write(
            key: kcountryNameKey, value: "THE One Kuwait");
        SchedulerBinding.instance!.addPostFrameCallback((_) {
          Future.delayed(Duration.zero).whenComplete(() {
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (_) => MyApp(),
              ),
            );
          });
        });
      } else if (_country.toLowerCase().contains("india")) {
        await secureStorage.write(
            key: kcountryNameKey,
            value: "THE One\nThis app is only available for Developers");

        await secureStorage.write(key: kselectedStoreIdKey, value: kuStoreId);
        // ScaffoldMessenger.of(context).removeCurrentSnackBar();
        SchedulerBinding.instance!.addPostFrameCallback((_) {
          Future.delayed(Duration.zero).whenComplete(() {
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (_) => MyApp(),
              ),
            );
          });
        });
      } else {
        Fluttertoast.showToast(
          msg: "App is not available for this country",
          toastLength: Toast.LENGTH_LONG,
        );

        Navigator.pushReplacement(context, CupertinoPageRoute(
          builder: (context) {
            final size = MediaQuery.of(context).size;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: ConstantsVar.appColor,
                toolbarHeight: size.width * 0.18,
                centerTitle: true,
                title: Image.asset(
                  'MyAssets/logo.png',
                  width: size.width * 0.15,
                  height: size.width * 0.15,
                ),
              ),
              body: SizedBox(
                height: size.height,
                width: size.width,
                child: Center(
                  child: Text(
                    "We are sorry but app is not available for your country.\n\nComing soon.",
                    textAlign: TextAlign.center,
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
                      fontSize: size.width * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        ));
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg:
              "App is not able to process your location right now.\nSelect your store\n" +
                  e.toString(),
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_LONG);

      // await secureStorage.write(key: kselectedStoreIdKey, value: kuStoreId);
      // ScaffoldMessenger.of(context).removeCurrentSnackBar();
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Future.delayed(Duration.zero).whenComplete(() {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (_) => const StoreSelectionScreen(),
            ),
          );
        });
      });

      // Future.delayed(Duration(seconds: 5)).then((value) => exit(0));
    }
  }

  Future<void> checkAppUpdate({required BuildContext ctx}) async {
    String version = '';
    try {
      PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
        version = packageInfo.version;
        log("1");
      });
    } on Exception catch (e) {
      log(e.toString());
    }
    log("11");
    await ApiCalls.checkForUpdates().then(
      (value) async {
        switch (value) {
          case kerrorString:
            _isupdated = true;
            break;
          default:
            try {
              final response = jsonDecode(value);
              String _latestBuildNumber = response['ResponseData'];
              log(_latestBuildNumber);
              if (_latestBuildNumber != version) {
                _isupdated = false;

                _appVersion = _latestBuildNumber;
                // if (Platform.isIOS) {
                //   showCupertinoAlertaDialog(
                //       context: ctx,
                //       version: _latestBuildNumber,
                //       currentVersion: version);
                // } else if (Platform.isAndroid) {
                //   showMaterialDialogBox(
                //       context: ctx,
                //       version: _latestBuildNumber,
                //       currentVersion: version);
                // }
                notifyListeners();
              } else {
                Fluttertoast.showToast(
                    msg: "No update available.....",
                    toastLength: Toast.LENGTH_LONG);
                _isupdated = true;
              }
            } on Exception catch (e) {
              ConstantsVar.excecptionMessage(e);
              // log(e.toString());
              _isupdated = true;
            }
            break;
        }
        notifyListeners();
      },
    );
    log(_isupdated.toString());
    notifyListeners();
  }

  showCupertinoAlertaDialog(
      {required BuildContext context,
      required String version,
      required String currentVersion}) {
    showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: const Text("THE One Mobile App"),
              content: Text(
                  "Update is available\(Current Version#$currentVersion \nAvailable Version #$version\).\nIf this link does not work, kindly go to App Store to update the app."),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text("Update"),
                  onPressed: () {
                    ApiCalls.launchUrl(
                        "https://apps.apple.com/in/app/the-one-home-fashion-app/");
                    // Navigator.of(context).pop();
                  },
                ),
                CupertinoDialogAction(
                  child: const Text("CANCEL"),
                  onPressed: () {
                    _isupdated = false;
                    Navigator.maybePop(context);
                    // checkLocationPermission();
                    notifyListeners();
                    // Navigator.pushAndRemoveUntil(
                    //   context,
                    //   CupertinoPageRoute(
                    //     builder: (context) {
                    //       final size = MediaQuery.of(context).size;
                    //       return Scaffold(
                    //         appBar: AppBar(
                    //           backgroundColor: ConstantsVar.appColor,
                    //           toolbarHeight: size.width * 0.18,
                    //           centerTitle: true,
                    //           title: Image.asset(
                    //             'MyAssets/logo.png',
                    //             width: size.width * 0.15,
                    //             height: size.width * 0.15,
                    //           ),
                    //         ),
                    //         body: SizedBox(
                    //           height: size.height,
                    //           width: size.width,
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: [
                    //               Text(
                    //                 "Please update the app",
                    //                 style: TextStyle(
                    //                   shadows: <Shadow>[
                    //                     Shadow(
                    //                       offset: const Offset(1.0, 1.2),
                    //                       blurRadius: 3.0,
                    //                       color: Colors.grey.shade300,
                    //                     ),
                    //                     Shadow(
                    //                       offset: const Offset(1.0, 1.2),
                    //                       blurRadius: 8.0,
                    //                       color: Colors.grey.shade300,
                    //                     ),
                    //                   ],
                    //                   fontSize: size.width * 0.05,
                    //                   fontWeight: FontWeight.bold,
                    //                 ),
                    //               ),
                    //               ElevatedButton(
                    //                 onPressed: () {
                    //                   ApiCalls.launchUrl(
                    //                       "https://apps.apple.com/in/app/the-one-home-fashion-app/");
                    //                 },
                    //                 child: Text(
                    //                   'Update',
                    //                   style: TextStyle(
                    //                     fontSize:
                    //                         MediaQuery.of(context).size.width *
                    //                             0.05,
                    //                     fontWeight: FontWeight.bold,
                    //                   ),
                    //                 ),
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   ),
                    //   (Route<dynamic> route) => false,
                    // );
                  },
                ),
              ],
            ));
  }

  showMaterialDialogBox(
      {required BuildContext context,
      required String version,
      required String currentVersion}) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        _isupdated = false;
        Navigator.maybePop(context);
        //        checkLocationPermission();
        // getLocation(context: context);
        notifyListeners();
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   CupertinoPageRoute(
        //     builder: (context) {
        //       final size = MediaQuery.of(context).size;
        //       return Scaffold(
        //         appBar: AppBar(
        //           backgroundColor: ConstantsVar.appColor,
        //           toolbarHeight: size.width * 0.18,
        //           centerTitle: true,
        //           title: Image.asset(
        //             'MyAssets/logo.png',
        //             width: size.width * 0.15,
        //             height: size.width * 0.15,
        //           ),
        //         ),
        //         body: SizedBox(
        //           height: size.height,
        //           width: size.width,
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //               Text(
        //                 "Please update the app",
        //                 style: TextStyle(
        //                   shadows: <Shadow>[
        //                     Shadow(
        //                       offset: const Offset(1.0, 1.2),
        //                       blurRadius: 3.0,
        //                       color: Colors.grey.shade300,
        //                     ),
        //                     Shadow(
        //                       offset: const Offset(1.0, 1.2),
        //                       blurRadius: 8.0,
        //                       color: Colors.grey.shade300,
        //                     ),
        //                   ],
        //                   fontSize: size.width * 0.05,
        //                   fontWeight: FontWeight.bold,
        //                 ),
        //               ),
        //               ElevatedButton(
        //                 onPressed: () {
        //                   ApiCalls.launchUrl(
        //                       "https://play.google.com/store/apps/details?id=com.theone.androidtheone");
        //                 },
        //                 child: Text(
        //                   'Update',
        //                   style: TextStyle(
        //                     fontSize: MediaQuery.of(context).size.width * 0.05,
        //                     fontWeight: FontWeight.bold,
        //                   ),
        //                 ),
        //               )
        //             ],
        //           ),
        //         ),
        //       );
        //     },
        //   ),
        //   (Route<dynamic> route) => false,
        // );
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Update"),
      onPressed: () {
        ApiCalls.launchUrl(
            "https://play.google.com/store/apps/details?id=com.theone.androidtheone");
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("THE One Mobile App"),
      content: Text(
          "Update is available\(Current Version#$currentVersion\nAvailable Version #$version\).\nIf this link does not work, kindly go to Play Store to update the app."),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _openStoreSelectionScreen({required BuildContext context}) {
    showSnackbar(
        duration: const Duration(
          seconds: 3,
        ),
        message: "Location Permission revoked. Opening Store Selection Screen.",
        lableName: "",
        method: () {
          // AppSettings.openLocationSettings();
        },
        context: context);
  }
}
