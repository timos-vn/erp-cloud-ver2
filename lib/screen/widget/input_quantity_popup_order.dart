import 'package:flutter/material.dart';
import 'package:sse/themes/colors.dart';
import 'package:sse/utils/const.dart';
import 'package:sse/utils/utils.dart';

class InputQuantityPopupOrder extends StatefulWidget {
  final double quantity;
  final List<String> listDvt;
  final bool? allowDvt;
  const InputQuantityPopupOrder({Key? key,required this.quantity, required this.listDvt, required this.allowDvt}) : super(key: key);

  @override
  _InputQuantityPopupOrderState createState() => _InputQuantityPopupOrderState();
}

class _InputQuantityPopupOrderState extends State<InputQuantityPopupOrder> {

  late TextEditingController contentController;

  FocusNode focusNodeContent = FocusNode();

  double valueInput = 0;

  String unitOfCalculation = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    contentController = new TextEditingController();
    if(widget.listDvt.isNotEmpty){
      unitOfCalculation = widget.listDvt[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.white,),
              height: 180,
              width: double.infinity,
              child: Material(
                  animationDuration: Duration(seconds: 3),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  child: Column(
                    children: [
                      Expanded(
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16))),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                       'Vui lòng nhập số lượng',
                                        style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      InkWell(
                                        onTap: ()=> Navigator.pop(context,['0','Close']),
                                        child: Icon(Icons.clear,color: Colors.black,),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => FocusScope.of(context).requestFocus(focusNodeContent),
                                            child: Container(
                                              // height: 100,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                              ),
                                              child: TextField(
                                                maxLines: 1,
                                                autofocus: true,
                                                // obscureText: true,
                                                controller: contentController,
                                                decoration: new InputDecoration(
                                                  hintText: '0',
                                                  hintStyle: TextStyle( color: Colors.grey),
                                                ),
                                                // focusNode: focusNodeContent,
                                                keyboardType: TextInputType.number,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(fontSize: 13),
                                                onChanged: (text){
                                                  valueInput = double.parse(text);
                                                  print(valueInput);
                                                },
                                                //textInputAction: TextInputAction.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: widget.allowDvt == true,
                                          child: Container(
                                              width: 70,
                                              child: genderUnitOfCalculation()),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: TextButton(
                          onPressed: (){
                            if(valueInput > 0){
                              if(Const.inStockCheck == false){
                                if(valueInput < widget.quantity){
                                  Navigator.pop(context,[valueInput,unitOfCalculation]);
                                }else{
                                  Utils.showCustomToast(context, Icons.warning_amber_outlined, 'Vượt quá số lượng hiện có');
                                }
                              }else if(Const.inStockCheck == true){
                                Navigator.pop(context,[valueInput,unitOfCalculation]);
                              }
                            }else{
                              Utils.showCustomToast(context, Icons.warning_amber_outlined, 'Vui lòng nhập số liệu!');
                            }
                          },
                          child: Container(
                            height: 45,
                            padding: const EdgeInsets.only(right: 20, left: 20),
                            decoration: BoxDecoration(color: Colors.orange,),
                            child: Center(
                              child: Text(
                                'Xong',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15,),
                    ],
                  )),
            ),
          ],
        ));
  }

  Widget genderUnitOfCalculation() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
          isDense: true,
          isExpanded: true,
          style: TextStyle(
            color: black,
            fontSize: 12.0,
          ),
          value: unitOfCalculation,
          items: widget.listDvt.map((value) => DropdownMenuItem<String>(
            child: Align(
                alignment: Alignment.center,
                child: Text(value.toString(), style: TextStyle(fontSize: 13.0, color: blue.withOpacity(0.6)),)),
            value: value,
          )).toList(),
          onChanged: (value) {
            setState(() {
              unitOfCalculation = value!;
            });
            focusNodeContent.requestFocus();
          }),
    );
  }
}
