class UpdateOrderResponse {
  UpdateOrderResponseData? data;
  int? statusCode;
  String? message;

  UpdateOrderResponse({this.data, this.statusCode, this.message});

  UpdateOrderResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new UpdateOrderResponseData.fromJson(json['data']) : null;
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

class UpdateOrderResponseData {
  Master? master;
  List<LineItems>? lineItems;

  UpdateOrderResponseData({this.master, this.lineItems});

  UpdateOrderResponseData.fromJson(Map<String, dynamic> json) {
    master =
    json['master'] != null ? new Master.fromJson(json['master']) : null;
    if (json['line_items'] != null) {
      lineItems = <LineItems>[];
      json['line_items'].forEach((v) {
        lineItems?.add(new LineItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.master != null) {
      data['master'] = this.master?.toJson();
    }
    if (this.lineItems != null) {
      data['line_items'] = this.lineItems?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Master {
  String? sttRec;
  String? soCt;
  String? ngayCt;
  String? maKh;
  String? tenKh;
  double? tTcTienNt2;
  double? tCkTtNt;
  double? tTtNt;
  int? status;
  Ck? ck;

  Master(
      {this.sttRec,
        this.soCt,
        this.ngayCt,
        this.maKh,
        this.tenKh,
        this.tTcTienNt2,
        this.tCkTtNt,
        this.tTtNt,
        this.status,
        this.ck});

  Master.fromJson(Map<String, dynamic> json) {
    sttRec = json['stt_rec'];
    soCt = json['so_ct'];
    ngayCt = json['ngay_ct'];
    maKh = json['ma_kh'];
    tenKh = json['ten_kh'];
    tTcTienNt2 = json['t_tc_tien_nt2'];
    tCkTtNt = json['t_ck_tt_nt'];
    tTtNt = json['t_tt_nt'];
    status = json['status'];
    ck = json['ck'] != null ? new Ck.fromJson(json['ck']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stt_rec'] = this.sttRec;
    data['so_ct'] = this.soCt;
    data['ngay_ct'] = this.ngayCt;
    data['ma_kh'] = this.maKh;
    data['ten_kh'] = this.tenKh;
    data['t_tc_tien_nt2'] = this.tTcTienNt2;
    data['t_ck_tt_nt'] = this.tCkTtNt;
    data['t_tt_nt'] = this.tTtNt;
    data['status'] = this.status;
    if (this.ck != null) {
      data['ck'] = this.ck?.toJson();
    }
    return data;
  }
}

class Ck {
  String? maCk;
  String? tenCk;
  String? tenNs;
  double? gtCl;
  String? loaiCt;

  Ck({this.maCk, this.tenCk, this.tenNs, this.gtCl, this.loaiCt});

  Ck.fromJson(Map<String, dynamic> json) {
    maCk = json['ma_ck'];
    tenCk = json['ten_ck'];
    tenNs = json['ten_ns'];
    gtCl = json['gt_cl'];
    loaiCt = json['loai_ct'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ma_ck'] = this.maCk;
    data['ten_ck'] = this.tenCk;
    data['ten_ns'] = this.tenNs;
    data['gt_cl'] = this.gtCl;
    data['loai_ct'] = this.loaiCt;
    return data;
  }
}

class LineItems {
  String? maVt;
  String? tenVt;
  int? kmYn;
  double? soLuong;
  double? gia;
  double? ckNt;
  double? tienNt;
  String? name2;
  String? dvt;
  double? discountPercent;
  String? imageUrl;
  double? priceAfter;
  double? stockAmount;
  List<DsCkItemOrder>? dsCk;

  LineItems(
      {this.maVt,
        this.tenVt,
        this.kmYn,
        this.soLuong,
        this.gia,
        this.ckNt,
        this.tienNt,
        this.name2,
        this.dvt,
        this.discountPercent,
        this.imageUrl,
        this.priceAfter,
        this.stockAmount,
        this.dsCk});

  LineItems.fromJson(Map<String, dynamic> json) {
    maVt = json['ma_vt'];
    tenVt = json['ten_vt'];
    kmYn = json['km_yn'];
    soLuong = json['so_luong'];
    gia = json['gia'];
    ckNt = json['ck_nt'];
    tienNt = json['tien_nt'];
    name2 = json['name2'];
    dvt = json['dvt'];
    discountPercent = json['discountPercent'];
    imageUrl = json['imageUrl'];
    priceAfter = json['priceAfter'];
    stockAmount = json['stockAmount'];
    if (json['ds_ck'] != null) {
      dsCk = <DsCkItemOrder>[];
      json['ds_ck'].forEach((v) {
        dsCk?.add(new DsCkItemOrder.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ma_vt'] = this.maVt;
    data['ten_vt'] = this.tenVt;
    data['km_yn'] = this.kmYn;
    data['so_luong'] = this.soLuong;
    data['gia'] = this.gia;
    data['ck_nt'] = this.ckNt;
    data['tien_nt'] = this.tienNt;
    data['name2'] = this.name2;
    data['dvt'] = this.dvt;
    data['discountPercent'] = this.discountPercent;
    data['imageUrl'] = this.imageUrl;
    data['priceAfter'] = this.priceAfter;
    data['stockAmount'] = this.stockAmount;
    if (this.dsCk != null) {
      data['ds_ck'] = this.dsCk?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DsCkItemOrder {
  String? maCk;
  String? tenCk;
  String? tenNs;
  double? gtCl;
  String? loaiCt;

  DsCkItemOrder({this.maCk, this.tenCk, this.tenNs, this.gtCl, this.loaiCt});

  DsCkItemOrder.fromJson(Map<String, dynamic> json) {
    maCk = json['ma_ck'];
    tenCk = json['ten_ck'];
    tenNs = json['ten_ns'];
    gtCl = json['gt_cl'];
    loaiCt = json['loai_ct'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ma_ck'] = this.maCk;
    data['ten_ck'] = this.tenCk;
    data['ten_ns'] = this.tenNs;
    data['gt_cl'] = this.gtCl;
    data['loai_ct'] = this.loaiCt;
    return data;
  }
}

