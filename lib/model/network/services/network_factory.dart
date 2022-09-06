import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sse/model/network/request/config_request.dart';
import 'package:sse/model/network/request/detail_delivery_plan_request.dart';
import 'package:sse/model/network/request/get_list_checkin_request.dart';
import 'package:sse/model/network/request/login_request.dart';
import 'package:sse/model/network/request/report_data_request.dart';
import 'package:sse/model/network/request/update_plan_delivery_request.dart';
import 'package:sse/utils/const.dart';
import 'package:sse/utils/log.dart';
import 'package:sse/utils/utils.dart';

import '../../entity/entity_request.dart';
import '../request/atccept_approval_request.dart';
import '../request/confirm_dnc_request.dart';
import '../request/confirm_shipping_request.dart';
import '../request/create_dnc_request.dart';
import '../request/create_order_request.dart';
import '../request/create_tkcd_request.dart';
import '../request/delivery_plan_request.dart';
import '../request/detail_approval_request.dart';
import '../request/discount_request.dart';
import '../request/get_item_shipping_request.dart';
import '../request/list_dnc_request.dart';
import '../request/list_history_order_request.dart';
import '../request/list_shipping_request.dart';
import '../request/list_status_approval_request.dart';
import '../request/manager_customer_request.dart';
import '../request/report_field_lookup_request.dart';
import '../request/result_report_request.dart';
import '../request/search_list_item_request.dart';
import '../request/stage_statistic_request.dart';
import '../request/store_list_request.dart';
import '../request/time_keeping_request.dart';
import '../request/update_order_request.dart';
import 'host.dart';

class NetWorkFactory{
  BuildContext context;
  Dio? _dio;
  SharedPreferences? _sharedPreferences;
  bool? isGoogle;
  String? refToken;
  String? token;

  NetWorkFactory(this.context) {
    HostSingleton hostSingleton = HostSingleton();
    hostSingleton.showError();
    String host = hostSingleton.host;
    int port = hostSingleton.port;

    if (!host.contains("http")) {
      host = "http://" + host;
    }
    _dio = Dio(BaseOptions(
      baseUrl: "$host${port!=0?":$port":""}",
      receiveTimeout: 30000,
      connectTimeout: 30000,
    ));
    _setupLoggingInterceptor();
  }

  void _setupLoggingInterceptor(){
    int maxCharactersPerLine = 200;
    refToken = Const.REFRESH_TOKEN;
    _dio!.interceptors.clear();
    _dio!.interceptors.add(InterceptorsWrapper(
      onRequest:(RequestOptions options, handler){
        logger.d("--> ${options.method} ${options.path}");
        logger.d("Content type: ${options.contentType}");
        logger.d("Request body: ${options.data}");
        logger.d("<-- END HTTP");
        return handler.next(options);
      },
      onResponse: (Response response, handler) {
        // Do something with response data
        logger.d("<-- ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}");
        String responseAsString = response.data.toString();
        if (responseAsString.length > maxCharactersPerLine) {
          int iterations = (responseAsString.length / maxCharactersPerLine).floor();
          for (int i = 0; i <= iterations; i++) {
            int endingIndex = i * maxCharactersPerLine + maxCharactersPerLine;
            if (endingIndex > responseAsString.length) {
              endingIndex = responseAsString.length;
            }
            print(responseAsString.substring(i * maxCharactersPerLine, endingIndex));
          }
        } else {
          logger.d(response.data);
        }
        logger.d("<-- END HTTP");
        return handler.next(response); // continue
      },
        onError: (DioError error,handler) async{
          // Do something with response error
          logger.e("DioError: ${error.message}");
          if (error.response?.statusCode == 402) {
            try {
              await _dio!.post(
                  "https://refresh.api",
                  data: jsonEncode(
                      {"refresh_token": refToken}))
                  .then((value) async {
                if (value.statusCode == 201) {
                  //get new tokens ...
                  //set bearer
                  error.requestOptions.headers["Authorization"] =
                      "Bearer " + token!;
                  //create request with new access token
                  final opts = Options(
                      method: error.requestOptions.method,
                      headers: error.requestOptions.headers);
                  final cloneReq = await _dio!.request(error.requestOptions.path,
                      options: opts,
                      data: error.requestOptions.data,
                      queryParameters: error.requestOptions.queryParameters);

                  return handler.resolve(cloneReq);
                }
                return handler.next(error);
              });
              return handler.next(error);
            } catch (e, st) {
              logger.e(e.toString());
            }
          }

          if (error.response?.statusCode == 401) {
            // Utils.showToast('Hết phiên làm việc');
            // libGetX.Get.offAll(LoginPage());
          }
          return handler.next(error); //continue
        })
    );
  }

  Future<Object> requestApi(Future<Response> request) async {
    try {
      Response response = await request;
      var data = response.data;
      if (data["statusCode"] == 200 || data["status"] == 200 || data["status"] == "OK") {
        return data;
      } else {
        if (data["statusCode"] == 423) {
          //showOverlay((context, t) => UpgradePopup(message: data["message"],));
        } else if (data["statusCode"] == 401) {
          try {
            // Authen authBloc =
            // BlocProvider.of<AuthenticationBloc>(context);
            // authBloc.add(LoggedOut());
          } catch (e) {
            debugPrint(e.toString());
          }
        }
        return data["message"];
      }
    } catch (error, stacktrace) {
      return _handleError(error);
    }
  }

  String _handleError(dynamic error) {
    String errorDescription = "";
    logger.e(error?.toString());
    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.sendTimeout:
          errorDescription = 'ErrorRTS';
          break;
        case DioErrorType.cancel:
          errorDescription = 'ErrorSWC';
          break;
        case DioErrorType.connectTimeout:
          errorDescription = 'ErrorCTS';
          break;
        case DioErrorType.other:
          errorDescription = 'ErrorTSF';
          break;
        case DioErrorType.receiveTimeout:
          errorDescription = 'ErrorRTR';
          break;
        case DioErrorType.response:
          var errorData = error.response?.data;
          String? message;
          int? code;
          if (!Utils.isEmpty(errorData)) {
            if(errorData is String){
              message = 'Error404';
              code = 404;
            } else{
              message = errorData["message"].toString();
              code = errorData["statusCode"];
            }
          } else {
            code = error.response!.statusCode;
          }
          errorDescription = message ?? "ErrorCode" + ': $code';
          if (code == 401) {
            try {
              //libGetX.Get.offAll(LoginPage());
              // MainBloc mainBloc = BlocProvider.of<MainBloc>(context);
              // mainBloc.add(LogoutMainEvent());
            } catch (e) {
              debugPrint(e.toString());
            }
          } else if (code == 423) {
            try {
              // AuthenticationBloc authBloc =
              // BlocProvider.of<AuthenticationBloc>(context);
              // authBloc.add(ShowUpgradeDialogEvent(message ?? ""));
            } catch (e) {
              debugPrint(e.toString());
            }
            //showOverlay((context, t) => UpgradePopup(message: message ?? "",), duration: Duration.zero);
          }
          break;
        default:
          errorDescription = 'Có lỗi xảy ra.';
      }
    } else {
      errorDescription = 'Có lỗi xảy ra.';
    }
    return errorDescription;
  }

  /// List API
  Future<Object> getConnection() async {
    return await requestApi(_dio!.get('api/check-connect'));
  }

  Future<Object> login(LoginRequest request) async {
    return await requestApi(_dio!.post('/api/v1/users/signin', data: request.toJson()));
  }

  Future<Object> getCompanies(String token) async {
    return await requestApi(_dio!.get('/api/v1/users/companies', options: Options(headers: {"Authorization": "Bearer $token"}))); //["Authorization"] = "Bearer " + token
  }

  Future<Object> config(ConfigRequest request) async {
    return await requestApi(_dio!.post('/api/v1/users/config', data: request.toJson()));
  }

  Future<Object> getUnits(String token) async {
    return await requestApi(_dio!.get('/api/v1/users/units', options: Options(headers: {"Authorization": "Bearer $token"}))); //["Authorization"] = "Bearer " + token
  }

  Future<Object> getStore(String token, String unitId) async {
    return await requestApi(_dio!.get('/api/v1/users/stores', options: Options(headers: {"Authorization": "Bearer $token"}), queryParameters: {
      "unitId": unitId,
    }));
  }

  Future<Object> updateUId(String token,String uId) async {
    return await requestApi(_dio!.post('/api/v1/users/update-uid-user', options: Options(headers: {"Authorization": "Bearer $token"}), queryParameters: {
      "UIdUser": uId,
    }));
  }

  Future<Object> getDefaultData(String token) async {
    return await requestApi(_dio!.get('/api/v1/home', options: Options(headers: {"Authorization": "Bearer $token"}))); //["Authorization"] = "Bearer " + token
  }

  Future<Object> getData(ReportRequest request, String token) async {
    return await requestApi(_dio!.post('/api/v1/home/reports', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  ///order
  Future<Object> getItemMainGroup(String token) async {
    return await requestApi(_dio!.get('/api/v1/order/item-main-group', options: Options(headers: {"Authorization": "Bearer $token"}))); //["Authorization"] = "Bearer " + token
  }
  Future<Object> getListItemScanRequest(String token, String itemCode,String currency) async {
    return await requestApi(_dio!.get('/api/v1/order/scan-item', options: Options(headers: {"Authorization": "Bearer $token"}), queryParameters: {
      "ItemCode": itemCode,
      "Currency": currency
    })); //["Authorization"] = "Bearer " + token
  }
  Future<Object> getItemListSearchOrder(SearchListItemRequest request, String token) async {
    return await requestApi(_dio!.post('/api/v1/order/search-item', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }
  Future<Object> getItemGroup(String token, int groupType,int level) async {
    return await requestApi(_dio!.get('/api/v1/order/item-group', options: Options(headers: {"Authorization": "Bearer $token"}), queryParameters: {
      "GroupType": groupType,
      "Level":level
    })); //["Authorization"] = "Bearer " + token
  }

  Future<Object> confirmDNC(ConfirmDNCRequest request, String token) async {
    return await requestApi(_dio!.post('/api/v1/order/DNC-authorize', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  Future<Object> createDNC(CreateDNCRequest request, String token) async {
    return await requestApi(_dio!.post('/api/v1/order/TaoPhieuDNC', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  Future<Object> getDetailDNC(String token, String sttRec) async {
    return await requestApi(_dio!.post('/api/v1/order/DNC-detail', options: Options(headers: {"Authorization": "Bearer $token"}), queryParameters: {
      "stt_rec": sttRec
    })); //["Authorization"] = "Bearer " + token
  }

  Future<Object> getListDNCHistory(ListDNCRequest request, String token) async {
    return await requestApi(_dio!.post('/api/v1/order/DNC_list_history', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  Future<Object> reportFieldLookup(ReportFieldLookupRequest request, String token) async {
    return await requestApi(_dio!.post('/api/v1/report/report-field-lookup', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  Future<Object> timeKeeping(TimeKeepingRequest request,String token) async {
    return await requestApi(_dio!.post('/api/v1/todos/time-keeping', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  Future<Object> getListShipping(ListShippingRequest request, String token) async {
    return await requestApi(_dio!.post('/api/v1/fulfillment/getlist', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  Future<Object> getItemDetailShipping(GetItemShippingRequest request, String token) async {
    return await requestApi(_dio!.post('/api/v1/fulfillment/detail', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  Future<Object> confirmDetailShipping(ConfirmShippingRequest request, String token) async {
    return await requestApi(_dio!.post('/api/v1/fulfillment/cofirm', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  Future<Object> getProductDetail(String token, String itemCode,String currency) async {
    return await requestApi(_dio!.get('/api/v1/order/item-detail', options: Options(headers: {"Authorization": "Bearer $token"}), queryParameters: {
      "ItemCode": itemCode,
      "Currency":currency
    })); //["Authorization"] = "Bearer " + token
  }

  Future<Object> getDiscountWhenUpdate(DiscountRequest request,String token) async {
    return await requestApi(_dio!.post('/api/v1/discount/get-discount-when-update', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  Future<Object> getItemDetailOrder(String token,String sttRec) async {
    return await requestApi(_dio!.post('/api/v1/order/order-detail', options: Options(headers: {"Authorization": "Bearer $token"}), queryParameters: {
      "stt_rec": sttRec,
    }));
  }

  Future<Object> calculatorPayment(DiscountRequest request,String token) async {
    return await requestApi(_dio!.post('/api/v1/discount/checkdiscount', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  Future<Object> updateOrder(UpdateOrderRequest request, String token) async {
    return await requestApi(_dio!.post('/api/v1/order/create-update', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  Future<Object> createOrder(CreateOrderRequest request, String token) async {
    return await requestApi(_dio!.post('/api/v1/order/create-order', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  Future<Object> getListCustomer(ManagerCustomerRequestBody request, String token) async {
    return await requestApi(_dio!.post('/api/v1/customer/customer-list', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  Future<Object> getDetailCustomer(String token, String idCustomer) async {
    return await requestApi(_dio!.get('/api/v1/customer/customer-info', options: Options(headers: {"Authorization": "Bearer $token"}), queryParameters: {
      "CustomerCode": idCustomer
    })); //["Authorization"] = "Bearer " + token
  }

  Future<Object> getListHistoryOrder(ListHistoryOrderRequest request, String token) async {
    return await requestApi(_dio!.post('/api/v1/order/order-list', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  Future<Object> deleteOrderHistory(String token,String sttRec) async {
    return await requestApi(_dio!.post('/api/v1/order/order-cancel', options: Options(headers: {"Authorization": "Bearer $token"}), queryParameters: {
      "stt_rec": sttRec,
    }));
  }

  Future<Object> getListStageStatistic(StageStatisticRequest request, String token) async {
    return await requestApi(_dio!.post('/api/v1/order/command_list', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  Future<Object> getStoreList(StoreListRequest request, String token) async {
    return await requestApi(_dio!.post('/api/v1/order/site_list', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  Future<Object> updateTKCDDraft(CreateTKCDRequest request, String token) async {
    return await requestApi(_dio!.post('/api/v1/order/UpdateTKCDDrafts', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  Future<Object> createTKCD(CreateTKCDRequest request, String token) async {
    return await requestApi(_dio!.post('/api/v1/order/TaoPhieuTKCD', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  Future<Object> getDetailListStageStatistic(String token, String soCT) async {
    return await requestApi(_dio!.get('/api/v1/order/command_detail', options: Options(headers: {"Authorization": "Bearer $token"}), queryParameters: {
      "stt_rec": soCT
    })); //["Authorization"] = "Bearer " + token
  }

  // Future<Object> getListApproval(String token) async {
  //   return await requestApi(_dio!.get('/api/v1/letter-authority/letter-display', options: Options(headers: {"Authorization": "Bearer $token"}))); //["Authorization"] = "Bearer " + token
  // }

  Future<Object> getListApproval(EntityRequest request, String token) async {
    return await requestApi(_dio!.post('/api/v1/fulfillment/authorize_type_list', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  Future<Object> getHTMLApproval(String token, String letterId) async {
    return await requestApi(_dio!.get('/api/v1/letter-authority/detail', options: Options(headers: {"Authorization": "Bearer $token"}), queryParameters: {
      "LetterId": letterId,
    })); //["Authorization"] = "Bearer " + token
  }

  Future<Object> getListDetailApproval(ListApprovalDetailRequest request, String token) async {
    return await requestApi(_dio!.post('/api/v1/fulfillment/authorize_list', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  Future<Object> getStatusApprovalApproval(ListStatusApprovalRequest request, String token) async {
    return await requestApi(_dio!.post('/api/v1/fulfillment/authorize_status_list', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  Future<Object> acceptApprovalApproval(AcceptApprovalRequest request, String token) async {
    return await requestApi(_dio!.post('/api/v1/fulfillment/authorize', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  Future<Object> getListReports(String token) async {
    return await requestApi(_dio!.get('/api/v1/report/report-list', options: Options(headers: {"Authorization": "Bearer $token"}))); //["Authorization"] = "Bearer " + token
  }

  Future<Object> getListReportLayout(String token, String reportId) async {
    return await requestApi(_dio!.get('/api/v1/report/report-layout', options: Options(headers: {"Authorization": "Bearer $token"}), queryParameters: {
      "ReportId": reportId,
    })); //["Authorization"] = "Bearer " + token
  }

  Future<Object> getResultReport(ResultReportRequest request, String token) async {
    return await requestApi(_dio!.post('/api/v1/report/report-result', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  Future<Object> getPermissionUser(String token) async {
    return await requestApi(_dio!.get('/api/v1/users/get-permission-user', options: Options(headers: {"Authorization": "Bearer $token"}))); //["Authorization"] = "Bearer " + token
  }

  Future<Object> getSettingOption(String token) async {
    return await requestApi(_dio!.get('/api/v1/users/get-setting-options', options: Options(headers: {"Authorization": "Bearer $token"}))); //["Authorization"] = "Bearer " + token
  }

  Future<Object> getListDeliveryPlan(DeliveryPlanRequest request, String token) async {
    return await requestApi(_dio!.post('/api/v1/fulfillment/list_delivery_plan', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  Future<Object> getDetailDeliveryPlan(DeliveryPlanDetailRequest request, String token) async {
    return await requestApi(_dio!.post('/api/v1/fulfillment/detail_delivery_plan', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  Future<Object> updatePlanDeliveryDraft(UpdatePlanDeliveryRequest request, String token) async {
    return await requestApi(_dio!.post('/api/v1/fulfillment/update_delivery_plan', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  Future<Object> createPlanDelivery(UpdatePlanDeliveryRequest request, String token) async {
    return await requestApi(_dio!.post('/api/v1/fulfillment/create_delivery_plan', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

  Future<Object> getListCheckIn(ListCheckInRequest request, String token) async {
    return await requestApi(_dio!.post('/api/v1/todos/list-check-in', options: Options(headers: {"Authorization": "Bearer $token"}), data: request.toJson()));
  }

}