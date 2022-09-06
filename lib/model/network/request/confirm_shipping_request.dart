class ConfirmShippingRequest {
  List<DsLine>? dsLine;
  int? typePayment;

  ConfirmShippingRequest({this.dsLine,this.typePayment});

  ConfirmShippingRequest.fromJson(Map<String, dynamic> json) {
    if (json['ds_line'] != null) {
      dsLine = <DsLine>[];
      json['ds_line'].forEach((v) {
        dsLine!.add(new DsLine.fromJson(v));
      });
      typePayment = json['TypePayment'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dsLine != null) {
      data['ds_line'] = this.dsLine!.map((v) => v.toJson()).toList();
    }
    data['TypePayment'] = typePayment;
    return data;
  }
}

class DsLine {
  String? sttRec;
  String? sttRec0;
  double? soLuong;

  DsLine({this.sttRec, this.sttRec0, this.soLuong});

  DsLine.fromJson(Map<String, dynamic> json) {
    sttRec = json['stt_rec'];
    sttRec0 = json['stt_rec0'];
    soLuong = json['so_luong'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stt_rec'] = this.sttRec;
    data['stt_rec0'] = this.sttRec0;
    data['so_luong'] = this.soLuong;
    return data;
  }
}
