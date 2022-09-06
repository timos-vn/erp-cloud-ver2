import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sse/model/network/response/report_field_lookup_response.dart';
import 'package:sse/model/network/response/report_layout_response.dart';
import 'package:sse/screen/widget/text_field_widget.dart';
import 'package:sse/screen/widget/text_field_widget2.dart';
import 'package:sse/themes/colors.dart';
import 'package:sse/utils/const.dart';
import 'package:sse/utils/utils.dart';

import '../report/result_report/result_report_screen.dart';
import 'option_report_filter.dart';

class ValueReportFilter extends StatefulWidget {
  final List<DataReportLayout> listRPLayout;
  final String idReport;
  final String title;

  const ValueReportFilter({Key? key, required this.listRPLayout,required this.idReport,required this.title}) : super(key: key);
  @override
  _ValueReportFilterState createState() => _ValueReportFilterState();
}

class _ValueReportFilterState extends State<ValueReportFilter> {
  final TextEditingController dateFrom = TextEditingController();
  final TextEditingController dateTo = TextEditingController();
  final TextEditingController type4 = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: buildBody(context),
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
                "${widget.title}",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.white,),
                maxLines: 1,overflow: TextOverflow.fade,
              ),
            ),
          ),
          const SizedBox(width: 10,),
          Container(
            height: 50,
            child: Icon(
              Icons.filter_alt_outlined,
              size: 25,
              color: Colors.transparent,
            ),
          )
        ],
      ),
    );
  }

  buildBody(BuildContext context){
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          buildAppBar(),
          Expanded(
            child:widget.listRPLayout.isEmpty
                ? Center(
              child:Text('Úi, Đại Vương dữ liệu trống!!!',style: TextStyle(color: Colors.blueGrey)),)
                : ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  ///Text
                  if (int.parse(widget.listRPLayout[index].type.toString()) == 1) {
                    //if(widget.listRPLayout[index].field == 'so_ct1'){
                    return textInput(context, index);
                    // }
                  }
                  ///Numeric
                  else if (int.parse(widget.listRPLayout[index].type.toString()) == 2) {
                    return numberInput(context,index);
                  }
                  ///Datetime
                  else if (int.parse(widget.listRPLayout[index].type.toString()) == 3) {
                    if (widget.listRPLayout[index].field == 'DateFrom') {
                      return dateTimeFrom(context,index);
                    }
                    if (widget.listRPLayout[index].field == 'DateTo') {
                      return dateTimeTo(context,index);
                    }
                    if(widget.listRPLayout[index].field != 'DateFrom' && widget.listRPLayout[index].field != 'DateTo'){
                      return dateTimeOther(context,index);
                    }
                  }
                  ///AutoComplete
                  else if (int.parse(widget.listRPLayout[index].type.toString()) == 4) {
                    return filterAutoComplete(context, index);
                  }
                  ///Lookup
                  else if (int.parse(widget.listRPLayout[index].type.toString()) == 5) {
                    return filterLookup(context, index);
                  }
                  ///Checkbox
                  else if (int.parse(widget.listRPLayout[index].type.toString()) == 6) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            if(widget.listRPLayout[index].c == true){
                              widget.listRPLayout[index].c = false;
                              widget.listRPLayout[index].selectValue = new ReportFieldLookupResponseData(code: '0', name: '0',);
                            }else {
                              widget.listRPLayout[index].c = true;
                              widget.listRPLayout[index].selectValue = new ReportFieldLookupResponseData(code: '1', name: '1',);
                            }
                          });
                        },
                        child: Container(
                          child: Row(
                            children: [
                              Checkbox(
                                value: widget.listRPLayout[index].defaultValue != null
                                    ? (widget.listRPLayout[index].defaultValue?.trim() == '0' ? false : true)
                                    : widget.listRPLayout[index].c,
                                onChanged: (bool? newValue) {
                                  setState(() {//0 - false
                                    if(widget.listRPLayout[index].c == true){
                                      widget.listRPLayout[index].c = false;
                                      widget.listRPLayout[index].selectValue = new ReportFieldLookupResponseData(code: '0', name: '0',);
                                    }else{
                                      widget.listRPLayout[index].c = true;
                                      widget.listRPLayout[index].selectValue = new ReportFieldLookupResponseData(code: '1', name: '1',);
                                    }
                                  });
                                },
                              ),
                              Row(
                                children: [
                                  Text(widget.listRPLayout[index].name.toString().trim(),style: TextStyle(fontSize: 12,color: widget.listRPLayout[index].isNull == false? Colors.red : Colors.grey),),
                                  SizedBox(width: 4,),
                                  Visibility(
                                      visible: widget.listRPLayout[index].isNull == false ,
                                      child: Text('*',style: TextStyle(fontSize: 11,color: Colors.red),)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  ///DropDown
                  else if (int.parse(widget.listRPLayout[index].type.toString()) == 7) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Column(
                        children: [
                          Visibility(
                            visible: widget.listRPLayout[index].selectValue != null || widget.listRPLayout[index].defaultValue != null,
                            child: Row(
                              children: [
                                Text('${widget.listRPLayout[index].name}',style: TextStyle(color: widget.listRPLayout[index].isNull == false? Colors.red : Colors.grey,fontSize: 11),),
                                SizedBox(width: 4,),
                                Visibility(
                                    visible: widget.listRPLayout[index].isNull == false ,
                                    child: Text('*',style: TextStyle(fontSize: 11,color: Colors.red),)),
                              ],
                            ),
                          ),
                          Container(
                            height: 30,
                            width: double.infinity,
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                // alignedDropdown: true,
                                child: DropdownButton<String>(
                                  underline: Container(color:Colors.red, height:10.0),
                                  value:  widget.listRPLayout[index].selectValue != null ? widget.listRPLayout[index].selectValue?.code
                                      :(widget.listRPLayout[index].defaultValue != null? widget.listRPLayout[index].defaultValue?.trim() : null ),
                                  iconSize: 25,
                                  icon: (null),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                  ),
                                  hint:  Text(
                                    widget.listRPLayout[index].name.toString().trim() +
                                        (widget.listRPLayout[index].isNull == false? ' *' : ''),
                                    style: TextStyle(color: widget.listRPLayout[index].isNull == false? Colors.red : Colors.grey,fontSize: 11),),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      widget.listRPLayout[index].selectValue = new ReportFieldLookupResponseData(code: newValue, name: newValue,);
                                      widget.listRPLayout[index].c  = true;
                                      print("${widget.listRPLayout[index].selectValue?.code} <---");
                                    });
                                  },
                                  items: widget.listRPLayout[index].dropDownList?.map((item) {
                                    return DropdownMenuItem(
                                      child: Text(
                                        item.text.toString().trim(),
                                        style: TextStyle(fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                      value: item.value.toString().trim(),
                                    );
                                  }).toList() ?? [],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 0,),
                          Container(color:Colors.grey, height:1.0)
                        ],
                      ),
                    );
                  }
                  return Container();
                },
                separatorBuilder: (BuildContext context, int index) =>
                    Container(),
                itemCount: widget.listRPLayout.length),
          ),
          widget.listRPLayout.isEmpty ? Container() : button(context),
          const SizedBox(height: 65,)
        ],
      ),
    );
  }

  dateTimeOther(BuildContext context,int index){
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Container(
        height: 40,
        child: Column(
          children: [
            Row(
              children: [
                Text(widget.listRPLayout[index].name?.trim()??'',
                    style: TextStyle(fontSize: 11, color: widget.listRPLayout[index].isNull == false? Colors.red : Colors.grey)),
                SizedBox(width: 4,),
                Visibility(
                    visible: widget.listRPLayout[index].isNull == false ,
                    child: Text('*',style: TextStyle(fontSize: 11,color: Colors.red),)),
              ],
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
                  widget.listRPLayout[index].textEditingController = TextEditingController();
                  widget.listRPLayout[index].textEditingController?.text = result.toString();
                  widget.listRPLayout[index].selectValue = new ReportFieldLookupResponseData(
                    code: widget.listRPLayout[index].textEditingController?.text,
                    name: widget.listRPLayout[index].textEditingController?.text,
                  );
                  widget.listRPLayout[index].c  = true;
                  return null;
                },
                onSaved: (val) => print(val),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget dateTimeFrom(BuildContext context,int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Container(
        height: 40,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Từ ngày',
                    style: TextStyle(fontSize: 11, color: widget.listRPLayout[index].isNull == false? Colors.red : Colors.grey)),
                SizedBox(width: 4,),
                Visibility(
                    visible: widget.listRPLayout[index].isNull == false ,
                    child: Text('*',style: TextStyle(fontSize: 11,color: Colors.red),)),
              ],
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
                  dateFrom.text = result.toString();
                  widget.listRPLayout[index].selectValue = new ReportFieldLookupResponseData(code: dateFrom.text, name: dateFrom.text,);
                  widget.listRPLayout[index].c  = true;
                  return null;
                },
                onSaved: (val) => print(val),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dateTimeTo(BuildContext context,int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Container(
        height: 40,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Tới ngày',
                    style: TextStyle(fontSize: 11, color: widget.listRPLayout[index].isNull == false? Colors.red : Colors.grey)),
                SizedBox(width: 4,),
                Visibility(
                    visible: widget.listRPLayout[index].isNull == false ,
                    child: Text('*',style: TextStyle(fontSize: 11,color: Colors.red),)),
              ],
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
                  dateTo.text = result.toString();
                  widget.listRPLayout[index].selectValue = new ReportFieldLookupResponseData(code: dateTo.text, name: dateTo.text,);
                  widget.listRPLayout[index].c  = true;
                  return null;
                },
                onSaved: (val) => print(val),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget filterLookup(BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Container(
        height: 40,
        child: Column(
          children: [
            Visibility(
              visible: widget.listRPLayout[index].selectValue != null ||
              widget.listRPLayout[index].defaultValue != null,
              child: Row(
                children: [
                  Text('${widget.listRPLayout[index].name}',style: TextStyle(color: widget.listRPLayout[index].isNull == false? Colors.red : Colors.grey,fontSize: 11),),
                  SizedBox(width: 4,),
                  Visibility(
                      visible: widget.listRPLayout[index].isNull == false ,
                      child: Text('*',style: TextStyle(fontSize: 11,color: Colors.red),)),
                ],
              ),
            ),
            Stack(
              children: [
                TextFieldWidget2(
                  isEnable: true,
                  textInputAction: TextInputAction.done,
                  controller: TextEditingController(),
                  isNull : widget.listRPLayout[index].isNull ,
                  color: widget.listRPLayout[index].selectValue != null ? black : Colors.grey,
                  onChanged: (text){
                    widget.listRPLayout[index].listItemPush = text;
                    print(widget.listRPLayout[index].listItemPush);
                  },
                  labelText: widget.listRPLayout[index].selectValue != null ? null
                      : (
                      widget.listRPLayout[index].defaultValue != null
                          ? widget.listRPLayout[index].defaultValue :  widget.listRPLayout[index].name),

                ),
                Positioned(
                    top: 0,right: 0,bottom: 1,
                    child: Container(
                      height: 50,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8)
                      ),
                      child: InkWell(
                          onTap: (){
                            showDialog(
                                context: context,
                                builder: (context) => OptionReportFilter(controller: widget.listRPLayout[index].controller!,
                                  listItem: widget.listRPLayout[index].listItemPush != null
                                      ?
                                  widget.listRPLayout[index].listItemPush.toString() : '',show: true,)).then((value) {//listItem: widget.listRPLayout[index].selectValue.code
                              if (!Utils.isEmpty(value)) {
                                setState(() {
                                  List<String> geek = <String>[];
                                  widget.listRPLayout[index].listItem = value;
                                  widget.listRPLayout[index].listItem?.forEach((element) {
                                    ///sau co sửa code hay name thì tuỳ
                                    geek.add(element.code.toString());
                                  });
                                  String geek2 = geek.join(",");
                                  widget.listRPLayout[index].textEditingController = TextEditingController();
                                  widget.listRPLayout[index].textEditingController?.text = geek2;
                                  widget.listRPLayout[index].listItemPush = geek2;
                                  widget.listRPLayout[index].selectValue = new ReportFieldLookupResponseData(code: geek2, name: '',);
                                  // widget.listRPLayout[index].listItem = value;
                                  widget.listRPLayout[index].c = true;
                                  print('valueSelect = ${widget.listRPLayout[index].selectValue?.name}');
                                });
                              }
                            });
                          },
                          child: Icon(Icons.search)),
                    )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget filterAutoComplete(BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Container(
        height: 45,
        child: Column(
          children: [
            Visibility(
              visible: widget.listRPLayout[index].selectValue != null || widget.listRPLayout[index].defaultValue != null,
              child: Row(
                children: [
                  Text('${widget.listRPLayout[index].name}',style: TextStyle(color: widget.listRPLayout[index].isNull == false? Colors.red : Colors.grey,fontSize: 11),),
                  SizedBox(width: 4,),
                  Visibility(
                      visible: widget.listRPLayout[index].isNull == false ,
                      child: Text('*',style: TextStyle(fontSize: 11,color: Colors.red),)),
                ],
              ),
            ),
            Stack(
              children: [
                TextFieldWidget2(
                  isEnable: true,
                  textInputAction: TextInputAction.done,
                  isNull : widget.listRPLayout[index].isNull ,
                  color: widget.listRPLayout[index].selectValue != null ? black : Colors.grey,
                  controller: TextEditingController(),
                  onChanged: (text){
                    widget.listRPLayout[index].textEditingController = TextEditingController();
                    widget.listRPLayout[index].textEditingController?.text = text!;
                  },
                  labelText: widget.listRPLayout[index].selectValue != null ?
                  null
                      : (widget.listRPLayout[index].defaultValue != null ? widget.listRPLayout[index].defaultValue :  widget.listRPLayout[index].name),
                ),
                Positioned(
                    top: 0,right: 0,bottom: 1,
                    child: Container(
                      height: 50,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8)
                      ),
                      child: InkWell(
                          onTap: (){
                            showDialog(
                                context: context,
                                builder: (context) => OptionReportFilter(controller: widget.listRPLayout[index].controller!,show: false, listItem: '',)).then((value) {
                              if (!Utils.isEmpty(value)) {
                                setState(() {
                                  widget.listRPLayout[index].textEditingController = TextEditingController();
                                  widget.listRPLayout[index].textEditingController?.text =  value[0].toString().trim() + ' ( ${value[1].toString().trim()} )';
                                  widget.listRPLayout[index].selectValue = new ReportFieldLookupResponseData(code: value[0].toString(), name: value[1].toString(),);
                                  widget.listRPLayout[index].c = true;
                                });
                              }
                            });
                          },
                          child: Icon(Icons.search)),
                    )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget textInput(BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Container(
        height: 45,
        child: Column(
          children: [
            Visibility(
              visible: widget.listRPLayout[index].selectValue != null || widget.listRPLayout[index].defaultValue != null,
              child: Row(
                children: [
                  Text('${widget.listRPLayout[index].name}',style: TextStyle(color: widget.listRPLayout[index].isNull == false? Colors.red : Colors.grey,fontSize: 13),),
                  SizedBox(width: 4,),
                  Visibility(
                      visible: widget.listRPLayout[index].isNull == false ,
                      child: Text('*',style: TextStyle(fontSize: 12,color: Colors.red),)),
                ],
              ),
            ),
            Stack(
              children: [
                TextFieldWidget2(
                  isEnable: true,
                  controller: TextEditingController(),
                  isNull : widget.listRPLayout[index].isNull ,
                  color: widget.listRPLayout[index].selectValue != null ? black : (widget.listRPLayout[index].defaultValue != null ? Colors.grey : Colors.black) ,//,
                  hintText: (widget.listRPLayout[index].defaultValue != null ? widget.listRPLayout[index].defaultValue : widget.listRPLayout[index].name),
                  onChanged: (text){
                    widget.listRPLayout[index].selectValue = new ReportFieldLookupResponseData(code: text, name: text,);
                    widget.listRPLayout[index].c = true;
                  },
                ),
                Positioned(
                    top: 0,right: 0,bottom: 0,
                    child: Container(
                      height: 50,
                      width: 40,
                    )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget numberInput(BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Container(
        height: 45,
        child: Column(
          children: [
            Visibility(
              visible: widget.listRPLayout[index].selectValue != null || widget.listRPLayout[index].defaultValue != null,
              child: Row(
                children: [
                  Text('${widget.listRPLayout[index].name}',style: TextStyle(color: widget.listRPLayout[index].isNull == false? Colors.red : Colors.grey,fontSize: 13),),
                  SizedBox(width: 4,),
                  Visibility(
                      visible: widget.listRPLayout[index].isNull == false ,
                      child: Text('*',style: TextStyle(fontSize: 12,color: Colors.red),)),
                ],
              ),
            ),
            Stack(
              children: [
                TextFieldWidget2(
                  isEnable: true,
                  controller: TextEditingController(),
                  isNull : widget.listRPLayout[index].isNull ,
                  color: widget.listRPLayout[index].selectValue != null ? black : widget.listRPLayout[index].defaultValue != null ? Colors.grey : Colors.black ,
                  hintText: (widget.listRPLayout[index].defaultValue != null ? widget.listRPLayout[index].defaultValue : widget.listRPLayout[index].name),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.phone,
                  inputFormatter: [Const.FORMAT_DECIMA_NUMBER],
                  onChanged: (text){
                    widget.listRPLayout[index].selectValue = new ReportFieldLookupResponseData(code: text, name: text,);
                    widget.listRPLayout[index].c = true;
                  },
                ),
                Positioned(
                    top: 0,right: 0,bottom: 0,
                    child: Container(
                      height: 50,
                      width: 40,
                    )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget textInput2(BuildContext context, int index) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(top: 25),
        child: Container(
          height: 40,
          width: double.infinity,
          child: Column(
            children: [
              Visibility(
                visible: widget.listRPLayout[index].selectValue != null,
                child: Row(
                  children: [
                    Text('${widget.listRPLayout[index].name}',style: TextStyle(color: widget.listRPLayout[index].isNull == false? Colors.red : Colors.grey,fontSize: 11),),
                    SizedBox(width: 4,),
                    Visibility(
                        visible: widget.listRPLayout[index].isNull == false ,
                        child: Text('*',style: TextStyle(fontSize: 11,color: Colors.red),)),
                  ],
                ),
              ),
              Stack(
                children: [
                  TextFieldWidget2(
                    controller: TextEditingController(),
                    //errorText: (widget.listRPLayout[index].c  == true ? null : 'Không được để trống'),
                    isEnable: true,
                    hintText: widget.listRPLayout[index].name! + (widget.listRPLayout[index].isNull == false? '  *' : ''),
                    isNull : widget.listRPLayout[index].isNull ,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    onChanged: (text){
                      widget.listRPLayout[index].selectValue = new ReportFieldLookupResponseData(code: text.toString(), name: text.toString(),);
                      widget.listRPLayout[index].c = true;
                    },
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget numberInput2(BuildContext context, String hintTitle,int index) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Container(
        height: 40,
        child: TextFieldWidget(
          readOnly: false,
          controller: TextEditingController(),
          errorText: widget.listRPLayout[index].isNull == false? (widget.listRPLayout[index].selectValue != null ? '' : 'Úi, Đại Vương dữ liệu trống!!!') : null,
          hintText: hintTitle,
          isEnable: true,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.phone,
          inputFormatters: [Const.FORMAT_DECIMA_NUMBER],
          onChanged: (text){
            widget.listRPLayout[index].selectValue = new ReportFieldLookupResponseData(code: text.toString(), name: text.toString(),);
            widget.listRPLayout[index].c = true;
          },
        ),
      ),
    );
  }

  Widget button(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20,right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 120.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.0), color: grey),
                  child: Center(
                    child: Text(
                      'Huỷ',
                      style: TextStyle(
                        fontSize: 13,
                        color: white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  List list = [];
                  bool isEmpty = true;
                  for(int i = 0; i <= widget.listRPLayout.length-1; i++){
                    list.add(ReportResultResponseData(
                        field: widget.listRPLayout[i].field,
                        value: widget.listRPLayout[i].selectValue != null
                            ? widget.listRPLayout[i].selectValue?.code : (widget.listRPLayout[i].defaultValue != null ? widget.listRPLayout[i].defaultValue : '')));
                    if(widget.listRPLayout[i].defaultValue != null){
                      widget.listRPLayout[i].isNull = true;
                    }
                    if(widget.listRPLayout[i].c == false && widget.listRPLayout[i].isNull == false){
                      isEmpty = false;
                    }
                  }
                  if(isEmpty == true){
                    if(!Utils.isEmpty(widget.idReport)){
                      ///ResultReportPage
                      pushNewScreen(context, screen: ResultReportScreen(
                        idReport: widget.idReport,listRequestValue: list,title: widget.title,
                      ),withNavBar: true);
                    }else{
                      widget.listRPLayout.clear();
                      Navigator.pop(context,[list]);
                    }
                  }else{
                    Utils.showCustomToast(context, Icons.warning_amber_outlined, 'Úi, Nhập thiếu thông tin rồi Đại Vương!');
                  }
                },
                child: Container(
                  width: 120.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.0), color: orange),
                  child: Center(
                    child: Text(
                      Utils.isEmpty(widget.idReport) ? 'Lọc' :
                      'Tiếp tục',
                      style: TextStyle(
                        fontSize: 13,
                        color: white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
