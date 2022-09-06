import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sse/screen/filter/filter_page.dart';
import 'package:sse/screen/personnel/suggestions/suggestions_bloc.dart';
import 'package:sse/screen/personnel/suggestions/suggestions_state.dart';

import '../../../themes/colors.dart';
import '../../../utils/const.dart';
import '../../widget/custom_dropdown.dart';
import '../../widget/pending_action.dart';
import '../component/create_dnc.dart';
import '../component/list_dnc.dart';


class SuggestionsScreen extends StatefulWidget {
  final int keySuggestion;
  final String title;

  const SuggestionsScreen({Key? key, required this.keySuggestion,required this.title}) : super(key: key);
  @override
  _SuggestionsScreenState createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen> {
  FocusNode focusNodeContent = FocusNode();

  FocusNode focusNodeCar = FocusNode();
  TextEditingController _carController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  String? departmentCode,departmentName;
  List<String> _list = [
    'Phép năm',
   'Ốm',
  'Con ốm',
  'Thai sản',
  'Tai nạn',
  'Kết hôn',
  'Tang gia',
  'Không hưởng lương',
  'Khác'
  ];
  String? values;

  late SuggestionsBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = SuggestionsBloc(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SuggestionsBloc,SuggestionsState>(
        bloc: _bloc,
        listener: (context, state){

        },
        child: BlocBuilder<SuggestionsBloc,SuggestionsState>(
          bloc: _bloc,
          builder: (BuildContext context, SuggestionsState state){
            return Stack(
              children: [
                buildBody(context, state),
                Visibility(
                  visible: state is GetListDNCEmpty,
                  child: Center(
                    child: Text('Úi, Đại Vương dữ liệu trống!!!',style: TextStyle(color: Colors.blueGrey)),
                  ),
                ),
                Visibility(
                  visible: state is SuggestionsLoading,
                  child: PendingAction(),
                )
              ],
            );
          },
        ),
      )
    );
  }

  buildBody(BuildContext context,SuggestionsState state){
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 0),
      child: Column(
        children: [
          buildAppBar(),
          const SizedBox(height: 10,),
          Expanded(
            child: widget.keySuggestion == 1 ? buildLeave(context) : (widget.keySuggestion == 2 ? buildMoney(context)  : buildCar(context)),
          )
        ],
      ),
    );
  }

  buildAppBar(){
    return Container(
      height: 83,
      width: double.infinity,
      decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [subColor,Color.fromARGB(255, 150, 185, 229)])),
      padding: const EdgeInsets.fromLTRB(5, 35, 12,0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: ()=> Navigator.pop(context),
            child: Container(
              width: 40,
              height: 50,
              child: Icon(
                Icons.arrow_back_rounded,
                size: 25,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                widget.title,
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.white,),
                maxLines: 1,overflow: TextOverflow.fade,
              ),
            ),
          ),
          const SizedBox(width: 10,),
          Container(
            width: 40,
            height: 50,
            child: Icon(
              Icons.check,
              size: 25,
              color: Colors.transparent,
            ),
          )
        ],
      ),
    );
  }

  Widget buildLeave(BuildContext context){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Từ ngày')),
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: ()async {
                            // final DateTime result = await showDialog<dynamic>(
                            //     context: context,
                            //     builder: (BuildContext context) {
                            //       return DateRangePicker(
                            //             DateTime.now(),
                            //         null,
                            //         minDate: DateTime.now().subtract(const Duration(days: 10000)),
                            //         maxDate:
                            //         DateTime.now().add(const Duration(days: 10000)),
                            //         displayDate: DateTime.now(),
                            //       );
                            //     });
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.6),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(child: Text(
                                    // !Utils.isEmpty(_bloc.dateFrom) ?
                                    // DateFormat('yyyy-MM-dd').format(_bloc.dateFrom) :
                                    ''
                                    ,style: TextStyle(color: Colors.grey,fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis)),
                                Icon(Icons.event,color: Colors.grey,),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Tới ngày',overflow: TextOverflow.ellipsis,maxLines: 1,)),
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: ()async {
                            // final DateTime result = await showDialog<dynamic>(
                            //     context: context,
                            //     builder: (BuildContext context) {
                            //       return DateRangePicker(
                            //         // _bloc.dateTo ??
                            //             DateTime.now(),
                            //         null,
                            //         minDate: DateTime.now().subtract(const Duration(days: 10000)),
                            //         maxDate:
                            //         DateTime.now().add(const Duration(days: 10000)),
                            //         displayDate: //_bloc.dateTo ??
                            //             DateTime.now(),
                            //       );
                            //     });
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.6),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(child: Text(
                                    // !Utils.isEmpty(_bloc.dateTo) ? DateFormat('yyyy-MM-dd').format(_bloc.dateTo) :
                                    '',style: TextStyle(color: Colors.grey,fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis)),
                                Icon(Icons.event,color: Colors.grey,),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30,),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text('Gửi đến')),
                Expanded(
                  flex: 4,
                  child:InkWell(
                    onTap: (){
                      // showDialog(
                      //     context: context,
                      //     builder: (context) => FilterPage(controller: 'dmbp_lookup',
                      //       listItem: null,show: false,)).then((value){
                      //   if(!Utils.isEmpty(value)){
                      //     setState(() {
                      //       departmentCode = value[0];
                      //       departmentName = value[1];
                      //     });
                      //   }
                      // });
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.6),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(child: Text(departmentName?.toString()??'',style: TextStyle(color: Colors.grey,fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis)),
                          Icon(Icons.search,color: Colors.grey,),
                        ],
                      ),
                    ),
                  )
                )
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Lý do'),
                buildReason(),
              ],
            ),
            SizedBox(height: 20,),
            Align(alignment:Alignment.centerLeft,child: Text('Mô tả')),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: ()=> FocusScope.of(context).requestFocus(focusNodeContent),
              child:  Container(
                height: 150 ,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: TextField(
                  maxLines: 10,
                  //obscureText: true,
                  controller: _contentController,
                  decoration: new InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey, ),
                    ),
                    contentPadding: EdgeInsets.all(8),
                    hintText: 'Vui lòng nhập mô tả',
                    hintStyle: TextStyle(fontStyle: FontStyle.italic,color: Colors.grey),
                  ),
                  focusNode: focusNodeContent,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 14),
                  //textInputAction: TextInputAction.none,
                ),
              ),
            ),
            SizedBox(height: 30,),
            GestureDetector(
              onTap: (){
                //login(hostIdController.text,usernameController.text,passwordController.text,isChecked);
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 100.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.0),
                      color: mainColor
                  ),
                  child: Center(
                    child: Text(
                      'Gửi',
                      style: TextStyle( fontSize: 16, color: Colors.white,),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  buildReason(){
    return PopupMenuButton(
      shape: const TooltipShape(),
      padding: EdgeInsets.zero,
      offset: const Offset(0, 40),
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<Widget>>[
          PopupMenuItem<Widget>(
            child: Container(
              width: 200,
              decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: Scrollbar(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: _list.length,
                  itemBuilder: (context, index) {
                    final trans = _list[index];
                    return Container(
                      width: double.infinity,
                      child: ListTile(
                        minVerticalPadding: 1,
                        title: Text(
                          trans.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                          maxLines: 1,overflow: TextOverflow.fade,
                        ),
                        subtitle: Divider(height: 1,),
                        onTap: () {
                          setState(() {
                            values = _list[index].toString();
                          });
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),
              height: 250,
            ),
          ),
        ];
      },
      child: Container(
        child: Row(
          children: [
            Text(values.toString()),
            const SizedBox(width: 8,),
            Icon(
              MdiIcons.sortVariant,
              size: 15,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMoney(BuildContext context){
    return Column(
      children: [
        const SizedBox(height: 12,),
        GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CreateDNCScreen())), child: buildItem(context, 'Tạo mới Đề Nghị Chi', Colors.purple.withOpacity(0.7), Icons.transfer_within_a_station)),
        GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ListDNC())), child: buildItem(context, 'Danh sách Đề Nghị Chi', Colors.grey.withOpacity(0.7), Icons.switch_account)),
      ],
    );
  }

  Widget buildCar(BuildContext context){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Từ ngày')),
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: ()async {
                            // final DateTime result = await showDialog<dynamic>(
                            //     context: context,
                            //     builder: (BuildContext context) {
                            //       return DateRangePicker(
                            //         // _bloc.dateFrom ??
                            //         DateTime.now(),
                            //         null,
                            //         minDate: DateTime.now().subtract(const Duration(days: 10000)),
                            //         maxDate:
                            //         DateTime.now().add(const Duration(days: 10000)),
                            //         displayDate:// _bloc.dateFrom ??
                            //         DateTime.now(),
                            //       );
                            //     });
                            // if (result != null) {
                            //   // _bloc.add(DateFrom(result));
                            // }
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.6),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(child: Text(
                                  // !Utils.isEmpty(_bloc.dateFrom) ?
                                  // DateFormat('yyyy-MM-dd').format(_bloc.dateFrom) :
                                    ''
                                    ,style: TextStyle(color: Colors.grey,fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis)),
                                Icon(Icons.event,color: Colors.grey,),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Đến ngày',overflow: TextOverflow.ellipsis,maxLines: 1,)),
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: ()async {
                            // final DateTime result = await showDialog<dynamic>(
                            //     context: context,
                            //     builder: (BuildContext context) {
                            //       return DateRangePicker(
                            //         // _bloc.dateTo ??
                            //         DateTime.now(),
                            //         null,
                            //         minDate: DateTime.now().subtract(const Duration(days: 10000)),
                            //         maxDate:
                            //         DateTime.now().add(const Duration(days: 10000)),
                            //         displayDate: //_bloc.dateTo ??
                            //         DateTime.now(),
                            //       );
                            //     });
                            // if (result != null) {
                            //   // _bloc.add(DateTo(result));
                            // }
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.6),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(child: Text(
                                  // !Utils.isEmpty(_bloc.dateTo) ? DateFormat('yyyy-MM-dd').format(_bloc.dateTo) :
                                    '',style: TextStyle(color: Colors.grey,fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis)),
                                Icon(Icons.event,color: Colors.grey,),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30,),
            Row(
              children: [
                Expanded(
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Địa điểm đi',overflow: TextOverflow.ellipsis,maxLines: 1,)),
                ),
                SizedBox(width: 5,),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: ()=> FocusScope.of(context).requestFocus(focusNodeCar),
                    child:  Container(
                      height: 40 ,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        // border: Border.all(color: Colors.grey,width: 0.5)
                      ),
                      child: TextField(
                        maxLines: 1,
                        //obscureText: true,
                        controller: _carController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey, ),
                          ),
                          contentPadding: EdgeInsets.all(8),
                          hintText: 'Vui lòng nhập địa điểm đi',
                          hintStyle: TextStyle(fontStyle: FontStyle.italic,color: Colors.grey,fontSize: 12),
                        ),
                        focusNode: focusNodeCar,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 14),
                        //textInputAction: TextInputAction.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30,),
            Row(
              children: [
                Expanded(
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Địa điểm đến',overflow: TextOverflow.ellipsis,maxLines: 1,)),
                ),
                SizedBox(width: 5,),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: ()=> FocusScope.of(context).requestFocus(focusNodeCar),
                    child:  Container(
                      height: 40 ,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        // border: Border.all(color: Colors.grey,width: 0.5)
                      ),
                      child: TextField(
                        maxLines: 1,
                        //obscureText: true,
                        controller: _carController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey, ),
                          ),
                          contentPadding: EdgeInsets.all(8),
                          hintText: 'Vui lòng nhập địa điểm đến',
                          hintStyle: TextStyle(fontStyle: FontStyle.italic,color: Colors.grey,fontSize: 12),
                        ),
                        focusNode: focusNodeCar,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 14),
                        //textInputAction: TextInputAction.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30,),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text('Gửi đến')),
                Expanded(
                    flex: 2,
                    child:InkWell(
                      onTap: (){
                        showDialog(
                            context: context,
                            builder: (context) => FilterScreen(controller: 'dmbp_lookup',
                              listItem: null,show: false,)).then((value){
                          if(value != ''){
                            setState(() {
                              departmentCode = value[0];
                              departmentName = value[1];
                            });
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.6),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(child: Text(departmentName?.toString()??'',style: TextStyle(color: Colors.grey,fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis)),
                            Icon(Icons.search,color: Colors.grey,),
                          ],
                        ),
                      ),
                    )
                )
              ],
            ),
            SizedBox(height: 20,),
            Align(alignment:Alignment.centerLeft,child: Text('Mô tả')),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: ()=> FocusScope.of(context).requestFocus(focusNodeContent),
              child:  Container(
                height: 150 ,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: TextField(
                  maxLines: 10,
                  //obscureText: true,
                  controller: _contentController,
                  decoration: new InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey, ),
                    ),
                    contentPadding: EdgeInsets.all(8),
                    hintText: 'Vui lòng nhập mô tả',
                    hintStyle: TextStyle(fontStyle: FontStyle.italic,color: Colors.grey),
                  ),
                  focusNode: focusNodeContent,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 14),
                  //textInputAction: TextInputAction.none,
                ),
              ),
            ),
            SizedBox(height: 30,),
            GestureDetector(
              onTap: (){
                //login(hostIdController.text,usernameController.text,passwordController.text,isChecked);
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 100.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.0),
                      color: mainColor
                  ),
                  child: Center(
                    child: Text(
                      'Gửi',
                      style: TextStyle( fontSize: 16, color: Colors.white,),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, String name, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: color,
                  ),
                  child: Center(
                      child: Icon(
                        icon,
                        size: 15,
                        color: Colors.white,
                      ))),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  name,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
