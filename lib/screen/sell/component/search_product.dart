// ignore_for_file: unnecessary_null_comparison

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:collection/collection.dart';
import 'package:sse/screen/product_detail/product_detail_screen.dart';
import 'package:sse/screen/sell/cart/cart_bloc.dart';
import 'package:sse/screen/sell/cart/cart_event.dart';
import 'package:sse/themes/colors.dart';
import 'package:sse/utils/debouncer.dart';
import 'package:sse/utils/utils.dart';
import '../../../model/entity/product.dart';
import '../../../model/network/response/search_list_item_response.dart';
import '../../../utils/images.dart';
import '../../widget/input_quantity_popup_order.dart';
import '../../widget/pending_action.dart';
import '../cart/cart_state.dart';


class SearchProductScreen extends StatefulWidget {
  final String? currency;
  final bool? viewUpdateOrder;
  final int? idGroup;
  final String? itemGroupCode;
  final List<Product> listOrder;

  const SearchProductScreen({Key? key, this.currency,this.viewUpdateOrder,this.idGroup,this.itemGroupCode,required this.listOrder}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SearchProductScreenState();
  }
}

class SearchProductScreenState extends State<SearchProductScreen> {

  late CartBloc _bloc;

  final focusNode = FocusNode();
  TextEditingController _searchController = TextEditingController();

  late ScrollController _scrollController;
  final _scrollThreshold = 200.0;
  bool _hasReachedMax = true;

  List<Product> listOrderInCart = <Product>[];


  final Debouncer onSearchDebouncer = new Debouncer(delay: new Duration(milliseconds: 1000));

  late List<SearchItemResponseData> _dataListSearch;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = CartBloc(context);
    listOrderInCart = widget.listOrder;
    _bloc.add(GetPrefs());

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScroll - currentScroll <= _scrollThreshold && !_hasReachedMax && _bloc.isScroll == true) {
        _bloc.add(SearchProduct(_searchController.text,widget.idGroup!.toInt(), widget.itemGroupCode.toString(),isLoadMore: true,));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: BlocListener<CartBloc,CartState>(
            bloc: _bloc,
            listener: (context, state) {
              if (state is CartFailure)
                Utils.showCustomToast(context, Icons.warning_amber_outlined, 'Úi, Đã có lỗi xảy ra.');
              else if (state is RequiredText) {
                // Utils.showErrorSnackBar(context, 'Vui lòng nhập kí tự cần tìm kiếm!');
              }
              else if(state is AddCartSuccess){
                //Utils.showCustomToast(context, Icons.check_circle_outline, 'Thêm vào giỏ hàng thành công.');
              }
            },
            child: BlocBuilder<CartBloc,CartState>(
                bloc: _bloc,
                builder: (BuildContext context, CartState state) {
                  return buildBody(context, state);
                })),
      ),
    );
  }


  buildBody(BuildContext context,CartState state){

    _dataListSearch = _bloc.searchResults;
    int length = _dataListSearch.length;
    if (state is SearchProductSuccess)
      _hasReachedMax = length < _bloc.currentPage * 20;
    else
      _hasReachedMax = false;
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          buildAppBar(),
          const SizedBox(height: 10,),
          Expanded(
            child: Stack(children: <Widget>[
              ListView.builder(
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index){
                    if(listOrderInCart.isNotEmpty){
                      if(widget.viewUpdateOrder == false){
                        String code = _dataListSearch[index].code.toString().trim();
                        final valueItemCount = listOrderInCart.firstWhereOrNull((item) => item.code == code);
                        if (valueItemCount != null) {
                          _dataListSearch[index].count = valueItemCount.count;
                        }
                      }
                      else {
                        final valueItemCount = listOrderInCart.firstWhereOrNull((item) => item.code == _dataListSearch[index].code,);
                        if (valueItemCount != null) {
                          _dataListSearch[index].count = valueItemCount.count;
                        }
                      }
                    }
                    if(_dataListSearch[index].count == null){
                      _dataListSearch[index].count = 0;
                    }
                    return index >= length ?  Container(
                      height: 100.0,
                      color: white,
                      child: PendingAction(),
                    )
                        : GestureDetector(
                      onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ProductDetailScreen(itemCode:  _dataListSearch[index].code,currency:  widget.currency ,))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8,right: 8),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(16)),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: (_dataListSearch[index].imageUrl != null || _dataListSearch[index].imageUrl != 'null') ?
                                      Image.asset(noWallpaper,fit: BoxFit.cover) :
                                      CachedNetworkImage(imageUrl: _dataListSearch[index].imageUrl.toString() , fit: BoxFit.cover),
                                    )
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "[${_dataListSearch[index].code ?? ''}] ${_dataListSearch[index].name ?? ''}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Text(
                                            'Tồn kho:',style: TextStyle(color: grey,fontSize: 10),
                                            textAlign: TextAlign.left,
                                          ),
                                          SizedBox(width: 5,),
                                          Text(
                                            _dataListSearch[index].stockAmount.toString().trim(),style: TextStyle(color: blue,fontSize: 10),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5,),
                                      Row(
                                        children: [
                                          Text(
                                            'Giá:',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(color: grey,fontSize: 10),
                                          ),
                                          SizedBox(width: 5,),
                                          Text(
                                            _dataListSearch[index].price.toString().trim(),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(color: grey,fontSize: 10,decoration: TextDecoration.lineThrough),
                                          ),
                                          SizedBox(width: 5,),
                                          Text(
                                            _dataListSearch[index].priceAfter.toString().trim(),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(color: red,fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: (){
                                    if(_dataListSearch[index].stockAmount!>0){
                                      showDialog(
                                          barrierDismissible: true,
                                          context: context,
                                          builder: (context) {
                                            return InputQuantityPopupOrder(
                                                quantity: _bloc.searchResults[index].stockAmount!.toDouble(),
                                                listDvt: _bloc.searchResults[index].allowDvt == true ? _bloc.searchResults[index].contentDvt!.split(',').toList() : [],
                                                allowDvt: _bloc.searchResults[index].allowDvt,
                                            );
                                          }).then((value){
                                        if(!Utils.isEmpty(value)){
                                          setState(() {
                                            if(widget.viewUpdateOrder == true){
                                              _bloc.searchResults[index].count = double.parse(value.toString());
                                              if(_bloc.listProductOrderAndUpdate.isNotEmpty){
                                                final valueItem = _bloc.listProductOrderAndUpdate.firstWhereOrNull((item) => item.code == _bloc.searchResults[index].code,);
                                                if (valueItem != null) {
                                                  final indexWithStart =  _bloc.listProductOrderAndUpdate.indexOf(valueItem);
                                                  _bloc.listProductOrderAndUpdate[indexWithStart].count = _bloc.searchResults[index].count;
                                                }else {
                                                  Product production = Product(
                                                      code: _bloc.searchResults[index].code,
                                                      name: _bloc.searchResults[index].name,
                                                      name2:_bloc.searchResults[index].name2,
                                                      dvt:_bloc.searchResults[index].dvt,
                                                      description:_bloc.searchResults[index].descript,
                                                      price:_bloc.searchResults[index].price,
                                                      discountPercent:_bloc.searchResults[index].discountPercent,
                                                      priceAfter:_bloc.searchResults[index].priceAfter,
                                                      stockAmount:_bloc.searchResults[index].stockAmount,
                                                      taxPercent:_bloc.searchResults[index].taxPercent,
                                                      imageUrl:_bloc.searchResults[index].imageUrl,
                                                      count:_bloc.searchResults[index].count,
                                                      isMark:0,
                                                      discountMoney:_bloc.searchResults[index].discountMoney,
                                                      discountProduct:_bloc.searchResults[index].discountProduct,
                                                      budgetForItem:_bloc.searchResults[index].budgetForItem,
                                                      budgetForProduct:_bloc.searchResults[index].budgetForProduct,
                                                      residualValueProduct:_bloc.searchResults[index].residualValueProduct,
                                                      residualValue:_bloc.searchResults[index].residualValue,
                                                      unit:_bloc.searchResults[index].unit,
                                                      unitProduct:_bloc.searchResults[index].unitProduct,
                                                      dsCKLineItem:_bloc.searchResults[index].dsCKLineItem?.join(',')
                                                  );
                                                  _bloc.listProductOrderAndUpdate.add(production);
                                                }
                                              }else {
                                                Product production = Product(
                                                    code: _bloc.searchResults[index].code,
                                                    name: _bloc.searchResults[index].name,
                                                    name2:_bloc.searchResults[index].name2,
                                                    dvt:_bloc.searchResults[index].dvt,
                                                    description:_bloc.searchResults[index].descript,
                                                    price:_bloc.searchResults[index].price,
                                                    discountPercent:_bloc.searchResults[index].discountPercent,
                                                    priceAfter:_bloc.searchResults[index].priceAfter,
                                                    stockAmount:_bloc.searchResults[index].stockAmount,
                                                    taxPercent:_bloc.searchResults[index].taxPercent,
                                                    imageUrl:_bloc.searchResults[index].imageUrl,
                                                    count:_bloc.searchResults[index].count,
                                                    isMark:0,
                                                    discountMoney:_bloc.searchResults[index].discountMoney,
                                                    discountProduct:_bloc.searchResults[index].discountProduct,
                                                    budgetForItem:_bloc.searchResults[index].budgetForItem,
                                                    budgetForProduct:_bloc.searchResults[index].budgetForProduct,
                                                    residualValueProduct:_bloc.searchResults[index].residualValueProduct,
                                                    residualValue:_bloc.searchResults[index].residualValue,
                                                    unit:_bloc.searchResults[index].unit,
                                                    unitProduct:_bloc.searchResults[index].unitProduct,
                                                    dsCKLineItem:_bloc.searchResults[index].dsCKLineItem?.join(',')
                                                );
                                                _bloc.listProductOrderAndUpdate.add(production);
                                              }
                                            }
                                            else {
                                              if(value != null){
                                                _bloc.searchResults[index].count = double.parse(value.toString());
                                                Product production = Product(
                                                    code: _bloc.searchResults[index].code,
                                                    name: _bloc.searchResults[index].name,
                                                    name2:_bloc.searchResults[index].name2,
                                                    dvt:_bloc.searchResults[index].dvt,
                                                    description:_bloc.searchResults[index].descript,
                                                    price:_bloc.searchResults[index].price,
                                                    discountPercent:_bloc.searchResults[index].discountPercent,
                                                    priceAfter:_bloc.searchResults[index].priceAfter,
                                                    stockAmount:_bloc.searchResults[index].stockAmount,
                                                    taxPercent:_bloc.searchResults[index].taxPercent,
                                                    imageUrl:_bloc.searchResults[index].imageUrl,
                                                    count:_bloc.searchResults[index].count,
                                                    isMark:0,
                                                    discountMoney:_bloc.searchResults[index].discountMoney,
                                                    discountProduct:_bloc.searchResults[index].discountProduct,
                                                    budgetForItem:_bloc.searchResults[index].budgetForItem,
                                                    budgetForProduct:_bloc.searchResults[index].budgetForProduct,
                                                    residualValueProduct:_bloc.searchResults[index].residualValueProduct,
                                                    residualValue:_bloc.searchResults[index].residualValue,
                                                    unit:_bloc.searchResults[index].unit,
                                                    unitProduct:_bloc.searchResults[index].unitProduct,
                                                    dsCKLineItem:_bloc.searchResults[index].dsCKLineItem?.join(',')
                                                );
                                                _bloc.add(AddCartEvent(productItem: production));
                                              }
                                            }
                                          });
                                          _dataListSearch[index].count = double.parse(value.toString());
                                          Utils.showCustomToast(context, Icons.check_circle_outline, 'Yeahh, Thêm vào giỏ hàng thành công.');
                                        }
                                      });
                                    }else{
                                      Utils.showCustomToast(context, Icons.warning_amber_outlined, 'Úi, Sản phẩm đã hết hàng.');
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                          height: 35,width: 25,
                                          child: Icon(MdiIcons.minusCircle,color: grey,size: 20,)),
                                      SizedBox(width: 5,),
                                      Container(
                                        child: Text(
                                          '${_dataListSearch[index].count?.floor().toString()}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12, color: black, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      Container(
                                          height: 35,width: 25,
                                          child: Icon(MdiIcons.plusCircle,color: orange,size: 20,))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  //separatorBuilder: (BuildContext context, int index)=> Container(),
                  itemCount: length
              ),
              Visibility(
                visible: state is EmptySearchProductState,
                child: Center(
                  child: Text('Không có dữ liệu'),
                ),
              ),
              Visibility(
                visible: state is CartLoading,
                child: PendingAction(),
              ),
            ]),
          )
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
      padding: const EdgeInsets.fromLTRB(5, 35, 5,0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: (){
              if(widget.viewUpdateOrder == true){
                Navigator.pop(context);
              }else{
                Navigator.pop(context,);
              }
            },
            child: Container(
              width: 40,
              height: 50,
              padding: EdgeInsets.only(bottom: 10),
              child: Icon(
                Icons.arrow_back_rounded,
                size: 25,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
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
                        style: TextStyle(fontSize: 14, color: Colors.white),
                        focusNode: focusNode,
                        onSubmitted: (text) {
                          _bloc.add(SearchProduct(text,widget.idGroup!.toInt(), widget.itemGroupCode.toString()));
                        },
                        controller: _searchController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        onChanged: (text) => this.onSearchDebouncer.debounce(
                              () {
                            if(text != null)  _bloc.add(SearchProduct(text,widget.idGroup!.toInt(), widget.itemGroupCode.toString()));
                          },
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: transparent,
                            hintText: "Tìm kiếm sản phẩm",
                            hintStyle: TextStyle(color: Colors.white),
                            contentPadding: EdgeInsets.only(
                                bottom: 10, top: 10)
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _bloc.isShowCancelButton,
                    child: InkWell(
                        child: Icon(
                          MdiIcons.close,
                          color: Colors.white,
                          size: 28,
                        ),
                        onTap: () {
                          _searchController.text = "";
                          _bloc.add(CheckShowCloseEvent(""));
                        }),
                  )
                ],
              ),
            )
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _bloc.reset();
    super.dispose();
  }
}
