
class Genre {
    int id;
    String name;

    Genre({this.id, this.name});

    factory Genre.fromJson(Map<String, dynamic> json) {
        return Genre(
            id: json['id'], 
            name: json['name'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['name'] = this.name;
        return data;
    }
}