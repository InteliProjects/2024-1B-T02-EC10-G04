class Pyxis {
  String? createdAt;
  String? updatedAt;
  String? id;
  String? label;

  Pyxis({this.createdAt, this.id, this.label, this.updatedAt});

  Pyxis.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    id = json['id'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['id'] = id;
    data['label'] = label;
    return data;
  }
}
