class ModelClass {
  String _imageUrl;
  String _Name;
  String _items;

  ModelClass(this._imageUrl, this._Name, this._items);

  String get items => _items;

  set items(String value) {
    _items = value;
  }

  String get Name => _Name;

  set Name(String value) {
    _Name = value;
  }

  String get imageUrl => _imageUrl;

  set imageUrl(String value) {
    _imageUrl = value;
  }
}
