class ManagerCustomerRequestBody {
  int? type;
  int? pageIndex;
  String? searchValue;

  ManagerCustomerRequestBody({this.type,this.pageIndex, this.searchValue,});

  ManagerCustomerRequestBody.fromJson(Map<String, dynamic> json) {
    type = json['Type'];
    pageIndex = json['PageIndex'];
    searchValue = json['SearchValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.type != null){
      data['Type'] = this.type;
    }
    if(this.pageIndex != null){
      data['PageIndex'] = this.pageIndex;
    }
    if(this.searchValue != null){
      data['SearchValue'] = this.searchValue;
    }
    return data;
  }
}