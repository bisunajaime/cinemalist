class Cast {
  int cast_id;
  String character;
  String credit_id;
  int gender;
  int id;
  String name;
  int order;
  String profile_path;

  Cast(
      {this.cast_id,
      this.character,
      this.credit_id,
      this.gender,
      this.id,
      this.name,
      this.order,
      this.profile_path});

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      cast_id: json['cast_id'],
      character: json['character'],
      credit_id: json['credit_id'],
      gender: json['gender'],
      id: json['id'],
      name: json['name'],
      order: json['order'],
      profile_path: json['profile_path'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cast_id'] = this.cast_id;
    data['character'] = this.character;
    data['credit_id'] = this.credit_id;
    data['gender'] = this.gender;
    data['id'] = this.id;
    data['name'] = this.name;
    data['order'] = this.order;
    data['profile_path'] = this.profile_path;
    return data;
  }
}
