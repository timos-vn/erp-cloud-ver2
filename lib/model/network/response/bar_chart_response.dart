
class BarChartDataResponse{

  List<BarChartReportData>? data;

  BarChartDataResponse({this.data});

  BarChartDataResponse.fromJson(Map<String, dynamic> json) {

    if (json['reportData'] != null) {
      data = <BarChartReportData>[];(json['reportData'] as List).forEach((v) { data!.add(new BarChartReportData.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.data != null) {
      data['reportData'] =  this.data!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class BarChartReportData{
  int? colName;
  double? value1;
  double? value2;

  BarChartReportData({this.colName,this.value1,this.value2});

  BarChartReportData.fromJson(Map<String, dynamic> json) {
    colName = json['colName'];
    value1 = json['value1'];
    value2 = json['value2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['colName'] = this.colName;
    data['value1'] = this.value1;
    data['value2'] = this.value2;
    return data;
  }
}

