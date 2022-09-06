class ListCheckInRequest {
  String? datetime;

  ListCheckInRequest({this.datetime});

  ListCheckInRequest.fromJson(Map<String, dynamic> json) {
    datetime = json['datetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['datetime'] = this.datetime;
    return data;
  }
}