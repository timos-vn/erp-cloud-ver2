import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sse/screen/menu/menu_bloc.dart';
import 'package:sse/utils/images.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../themes/colors.dart';
import '../../../utils/utils.dart';
import '../../widget/register_use.dart';
import '../menu_state.dart';

class DetailHelpCenterScreen extends StatefulWidget {
  const DetailHelpCenterScreen({Key? key}) : super(key: key);

  @override
  _DetailHelpCenterScreenState createState() => _DetailHelpCenterScreenState();
}

class _DetailHelpCenterScreenState extends State<DetailHelpCenterScreen> with TickerProviderStateMixin  {

  late MenuBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = MenuBloc(context);
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<MenuBloc,MenuState>(
        bloc: _bloc,
        listener: (context,state){

        },
        child: BlocBuilder<MenuBloc,MenuState>(
          bloc: _bloc,
          builder: (BuildContext context, MenuState state){
            return buildBody(context,state);
          },
        ),
      ),
    );
  }

  buildBody(BuildContext context,MenuState state){
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.grey.withOpacity(0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildAppBar(),
          const SizedBox(height: 12,),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 12,right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6),color: Colors.white,),
                      padding: const EdgeInsets.all(16),
                      child: buildSupport(),
                    ),
                    Container(
                      height: 18,
                      width: double.infinity,
                    ),
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6),color: Colors.white,),
                      padding: const EdgeInsets.all(16),
                      child: buildRequestProblem(),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  buildSupport(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text('X??? l?? l???i ???ng d???ng',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
        const SizedBox(height:18,),
        Text('N???u b???n kh??ng th??? m??? ???ng d???ng, ???ng d???ng b??? treo, tho??t ra ?????t ng???t ho???c xu???t hi???n th??ng b??o l???i, b???n c?? th??? th???c hi???n nh???ng b?????c sau: ',
          style: TextStyle(color: Colors.black.withOpacity(0.7),fontSize: 14,height: 1.5),),
        const SizedBox(height: 22,),
        Text('1. Ki???m tra k???t n???i m???ng',
          style: TextStyle(color: Colors.black.withOpacity(0.7),fontSize: 14),),
        const SizedBox(height: 8,),
        Text('M??? tr??nh duy???t internet v?? th??? truy c???p trang www.google.com. N???u kh??ng th??? truy c???p ???????c, b???n c?? th??? ??ang g???p v???n ????? v??? k???t n???i m???ng. B???n c?? th??? ki???m tra h?????ng d???n s??? d???ng thi???t b??? c???a m??nh ho???c nh?? m???ng ????? kh??i ph???c l???i k???t n???i tr?????c khi th??? m??? l???i ???ng d???ng SSE-Cloud.',
          style: TextStyle(color: Colors.black.withOpacity(0.7),fontSize: 14,height: 1.5),),
        const SizedBox(height: 16,),
        Text('2. C???p nh???t ???ng d???ng l??n phi??n b???n m???i nh???t',
          style: TextStyle(color: Colors.black.withOpacity(0.7),fontSize: 14),),
        const SizedBox(height: 16,),
        Text('3. Tho??t ???ng d???ng & kh???i ?????ng l???i',
          style: TextStyle(color: Colors.black.withOpacity(0.7),fontSize: 14),),
        const SizedBox(height: 16,),
        Text('4. Xo?? ???ng d???ng & c??i ?????t l???i',
          style: TextStyle(color: Colors.black.withOpacity(0.7),fontSize: 14),),
        const SizedBox(height: 22,),
        Text('Trong tr?????ng h???p b???n ???? th??? c??c b?????c h?????ng d???n tr??n nh??ng ???ng d???ng v???n kh??ng kh???c ph???c l???i, vui l??ng G???i b??o c??o ????? SSE h??? tr??? b???n k???p th???i.',
          style: TextStyle(color: Colors.black.withOpacity(0.7),fontSize: 14,height: 1.5),),
      ],
    );
  }

  buildRequestProblem(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text('Y??u c???u tr??? gi??p v??? v???n ????? n??y',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
        const SizedBox(height:8,),
        const Divider(),
        InkWell(
          onTap: ()=>FlutterEmailSender.send(Email(recipients: ['supports@sse.net.vn'],cc: ['sse.supports.10@gmail.com'],subject: 'H??? tr??? l???i ???ng d???ng')),
          child: Row(
            children: [
              Icon(Icons.mail_outline,color: Colors.red,size: 22,),
              const SizedBox(width: 10,),
              Flexible(child: Text('G???i b??o c??o',style: TextStyle(color: Colors.black,fontSize: 13.5),)),
            ],
          ),
        ),
      ],
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
                'Trung T??m Tr??? gi??p',
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.white,),
                maxLines: 1,overflow: TextOverflow.fade,
              ),
            ),
          ),
          Container(
            height: 45,
            width: 40,
            child: Icon(Icons.how_to_reg,color: Colors.transparent,),
          )
        ],
      ),
    );
  }
}
