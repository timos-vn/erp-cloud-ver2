class EntityRequest {
  int? pageIndex;
  int? pageCount;

  EntityRequest({this.pageIndex, this.pageCount});

  EntityRequest.fromJson(Map<String, dynamic> json) {
    pageIndex = json['page_Index'];
    pageCount = json['page_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page_Index'] = this.pageIndex;
    data['page_count'] = this.pageCount;
    return data;
  }
}
