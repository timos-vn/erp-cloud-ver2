import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sse/screen/product_detail/product_detail_bloc.dart';
import 'package:sse/screen/product_detail/product_detail_event.dart';
import 'package:sse/screen/product_detail/product_detail_state.dart';

import '../../themes/colors.dart';
import '../widget/custom_slider.dart';
import '../widget/pending_action.dart';

class ProductDetailScreen extends StatefulWidget {
  final String? itemCode;
  final String? currency;

  const ProductDetailScreen({Key? key, this.itemCode, this.currency}) : super(key: key);
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>  with SingleTickerProviderStateMixin{

  late ProductDetailBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ProductDetailBloc(context);
    _bloc.add(GetPrefs());

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ProductDetailBloc,ProductDetailState>(
        bloc: _bloc,
        listener: (context, state){
          if(state is GetPrefsSuccess){
            _bloc.add(GetProductDetailEvent(widget.itemCode.toString(),widget.currency.toString()));
          }
        },
        child: BlocBuilder<ProductDetailBloc,ProductDetailState>(
          bloc: _bloc,
          builder: (BuildContext context, ProductDetailState state){
            return  Scaffold(
              backgroundColor: Colors.white10,
              body: Stack(
                children: [
                  buildBody(context, state),
                  Visibility(
                    visible: state is ProductDetailLoading,
                    child: PendingAction(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  buildSlider(){
    return Container(
      height: 200,
      width: double.infinity,
      child: CustomCarousel(items: _bloc.listImage,),
    );
  }

  buildBody(BuildContext context,ProductDetailState state){
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          buildAppBar(),
          const SizedBox(height: 10,),
          Expanded(
            child: _bloc.listProductDetail.isEmpty ? Container() :
            ListView(
              children: [
                Column(
                  children: [
                    buildSlider(),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            height: 1,
                            color: blue.withOpacity(0.5),
                          ),
                        ),
                        Text('Thông tin sản phẩm',style: TextStyle(color: Colors.grey,fontSize: 12),),
                        Expanded(
                          child: Divider(
                            height: 1,
                            color: blue.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12,right: 12,top: 10,bottom: 50),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text(_bloc.listProductDetail[0].tenVt.toString().trim(),style: TextStyle(color: black,fontWeight: FontWeight.bold),maxLines: 2,overflow: TextOverflow.ellipsis,)),
                            ],
                          ),
                          Divider(),
                          buildItem('Mã sản phẩm',_bloc.listProductDetail[0].maVt.toString().trim()),
                          SizedBox(height: 5,),
                          Divider(),
                          SizedBox(height: 15,),
                          buildItem('Sản xuất tại',_bloc.listProductDetail[0].nuocSx.toString().trim()),

                          SizedBox(height: 5,),
                          Divider(),
                          SizedBox(height: 15,),
                          buildItem('Loại',_bloc.listProductDetail[0].xstyle.toString().trim()),

                          SizedBox(height: 5,),
                          Divider(),
                          SizedBox(height: 15,),
                          buildItem('Kích cỡ',_bloc.listProductDetail[0].xsize.toString().trim()),

                          SizedBox(height: 5,),
                          Divider(),
                          SizedBox(height: 15,),
                          buildItem('Màu sắc',_bloc.listProductDetail[0].xcolor.toString().trim()),

                          SizedBox(height: 5,),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.only(top: 24,bottom: 24),
                            child: Text('Chi tiết',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                          ),
                          buildItem2('Chiều dài',_bloc.listProductDetail[0].length0.toString().trim(),'Độ rộng',_bloc.listProductDetail[0].width0.toString().trim()),
                          SizedBox(height: 5,),
                          Divider(),
                          SizedBox(height: 15,),
                          buildItem2('Khối lượng',_bloc.listProductDetail[0].weight0.toString().trim(),'Thể tích',_bloc.listProductDetail[0].volume0.toString().trim()),
                          SizedBox(height: 5,),
                          Divider(),
                          SizedBox(height: 15,),
                          buildItem2('Chiều cao',_bloc.listProductDetail[0].height0.toString().trim(),'Bao bì',_bloc.listProductDetail[0].weight2.toString().trim()),

                          SizedBox(height: 5,),
                          Divider(),
                          SizedBox(height: 15,),
                          buildItem2('Đường kính',_bloc.listProductDetail[0].diameter.toString().trim(),'Mật độ',_bloc.listProductDetail[0].density.toString().trim()),
                          SizedBox(height: 5,),
                          Divider(),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  buildItem(String title,String content){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title+':',style: TextStyle(color: black),),
        SizedBox(width: 10,),
        Text(content,style: TextStyle(color: black,fontWeight: FontWeight.bold),),
      ],
    );
  }

  buildItem2(String title1,String content1,String title2,String content2){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(children: [
            Text('${title1.toString()}:',style: TextStyle(color: black),),
            SizedBox(width: 10,),
            Text(content1,style: TextStyle(color: black,fontWeight: FontWeight.bold),),
          ],),
        ),
        Row(
          children: [
            Text('${title2.toString()}',style: TextStyle(color: black),),
            SizedBox(width: 10,),
            Text(content2,style: TextStyle(color: black,fontWeight: FontWeight.bold),),],
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
                "Chi tiết sản phẩm",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.white,),
                maxLines: 1,overflow: TextOverflow.fade,
              ),
            ),
          ),
          const SizedBox(width: 10,),
          Container(
            width: 40,
            height: 50,
            child: Icon(
              Icons.event,
              size: 25,
              color: Colors.transparent,
            ),
          )
        ],
      ),
    );
  }
}
