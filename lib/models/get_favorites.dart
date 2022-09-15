
class GetFavoritesModel {
  bool? status;
  FavoriteData? data;

  GetFavoritesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? FavoriteData.fromJson(json['data']) : null;
  }

}

class FavoriteData {
  int? currentPage;
  List<Data>? data;

  FavoriteData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];

    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

}

class Data {
  int? id;
  Product? product;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product =
    json['product'] != null ? Product.fromJson(json['product']) : null;
  }

}

class Product {
  int? id;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  String? image;
  String? name;
  String? description;


  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }

}
