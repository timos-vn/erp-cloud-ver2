import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputQuantityShipping extends StatefulWidget {
  final int? quantity;
  final String? title;
  final String? desc;
  const InputQuantityShipping({Key? key,this.quantity,this.title,this.desc}) : super(key: key);

  @override
  _InputQuantityShippingState createState() => _InputQuantityShippingState();
}

class _InputQuantityShippingState extends State<InputQuantityShipping> {

  TextEditingController contentController = TextEditingController();

  FocusNode focusNodeContent = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //contentController.text = widget.quantity.toString();
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
                                        widget.title??'',
                                        style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      InkWell(
                                        onTap: ()=> Navigator.pop(context),
                                        child: Icon(Icons.clear,color: Colors.black,),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    widget.desc??'',
                                    style: TextStyle(color: Colors.blueGrey, fontSize: 12, fontWeight: FontWeight.normal),
                                  ),
                                  SizedBox(height: 8,),
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
                                            hintText: widget.desc??'',
                                            hintStyle: TextStyle( color: Colors.grey),
                                          ),
                                          // focusNode: focusNodeContent,
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(fontSize: 13),
                                          //textInputAction: TextInputAction.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        child: Container(
                          width: double.infinity,
                          color: Colors.orange,
                          child: FlatButton(
                            child: Text('Xong',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),),
                            color: Colors.orange,
                            onPressed: (){
                              Navigator.pop(context,contentController.text);
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                    ],
                  )),
            ),
          ],
        ));
  }
}
