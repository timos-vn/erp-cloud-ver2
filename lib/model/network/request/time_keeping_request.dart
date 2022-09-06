class TimeKeepingRequest {
  String? datetime;
  String? userName;
  String? latLong;
  String? location;
  String? descript;
  String? note;
  String? qrCode;
  String? uId;


  TimeKeepingRequest(
      {
        this.datetime,
        this.userName,
        this.latLong,
        this.location,
        this.descript,
        this.note,
        this.qrCode,
        this.uId
      });

  TimeKeepingRequest.fromJson(Map<String, dynamic> json) {
    datetime = json['datetime'];
    userName = json['userName'];
    latLong = json['latLong'];
    location = json['location'];
    descript = json['descript'];
    note = json['note'];
    qrCode = json['qrCode'];
    uId = json['uId'];
  }



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.datetime != null){
      data['datetime'] = this.datetime;
    }
    if(this.userName != null){
      data['userName'] = this.userName;
    }
    if(this.latLong != null){
      data['latLong'] = this.latLong;
    }
    if(this.location != null){
      data['location'] = this.location;
    }
    if(this.descript != null){
      data['descript'] = this.descript;
    }
    if(this.note != null){
      data['note'] = this.note;
    }
    if(this.qrCode != null){
      data['qrCode'] = this.qrCode;
    }
    data['uId'] = this.uId;
    return data;
  }
}