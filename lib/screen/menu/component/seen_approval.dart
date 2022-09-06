import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:sse/screen/widget/custom_confirm.dart';
import 'package:sse/utils/utils.dart';

import '../../../model/network/response/get_html_approval_response.dart';
import '../../../themes/colors.dart';
import '../../widget/pending_action.dart';
import '../approval/detail_approval/detail_approval_bloc.dart';
import '../approval/detail_approval/detail_approval_event.dart';
import '../approval/detail_approval/detail_approval_state.dart';
import 'list_files.dart';

class SeenApproval extends StatefulWidget {
  final String tile;
  final String idApproval;
  final String sttRec;
  final int status;
  const SeenApproval({Key? key,required this.tile,required this.idApproval, required this.sttRec, required this.status}) : super(key: key);

  @override
  _SeenApprovalState createState() => _SeenApprovalState();
}

class _SeenApprovalState extends State<SeenApproval> {

  late DetailApprovalBloc _bloc;
  String? _htmlDetailApproval;
  List<ListValuesFilesView> listImage=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = DetailApprovalBloc(context);
    _bloc.add(GetPrefsDetailApproval());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: !Utils.isEmpty(listImage) ? Padding(
          padding: const EdgeInsets.only(bottom: 55),
          child: FloatingActionButton(
            child: Icon(Icons.attach_file,color: Colors.white,),
            backgroundColor: Colors.orange,
            onPressed: ()async{
              showDialog(
                  context: context,
                  builder: (context) {
                    return WillPopScope(
                      onWillPop: () async => false,
                      child: ListFilesPage(
                        listImage: _bloc.listImage,
                      ),
                    );
                  });
            },
          ),
        ) : Container(),
      body: BlocListener<DetailApprovalBloc,DetailApprovalState>(
        bloc: _bloc,
        listener: (context, state){
          if(state is GetPrefsSuccess){
            _bloc.add(SeenApprovalEvent(sttRec: widget.sttRec));
          }
          else if(state is GetHTMLApprovalSuccess){
            _htmlDetailApproval = state.htmlDetailApproval;
            listImage = state.listImage;
          }else if(state is DetailApprovalFailure){
            Utils.showCustomToast(context, Icons.warning_amber_outlined, 'Úi, ${state.error}');
          }
          else if (state is AcceptDetailApprovalSuccess) {
            Utils.showCustomToast(context, Icons.check_circle_outline, 'Yeah, Duyệt phiếu thành công');
            Navigator.pop(context,['Reload']);
          }
        },
        child: BlocBuilder(
          bloc: _bloc,
          builder: (BuildContext context, DetailApprovalState state){
            return Stack(
              children: [
                buildBody(context, state),
                Visibility(
                  visible: state is GetHTMLApprovalFail,
                  child:  Center(
                    child: Text('Úi, Đại Vương gặp Bug rồi!!!',style: TextStyle(color: Colors.blueGrey)),
                  ),
                ),
                Visibility(
                  visible: state is DetailApprovalLoading,
                  child: PendingAction(),
                )
              ],
            );
          },
        ),
      )
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
            onTap: ()=> Navigator.pop(context,['Back']),
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
                "${widget.tile.toString()}",
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

  buildBody(BuildContext context,DetailApprovalState state){
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          buildAppBar(),
          Expanded(
            child: Container(
              height: double.infinity,width: double.infinity,
              padding: EdgeInsets.only(bottom: 60),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: _htmlDetailApproval != null ? HtmlWidget(_htmlDetailApproval.toString()) : Container(),
                      ),
                    ),
                  ),
                  buildButton()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildButton(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 16),
      child: Row(
        children: [
          InkWell(
            onTap: ()async{
              showDialog(
                  context: context,
                  builder: (context) {
                    return WillPopScope(
                      onWillPop: () async => false,
                      child: CustomConfirm(
                        title: 'Bạn đang thực hiện Duyệt phiếu!',
                        content: 'Hãy chắc chắn là bạn muốn duyệt phiếu này!',
                        type: 0,
                      ),
                    );
                  }).then((value) {
                if(!Utils.isEmpty(value) && value[0] == 'confirm'){
                  if(!Utils.isEmpty(value[2])){
                    _bloc.add(AcceptDetailApprovalEvent(actionType: 1,idApproval: widget.idApproval,note: value[2],sttRec: widget.sttRec));
                  }else{
                    Utils.showCustomToast(context, Icons.warning_amber_outlined, 'Úi, Bạn đã hãy nhập lý do đi.');
                  }
                }
              });
            },
            child: Row(
              children: [
                Icon(Icons.check,color: Colors.blue,size: 20),
                SizedBox(width: 5,),
                Text('Duyệt',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w600),),
              ],
            ),
          ),
          SizedBox(width: 25,),
          InkWell(
            onTap: ()async{
              showDialog(
                  context: context,
                  builder: (context) {
                    return WillPopScope(
                      onWillPop: () async => false,
                      child: CustomConfirm(
                        title: 'Bạn đang thực hiện Huỷ phiếu!',
                        content: 'Hãy chắc chắn là bạn muốn Huỷ phiếu này!',
                        type: 0,
                      ),
                    );
                  }).then((value) {
                if(!Utils.isEmpty(value) && value[0] == 'confirm'){
                  if(!Utils.isEmpty(value[2])){
                    _bloc.add(AcceptDetailApprovalEvent(actionType: 3,idApproval: widget.idApproval,note: value[2],sttRec: widget.sttRec));
                  }else{
                    Utils.showCustomToast(context, Icons.warning_amber_outlined, 'Úi, Bạn đã hãy nhập lý do đi.');
                  }
                }
              });
            },
            child: Row(
              children: [
                Icon(Icons.close,color: Colors.blue,size: 20,),
                SizedBox(width: 5,),
                Text('Huỷ',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w600),),
              ],
            ),
          ),
          SizedBox(width: 25,),
          InkWell(
            onTap: ()async{
              showDialog(
                  context: context,
                  builder: (context) {
                    return WillPopScope(
                      onWillPop: () async => false,
                      child: CustomConfirm(
                        title: 'Bạn đang thực hiện Bỏ duyệt phiếu!',
                        content: 'Hãy chắc chắn là bạn muốn Bỏ duyệt phiếu này!',
                        type: 0,
                      ),
                    );
                  }).then((value) {
                if(!Utils.isEmpty(value) && value[0] == 'confirm'){
                  if(!Utils.isEmpty(value[2])){
                    _bloc.add(AcceptDetailApprovalEvent(actionType: 2,idApproval: widget.idApproval,note: value[2],sttRec: widget.sttRec));
                  }else{
                    Utils.showCustomToast(context, Icons.warning_amber_outlined, 'Úi, Bạn đã hãy nhập lý do đi.');
                  }
                }
              });
            },
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios_rounded,color: Colors.blue,size: 18),
                SizedBox(width: 5,),
                Text('Bỏ duyệt',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w600),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
