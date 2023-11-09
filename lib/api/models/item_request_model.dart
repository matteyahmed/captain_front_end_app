class ItemRequest {
  int? id;
  String? createdBy;
  String? boat;
  String? createdDate;
  String? item;
  int? quantity;
  Null? dispatch;
  String? status;
  String? received;
  Null? dispatchBy;

  ItemRequest(
      {this.id,
      this.createdBy,
      this.boat,
      this.createdDate,
      this.item,
      this.quantity,
      this.dispatch,
      this.status,
      this.received,
      this.dispatchBy});

  ItemRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    boat = json['boat'];
    createdDate = json['created_date'];
    item = json['item'];
    quantity = json['quantity'];
    dispatch = json['dispatch'];
    status = json['status'];
    received = json['received'];
    dispatchBy = json['dispatch_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_by'] = this.createdBy;
    data['boat'] = this.boat;
    data['created_date'] = this.createdDate;
    data['item'] = this.item;
    data['quantity'] = this.quantity;
    data['dispatch'] = this.dispatch;
    data['status'] = this.status;
    data['received'] = this.received;
    data['dispatch_by'] = this.dispatchBy;
    return data;
  }
}

class ItemUpdate {
  final int id;
  final String received;

  ItemUpdate({required this.id, required this.received});
}