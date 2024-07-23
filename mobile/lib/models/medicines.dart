class Medicines {
  String? batch;
  String? createdAt;
  String? id;
  String? name;
  String? stripe;
  String? updatedAt;

  Medicines(
      {this.batch,
      this.createdAt,
      this.id,
      this.name,
      this.stripe,
      this.updatedAt});

  Medicines.fromJson(Map<String, dynamic> json) {
    batch = json['batch'];
    createdAt = json['created_at'];
    id = json['id'];
    name = json['name'];
    stripe = json['stripe'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['batch'] = batch;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['name'] = name;
    data['stripe'] = stripe;
    data['updated_at'] = updatedAt;
    return data;
  }
}
