class GetItemShippingResponse {
  GetItemShippingResponseData? data;
  int? statusCode;
  String? message;

  GetItemShippingResponse({this.data, this.statusCode, this.message});

  GetItemShippingResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new GetItemShippingResponseData.fromJson(json['data']) : null;
    statusCode = json['statusCode'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class GetItemShippingResponseData {
  MasterDetailItemShipping? master;
  List<DettailItemShipping>? dettail;

  GetItemShippingResponseData({this.master, this.dettail});

  GetItemShippingResponseData.fromJson(Map<String, dynamic> json) {
    master =
    json['master'] != null ? new MasterDetailItemShipping.fromJson(json['master']) : null;
    if (json['dettail'] != null) {
      dettail = <DettailItemShipping>[];
      json['dettail'].forEach((v) {
        dettail!.add(new DettailItemShipping.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.master != null) {
      data['master'] = this.master?.toJson();
    }
    if (this.dettail != null) {
      data['dettail'] = this.dettail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MasterDetailItemShipping {
  String? sttRec;
  String? ngayCt;
  String? soCt;
  String? maKh;
  String? tenKh;
  double? tSoLuong;
  String? status;
  double? tTtNt;
  double? tTcTienNt2;
  double? tCkNt;

  MasterDetailItemShipping(
      {this.sttRec,
        this.ngayCt,
        this.soCt,
        this.maKh,
        this.tenKh,
        this.tSoLuong,
        this.status,
        this.tTtNt,
        this.tTcTienNt2,
        this.tCkNt});

  MasterDetailItemShipping.fromJson(Map<String, dynamic> json) {
    sttRec = json['stt_rec'];
    ngayCt = json['ngay_ct'];
    soCt = json['so_ct'];
    maKh = json['ma_kh'];
    tenKh = json['ten_kh'];
    tSoLuong = json['t_so_luong'];
    status = json['status'];
    tTtNt = json['t_tt_nt'];
    tTcTienNt2 = json['t_tc_tien_nt2'];
    tCkNt = json['t_ck_nt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stt_rec'] = this.sttRec;
    data['ngay_ct'] = this.ngayCt;
    data['so_ct'] = this.soCt;
    data['ma_kh'] = this.maKh;
    data['ten_kh'] = this.tenKh;
    data['t_so_luong'] = this.tSoLuong;
    data['status'] = this.status;
    data['t_tt_nt'] = this.tTtNt;
    data['t_tc_tien_nt2'] = this.tTcTienNt2;
    data['t_ck_nt'] = this.tCkNt;
    return data;
  }
}

class DettailItemShipping {
  String? sttRec0;
  String? maVt;
  String? tenVt;
  String? dvt;
  String? maKho;
  double? soLuong;
  double? soLuongThucGiao;
  double? giaNt2;
  double? tienNt2;
  double? tlCk;
  double? ckNt;

  DettailItemShipping(
      {this.sttRec0,
        this.maVt,
        this.tenVt,
        this.dvt,
        this.maKho,
        this.soLuong,
        this.soLuongThucGiao,
        this.giaNt2,
        this.tienNt2,
        this.tlCk,
        this.ckNt});

  DettailItemShipping.fromJson(Map<String, dynamic> json) {
    sttRec0 = json['stt_rec0'];
    maVt = json['ma_vt'];
    tenVt = json['ten_vt'];
    dvt = json['dvt'];
    maKho = json['ma_kho'];
    soLuong = json['so_luong'];
    soLuongThucGiao = json['so_luong_tg'];
    giaNt2 = json['gia_nt2'];
    tienNt2 = json['tien_nt2'];
    tlCk = json['tl_ck'];
    ckNt = json['ck_nt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stt_rec0'] = this.sttRec0;
    data['ma_vt'] = this.maVt;
    data['ten_vt'] = this.tenVt;
    data['dvt'] = this.dvt;
    data['ma_kho'] = this.maKho;
    data['so_luong'] = this.soLuong;
    data['so_luong_tg'] = this.soLuongThucGiao;
    data['gia_nt2'] = this.giaNt2;
    data['tien_nt2'] = this.tienNt2;
    data['tl_ck'] = this.tlCk;
    data['ck_nt'] = this.ckNt;
    return data;
  }
}
