class ListShippingResponse {
  List<ListShippingResponseData>? data;
  int? statusCode;
  String? message;

  ListShippingResponse({this.data, this.statusCode, this.message});

  ListShippingResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ListShippingResponseData>[];
      json['data'].forEach((v) {
        data!.add(new ListShippingResponseData.fromJson(v));
      });
    }
    statusCode = json['statusCode'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class ListShippingResponseData {
  String? sttRec;
  String? maDvcs;
  String? ngayCt;
  String? soCt;
  String? maKh;
  String? tenKh;
  String? dienGiai;
  double? tTtNt;
  String? maNt;
  String? maCt;
  String? status;

  ListShippingResponseData(
      {this.sttRec,
        this.maDvcs,
        this.ngayCt,
        this.soCt,
        this.maKh,
        this.tenKh,
        this.dienGiai,
        this.tTtNt,
        this.maNt,
        this.maCt,
        this.status});

  ListShippingResponseData.fromJson(Map<String, dynamic> json) {
    sttRec = json['stt_rec'];
    maDvcs = json['ma_dvcs'];
    ngayCt = json['ngay_ct'];
    soCt = json['so_ct'];
    maKh = json['ma_kh'];
    tenKh = json['ten_kh'];
    dienGiai = json['dien_giai'];
    tTtNt = json['t_tt_nt'];
    maNt = json['ma_nt'];
    maCt = json['ma_ct'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stt_rec'] = this.sttRec;
    data['ma_dvcs'] = this.maDvcs;
    data['ngay_ct'] = this.ngayCt;
    data['so_ct'] = this.soCt;
    data['ma_kh'] = this.maKh;
    data['ten_kh'] = this.tenKh;
    data['dien_giai'] = this.dienGiai;
    data['t_tt_nt'] = this.tTtNt;
    data['ma_nt'] = this.maNt;
    data['ma_ct'] = this.maCt;
    data['status'] = this.status;
    return data;
  }
}
