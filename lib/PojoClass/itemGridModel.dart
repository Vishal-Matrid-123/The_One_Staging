class GridPojo {
  String _image;
  String _name;
  String _priceRang;

  GridPojo(this._image, this._name, this._priceRang);

  String get priceRang => _priceRang;

  set priceRang(String value) {
    _priceRang = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get image => _image;

  set image(String value) {
    _image = value;
  }
}
