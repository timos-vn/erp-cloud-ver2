import 'package:flutter/material.dart';
import 'package:sse/themes/colors.dart';

class ConfirmTypePayment extends StatefulWidget {
  final String? title;
  final String? content;
  final int? type;

  const ConfirmTypePayment({Key? key, this.title, this.content, this.type}) : super(key: key);
  @override
  _ConfirmSuccessPageState createState() => _ConfirmSuccessPageState();
}

class _ConfirmSuccessPageState extends State<ConfirmTypePayment> {
  TextEditingController contentController = TextEditingController();
  int groupValue = 0;
  FocusNode focusNodeContent = FocusNode();

  bool typeMoney = false;
  bool typeDebt = false;

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
                        const SizedBox(height: 20,),
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
                        const SizedBox(height: 15,),
                        Flexible(child: Text(widget.title.toString(),style:  TextStyle(fontWeight: FontWeight.w600,fontSize: 18,color: subColor),maxLines: 2,overflow: TextOverflow.ellipsis,)),
                        const SizedBox(height: 7,),
                        Text(widget.content.toString(),style: const TextStyle(color: Colors.blueGrey,fontSize: 12),textAlign: TextAlign.center,),
                        const SizedBox(height: 12,),
                        Container(
                          height: 30,
                          width: double.infinity,
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: InkWell(
                                    onTap: (){
                                      setState(() {
                                        if(typeDebt == true){
                                          typeDebt = false;
                                        }else if(typeDebt == false){
                                          typeDebt = true;
                                          typeMoney = false;
                                        }
                                      });
                                    },
                                    child: checkbox(
                                        title: "Công nợ",
                                        initValue: typeDebt,
                                        onChanged: (sts) {
                                          setState(() {
                                            if(typeDebt == true){
                                              typeDebt = false;
                                            }else if(typeDebt == false){
                                              typeDebt = true;
                                              typeMoney = false;
                                            }
                                          });
                                        }
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        if(typeMoney == true){
                                          typeMoney = false;
                                        }else if(typeMoney == false){
                                          typeMoney = true;
                                          typeDebt = false;
                                        }
                                      });
                                    },
                                    child: checkbox(
                                        title: "Tiền mặt",
                                        initValue: typeMoney,
                                        onChanged: (sts){
                                          setState(() {
                                            if(typeMoney == true){
                                              typeMoney = false;
                                            }else if(typeMoney == false){
                                              typeMoney = true;
                                              typeDebt = false;
                                            }
                                          });
                                        },
                                    )
                                  ),
                                ),
                              ]),
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
            onTap: ()=>Navigator.pop(context,['Cancel']),
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
            onTap: ()=>Navigator.pop(context,['confirm',typeMoney,typeDebt]),
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

  Widget checkbox({String? title, bool? initValue, Function(bool boolValue)? onChanged}) {
    return Container(
      //width: 170,color: red,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Checkbox(value: initValue, onChanged: (b) => onChanged!(b!),activeColor: Colors.orange,),
            Text(title!),
          ]),
    );
  }
}



