class GridViewModel {
  String _images;
  String _discount;
  String _type;
  String _name;

  GridViewModel(this._images, this._discount, this._type, this._name);

  String get type => _type;

  // ignore: unnecessary_getters_setters
  set type(String value) {
    _type = value;
  }

  String get discount => _discount;

  set discount(String value) {
    _discount = value;
  }

  String get images => _images;

  set images(String value) {
    _images = value;
  }
}
