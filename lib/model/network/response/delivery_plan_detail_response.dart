class DeliveryPlanDetailResponse {
  List<DeliveryPlanDetailResponseData>? data;
  int? totalPage;
  int? statusCode;
  String? message;

  DeliveryPlanDetailResponse(
      {this.data, this.totalPage, this.statusCode, this.message});

  DeliveryPlanDetailResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DeliveryPlanDetailResponseData>[];
      json['data'].forEach((v) {
        data!.add(new DeliveryPlanDetailResponseData.fromJson(v));
      });
    }
    totalPage = json['totalPage'];
    statusCode = json['statusCode'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['totalPage'] = this.totalPage;
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class DeliveryPlanDetailResponseData {
  String? maVt;
  String? tenVt;
  String? dvt;
  double? slKh;
  double? slXtt;
  String? maVc;
  String? tenVc;
  String? maKh;
  String? tenKh;
  String? diaChi;
  String? gioCoMat;
  String? ngayGiao;
  String? maNvvc;
  String? tenNvvc;
  String? ghiChu;

  DeliveryPlanDetailResponseData(
      {this.maVt,
        this.tenVt,
        this.dvt,
        this.slKh,
        this.slXtt,
        this.maVc,
        this.tenVc,
        this.maKh,
        this.tenKh,
        this.diaChi,
        this.gioCoMat,this.ngayGiao,
        this.maNvvc,
        this.tenNvvc,this.ghiChu});

  DeliveryPlanDetailResponseData.fromJson(Map<String, dynamic> json) {
    maVt = json['ma_vt'];
    tenVt = json['ten_vt'];
    dvt = json['dvt'];
    slKh = json['sl_kh'];
    slXtt = json['sl_xtt'];
    maVc = json['ma_vc'];
    tenVc = json['ten_vc'];
    maKh = json['ma_kh'];
    tenKh = json['ten_kh'];
    diaChi = json['dia_chi'];
    gioCoMat = json['gio_co_mat'];
    ngayGiao = json['ngay_giao'];
    maNvvc = json['ma_nvvc'];
    tenNvvc = json['ten_nvvc'];
    ghiChu = json['ghi_chu'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ma_vt'] = this.maVt;
    data['ten_vt'] = this.tenVt;
    data['dvt'] = this.dvt;
    data['sl_kh'] = this.slKh;
    data['sl_xtt'] = this.slXtt;
    data['ma_vc'] = this.maVc;
    data['ten_vc'] = this.tenVc;
    data['ma_kh'] = this.maKh;
    data['ten_kh'] = this.tenKh;
    data['dia_chi'] = this.diaChi;
    data['gio_co_mat'] = this.gioCoMat;
    data['ngay_giao'] = this.ngayGiao;
    data['ma_nvvc'] = this.maNvvc;
    data['ten_nvvc'] = this.tenNvvc;
    data['ghi_chu'] = this.ghiChu;
    return data;
  }
}

