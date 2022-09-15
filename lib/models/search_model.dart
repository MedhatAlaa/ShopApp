class GetSearchModel {
  bool? status;
  Data? data;

  GetSearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  int? currentPage;
  List<GetSearchProduct> data = [];

  Data.fromJson(Map<String, dynamic> json) {

    currentPage = json['current_page'];
    json['data'].forEach((element) {
      data.add(GetSearchProduct.fromJson(element));
    });
  }
}

class GetSearchProduct {
  int? id;
  dynamic price;
  String? image;
  String? name;
  String? description;

  GetSearchProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }
}
