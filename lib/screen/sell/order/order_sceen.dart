import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sse/model/entity/product.dart';
import 'package:sse/themes/colors.dart';
import 'package:sse/utils/const.dart';
import 'package:sse/utils/utils.dart';
import '../../../model/network/response/search_list_item_response.dart';
import '../../../utils/images.dart';
import '../../product_detail/product_detail_screen.dart';
import '../../widget/custom_dropdown.dart';
import '../../widget/custom_question.dart';
import '../../widget/input_quantity_popup_order.dart';
import '../../widget/pending_action.dart';
import '../cart/cart_screen.dart';
import 'order_bloc.dart';
import 'order_event.dart';
import 'order_sate.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with TickerProviderStateMixin {
  late OrderBloc _orderBloc;
  TextEditingController _searchController = TextEditingController();
  int countProduct = 0;
  String currencyCode = 'VND';
  String itemGroupCode = '';
  int codeGroupProduct = 1;
  String user='all';
  int selectedIndex=0;
  TextEditingController _totalController = TextEditingController();
  TextEditingController inputNumber = TextEditingController();

  List<SearchItemResponseData> _list = [];
  int lastPage=0;
  int selectedPage=1;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _totalController.text = '0';
    _orderBloc = OrderBloc(context);
    _orderBloc.add(GetPrefs());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<OrderBloc, OrderState>(
          bloc: _orderBloc,
          listener: (context, state) {
            if(state is GetPrefsSuccess){
              _orderBloc.add(GetCountProductEvent(true));
            }else if(state is GetCountProductSuccess){
              if(state.firstLoad == true){
                _orderBloc.add(GetListOderEvent(searchValues: itemGroupCode,codeCurrency: currencyCode, pageIndex: selectedPage,idGroup: 1));
              }
            }
            else if (state is GetListOrderSuccess) {
              _list = _orderBloc.listItemOrder;
              _orderBloc.add(GetListGroupProductEvent());
            }else if(state is GetListGroupProductSuccess){
              _orderBloc.add(GetListItemGroupEvent(codeGroup: codeGroupProduct));
            }
            else if(state is PickCurrencyNameSuccess){
              _orderBloc.listItemOrder.clear();
              _orderBloc.add(GetListOderEvent(searchValues: itemGroupCode,codeCurrency: state.codeCurrency,idGroup: codeGroupProduct,isReLoad: true, pageIndex: selectedPage));
            }
            else if(state is PickupGroupProductSuccess){
              _orderBloc.add(GetListItemGroupEvent(codeGroup: codeGroupProduct));
            }
            else if(state is Success){
              // setState(() {
              //   showAsyncChoice = true;
              // });
              // usersMemoizer.runOnce(_orderBloc.getUsers);
            }
            else if(state is ItemScanSuccess){
              // Navigator.push(
              //     context,
                  // MaterialPageRoute(
                  //     builder: (context) => CartPageNew(
                  //       viewUpdateOrder: false,
                  //       viewDetail: false,
                  //       listOrder: DataLocal.listStore,
                  //       currencyCode: !Utils.isEmpty(currencyCode) ? currencyCode : Const.currencyList[0].currencyCode.toString(),
                  //     )));
            }
            else if(state is AddCartSuccess){
              Utils.showCustomToast(context, Icons.check_circle_outline, 'Thêm vào giỏ hàng thành công.');
              _orderBloc.add(GetCountProductEvent(false));
            }
          },
          child: BlocBuilder<OrderBloc, OrderState>(
            bloc: _orderBloc,
            builder: (BuildContext context, OrderState state) {
              return Stack(
                children: [
                  buildBody(context, state),
                  Visibility(
                    visible: state is EmptyDataState,
                    child: Center(
                      child: Text('Không có dữ liệu'),
                    ),
                  ),
                  Visibility(
                    visible: state is OrderLoading,
                    child: PendingAction(),
                  ),
                ],
              );
            },
          )),
    );
  }

  Widget _getDataPager() {
    return Center(
      child: Container(
        height: 57,
        width: double.infinity,
        child: Column(
          children: [
            Divider(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16,right: 16,bottom: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                        onTap: (){
                          setState(() {
                            lastPage = selectedPage;
                            selectedPage = 1;
                          });
                          _orderBloc.add(GetListOderEvent(searchValues: itemGroupCode, codeCurrency: currencyCode,idGroup: codeGroupProduct, pageIndex: selectedPage));
                        },
                        child: Icon(Icons.skip_previous_outlined,color: Colors.grey)),
                    SizedBox(width: 10,),
                    InkWell(
                        onTap: (){
                          if(selectedPage > 1){
                            setState(() {
                              lastPage = selectedPage;
                              selectedPage = selectedPage - 1;
                            });
                            _orderBloc.add(GetListOderEvent(searchValues: itemGroupCode, codeCurrency: currencyCode,idGroup: codeGroupProduct, pageIndex: selectedPage));
                          }
                        },
                        child: Icon(Icons.navigate_before_outlined,color: Colors.grey,)),
                    SizedBox(width: 10,),
                    Expanded(
                      child: ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index){
                            return InkWell(
                              onTap: (){
                                setState(() {
                                  lastPage = selectedPage;
                                  selectedPage = index+1;
                                });
                                _orderBloc.add(GetListOderEvent(searchValues: itemGroupCode, codeCurrency: currencyCode,idGroup: codeGroupProduct, pageIndex: selectedPage));
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: selectedPage == (index + 1) ?  mainColor : Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(48))
                                ),
                                child: Center(
                                  child: Text((index + 1).toString(),style: TextStyle(color: selectedPage == (index + 1) ?  Colors.white : Colors.black),),
                                ),
                              ),
                            );
                          },
                          separatorBuilder:(BuildContext context, int index)=> Container(width: 6,),
                          itemCount: _orderBloc.totalPager > 10 ? 10 : _orderBloc.totalPager),
                    ),
                    SizedBox(width: 10,),
                    InkWell(
                        onTap: (){
                          if(selectedPage < _orderBloc.totalPager){
                            setState(() {
                              lastPage = selectedPage;
                              selectedPage = selectedPage + 1;
                            });
                            _orderBloc.add(GetListOderEvent(searchValues: itemGroupCode, codeCurrency: currencyCode,idGroup: codeGroupProduct, pageIndex: selectedPage));
                          }
                        },
                        child: Icon(Icons.navigate_next_outlined,color: Colors.grey)),
                    SizedBox(width: 10,),
                    InkWell(
                        onTap: (){
                          setState(() {
                            lastPage = selectedPage;
                            selectedPage = _orderBloc.totalPager;
                          });
                          _orderBloc.add(GetListOderEvent(searchValues: itemGroupCode, codeCurrency: currencyCode,idGroup: codeGroupProduct, pageIndex: selectedPage));
                        },
                        child: Icon(Icons.skip_next_outlined,color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildGroupProduct(){
    return _orderBloc.listGroupProduct?.isEmpty == true
        ? Container(child: Text('Không có dữ liệu'),)
        :
    PopupMenuButton(
      shape: const TooltipShape(),
      padding: EdgeInsets.zero,
      offset: const Offset(0, 40),
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<Widget>>[
          PopupMenuItem<Widget>(
            child: Container(
              width: 200,
              decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: Scrollbar(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: _orderBloc.listGroupProduct?.length??0,
                  itemBuilder: (context, index) {
                    final trans = _orderBloc.listGroupProduct?[index].groupName??'';
                    return Container(
                      width: double.infinity,
                      child: ListTile(
                        minVerticalPadding: 1,
                        title: Text(
                          trans.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                          maxLines: 1,overflow: TextOverflow.fade,
                        ),
                        subtitle: Divider(height: 1,),
                        onTap: () {
                          _orderBloc.add(PickGroupProduct(codeGroup: _orderBloc.listGroupProduct?[index].groupCode??'', nameGroup: _orderBloc.listGroupProduct?[index].groupName??''));
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),
              height: 250,
            ),
          ),
        ];
      },
      child: Container(
        child: Row(
          children: [
            Text(_orderBloc.groupProductName.toString()),
            const SizedBox(width: 8,),
            Icon(
              MdiIcons.sortVariant,
              size: 15,
              color: black,
            ),
          ],
        ),
      ),
    );
  }

  buildCurrency(){
    return Const.currencyList.isEmpty
        ? Container(child: Text('Không có dữ liệu'),) :
    PopupMenuButton(
      shape: const TooltipShape(),
      padding: EdgeInsets.zero,
      offset: const Offset(0, 40),
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<Widget>>[
          PopupMenuItem<Widget>(
            child: Container(
              decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: Scrollbar(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 10,),
                  itemCount: Const.currencyList.length,
                  itemBuilder: (context, index) {
                    final trans = Const.currencyList[index].currencyName;
                    return ListTile(
                      minVerticalPadding: 1,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              trans.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                              maxLines: 1,overflow: TextOverflow.fade,
                            ),
                          ),
                          Text(
                            Const.currencyList[index].currencyCode.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Divider(height: 1,),
                      onTap: () {
                        _orderBloc.add(PickCurrencyName(currencyCode: Const.currencyList[index].currencyCode.toString(),currencyName: Const.currencyList[index].currencyName.toString()));
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              height: 250,
              width: 200,
            ),
          ),
        ];
      },
      child: Container(
        child: Text(_orderBloc.currencyName.toString(),style: TextStyle(color: subColor),),
      ),
    );
  }

  buildBody(BuildContext context,OrderState state){
    int length = _list.length;
    return Column(
      children: [
        buildAppBar(),
        Divider(height: 1,),
        Expanded(
          child: Column(
            children: [
              _orderBloc.listItemGroupProduct.isEmpty ? Container() : Container(
                height: 135,
                width: double.infinity,
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  elevation: 2,
                  margin: const EdgeInsets.all(5),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 15,left: 15,bottom: 15,right: 8),
                        color: Colors.blueGrey[50],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text('Nhóm Sản phẩm', style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Container(
                                height: 20,
                                child: buildGroupProduct())
                          ],
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Row(
                          children: [
                            InkWell(
                              onTap:(){
                                showModalBottomSheet(
                                    context: context,
                                    isDismissible: true,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
                                    ),
                                    backgroundColor: Colors.white,
                                    builder: (builder){
                                      return Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(25),
                                                topLeft: Radius.circular(25)
                                            )
                                        ),
                                        margin: MediaQuery.of(context).viewInsets,
                                        child: FractionallySizedBox(
                                          heightFactor: 0.9,
                                          child: StatefulBuilder(
                                            builder: (BuildContext context,StateSetter myState){
                                              return Padding(
                                                padding: const EdgeInsets.only(top: 10,bottom: 0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.only(
                                                          topRight: Radius.circular(25),
                                                          topLeft: Radius.circular(25)
                                                      )
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(top: 8.0,left: 16,right: 16),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            const Icon(Icons.check,color: Colors.white,),
                                                            const Text('Danh sách nhóm sản phẩm',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800),),
                                                            InkWell(
                                                                onTap: ()=> Navigator.pop(context),
                                                                child: const Icon(Icons.close,color: Colors.black,)),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5,),
                                                      const Divider(color: Colors.blueGrey,),
                                                      const SizedBox(height: 5,),
                                                      Container(
                                                        width: double.infinity,
                                                        margin: EdgeInsets.only(right: 20,left: 20),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(color: accent),
                                                            borderRadius:
                                                            BorderRadius.all(Radius.circular(20))),
                                                        padding:
                                                        EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: SizedBox(
                                                                height: 30,
                                                                child: TextField(
                                                                  autofocus: true,
                                                                  textAlign: TextAlign.left,
                                                                  textAlignVertical: TextAlignVertical.top,
                                                                  style: TextStyle(fontSize: 14, color: accent),
                                                                  // onSubmitted: (text) {
                                                                  //   _bloc.add(SearchProduct(text,widget.idGroup, widget.selectedId));
                                                                  // },
                                                                  controller: _searchController,
                                                                  keyboardType: TextInputType.text,
                                                                  textInputAction: TextInputAction.done,
                                                                  onChanged: (text){
                                                                    _orderBloc.add(SearchItemGroupEvent(text));
                                                                    myState((){});
                                                                  },
                                                                  decoration: InputDecoration(
                                                                      border: InputBorder.none,
                                                                      filled: true,
                                                                      fillColor: transparent,
                                                                      hintText: "Tìm kiếm nhóm sản phẩm",
                                                                      hintStyle: TextStyle(color: accent),
                                                                      contentPadding: EdgeInsets.only(
                                                                          bottom: 10, top: 10)
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Visibility(
                                                              visible: _searchController.text.length > 1,
                                                              child: InkWell(
                                                                  child: Icon(
                                                                    MdiIcons.close,
                                                                    color: accent,
                                                                    size: 20,
                                                                  ),
                                                                  onTap: () {
                                                                    myState(()=>_searchController.text = "");
                                                                  }),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: ListView.separated(
                                                            separatorBuilder: (BuildContext context, int index)=>Padding(
                                                              padding: const EdgeInsets.only(left: 16,right: 16,),
                                                              child: Divider(),
                                                            ),
                                                            padding: EdgeInsets.only(top: 14,bottom: 50,),
                                                            scrollDirection: Axis.vertical,
                                                            shrinkWrap: true,
                                                            itemCount: _orderBloc.listItemReSearch.length,
                                                            itemBuilder: (context,index) =>
                                                                GestureDetector(
                                                                  onTap: ()=> Navigator.pop(context,[_orderBloc.listItemReSearch[index].groupCode,_orderBloc.listItemReSearch[index].groupName]),
                                                                  child: Container(
                                                                    decoration: const BoxDecoration(
                                                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                                                      // color: Colors.blueGrey,
                                                                    ),
                                                                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                                                                    child: Column(
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                CircleAvatar(backgroundImage: NetworkImage(img),radius: 14,),
                                                                                const SizedBox(width: 10,),
                                                                                Text(_orderBloc.listItemReSearch[index].groupName??'',style: TextStyle(color: Colors.black),),
                                                                              ],
                                                                            ),
                                                                            Text(_orderBloc.listItemReSearch[index].groupCode??'',style: TextStyle(color: Colors.black),),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    }
                                ).then((value){
                                  if(value != null){
                                    _orderBloc.listItemOrder.clear();
                                    itemGroupCode = value[0];
                                    _orderBloc.add(GetListOderEvent(searchValues: itemGroupCode,codeCurrency: currencyCode,idGroup: codeGroupProduct, pageIndex: selectedPage ));
                                  }
                                });
                              },
                              child: Container(
                                width: 45,
                                child: Icon(Icons.search_outlined,color: subColor,),
                              ),
                            ),
                            Flexible(
                              child: ListView.builder(
                                  padding: EdgeInsets.only(top: 14,bottom: 14,),
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: _orderBloc.listItemGroupProduct.length < 10 ? _orderBloc.listItemGroupProduct.length : 10,
                                  itemBuilder: (context,index) =>
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: GestureDetector(
                                          onTap: (){
                                            itemGroupCode = _orderBloc.listItemGroupProduct[index].groupCode!;
                                            selectedIndex = index;
                                            _orderBloc.listItemOrder.clear();
                                            _orderBloc.add(GetListOderEvent(searchValues: itemGroupCode,codeCurrency: currencyCode,idGroup: codeGroupProduct, pageIndex: selectedPage ));
                                          },
                                          child: Container(
                                            height: 10,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                              color: selectedIndex == index ? subColor : Colors.blueGrey,
                                            ),
                                            padding: const EdgeInsets.only(right: 14,left: 5),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                CircleAvatar(backgroundImage: NetworkImage(img),radius: 14,),
                                                const SizedBox(width: 5,),
                                                Text(_orderBloc.listItemGroupProduct[index].groupName??'',style: TextStyle(color: Colors.white),),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(height: 1,color: Colors.blue.withOpacity(0.7),),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 16, top: 12, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Danh sách sản phẩm',
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),
                      ),
                    ),
                    buildCurrency()
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (BuildContext context, int index){
                      return GestureDetector(
                          onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ProductDetailScreen(itemCode: _list[index].code,currency:  currencyCode ,))),
                          child: Card(
                            semanticContainer: true,
                            margin: const EdgeInsets.all(5),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          color: _list[index].kColorFormatAlphaB,
                                          borderRadius: BorderRadius.all(Radius.circular(6),)
                                      ),
                                      child: Center(child: Text('${_list[index].name?.substring(0,1).toUpperCase()}',style: TextStyle(color: Colors.white),),),
                                    ),
                                    Visibility(
                                      visible: _list[index].discountPercent! > 0,
                                      child: Positioned(
                                        top: 10,left: 12,
                                        child: Container(
                                          padding: EdgeInsets.only(left: 8,right: 8,top: 5,bottom: 5),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                              color: Colors.red
                                          ),
                                          child: Center(child: Text('-${Utils.formatNumber(_list[index].discountPercent!)}%',style: TextStyle(color: Colors.white,fontSize: 11),),),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(left: 6,right: 6,top: 6,bottom: 5),
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                '${_list[index].name}',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  currencyCode == "VND"
                                                      ?
                                                  "\₫${NumberFormat(Const.amountFormat).format(_list[index].price??0)}"
                                                      :
                                                  "\$${NumberFormat(Const.amountNtFormat).format(_list[index].price??0)}"
                                                  ,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(color: grey, fontSize: 10, decoration: TextDecoration.lineThrough),
                                                ),
                                                SizedBox(height: 3,),
                                                Text(
                                                  currencyCode == "VND"
                                                      ?
                                                  "\₫${NumberFormat(Const.amountFormat).format(_list[index].priceAfter??0)}"
                                                      :
                                                  "\$${ NumberFormat(Const.amountNtFormat).format(_list[index].priceAfter??0)}",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(color: red, fontSize: 13),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${_list[index].code}',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Số lượng'+":",
                                                  style: TextStyle(color: grey, fontSize: 12),
                                                  textAlign: TextAlign.left,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text("${_list[index].stockAmount??0}",
                                                  style: TextStyle(color: blue, fontSize: 12),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5,),

                                        Padding(
                                          padding: const EdgeInsets.only(left: 0,right: 0),
                                          child: InkWell(
                                            onTap: (){
                                              if(_list[index].stockAmount!>0){
                                                showDialog(
                                                    barrierDismissible: true,
                                                    context: context,
                                                    builder: (context) {
                                                      return InputQuantityPopupOrder(
                                                        quantity: _list[index].stockAmount??0,
                                                        listDvt: _list[index].allowDvt == true ? _list[index].contentDvt!.split(',').toList() : [],
                                                        allowDvt: _list[index].allowDvt,);
                                                    }).then((value){
                                                  _list[index].count = double.parse(value[0].toString());
                                                  Product production = Product(
                                                      code: _list[index].code,
                                                      name: _list[index].name,
                                                      name2:_list[index].name2,
                                                      dvt:_list[index].dvt,
                                                      description:_list[index].descript,
                                                      price:_list[index].price,
                                                      discountPercent:_list[index].discountPercent,
                                                      priceAfter:_list[index].priceAfter,
                                                      stockAmount:_list[index].stockAmount,
                                                      taxPercent:_list[index].taxPercent,
                                                      imageUrl:_list[index].imageUrl,
                                                      count:_list[index].count,
                                                      isMark:0,
                                                      discountMoney:_list[index].discountMoney,
                                                      discountProduct:_list[index].discountProduct,
                                                      budgetForItem:_list[index].budgetForItem,
                                                      budgetForProduct:_list[index].budgetForProduct,
                                                      residualValueProduct:_list[index].residualValueProduct,
                                                      residualValue:_list[index].residualValue,
                                                      unit:_list[index].unit,
                                                      unitProduct:_list[index].unitProduct,
                                                      dsCKLineItem:_list[index].dsCKLineItem?.join(',')
                                                  );
                                                  _orderBloc.add(AddCartEvent(productItem: production));
                                                });
                                              }else{
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return WillPopScope(
                                                          onWillPop: () async => true,
                                                          child:  CustomQuestionComponent(
                                                            showTwoButton: false,
                                                            iconData: Icons.warning_amber_outlined,
                                                            title: 'Úi, sản phẩm đã hết hàng!',
                                                            content: 'Vui lòng liên hệ với Đại lý.',
                                                          )
                                                      );
                                                    });
                                              }
                                            },
                                            child: Container(
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                                  color: _list[index].kColorFormatAlphaB
                                              ),
                                              child: Center(child: Text('Thêm vào giỏ',style: TextStyle(color: Colors.white,fontSize: 12),),),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                      );
                    }
                ),
              ),
              _orderBloc.totalPager > 0 ? _getDataPager() : Container(),
              const SizedBox(height: 60,),
            ],
          ),
        )
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
      padding: const EdgeInsets.fromLTRB(5, 35, 5,0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: ()=> Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.only(bottom: 10),
              width: 40,
              height: 50,
              child: Icon(
                Icons.arrow_back_rounded,
                size: 25,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: GestureDetector(
              onTap: () {
                print(codeGroupProduct);
                // Utils.navigatePage(
                //     context,
                //     BlocProvider.value(
                //       value: _mainBloc,
                //       child: SearchPage(currency: currencyCode ,idGroup: codeGroupProduct,selectedId: selected,),
                //     ));
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(16)), border: Border.all(width: 1, color: white)),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: 18,
                      color: white,
                    ),
                    Expanded(
                        child: Text(
                          'Tìm kiếm sản phẩm',
                          style: TextStyle(color: white,fontSize: 14,fontStyle: FontStyle.normal),
                        )),
                    Icon(
                      Icons.cancel,
                      size: 18,
                      color: white,
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 5,),
          InkWell(
            onTap: (){
              print(_orderBloc.listProduct[0].code);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CartScreen(
                        viewUpdateOrder: false,
                        viewDetail: false,
                        codeGroupProduct: codeGroupProduct,
                        itemGroupCode:itemGroupCode,
                        listOrder: _orderBloc.listProduct,
                        currencyCode: !Utils.isEmpty(currencyCode) ? currencyCode : Const.currencyList[0].currencyCode.toString(),
                      ))).then((value){
                _orderBloc.add(GetCountProductEvent(true));
              });
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Stack(
                alignment: Alignment.center,
                overflow: Overflow.visible,
                children: [
                  Icon(
                    Icons.local_grocery_store,
                    color: white,
                    size: 20,
                  ),
                  Visibility(
                    visible: _orderBloc.listProduct.isNotEmpty,
                    child: Positioned(
                      top: -10,
                      right: -7,
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: blue,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 17,
                          minHeight: 17,
                        ),
                        child: Text(
                          _orderBloc.listProduct.length.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: (){
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => CartPageNew(
              //           viewUpdateOrder: false,
              //           viewDetail: false,
              //           listOrder: DataLocal.listStore,
              //           currencyCode: !Utils.isEmpty(currencyCode) ? currencyCode : Const.currencyList[0].currencyCode.toString(),
              //         ))).then((value){
              //   // if(value == Const.REFRESH){
              //   _orderBloc.add(GetListOderEvent(searchValues: '',codeCurrency: (value != Const.REFRESH) ? value: currencyCode));
              //   // }
              // });
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Icon(
                MdiIcons.qrcodeScan,
                color: white,
                size: 20,
              ),
            ),
          ),
          /// Scan barcode
          // InkWell(
          //   onTap:() async {
          //     // String code = await FlutterBarcodeScanner.scanBarcode(
          //     //     "#8CC63F",
          //     //     'Cancel'.tr,
          //     //     true,
          //     //     ScanMode.DEFAULT
          //     // );
          //     // if(!Utils.isEmpty(code) && code != '-1'){
          //     //   _orderBloc.add(ScanItemEvent(code,currencyCode));
          //     // }
          //   },
          //   child: Container(
          //     padding: EdgeInsets.only(right: 20,left: 5),
          //     child: Icon(
          //       MdiIcons.qrcodeScan,
          //       size: 20,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

}