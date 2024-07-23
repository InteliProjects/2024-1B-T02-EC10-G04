import 'package:mobile/models/medicines.dart';
import 'package:mobile/models/user.dart';

class Order {
  String? createdAt;
  String? id;
  List<Medicines>? medicines;
  String? observation;
  String? priority;
  int? quantity;
  String? status;
  String? updatedAt;
  User? user;
  String? pyxis_id;
  String? orderId;

  Order({
    this.createdAt,
    this.id,
    this.medicines,
    this.observation,
    this.priority,
    this.quantity,
    this.status,
    this.updatedAt,
    this.user,
    this.pyxis_id,
    this.orderId,
  });

  Order.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    id = json['id'];
    orderId = json['order_id'];
    medicines = <Medicines>[];
    if (json['medicine'] != null) {
      json['medicine'].forEach((x) {
        var medicine = Medicines.fromJson(x);
        if (medicines != null) {
          medicines!.add(medicine);
        }
      });
    }
    observation = json['observation'];
    priority = json['priority'];
    quantity = json['quantity'];
    status = json['status'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    pyxis_id = json['pyxis_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_at'] = createdAt;
    data['id'] = id;
    if (medicines != null) {
      data['medicine'] = medicines!.map((v) => v.toJson()).toList();
    }
    data['observation'] = observation;
    data['priority'] = priority;
    data['quantity'] = quantity;
    data['status'] = status;
    data['updated_at'] = updatedAt;
    data['pyxis_id'] = pyxis_id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
