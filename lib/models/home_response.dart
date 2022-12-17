class HomeResponse {
  List<Banners> banners = [];
  List<HomePageCategoriesImage> homePageCategoriesImage = [];
  List<HomePageProductImage> homePageProductImage = [];
  bool success = false;
  String? errorMessage;

  HomeResponse(
      {required this.banners,
      required this.homePageCategoriesImage,
      required this.homePageProductImage,
      required this.success,
      required this.errorMessage});

  HomeResponse.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      banners = [];
      json['banners'].forEach((v) {
        banners.add(new Banners.fromJson(v));
      });
    }
    if (json['HomePageCategoriesImage'] != null) {
      homePageCategoriesImage = [];
      json['HomePageCategoriesImage'].forEach((v) {
        homePageCategoriesImage.add(new HomePageCategoriesImage.fromJson(v));
      });
    }
    if (json['HomePageProductImage'] != null) {
      homePageProductImage = [];
      json['HomePageProductImage'].forEach((v) {
        homePageProductImage.add(new HomePageProductImage.fromJson(v));
      });
    }

    if (json['success'] != null) {
      success = json['success'];
    }
    if (json['errorMessage'] != null) {
      errorMessage = json['errorMessage'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['banners'] = this.banners.map((v) => v.toJson()).toList();
    data['HomePageCategoriesImage'] =
        this.homePageCategoriesImage.map((v) => v.toJson()).toList();
    data['HomePageProductImage'] =
        this.homePageProductImage.map((v) => v.toJson()).toList();

    data['success'] = this.success;

    if (this.errorMessage != null) {
      data['errorMessage'] = this.errorMessage;
    }
    return data;
  }
}

class Banners {
  String imageUrl = '';
  String imageLink = '';
  String displayOrder = '';

  Banners(
      {required this.imageUrl,
      required this.imageLink,
      required this.displayOrder});

  Banners.fromJson(Map<String, dynamic> json) {
    imageUrl = json['ImageUrl'];
    imageLink = json['ImageLink'];
    displayOrder = json['DisplayOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ImageUrl'] = this.imageUrl;
    data['ImageLink'] = this.imageLink;
    data['DisplayOrder'] = this.displayOrder;
    return data;
  }
}

class HomePageCategoriesImage {
  int id = 0;
  String name = '';
  int parentCategoryId = 0;
  String imageUrl = '';

  HomePageCategoriesImage(
      {required this.id,
      required this.name,
      required this.parentCategoryId,
      required this.imageUrl});

  HomePageCategoriesImage.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    parentCategoryId = json['ParentCategoryId'];
    imageUrl = json['ImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['ParentCategoryId'] = this.parentCategoryId;
    data['ImageUrl'] = this.imageUrl;
    return data;
  }
}

class HomePageProductImage {
  String price = '';
  int id = 0;
  String name = '';
  List<String> imageUrl = [];

  HomePageProductImage(
      {required this.price,
      required this.id,
      required this.name,
      required this.imageUrl});

  HomePageProductImage.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    id = json['Id'];
    name = json['Name'];
    imageUrl = json['ImageUrl'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['ImageUrl'] = this.imageUrl;
    return data;
  }
}
