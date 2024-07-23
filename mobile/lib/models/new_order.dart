import 'pyxis.dart';

class NewOrder {
  String? id;
  String? createdAt;
  List<Map<String, dynamic>> medicines;
  Pyxis? pyxis;
  String? userId;
  String? observation;
  String? priority;
  int? quantity;

  NewOrder({
    this.id,
    this.createdAt,
    required this.medicines,
    this.pyxis,
    this.userId,
    this.observation,
    this.priority,
    this.quantity,
  });

  NewOrder.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        createdAt = json['created_at'],
        medicines = List<Map<String, dynamic>>.from(json['medicines'].map((medicine) => {'medicineid': medicine['medicineid'], ...medicine})),
        pyxis = json['pyxis'] != null ? Pyxis.fromJson(json['pyxis']) : null,
        userId = json['userId'],
        observation = json['observation'],
        priority = json['priority'],
        quantity = json['quantity'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['medicines'] = medicines;
    if (pyxis != null) {
      data['pyxis'] = pyxis!.toJson();
    }
    data['userId'] = userId;
    data['observation'] = observation;
    data['priority'] = priority;
    data['quantity'] = quantity;
    return data;
  }
}
