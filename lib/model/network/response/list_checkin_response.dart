class ListCheckInResponse {
  List<ListCheckIn>? listCheckInToDay;
  List<ListCheckIn>? listCheckInOther;
  int? totalPage;
  int? statusCode;
  String? message;

  ListCheckInResponse(
      {this.listCheckInToDay,
        this.listCheckInOther,
        this.totalPage,
        this.statusCode,
        this.message});

  ListCheckInResponse.fromJson(Map<String, dynamic> json) {
    if (json['listCheckInToDay'] != null) {
      listCheckInToDay = <ListCheckIn>[];
      json['listCheckInToDay'].forEach((v) {
        listCheckInToDay!.add(new ListCheckIn.fromJson(v));
      });
    }
    if (json['listCheckInOther'] != null) {
      listCheckInOther = <ListCheckIn>[];
      json['listCheckInOther'].forEach((v) {
        listCheckInOther!.add(new ListCheckIn.fromJson(v));
      });
    }
    totalPage = json['totalPage'];
    statusCode = json['statusCode'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listCheckInToDay != null) {
      data['listCheckInToDay'] =
          this.listCheckInToDay!.map((v) => v.toJson()).toList();
    }
    if (this.listCheckInOther != null) {
      data['listCheckInOther'] =
          this.listCheckInOther!.map((v) => v.toJson()).toList();
    }
    data['totalPage'] = this.totalPage;
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class ListCheckIn {
  double? id;
  String? tieuDe;
  String? ngayCheckin;
  String? maKh;
  String? tenKh;
  String? tenCh;
  String? diaChi;
  String? dienThoai;
  String? gps;
  String? trangThai;
  String? tgHoanThanh;

  ListCheckIn(
      {this.tieuDe,
        this.ngayCheckin,
        this.maKh,
        this.tenKh,
        this.tenCh,
        this.diaChi,
        this.dienThoai,
        this.gps,
        this.trangThai,
        this.tgHoanThanh});

  ListCheckIn.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tieuDe = json['tieu_de'];
    ngayCheckin = json['ngay_checkin'];
    maKh = json['ma_kh'];
    tenKh = json['ten_kh'];
    tenCh = json['ten_ch'];
    diaChi = json['dia_chi'];
    dienThoai = json['dien_thoai'];
    gps = json['gps'];
    trangThai = json['trang_thai'];
    tgHoanThanh = json['tg_hoan_thanh'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tieu_de'] = this.tieuDe;
    data['ngay_checkin'] = this.ngayCheckin;
    data['ma_kh'] = this.maKh;
    data['ten_kh'] = this.tenKh;
    data['ten_ch'] = this.tenCh;
    data['dia_chi'] = this.diaChi;
    data['dien_thoai'] = this.dienThoai;
    data['gps'] = this.gps;
    data['trang_thai'] = this.trangThai;
    data['tg_hoan_thanh'] = this.tgHoanThanh;
    return data;
  }
}

