// ignore_for_file: unnecessary_null_comparison

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:sse/screen/sell/confirm_order/confirm_order_screen.dart';
import 'package:sse/themes/colors.dart';
import 'package:sse/utils/const.dart';
import 'package:sse/utils/utils.dart';

import '../../../model/entity/product.dart';
import '../../../utils/images.dart';
import '../../widget/custom_dropdown.dart';
import '../../widget/custom_paint.dart';
import '../../widget/pending_action.dart';
import '../component/search_product.dart';
import 'cart_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartScreen extends StatefulWidget {
  final String? sttRec;
  final bool? viewUpdateOrder;
  final List<Product>? listOrder;
  final String? currencyCode;
  final bool? viewDetail;
  final String? title;
  final String? phoneCustomer;
  final String? addressCustomer;
  final String? nameStore;
  final String? codeStore;
  final String? codeCustomer;
  final String? itemGroupCode;
  final int? codeGroupProduct;


  const CartScreen({Key? key,this.sttRec,this.viewUpdateOrder,this.listOrder,this.currencyCode,this.viewDetail,this.title,
        this.phoneCustomer,this.addressCustomer,this.nameStore,this.codeStore,this.codeCustomer,this.itemGroupCode,this.codeGroupProduct
  }) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  late CartBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = CartBloc(context);
    _bloc.add(GetPrefs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: BlocListener<CartBloc,CartState>(
        bloc: _bloc,
        listener: (context,state){
          if(state is GetPrefsSuccess){
            if(widget.viewUpdateOrder == false){
              if(_bloc.listProductOrder.isNotEmpty)
                _bloc.listProductOrder.clear();
              _bloc.listProductOrder = widget.listOrder!;
              _bloc.add(TotalDiscountAndMoneyForAppEvent(listProduct: widget.listOrder!,viewUpdateOrder: false,reCalculator: true));
            }else{
              _bloc.add(GetListItemUpdateOrderEvent(widget.sttRec.toString()));
            }
          }
          else if(state is TotalMoneyForAppSuccess){
            if(state.reCalculator == true){
              _bloc.add(GetListProductFromDB());
            }
          }else if(state is GetListProductFromDBSuccess){
            if(state.reGetList == true){
              _bloc.add(TotalDiscountAndMoneyForAppEvent(listProduct:_bloc.listProductOrderAndUpdate,viewUpdateOrder:false,reCalculator: false));
            }
          }
          else if(state is GetListItemUpdateOrderSuccess){
            _bloc.add(CheckDisCountWhenUpdateEvent(widget.sttRec.toString(),true,codeCustomer: widget.codeCustomer.toString(),codeStore: widget.codeStore.toString()));
          }else if(state is TotalMoneyUpdateOrderSuccess){
            // DataLocal.listStoreUpdate.addAll(_bloc.listOrder);
          }
        },
        child: BlocBuilder<CartBloc,CartState>(
          bloc: _bloc,
          builder: (BuildContext context, CartState state){
            return Stack(
              children: [
                buildBody(context, state),
                Visibility(
                  visible: state is CartLoading,
                  child: PendingAction(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  buildBody(BuildContext context,CartState state){
    return Column(
      children: [
        buildAppBar(),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10)
                )
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15,right: 16,left: 16,bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _bloc.listDiscountName!.length > 0 ?
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: _bloc.listDiscountName?.length,
                          itemBuilder: (context, index){
                            return
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('CKKM: ${_bloc.listDiscountName?[index].tenCk}',style: TextStyle(color: Colors.pink,fontSize: 12),),
                                  Visibility(
                                      visible: !Utils.isEmpty(_bloc.listProductOrderAndUpdate[index].budgetForItem.toString()),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text('${_bloc.listProductOrderAndUpdate[index].budgetForItem??''} : ${NumberFormat(Const.amountFormat).format(_bloc.listProductOrderAndUpdate[index].residualValue??0)} ${_bloc.listProductOrderAndUpdate[index].unit}',
                                          style: TextStyle(color: Colors.pink,fontSize: 12),),
                                      )),
                                ],
                              )
                            ;
                          },
                        ),
                      ) :
                      Text('Chưa có CKKM nào được áp dụng!',style: TextStyle(color: Colors.blueGrey,fontSize: 12),),
                      Icon(MdiIcons.gift, color: Colors.green,)
                    ],
                  ),
                ),
                Divider(),
                Expanded(
                    child: ListView.separated(
                        padding: EdgeInsets.only(left: 8,right: 8,top: 8),
                        shrinkWrap: true,
                        separatorBuilder: (BuildContext context, int index)=>Padding(
                          padding: const EdgeInsets.only(left: 16,right: 16),
                          child: Container(height: 20,),
                        ),
                        itemCount: _bloc.listProductOrderAndUpdate.length,
                        itemBuilder: (context,index) =>
                            Stack(
                              overflow: Overflow.visible,
                              children: [
                                Slidable(
                                  key: const ValueKey(1),
                                  endActionPane: ActionPane(
                                    motion: ScrollMotion(),
                                    dismissible: DismissiblePane(onDismissed: (){
                                      _bloc.add(DeleteProductFromDB(widget.viewUpdateOrder!,index,_bloc.listProductOrderAndUpdate[index]));
                                    }),
                                    children: [
                                      SlidableAction(
                                        onPressed:(_) {
                                          _bloc.add(DeleteProductFromDB(widget.viewUpdateOrder!,index,_bloc.listProductOrderAndUpdate[index]));
                                        },
                                        backgroundColor: Color(0xFF7BC043),
                                        foregroundColor: Colors.white,
                                        icon: Icons.archive,
                                        label: 'Xoá',
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    height: 122,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.withOpacity(0.7))
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          height: double.infinity,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(4),
                                            child: SizedBox.fromSize(
                                              size: Size.fromRadius(50), // Image radius
                                              child: _bloc.listProductOrderAndUpdate[index].imageUrl == null ?
                                              Image.asset(noWallpaper,fit: BoxFit.cover) :
                                              CachedNetworkImage(imageUrl: _bloc.listProductOrderAndUpdate[index].imageUrl.toString() , fit: BoxFit.cover),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                const EdgeInsets.only(right: 5.0,bottom: 5,top: 3),
                                                child: Text(
                                                  '[${_bloc.listProductOrderAndUpdate[index].code??''}] ${_bloc.listProductOrderAndUpdate[index].name??''}',
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(fontSize: 14, color: black,fontWeight: FontWeight.normal),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Visibility(
                                                    visible: _bloc.listProductOrderAndUpdate[index].priceAfter! > 0,
                                                    child: Text(
                                                      "\₫${NumberFormat(Const.amountFormat).format(_bloc.listProductOrderAndUpdate[index].price??0)}",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(color: grey, fontSize: 10, decoration: TextDecoration.lineThrough),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10,),
                                                  Text("\₫${NumberFormat(Const.amountFormat).format(_bloc.listProductOrderAndUpdate[index].priceAfter??0)}",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(color: red, fontSize: 13),
                                                  ),
                                                ],
                                              ),
                                              Visibility(
                                                visible: !Utils.isEmpty(_bloc.listProductOrderAndUpdate[index].discountProduct.toString()),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 4),
                                                  child: DottedBorder(
                                                    dashPattern: [5, 3],
                                                    color: Colors.orange,
                                                    borderType: BorderType.RRect,
                                                    radius: Radius.circular(2),
                                                    padding: EdgeInsets.symmetric(horizontal: 6,vertical: 2),
                                                    child: Text('${_bloc.listProductOrderAndUpdate[index].discountProduct} - Còn: ${NumberFormat(Const.amountFormat).format(_bloc.listProductOrderAndUpdate[index].residualValueProduct??0)} ${_bloc.listProductOrderAndUpdate[index].unitProduct}',
                                                      style: TextStyle(color: Colors.orange,fontSize: 10),maxLines: 2,overflow: TextOverflow.ellipsis,),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10,right: 12,top: 0,bottom: 0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                  onTap:(){
                                                    _bloc.add(Decrement(index));
                                                  },
                                                  child: Container(height: 30,child: Center(child: Icon(MdiIcons.minusCircleOutline,color: grey,size: 20,)))),
                                              Text('${_bloc.listProductOrderAndUpdate[index].count?.floor().toString()}',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                              InkWell(
                                                  onTap: (){
                                                    _bloc.add(Increment(index));
                                                  },
                                                  child: Container(height: 30,child: Center(child: Icon(MdiIcons.plusCircleOutline,color: orange,size: 20,))))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: !Utils.isEmpty(_bloc.listProductOrderAndUpdate[index].discountMoney.toString()),
                                  child: Positioned(
                                    left: -8,
                                    top: -10,
                                    child: PopupMenuButton(
                                      shape: const TooltipShape(),
                                      padding: EdgeInsets.zero,
                                      offset: const Offset(3, 65),
                                      itemBuilder: (BuildContext context) {
                                        return <PopupMenuEntry<Widget>>[
                                          PopupMenuItem<Widget>(
                                            child: Container(
                                              decoration: ShapeDecoration(
                                                  color: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10))),
                                              child: Scrollbar(
                                                child: ListView(
                                                  children: [
                                                    Text('${_bloc.listProductOrderAndUpdate[index].discountMoney}',
                                                      style: TextStyle(fontSize: 12,color: Colors.black,height: 2),),
                                                  ],
                                                ),
                                              ),
                                              height: 150,
                                              width: 500,
                                            ),
                                          )
                                        ];
                                      },
                                      child: Container(
                                        width: 80,
                                        child: CustomPaint(
                                          size: Size(40, 20),
                                          painter: ProductLikePaint(),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 8,right: 8,top: 6,bottom: 10),
                                            child: Center(child: Text('${_bloc.listProductOrderAndUpdate[index].discountMoney}',
                                              style: TextStyle(fontSize: 9,color: Colors.white),maxLines: 1,overflow: TextOverflow.ellipsis,
                                            )),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                    )
                ),
                Container(
                  padding: EdgeInsets.only(left: 16,right: 16,top: 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tổng tiền',style: TextStyle(color: Colors.black,fontSize: 12),),
                          Text('${NumberFormat(Const.amountFormat).format(_bloc.totalMNProduct??0)} ₫',style: TextStyle(color: Colors.black,fontSize: 12),),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Chiết khấu',style: TextStyle(color: Colors.black,fontSize: 12),),
                          Text('${NumberFormat(Const.amountFormat).format(_bloc.totalMNDiscount??0)} ₫',style: TextStyle(color: Colors.black,fontSize: 12),),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tổng thanh toán',style: TextStyle(color: Colors.black,fontSize: 12),),
                          Text('${NumberFormat(Const.amountFormat).format(_bloc.totalMNPayment??0)} ₫',style: TextStyle(color: Colors.black,fontSize: 12),),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Visibility(
                        visible: widget.viewDetail == false,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ConfirmOrderScreen(
                                currencyCode: widget.currencyCode,
                                totalMNProduct: _bloc.totalMNProduct,
                                totalMNDiscount: _bloc.totalMNDiscount,
                                totalMNPayment: _bloc.totalMNPayment,
                                listCodeDisCount: _bloc.listCodeDisCount,
                                viewUpdateOrder: widget.viewUpdateOrder,
                                sstRec: widget.sttRec,
                                nameCustomer: widget.title,
                                phoneCustomer: widget.phoneCustomer,
                                addressCustomer: widget.addressCustomer,
                                nameStore:widget.nameStore,
                                codeStore:widget.codeStore,
                                codeCustomer: widget.codeCustomer,
                                listProductOrderAndUpdate: _bloc.listProductOrderAndUpdate,
                              ))).then((value) {
                                if(value == Const.REFRESH){
                                  Navigator.of(context).pop(Const.REFRESH);
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
                              height: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.orange
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.viewUpdateOrder == true ? 'Tiếp tục' :'Đặt hàng ngay',style: TextStyle(color: Colors.white,fontSize: 14),),
                                  Icon(widget.viewUpdateOrder == true ? MdiIcons.update : MdiIcons.arrowRightBoldHexagonOutline,color: Colors.white,)
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 60,)
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
            onTap: ()=> Navigator.of(context).pop(widget.currencyCode),
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
                widget.viewUpdateOrder == true ? widget.title?.toString()??'' :'Giỏ hàng',
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.white,),
                maxLines: 1,overflow: TextOverflow.fade,
              ),
            ),
          ),
          const SizedBox(width: 10,),
          InkWell(
            onTap: (){
              if(widget.viewDetail == false){
                pushNewScreen(context, screen: SearchProductScreen(
                    currency: widget.currencyCode ,
                    viewUpdateOrder: widget.viewUpdateOrder,
                    idGroup: widget.codeGroupProduct,
                    itemGroupCode: widget.itemGroupCode,
                    listOrder: _bloc.listProductOrderAndUpdate),withNavBar: false).then((value){
                      if(widget.viewUpdateOrder == false){
                        _bloc.add(GetListProductFromDB());
                      }
                      else {
                        _bloc.add(CheckDisCountWhenUpdateEvent(widget.sttRec.toString(),false,addNewItem: true,codeCustomer: widget.codeCustomer.toString(),codeStore: widget.codeStore.toString()));
                  }
                });
              }
            },
            child: Container(
              width: 40,
              height: 50,
              child: Icon(
                Icons.search,
                size: 25,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

}



