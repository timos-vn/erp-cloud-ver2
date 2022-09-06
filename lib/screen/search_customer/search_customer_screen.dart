import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sse/screen/search_customer/search_customer_bloc.dart';
import 'package:sse/themes/colors.dart';
import '../../model/network/response/manager_customer_response.dart';
import '../../utils/debouncer.dart';
import '../../utils/images.dart';
import '../sell/detail_info_customer/detail_customer_screen.dart';
import '../widget/pending_action.dart';
import 'search_customer_state.dart';
import 'search_customer_event.dart';

class SearchCustomerScreen extends StatefulWidget {
  final bool? selected;

  const SearchCustomerScreen({Key? key, this.selected}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SearchCustomerScreenState();
  }
}

class SearchCustomerScreenState extends State<SearchCustomerScreen> {

  final focusNode = FocusNode();
  final _searchController = TextEditingController();
  late SearchCustomerBloc _bloc;
  late ScrollController _scrollController;
  final _scrollThreshold = 200.0;
  bool _hasReachedMax = true;


  final Debouncer onSearchDebouncer = new Debouncer(delay: new Duration(milliseconds: 1000));
  late List<ManagerCustomerResponseData> _dataListSearch;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = SearchCustomerBloc(context);
    _bloc.add(GetPrefs());

    Future.delayed(Duration(seconds: 3));
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScroll - currentScroll <= _scrollThreshold && !_hasReachedMax && _bloc.isScroll == true) {
        _bloc.add(SearchCustomer(_searchController.text, isLoadMore: true));
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
        child: BlocListener<SearchCustomerBloc, SearchCustomerState>(
            bloc: _bloc,
            listener: (context, state) {
              if (state is SearchFailure){}
                //Utils.showErrorSnackBar(context, state.message);
              if (state is RequiredText) {
                // Utils.showErrorSnackBar(
                //     context, 'Vui lòng nhập kí tự cần tìm kiếm!');
              }
            },
            child: BlocBuilder<SearchCustomerBloc, SearchCustomerState>(
                bloc: _bloc,
                builder: (BuildContext context, SearchCustomerState state) {
                  return buildBody(context, state);
                })),
      ),
    );
  }

  buildBody(BuildContext context,SearchCustomerState state){
    _dataListSearch = _bloc.searchResults;
    int length = _dataListSearch.length;
    if (state is SearchSuccess)
      _hasReachedMax = length < _bloc.currentPage * 20;//_bloc.maxPage
    else
      _hasReachedMax = false;
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white.withOpacity(.09),
      child: Column(
        children: [
          buildAppBar(),
          const SizedBox(height: 10,),
          Expanded(
            child: Stack(children: <Widget>[
              ListView.separated(
                padding: EdgeInsets.zero,
                controller: _scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Divider(
                      height: 0.5,
                    ),
                  );
                },
                shrinkWrap: true,
                itemCount: length == 0
                    ? length
                    : _hasReachedMax ? length : length + 1,
                itemBuilder: (context, index) {
                  return index >= length
                      ? Container(
                    height: 100.0,
                    color: white,
                    // child: PendingAction(),
                  )
                      :
                  GestureDetector(
                    onTap: (){
                      if(widget.selected == true){
                        Navigator.pop(context,_dataListSearch[index]);
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailInfoCustomerScreen(idCustomer: _dataListSearch[index].customerCode,)));
                      }
                    },
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8,right: 8,top: 16,bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(img),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_dataListSearch[index].customerName}',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontWeight: FontWeight.bold,color: blue),
                                  ),
                                  SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on,size: 12,color: grey,),
                                      SizedBox(width: 4,),
                                      Expanded(
                                        child: Text(
                                          '${_dataListSearch[index].address}',
                                          style: TextStyle(fontSize: 12,color: grey,),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5,),
                                  Row(
                                    children: [
                                      Icon(Icons.phone,size: 12,color: grey,),
                                      SizedBox(width: 4,),
                                      Text(
                                        '${_dataListSearch[index].phone}',
                                        style: TextStyle(fontSize: 12,color: grey,),
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              Visibility(
                visible: state is EmptySearchState,
                child: Center(
                  child: Text('Không có dữ liệu'),
                ),
              ),
              Visibility(
                visible: state is SearchLoading,
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
            onTap: ()=> Navigator.pop(context),
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
                  borderRadius:
                  BorderRadius.all(Radius.circular(20))),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      height: 30,
                      child: Center(
                        child: TextField(
                          autofocus: true,
                          textAlign: TextAlign.left,
                          textAlignVertical: TextAlignVertical.top,
                          style:
                          TextStyle(fontSize: 14, color: Colors.white),
                          focusNode: focusNode,
                          onSubmitted: (text) {
                            _bloc.add(SearchCustomer(text));
                          },
                          controller: _searchController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onChanged: (text) => this.onSearchDebouncer.debounce(
                                  ()=> _bloc.add(SearchCustomer(text))),//_bloc.add(CheckShowCloseEvent(text)),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: transparent,
                            hintText: 'Tìm kiếm khách hàng',
                            hintStyle: TextStyle(color: Colors.white),
                              contentPadding: EdgeInsets.only(
                                  bottom: 10, top: 10)
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _bloc.isShowCancelButton,
                    child: InkWell(
                        child: Padding(
                          padding: EdgeInsets.only(left: 0,top:0,right: 8,bottom: 10),
                          child: Icon(
                            MdiIcons.close,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        onTap: () {
                          _searchController.text = "";
                          _bloc.add(CheckShowCloseEvent(""));
                        }),
                  )
                ],
              ),
            ),
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
