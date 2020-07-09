class ProductionCountry {
  String iso_3166_1;
  String name;

  ProductionCountry({this.iso_3166_1, this.name});

  factory ProductionCountry.fromJson(Map<String, dynamic> json) {
    return ProductionCountry(
      iso_3166_1: json['iso_3166_1'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iso_3166_1'] = this.iso_3166_1;
    data['name'] = this.name;
    return data;
  }
}
