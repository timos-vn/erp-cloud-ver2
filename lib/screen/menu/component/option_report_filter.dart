import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sse/model/network/response/report_field_lookup_response.dart';
import 'package:sse/screen/filter/filter_bloc.dart';
import 'package:sse/screen/filter/filter_event.dart';
import 'package:sse/screen/filter/filter_state.dart';
import 'package:sse/themes/colors.dart';
import 'package:sse/utils/utils.dart';
import '../../widget/pending_action.dart';

class OptionReportFilter extends StatefulWidget {
  final String controller;
  final String listItem;
  final bool show;
  const OptionReportFilter({Key? key, required this.controller,required this.listItem,required this.show}) : super(key: key);
  @override
  _OptionReportFilterState createState() => _OptionReportFilterState();
}

class _OptionReportFilterState extends State<OptionReportFilter> {

  late FilterBloc _filterBloc;
  final ScrollController _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  bool _hasReachedMax = true;
  bool values = false;
  final TextEditingController _searchControllerCode = TextEditingController();
  final TextEditingController _searchControllerName = TextEditingController();
  final focusNodeCode = FocusNode();
  final focusNodeName = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _filterBloc = FilterBloc(context);
    _filterBloc.add(GetPrefs());
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScroll - currentScroll <= _scrollThreshold && !_hasReachedMax && _filterBloc.isScroll == true) {
        _filterBloc.add(GetListFieldLookup(isLoadMore: true,controller: widget.controller,listItem: widget.listItem));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocProvider<FilterBloc>(
        create:(context)=> FilterBloc(context),

        child: BlocListener(
          bloc: _filterBloc,
          listener: (context,state){
            if(state is GetPrefsSuccess){
              _filterBloc.add(GetListFieldLookup(controller: widget.controller,listItem: widget.listItem));
            }
          },
          child: BlocBuilder<FilterBloc,FilterState>(
            bloc: _filterBloc,
            builder: (BuildContext context, FilterState state,){
              return buildPage(context,state);
            },
          ),
        ),
      ),
    );
  }

  Widget buildPage(BuildContext context,FilterState state){
    List<ReportFieldLookupResponseData> _list = _filterBloc.listRPLP;
    int length = _list.length;
    if (state is FilterSuccess){
      _hasReachedMax = length < _filterBloc.currentPage * 20;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 32,bottom: 32),
      child: AlertDialog(
        title:Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Text('Điều kiện lọc',style: TextStyle(fontSize: 16),)),
              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: accent),
                          borderRadius:
                          BorderRadius.all(Radius.circular(16))),
                      padding:
                      EdgeInsets.only(left: 10,right: 10,top: 7),
                      child: SizedBox(
                        height: 25,
                        width: 100,
                        child: TextField(
                          autofocus: false,
                          textAlign: TextAlign.left,
                          textAlignVertical: TextAlignVertical.top,
                          style:
                          TextStyle(fontSize: 12, color: accent),
                          focusNode: focusNodeCode,
                          onSubmitted: (text) {
                            _filterBloc.listRPLP.clear();
                           _filterBloc.add(GetListFieldLookup(controller: widget.controller,searchTextCode: text,listItem: widget.listItem));
                          },

                         controller: _searchControllerCode,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onChanged: (text) {},
                          //    _bloc.add(CheckShowCloseEvent(text)
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: transparent,
                              hintText: 'Code',
                              hintStyle: TextStyle(color: accent),
                              contentPadding: EdgeInsets.only(
                                  bottom: 13, top: 10)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Container(
                      //width: double.infinity,
                      // margin: EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                          border: Border.all(color: accent),
                          borderRadius:
                          BorderRadius.all(Radius.circular(16))),
                      padding:
                      EdgeInsets.only(left: 10,right: 10,top: 7),
                      child: SizedBox(
                        height: 25,
                        width: 100,
                        child: TextField(
                          autofocus: false,
                          textAlign: TextAlign.left,
                          textAlignVertical: TextAlignVertical.top,
                          style:
                          TextStyle(fontSize: 12, color: accent),
                          focusNode: focusNodeName,
                          onSubmitted: (text) {
                            _filterBloc.listRPLP.clear();
                              _filterBloc.add(GetListFieldLookup(controller: widget.controller,searchTextName: text,listItem: widget.listItem));
                          },

                          controller: _searchControllerName,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onChanged: (text) {},
                          //    _bloc.add(CheckShowCloseEvent(text)
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: transparent,
                              hintText: 'Tên',
                              hintStyle: TextStyle(color: accent),
                              contentPadding: EdgeInsets.only(
                                  bottom: 13, top: 10)),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        actionsPadding: EdgeInsets.symmetric(vertical: 0),

         actions: [
          Visibility(
            visible: widget.show == false,
            child: InkWell(
              onTap:()=>Navigator.pop(context),
              child: Container(
                width: 70.0,
                height: 30.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.0),
                    color: Colors.grey
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cancel,size: 15,color: Colors.white,),
                      SizedBox(width: 3,),
                      Text(
                        'Huỷ',
                        style: TextStyle(fontSize: 13, color: white,),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],

        content: Column(
          children: [
            Expanded(
              child: Stack(children: <Widget>[
                Container(
                  height:700,
                  width: 700,
                  child: ListView.separated(
                    controller: _scrollController,
                    physics: AlwaysScrollableScrollPhysics(),
                    separatorBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: widget.show == false ? 14 : 0),
                        child: Divider(
                          height: 0.5,
                          thickness: 1,
                        ),
                      );
                    },
                    shrinkWrap: true,
                    itemCount: length == 0 ? length : _hasReachedMax ? length : length + 1,
                    itemBuilder: (context, index) {
                      return
                        index >= length
                            ?  Container(
                          height: 100.0,
                          color: white,
                          child: PendingAction(),
                        )
                            :
                        InkWell(
                          onTap: widget.show == false ? ()=> Navigator.of(context).pop([ _list[index].code.toString(), _list[index].name.toString()]) : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Visibility(
                                visible: widget.show == true,
                                child: Checkbox(
                                  value: _list[index].isChecked,
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      _list[index].isChecked = newValue!;
                                      _filterBloc.add(AddItemSelectedEvent(_list[index], newValue));
                                      print(_list[index].isChecked);
                                    });
                                  },
                                ),
                              ),

                              Expanded(flex:3,child: Align(alignment:Alignment.centerLeft,
                                  child: Text(_list[index].name ?? '',style: TextStyle(fontSize: 13),maxLines: 2,overflow: TextOverflow.ellipsis,textAlign: TextAlign.left,))),
                              Expanded(child: Align(alignment:Alignment.centerRight,child: Text(_list[index].code ?? '',style: TextStyle(fontSize: 13),))),
                            ],
                          ),
                        );
                    },
                  ),
                ),
                Visibility(
                  visible: state is FilterEmpty,
                  child: Center(
                    child: Text('Úi, Đại Vương dữ liệu trống!!!',style: TextStyle(color: Colors.blueGrey)),
                  ),
                ),
                Visibility(
                  visible: state is FilterLoading,
                  child: PendingAction(),
                )
              ]),
            ),
            Visibility(
                visible: widget.show == true,
                child: SizedBox(height: 10,)),
            Visibility(
              visible: widget.show == true,
              child: Padding(
                padding: const EdgeInsets.only(left: 16,right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap:()=>Navigator.pop(context),
                      child: Container(
                        width: 100.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18.0),
                            color: Colors.grey
                        ),
                        child: Center(
                          child: Text(
                            'Huỷ',
                            style: TextStyle(fontSize: 13, color: white,),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        if(!Utils.isEmpty(_filterBloc.listCheckedReport)){
                          Navigator.of(context).pop(_filterBloc.listCheckedReport);
                        }else{
                          Utils.showCustomToast(context, Icons.warning_amber_outlined, 'Úi, Vui lòng chọn thêm điều kiện hoặc hủy bỏ');
                        }
                      },
                      child: Container(
                        width: 100.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18.0),
                            color: orange
                        ),
                        child: Center(
                          child: Text(
                            'OK',
                            style: TextStyle(fontSize: 13, color: white,),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
