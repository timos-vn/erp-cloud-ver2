import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sse/themes/colors.dart';
import 'package:sse/utils/const.dart';
import 'package:sse/utils/utils.dart';
import '../../model/network/response/approval_detail_response.dart';
import '../../model/network/response/list_status_response.dart';
import '../widget/custom_dropdown.dart';
import 'options_input_bloc.dart';
import 'options_input_event.dart';
import 'options_input_state.dart';


class OptionsFilterDate extends StatefulWidget {
  final List<ListStatusApprovalResponseData>? listStatus;

  const OptionsFilterDate({Key? key, this.listStatus}) : super(key: key);
  @override
  _OptionsFilterDateState createState() => _OptionsFilterDateState();
}

class _OptionsFilterDateState extends State<OptionsFilterDate> {

  late OptionsInputBloc _bloc;
  String statusTypeName = 'Chờ duyệt';
  int statusType = 0;
  String toDate ="";
  String fromDate="";
  ListStatusApprovalResponseData? itemData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = OptionsInputBloc(context);
    itemData = widget.listStatus?[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
        body: BlocListener<OptionsInputBloc,OptionsInputState>(
          bloc: _bloc,
            listener: (context, state){
              if (state is WrongDate) {
                Utils.showCustomToast(context, Icons.warning_amber_outlined, '\'Từ ngày\' phải là ngày trước \'Đến ngày\'');
              }
            },
            child: BlocBuilder<OptionsInputBloc,OptionsInputState>(
              bloc: _bloc,
              builder: (BuildContext context, OptionsInputState state){
                return buildPage(context,state);
              },
            )
        )
    );
  }

  Widget buildPage(BuildContext context,OptionsInputState state){
    return Padding(
      padding: const EdgeInsets.only(top: 35,bottom: 35),
      child: AlertDialog(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(children: [
                Text('Bộ lọc',style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Divider(),
                SizedBox(height: 10,),
            ],),
            Visibility(
              visible: widget.listStatus?.isNotEmpty == true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 40,
                      child: Row(
                        children: [
                          Container(
                            // width: 50,
                            child: Text(
                              "Trạng thái",
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Expanded(child: genderStatus2()),
                          SizedBox(width: 5,)
                        ],
                      )
                  ),
                  Container(
                      height: 40,
                      child: Row(
                        children: [
                          Container(
                            // width: 50,
                            child: Text(
                              "Loại           ",
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Expanded(child: genderType()),
                          SizedBox(width: 5,)
                        ],
                      )
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ///or
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          height: 1,
                          color: Colors.blue.withOpacity(0.8),
                        ),
                      ),
                      SizedBox(width: 3,),
                      Text(
                        'Hoặc',
                        style: TextStyle(fontSize: 12,color: Colors.grey),
                      ),
                      SizedBox(width: 3,),
                      Expanded(
                        child: Divider(
                          height: 1,
                          color: Colors.blue.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            ///FromDate
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text(
                    'Từ ngày',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: DateTimePicker(
                    type: DateTimePickerType.date,
                    dateMask: 'd MMM, yyyy',
                    initialValue: DateTime.now().toString(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.event,color: subColor,size: 22,),
                      contentPadding: EdgeInsets.only(left: 12),
                      // border: InputBorder.none,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: grey, width: 1),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: grey, width: 1),
                      ),
                    ),
                    style: TextStyle(fontSize: 13),
                    locale: const Locale("vi", "VN"),
                    // icon: Icon(Icons.event),
                    selectableDayPredicate: (date) {
                      // Disable weekend days to select from the calendar
                      // if (date.weekday == 6 || date.weekday == 7) {
                      //   return false;
                      // }

                      return true;
                    },
                    onChanged: (val) => print(val),
                    validator: (result) {
                      _bloc.add(DateFrom(Utils.parseStringToDate(result.toString(), Const.DATE_SV_FORMAT_2)));
                      return null;
                    },
                    onSaved: (val) => print(val),
                  )
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            ///ToDate
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Text(
                    "Tới ngày",
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: DateTimePicker(
                    type: DateTimePickerType.date,
                    dateMask: 'd MMM, yyyy',
                    initialValue: DateTime.now().toString(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.event,color: subColor,size: 22,),
                      contentPadding: EdgeInsets.only(left: 12),
                      // border: InputBorder.none,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: grey, width: 1),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: grey, width: 1),
                      ),
                    ),
                    style: TextStyle(fontSize: 13),
                    locale: const Locale("vi", "VN"),
                    // icon: Icon(Icons.event),
                    selectableDayPredicate: (date) {
                      // Disable weekend days to select from the calendar
                      // if (date.weekday == 6 || date.weekday == 7) {
                      //   return false;
                      // }

                      return true;
                    },
                    onChanged: (val) => print(val),
                    validator: (result) {
                      _bloc.add(DateTo(Utils.parseStringToDate(result.toString(), Const.DATE_SV_FORMAT_2)));
                      return null;
                    },
                    onSaved: (val) => print(val),
                  )
                ),
              ],
            ),

            SizedBox(height: 25,),
            ///Button
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 90.0,
                      height: 35.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.0), color: grey),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Huỷ',
                            style: TextStyle(
                              fontSize: 12,
                              color: white,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context,[statusType,_bloc.statusCode,'',_bloc.getStringFromDateYMD(_bloc.dateFrom),_bloc.getStringFromDateYMD(_bloc.dateTo),statusTypeName]);
                    },
                    child: Container(
                      width: 90.0,
                      height: 35.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.0), color: orange),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Chọn',
                            style: TextStyle(
                              fontSize: 12,
                              color: white,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  List<String> typeStatus = ['Chờ duyệt','Đã duyệt'];

  Widget genderType() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
          icon: Icon(
            MdiIcons.sortVariant,
            size: 15,
            color: black,
          ),
          isDense: true,
          isExpanded: true,
          style: TextStyle(
            color: black,
            fontSize: 12.0,
          ),
          value: statusTypeName,
          items: typeStatus.map((value) => DropdownMenuItem<String>(
            child: Align(
                alignment: Alignment.center,
                child: Text(value.toString(), style: TextStyle(fontSize: 13.0, color: blue.withOpacity(0.6)),)),
            value: value,
          )).toList(),
          onChanged: (value) {
            setState(() {
              statusTypeName = value!;
            });
            if(value == 'Chờ duyệt'){
              statusType = 1;
            }else if(value == 'Đã duyệt'){
              statusType = 2;
            }
          }),
    );
  }


  Widget genderStatus2() {
    return widget.listStatus?.isEmpty == true
        ? Container(child: Text('Không có dữ liệu',style: TextStyle(fontSize: 11,color: Colors.red),),)
        : DropdownButtonHideUnderline(
          child: DropdownButton<ListStatusApprovalResponseData>(
          icon: Icon(
            MdiIcons.sortVariant,
            size: 15,
            color: black,
          ),
          isDense: true,
          isExpanded: true,
          style: TextStyle(
            color: black,
            fontSize: 12.0,
          ),
          value: itemData,
          items: widget.listStatus?.map((value) => DropdownMenuItem<ListStatusApprovalResponseData>(
            child: Align(
                alignment: Alignment.center,
                child: Text(value.uStatusName.toString(), style: TextStyle(fontSize: 13.0, color: blue.withOpacity(0.6)),)),
            value: value,
          )).toList() ?? [],
          onChanged: (value) {
            setState(() {
              itemData = value;
            });
            _bloc.add(PickGenderStatus(statusCode:  int.parse(itemData!.uStatus.toString()),statusName: itemData?.uStatusName));
          }),
    );
  }
}
