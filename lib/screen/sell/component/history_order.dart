import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:sse/screen/options_input/options_input_screen.dart';
import 'package:sse/screen/sell/cart/cart_screen.dart';
import 'package:sse/screen/sell/sell_bloc.dart';
import 'package:sse/screen/sell/sell_state.dart';
import 'package:sse/screen/sell/sell_event.dart';
import 'package:sse/screen/widget/pending_action.dart';
import 'package:sse/themes/colors.dart';
import 'package:sse/utils/const.dart';
import 'package:sse/utils/utils.dart';

class HistoryOrderScreen extends StatefulWidget {
  const HistoryOrderScreen({Key? key}) : super(key: key);

  @override
  _HistoryOrderScreenState createState() => _HistoryOrderScreenState();
}

class _HistoryOrderScreenState extends State<HistoryOrderScreen> with SingleTickerProviderStateMixin{

  late SellBloc _bloc;
  late ScrollController _scrollController;
  final _scrollThreshold = 200.0;
  bool _hasReachedMax = true;
  late PageController _pageController;

  int status = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = SellBloc(context);
    _bloc.dateFrom =  DateTime.now().add(Duration(days: -60));
    _bloc.dateTo =  DateTime.now();
    _bloc.add(GetPrefs());

    _scrollController = ScrollController();
    _pageController = PageController();
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScroll - currentScroll <= _scrollThreshold && !_hasReachedMax && _bloc.isScroll == true) {
        _bloc.add(GetListHistoryOrder(status: status,dateFrom: _bloc.dateFrom, dateTo: _bloc.dateTo,isLoadMore: true));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<SellBloc,SellState>(
        bloc: _bloc,
        listener: (context,state){
          if(state is GetPrefsSuccess){
            _bloc.add(GetListHistoryOrder(status: status,dateFrom: _bloc.dateFrom, dateTo: _bloc.dateTo));
          }
          else if(state is DeleteOrderSuccess){
            _bloc.add(GetListHistoryOrder(status: 0,dateFrom: _bloc.dateFrom, dateTo: _bloc.dateTo));
          }
          else if(state is ChangePageViewSuccess) {
            if (state.valueChange == 0) {
              _bloc.list.clear();
              _bloc.add(GetListHistoryOrder(status: 0,dateFrom: _bloc.dateFrom, dateTo: _bloc.dateTo));
              _pageController.animateToPage(
                  0, duration: Duration(milliseconds: 500), curve: Curves.ease);
            } else {
              _bloc.list.clear();
              _bloc.add(GetListHistoryOrder(status: 2,dateFrom: _bloc.dateFrom, dateTo: _bloc.dateTo));
              _pageController.animateToPage(
                  1, duration: Duration(milliseconds: 500), curve: Curves.ease);
            }
          }
          else if(state is SellFailure){
            Utils.showCustomToast(context, Icons.warning_amber_outlined, state.error);
          }
        },
        child: BlocBuilder(
          bloc: _bloc,
          builder: (BuildContext context, SellState state){
            return  Stack(
              children: [
                buildBody(context,state),
                Visibility(
                  visible: state is GetListHistoryOrderEmpty,
                  child: Center(
                    child: Text('Úi, Đại Vương dữ liệu trống'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  buildBody(BuildContext context,SellState state){
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          buildAppBar(),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 10,top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: (){
                    _bloc.add(ChangePageViewEvent(0));
                    status = 0;
                  },
                  child: Container(
                    height: 35,
                    padding: EdgeInsets.only(left: 15,right: 15,top: 6,bottom: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: _bloc.valueChange == 0 ? Colors.indigo :  Colors.grey.withOpacity(0.3)
                    ),
                    child: Center(child: Text('Lập chứng từ'.toUpperCase(),style: TextStyle(color: _bloc.valueChange == 0 ?  Colors.white : Colors.black,fontWeight: FontWeight.bold),)),
                  ),
                ),
                SizedBox(width: 10,),
                GestureDetector(
                  onTap: (){
                    _bloc.add(ChangePageViewEvent(2));
                    status = 2;
                  },
                  child: Container(
                    height: 35,
                    padding: EdgeInsets.only(left: 20,right: 20,top: 6,bottom: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: _bloc.valueChange == 2 ? Colors.indigo : Colors.grey.withOpacity(0.3)
                    ),
                    child: Center(child: Text('Hoàn thành'.toUpperCase(),style: TextStyle(color: _bloc.valueChange == 2 ?  Colors.white : Colors.black,fontWeight: FontWeight.bold),)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20*0.5,),
          Expanded(
            child: Stack(
              children: [
                PageView(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    _bloc.list.isEmpty ? Container() : buildOrder(context),
                    _bloc.list.isEmpty ? Container() : buildOrderSuccess(context),
                  ],
                ),
                Visibility(
                  visible: state is SellLoading,
                  child: PendingAction(),
                )
              ],
            ),
          ),
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
                "Lịch sử đặt hàng",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.white,),
                maxLines: 1,overflow: TextOverflow.fade,
              ),
            ),
          ),
          const SizedBox(width: 10,),
          InkWell(
            onTap: ()=>  showDialog(
                context: context,
                builder: (context) => OptionsFilterDate()).then((value){
              if(value != 'CANCEL'){
                _bloc.dateFrom =  Utils.parseStringToDate(value[3], Const.DATE_SV_FORMAT);
                _bloc.dateTo =  Utils.parseStringToDate(value[4], Const.DATE_SV_FORMAT);
                _bloc.add(GetListHistoryOrder(status: status,dateFrom: _bloc.dateFrom, dateTo: _bloc.dateTo));
              }else{
                print('Cancel');
                print(_pageController.page);
              }
            }),
            child: Container(
              width: 40,
              height: 50,
              child: Icon(
                Icons.event,
                size: 25,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildOrder(BuildContext context){
    return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: _bloc.list.length,
        itemBuilder: (BuildContext context, int index){
          return GestureDetector(
            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen(
                viewUpdateOrder: true,
                sttRec: _bloc.list[index].sttRec,
                viewDetail: false,
                title: _bloc.list[index].tenKh,
                phoneCustomer: _bloc.list[index].dienThoaiKH,
                addressCustomer: _bloc.list[index].diaChiKH,
                nameStore:  _bloc.list[index].nameStore,
                codeStore:  _bloc.list[index].codeStore,
                codeCustomer: _bloc.list[index].maKh,
            ))).then((value){
              if(value == Const.REFRESH){
                _bloc.add(GetListHistoryOrder(status: status,dateTo: _bloc.dateTo,dateFrom: _bloc.dateFrom));
              }
            }),
            child: Slidable(
              key: const ValueKey(2),
              endActionPane: ActionPane(
                motion: ScrollMotion(),
                dismissible: DismissiblePane(onDismissed: (){
                  _bloc.add(DeleteEvent(sttRec: _bloc.list[index].sttRec.toString()));
                }),
                children: [
                  SlidableAction(
                    onPressed:(_) {
                      _bloc.add(DeleteEvent(sttRec: _bloc.list[index].sttRec.toString()));
                    },
                    backgroundColor: Color(0xFF7BC043),
                    foregroundColor: Colors.white,
                    icon: Icons.archive,
                    label: 'Xoá',
                  ),
                ],
              ),
              child: Card(
                elevation: 10,
                shadowColor: Colors.blueGrey.withOpacity(0.5),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${_bloc.list[index].tenKh}', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 13),),
                                SizedBox(height: 3,),
                                Row(
                                  children: [
                                    Icon(Icons.phone_iphone_rounded,color: Colors.grey,size: 12,),
                                    SizedBox(width: 3,),
                                    Text('${_bloc.list[index].dienThoaiKH??'null'}', style: TextStyle(color: Colors.grey,fontSize: 12),),
                                  ],
                                ),
                                SizedBox(height: 3,),
                                Row(
                                  children: [
                                    Icon(Icons.location_on_outlined,color: Colors.grey,size: 12,),
                                    SizedBox(width: 3,),
                                    Expanded(child: Text('${_bloc.list[index].diaChiKH}', style: TextStyle(color: Colors.grey,fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Text('${Utils.parseStringDateToString('${_bloc.list[index].ngayCt}', Const.DATE_SV, Const.DATE_FORMAT_1)}', style: TextStyle(color: Colors.black,fontSize: 12),),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tổng tiền: ${NumberFormat(Const.amountFormat).format(_bloc.list[index].tTtNt??0)} VNĐ', style: TextStyle(color: Colors.red,fontSize: 12),),
                          Text('${_bloc.list[index].statusname}', style: TextStyle(color: Colors.black,fontSize: 12),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget buildOrderSuccess(BuildContext context){
    return ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: _bloc.list.length,
        separatorBuilder: (BuildContext context, int index){
          return Container();
        },
        itemBuilder: (BuildContext context, int index){
          return GestureDetector(
            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen(
              viewUpdateOrder: true,
              sttRec: _bloc.list[index].sttRec,
              viewDetail: true,
              title: _bloc.list[index].tenKh,
              phoneCustomer: _bloc.list[index].dienThoaiKH,
              addressCustomer: _bloc.list[index].diaChiKH,
              nameStore:  _bloc.list[index].nameStore,
              codeStore:  _bloc.list[index].codeStore,
              codeCustomer: _bloc.list[index].maKh,
            ))),
            child: Card(
              elevation: 10,
              shadowColor: Colors.blueGrey.withOpacity(0.5),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${_bloc.list[index].tenKh}', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 13),),
                              SizedBox(height: 3,),
                              Row(
                                children: [
                                  Icon(Icons.phone_iphone_rounded,color: Colors.grey,size: 12,),
                                  SizedBox(width: 3,),
                                  Text('${_bloc.list[index].dienThoaiKH??'null'}', style: TextStyle(color: Colors.grey,fontSize: 12),),
                                ],
                              ),
                              SizedBox(height: 3,),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined,color: Colors.grey,size: 12,),
                                  SizedBox(width: 3,),
                                  Expanded(child: Text('${_bloc.list[index].diaChiKH}', style: TextStyle(color: Colors.grey,fontSize: 12),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Text('${Utils.parseStringDateToString('${_bloc.list[index].ngayCt}', Const.DATE_SV, Const.DATE_FORMAT_1)}', style: TextStyle(color: Colors.black,fontSize: 12),),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tổng tiền: ${NumberFormat(Const.amountFormat).format(_bloc.list[index].tTtNt??0)} VNĐ', style: TextStyle(color: Colors.red,fontSize: 12),),
                        Text('${_bloc.list[index].statusname}', style: TextStyle(color: Colors.black,fontSize: 12),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
