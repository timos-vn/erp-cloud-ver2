class DataDefaultResponse {
  List<FilterTimes>? filterTimes;
  List<ReportCategories>? reportCategories;
  List<CurrencyList>? currencyList;
  List<StockList>? stockList;
  bool? isCallServerCart;
  List<NumberFormatType>? numberFormat;
  // List<ReportData>? reportData;
  ReportInfo? reportInfo;
  int? statusCode;
  String? message;

  DataDefaultResponse(
      {this.filterTimes,
        this.reportCategories,
        this.currencyList,
        this.stockList,
        this.isCallServerCart,
        this.numberFormat,
        //this.reportData,
        this.reportInfo,
        this.statusCode,
        this.message});

  DataDefaultResponse.fromJson(Map<String, dynamic> json) {
    if (json['filterTimes'] != null) {
      filterTimes = <FilterTimes>[];
      json['filterTimes'].forEach((v) {
        filterTimes!.add(new FilterTimes.fromJson(v));
      });
    }
    if (json['reportCategories'] != null) {
      reportCategories = <ReportCategories>[];
      json['reportCategories'].forEach((v) {
        reportCategories!.add(new ReportCategories.fromJson(v));
      });
    }
    if (json['currencyList'] != null) {
      currencyList = <CurrencyList>[];
      json['currencyList'].forEach((v) {
        currencyList!.add(new CurrencyList.fromJson(v));
      });
    }
    if (json['stockList'] != null) {
      stockList = <StockList>[];
      json['stockList'].forEach((v) {
        stockList!.add(new StockList.fromJson(v));
      });
    }
    isCallServerCart = json['isCallServerCart'];
    if (json['numberFormat'] != null) {
      numberFormat = <NumberFormatType>[];
      json['numberFormat'].forEach((v) {
        numberFormat!.add(new NumberFormatType.fromJson(v));
      });
    }
    // if (json['reportData'] != null) {
    //   reportData = <ReportData>[];
    //   json['reportData'].forEach((v) {
    //     reportData!.add(new ReportData.fromJson(v));
    //   });
    // }
    reportInfo = json['reportInfo'] != null
        ? new ReportInfo.fromJson(json['reportInfo'])
        : null;
    statusCode = json['statusCode'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.filterTimes != null) {
      data['filterTimes'] = this.filterTimes!.map((v) => v.toJson()).toList();
    }
    if (this.reportCategories != null) {
      data['reportCategories'] =
          this.reportCategories!.map((v) => v.toJson()).toList();
    }
    if (this.currencyList != null) {
      data['currencyList'] = this.currencyList!.map((v) => v.toJson()).toList();
    }
    if (this.stockList != null) {
      data['stockList'] = this.stockList!.map((v) => v.toJson()).toList();
    }
    data['isCallServerCart'] = this.isCallServerCart;
    if (this.numberFormat != null) {
      data['numberFormat'] = this.numberFormat!.map((v) => v.toJson()).toList();
    }
    // if (this.reportData != null) {
    //   data['reportData'] = this.reportData!.map((v) => v.toJson()).toList();
    // }
    if (this.reportInfo != null) {
      data['reportInfo'] = this.reportInfo!.toJson();
    }
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}

class FilterTimes {
  String? filterTimeId;
  String? filterTimeName;

  FilterTimes({this.filterTimeId, this.filterTimeName});

  FilterTimes.fromJson(Map<String, dynamic> json) {
    filterTimeId = json['filterTimeId'];
    filterTimeName = json['filterTimeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['filterTimeId'] = this.filterTimeId;
    data['filterTimeName'] = this.filterTimeName;
    return data;
  }
}

class ReportCategories {
  String? reportId;
  String? reportName;
  String? viewType;
  String? chartType;

  ReportCategories(
      {this.reportId, this.reportName, this.viewType, this.chartType});

  ReportCategories.fromJson(Map<String, dynamic> json) {
    reportId = json['reportId'];
    reportName = json['reportName'];
    viewType = json['viewType'];
    chartType = json['chartType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reportId'] = this.reportId;
    data['reportName'] = this.reportName;
    data['viewType'] = this.viewType;
    data['chartType'] = this.chartType;
    return data;
  }
}

class CurrencyList {
  String? currencyCode;
  String? currencyName;
  String? currencyName2;

  CurrencyList({this.currencyCode, this.currencyName, this.currencyName2});

  CurrencyList.fromJson(Map<String, dynamic> json) {
    currencyCode = json['currencyCode'];
    currencyName = json['currencyName'];
    currencyName2 = json['currencyName2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currencyCode'] = this.currencyCode;
    data['currencyName'] = this.currencyName;
    data['currencyName2'] = this.currencyName2;
    return data;
  }
}

class StockList {
  String? stockCode;
  String? stockName;
  String? stockName2;

  StockList({this.stockCode, this.stockName, this.stockName2});

  StockList.fromJson(Map<String, dynamic> json) {
    stockCode = json['stockCode'];
    stockName = json['stockName'];
    stockName2 = json['stockName2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stockCode'] = this.stockCode;
    data['stockName'] = this.stockName;
    data['stockName2'] = this.stockName2;
    return data;
  }
}

class NumberFormatType {
  String? name;
  String? value;

  NumberFormatType({this.name, this.value});

  NumberFormatType.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}

class ReportData {
  int? colName;
  double? value1;
  double? value2;
  ReportData({this.colName, this.value1, this.value2});

  ReportData.fromJson(Map<String, dynamic> json) {
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

class ReportInfo {
  String? reportId;
  String? timeId;
  String? unitId;
  String? dataType;
  String? chartType;
  String? title;
  String? legend1;
  String? legend2;
  String? subtitle;
  String? defaultData;
  String? colors;

  ReportInfo(
      {this.reportId,
        this.timeId,
        this.unitId,
        this.dataType,
        this.chartType,
        this.title,
        this.legend1,
        this.legend2,
        this.subtitle,
        this.defaultData,
        this.colors});

  ReportInfo.fromJson(Map<String, dynamic> json) {
    reportId = json['reportId'];
    timeId = json['timeId'];
    unitId = json['unitId'];
    dataType = json['dataType'];
    chartType = json['chartType'];
    title = json['title'];
    legend1 = json['legend1'];
    legend2 = json['legend2'];
    subtitle = json['subtitle'];
    defaultData = json['defaultData'];
    colors = json['colors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reportId'] = this.reportId;
    data['timeId'] = this.timeId;
    data['unitId'] = this.unitId;
    data['dataType'] = this.dataType;
    data['chartType'] = this.chartType;
    data['title'] = this.title;
    data['legend1'] = this.legend1;
    data['legend2'] = this.legend2;
    data['subtitle'] = this.subtitle;
    data['defaultData'] = this.defaultData;
    data['colors'] = this.colors;
    return data;
  }
}