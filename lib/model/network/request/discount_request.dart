import 'package:sse/model/entity/product.dart';

class DiscountRequest {
  String? sttRec;
  String? maKh;
  String? maKho;
  List<Product>? lineItem;

  DiscountRequest({this.sttRec,this.maKh, this.maKho, this.lineItem});

  DiscountRequest.fromJson(Map<String, dynamic> json) {
    sttRec = json['stt_rec'];
    maKh = json['ma_kh'];
    maKho = json['ma_kho'];
    if (json['line_item'] != null) {
      lineItem = <Product>[];
      json['line_item'].forEach((v) {
        lineItem!.add(new Product.fromDb(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stt_rec'] = this.sttRec;
    data['ma_kh'] = this.maKh;
    data['ma_kho'] = this.maKho;
    if (this.lineItem != null) {
      data['line_item'] = this.lineItem!.map((v) => v.toMapForDb()).toList();
    }
    return data;
  }
}

