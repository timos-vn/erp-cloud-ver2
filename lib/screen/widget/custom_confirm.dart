import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

import 'package:sse/themes/colors.dart';
import 'package:sse/utils/const.dart';
import 'package:sse/utils/utils.dart';

class CustomConfirm extends StatefulWidget {
  final String? title;
  final String? content;
  final int? type;

  const CustomConfirm({Key? key, this.title, this.content, this.type}) : super(key: key);
  @override
  _CustomConfirmState createState() => _CustomConfirmState();
}

class _CustomConfirmState extends State<CustomConfirm> {
  TextEditingController contentController = TextEditingController();
  int groupValue = 0;
  FocusNode focusNodeContent = FocusNode();
  String date = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    date = '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Container(
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16))),
              height: 280,
              width: double.infinity,
              child: Material(
                  animationDuration: const Duration(seconds: 3),
                  borderRadius:const BorderRadius.all(Radius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15,),
                        Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(40)),
                              color: subColor,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.grey.shade200,
                                    offset: const Offset(2, 4),
                                    blurRadius: 5,
                                    spreadRadius: 2)
                              ],),
                            child:const Icon(Icons.warning_amber_outlined ,size: 50,color: Colors.white,)),
                        const SizedBox(height: 10,),
                        Flexible(child: Text(widget.title.toString(),style:  TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: subColor),maxLines: 2,overflow: TextOverflow.ellipsis,)),
                        const SizedBox(height: 7,),

                        Container(
                          padding: EdgeInsets.only(right: 10),
                          height: 30,
                          width: double.infinity,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Text('Ngày tạo phiếu: ',style: const TextStyle(color: Colors.blueGrey,fontSize: 12),textAlign: TextAlign.center,),
                                    const SizedBox(width: 5,),
                                    Text(date,style: const TextStyle(color: Colors.blueGrey,fontSize: 12),textAlign: TextAlign.center,maxLines: 1,overflow: TextOverflow.ellipsis,),
                                  ],
                                ),
                                Container(
                                  // height: 40,
                                  width: 50,
                                  child: DateTimePicker(
                                    type: DateTimePickerType.date,
                                    dateMask: 'd MMM, yyyy',
                                    initialValue: DateTime.now().toString(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                    decoration: InputDecoration(
                                      suffixIcon: Icon(Icons.event,color: Colors.red,size: 22,),
                                      contentPadding: EdgeInsets.only(left: 12),
                                      border: InputBorder.none,
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
                                      DateTime? dateOrder = result as DateTime?;
                                      setState(() {
                                        date = Utils.parseDateToString(dateOrder!, Const.DATE_FORMAT_1);
                                      });
                                      return null;
                                    },
                                    onSaved: (val) => print(val),
                                  ),
                                ),
                                // const SizedBox(width: 5,),
                              ]),
                        ),
                        GestureDetector(
                          onTap: () => FocusScope.of(context).requestFocus(focusNodeContent),
                          child: Container(
                            height: 30,
                            padding: EdgeInsets.only(left: 2),
                            decoration: BoxDecoration(

                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            child: TextField(
                              maxLines: 1,
                              autofocus: true,
                              // obscureText: true,
                              controller: contentController,
                              decoration: new InputDecoration(
                                hintText: 'Nhập ghi chú',
                                hintStyle: TextStyle( color: Colors.grey,fontSize: 12),
                              ),
                              // focusNode: focusNodeContent,
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 12),

                              //textInputAction: TextInputAction.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 22,),
                        _submitButton(context),
                      ],
                    ),
                  )),
            ),
          ),
        ));
  }
  Widget _submitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0,right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: ()=>Navigator.pop(context,['Back']),
            child: Container(
              width: 130,
              padding: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                color: Colors.grey,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.shade200,
                      offset: const Offset(2, 4),
                      blurRadius: 5,
                      spreadRadius: 2)
                ],
              ),
              child: const Text( 'Huỷ',
                style: TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 15,),
          GestureDetector(
            onTap: (){
              // print(Utils.parseStringToDate('2022-12-12', Const.DATE_SV_FORMAT));
              Navigator.pop(context,['confirm',Utils.parseStringToDate(date, Const.DATE_SV_FORMAT).toString(),contentController.text]);
            },
            child: Container(
              width: 130,
              padding: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.shade200,
                        offset: const Offset(2, 4),
                        blurRadius: 5,
                        spreadRadius: 2)
                  ],
                  gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xfffbb448), Color(0xfff7892b)])),
              child: const Text( 'Xác nhận',
                style: TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



