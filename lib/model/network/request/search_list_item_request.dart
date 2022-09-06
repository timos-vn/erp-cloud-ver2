
class SearchListItemRequest {
  String? searchValue;
  int? pageIndex;
  String? currency;
  String? itemGroup;
  String? itemGroup2;
  String? itemGroup3;
  String? itemGroup4;
  String? itemGroup5;

  SearchListItemRequest({this.searchValue,this.pageIndex, this.currency,this.itemGroup,this.itemGroup2,this.itemGroup3, this.itemGroup4,this.itemGroup5});

  SearchListItemRequest.fromJson(Map<String, dynamic> json) {
    searchValue = json['SearchValue'];
    pageIndex = json['PageIndex'];
    currency = json['Currency'];
    itemGroup = json['ItemGroup'];
    itemGroup2 = json['ItemGroup2'];
    itemGroup3 = json['ItemGroup3'];
    itemGroup4 = json['ItemGroup4'];
    itemGroup5 = json['ItemGroup5'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.searchValue != null){
      data['SearchValue'] = this.searchValue;
    }
    if(this.pageIndex != null){
      data['PageIndex'] = this.pageIndex;
    }
    if(this.currency != null){
      data['Currency'] = this.currency;
    }
    data['ItemGroup'] = this.itemGroup;
    data['ItemGroup2'] = this.itemGroup2;
    data['ItemGroup3'] = this.itemGroup3;
    data['ItemGroup4'] = this.itemGroup4;
    data['ItemGroup5'] = this.itemGroup5;
    return data;
  }
}