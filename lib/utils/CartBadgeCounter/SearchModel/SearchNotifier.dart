import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/AppPages/SearchPage/SearchResponse/SearchSuggestionsResp.dart';
import 'package:untitled2/utils/ApiCalls/ApiCalls.dart';

class SearchModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<String> _suggestions = history;
  List<String> get suggestions => _suggestions;

  String _query = '';
  String get query => _query;

  void onQueryChanged(
    String query,
  ) async {
    if (query == _query) return;

    _query = query;
    _isLoading = true;
    notifyListeners();

    if (query.isEmpty) {
      _suggestions = history;
    } else if (query.length >= 3) {
      final response = await http.get(
          Uri.parse(
              'https://www.theone.com/apis/GetCategorySuggestions?text=$query'),
          headers: ApiCalls.header);
      SearchSuggestionResponseNew body =
          SearchSuggestionResponseNew.fromJson(json.decode(response.body));
      List<String> features = body.responseData;

      _suggestions = features;
    }

    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _suggestions = history;
    notifyListeners();
  }
}

const List<String> history = ['Sofa', 'Chair', 'Bed', 'Flower'];
