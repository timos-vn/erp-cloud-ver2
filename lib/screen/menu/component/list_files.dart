import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sse/screen/menu/component/view_files.dart';
import 'package:sse/themes/colors.dart';

import '../../../model/network/response/get_html_approval_response.dart';

class ListFilesPage extends StatefulWidget {
  final List<ListValuesFilesView>? listImage;

  const ListFilesPage({Key? key, this.listImage}) : super(key: key);
  @override
  _ListFilesPageState createState() => _ListFilesPageState();
}

class _ListFilesPageState extends State<ListFilesPage> {
  TextEditingController contentController = TextEditingController();
  int groupValue = 0;
  FocusNode focusNodeContent = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16))),
              height: MediaQuery.of(context).size.height/2,
              width: double.infinity,
              child: Material(
                  animationDuration: Duration(seconds: 3),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10,),
                      Text('Click để xem Files',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 13),),
                      const SizedBox(height: 10,),
                      Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.only(left: 12,right: 12,bottom: 5),
                            itemBuilder: (context, index){
                              return Padding(
                                padding: const EdgeInsets.only(top: 10,bottom: 10),
                                child: InkWell(
                                    onTap: ()=> pushNewScreen(context, screen: ViewFilesPage(imageData: widget.listImage?[index].fileData,)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(child: Text('${widget.listImage?[index].fileName}',style: TextStyle(color: black),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                        Icon(Icons.remove_red_eye_outlined,color: Colors.blueGrey,size: 20,),
                                      ],
                                    )),
                              );
                            },
                            physics: AlwaysScrollableScrollPhysics(),
                            separatorBuilder: (BuildContext context, int index) {
                              return Container(
                                child: Divider(
                                  height: 0.5,
                                  thickness: 1,
                                ),
                              );
                            },
                            shrinkWrap: true,
                            itemCount: widget.listImage!.length
                        ),
                      ),
                      SizedBox(height: 30,),
                      _submitButton(context),
                    ],
                  )),
            ),
          ),
        ));
  }
  Widget _submitButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
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
                  colors: [Colors.blueGrey, Colors.blueGrey])),
          child: Text(
            'Đóng',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}



