import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:house/importLib.dart';
import 'package:house/utils/FileUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<User> login(
  BuildContext context,
  String account,
  String password, {
  CancelToken cancelToken,
}) async {
  BaseRes res = await HttpManager.post(
    context,
    path: "/login",
    data: {
      "account": account,
      "password": password,
    },
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    return User.fromJson(res.data);
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

Future<dynamic> retrievePassword(
  BuildContext context,
  String account, {
  CancelToken cancelToken,
}) async {
  BaseRes res = await HttpManager.post(
    context,
    path: "/retrievePassword",
    data: {
      "account": account,
    },
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    return res.data;
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

Future<String> sendEmail(
  BuildContext context,
  String account, {
  CancelToken cancelToken,
}) async {
  BaseRes res = await HttpManager.post(
    context,
    path: "/sendEmail",
    data: {
      "account": account,
    },
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    return res.data;
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

Future<User> register(
  BuildContext context, {
  String id,
  String account,
  String password,
  int type,
  String firstName,
  String lastName,
  String companyName,
  CancelToken cancelToken,
}) async {
  BaseRes res = await HttpManager.post(
    context,
    path: "/register",
    data: {
      "id": id,
      "account": account,
      "password": password,
      "firstName": firstName,
      "lastName": lastName,
      "companyName": companyName,
      "type": type,
    },
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    return User.fromJson(res.data);
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

Future<User> checkPollCode(
  BuildContext context,
  String pollCode, {
  CancelToken cancelToken,
}) async {
  BaseRes res = await HttpManager.post(
    context,
    path: "/checkPollCode",
    data: {
      "pollCode": pollCode,
    },
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    return User.fromJson(res.data);
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

Future<User> modifyUserInfo(
  BuildContext context, {
  String email,
  String password,
  String oldPassword,
  File imgStr,
  String imageName,
  String tel,
  String companyName,
  String companyProfile,
  String address,
  List<CityArea> cityArea,
  String firstName,
  String lastName,
  CancelToken cancelToken,
}) async {
  String id = (await User.getUser()).id;
  Map<String, dynamic> data = {
    "id": id,
    "email": email,
    "password": password,
    "oldPassword": oldPassword,
    "imgStr": await FileUtils.compressWithFileToBase64(imgStr),
    "imageName": imgStr?.path,
    "tel": tel,
    "companyName": companyName,
    "companyProfile": companyProfile,
    "address": address,
    "firstName": firstName,
    "lastName": lastName,
  };
  int i = 0;
  cityArea?.forEach((city) {
    if (city.checked) {
      data.putIfAbsent("userAreaList[$i].cityId", () {
        return city.id;
      });
      data.putIfAbsent("userAreaList[$i].checkAll", () {
        return 1;
      });
      i++;
    } else {
      city.districtList.forEach((d) {
        data.putIfAbsent("userAreaList[$i].cityId", () {
          return city.id;
        });
        data.putIfAbsent("userAreaList[$i].districtId", () {
          return d.id;
        });
        i++;
      });
    }
  });

  BaseRes res = await HttpManager.post(
    context,
    path: "/modifyUserInfo",
    data: data,
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    return User.fromJson(res.data);
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

Future<List<House>> getHouseList(
  BuildContext context,
  int currentPage, {
  CancelToken cancelToken,
}) async {
  final User user = await User.getUser();
  final String id = user.id;
  final int userType = user.type?.value ?? 0;
  Map<String, dynamic> data = {
    "userId": id,
    "userType": userType,
    "currentPage": currentPage,
    "pageSize": 10,
  };
  if (userType == TypeStatus.userType[0].value) {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<dynamic> a =
        json.decode(sp.getString(FilterPage.house_type) ?? "[]") ?? [];
    List<TypeStatus> aa = a.map((a) {
      return TypeStatus.fromJson(a);
    }).toList();
    String b = sp.getString(FilterPage.house_area) ?? "[]";
    List<dynamic> bb = json.decode(b) ?? [];
    List<CityArea> bbb = bb.map((a) {
      return CityArea.fromJson(a);
    }).toList();
    data.putIfAbsent("types", () {
      return aa.map((tag) {
        return tag.value;
      }).toList();
    });
    data.putIfAbsent("cityList", () {
      return bbb.where((area) {
        return area.checked;
      }).map((area) {
        return area.id;
      }).toList();
    });

    data.putIfAbsent("districtList", () {
      List<String> _data = [];
      bbb.where((area) {
        return !area.checked;
      }).forEach((area) {
        area.districtList.forEach((area) {
          _data.add(area.id);
        });
      });
      return _data;
    });
  }
  BaseRes res = await HttpManager.post(
    context,
    path: "/queryHouseList",
    data: data,
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    List<dynamic> a = res.data["dataList"] ?? [];
    return a.map((json) {
      LogUtils.log(json["repairStatus"]);
      LogUtils.log("\n################################\n");
      return House.fromJson(json);
    }).toList();
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

Future<dynamic> insertQuestionInfo(
  BuildContext context,
  String houseId,
  String description,
  List<File> images, {
  CancelToken cancelToken,
}) async {
  String id = (await User.getUser()).id;
  Map<String, dynamic> data = {
    "userId": id,
    "houseId": houseId,
    "description": description,
  };
  for (File f in images) {
    String a = await FileUtils.compressWithFileToBase64(f);
    data.putIfAbsent("photos.content[${images.indexOf(f)}].imgStr", () {
      return a;
    });
    data.putIfAbsent("photos.content[${images.indexOf(f)}].imageName", () {
      return f.path;
    });
  }
  BaseRes res = await HttpManager.post(
    context,
    path: "/insertQuestionInfo",
    data: data,
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    return res.data;
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

Future<List<Question>> selectQuestionInfoPageList(
  BuildContext context,
  int currentPage, {
  String houseId,
  CancelToken cancelToken,
}) async {
  User user = await User.getUser();
  Map<String, dynamic> data = {
    "userId": user.id,
    "userType": user.type.value,
    "houseId": houseId,
    "currentPage": currentPage,
    "pageSize": 10,
  };
  BaseRes res = await HttpManager.post(
    context,
    path: "/selectQuestionInfoPageList",
    data: data,
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    List a = res.data["dataList"] ?? [];
    return a.map((v) {
      return Question.fromJson(v);
    }).toList();
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

Future<House> houseDetail(
  BuildContext context,
  String houseId, {
  CancelToken cancelToken,
}) async {
  String id = (await User.getUser()).id;
  Map<String, dynamic> data = {
    "userId": id,
    "houseId": houseId,
  };
  BaseRes res = await HttpManager.post(
    context,
    path: "/houseDetail",
    data: data,
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    LogUtils.log("zuiweng     ${res.data["repairOrderList"]}");
    Map<String, dynamic> data = res.data["house"];
    data.putIfAbsent("repairOrderList", () {
      return res.data["repairOrderList"];
    });
    return House.fromJson(res.data["house"]);
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

Future<QuestionDetail> selectQuestionDetail(
  BuildContext context,
  String id, {
  CancelToken cancelToken,
}) async {
  BaseRes res = await HttpManager.post(
    context,
    path: "/selectQuestionInfoById",
    data: {
      "id": id,
    },
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    return QuestionDetail.fromJson(res.data);
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

Future<dynamic> insertRepairOrder(
  BuildContext context,
  String id,
  String type,
  String title,
  String desc, {
  CancelToken cancelToken,
}) async {
  BaseRes res = await HttpManager.post(
    context,
    path: "/insertRepairOrder",
    data: {
      "questionId": id,
      "type": type,
      "title": title,
      "desc": desc,
    },
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    return res.data;
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

Future<List<Order>> selectRepairOrderPageList(
  BuildContext context,
  int currentPage, {
  String houseId,
  int status,
  CancelToken cancelToken,
}) async {
  User user = await User.getUser();
  var path = "/selectRepairOrderPageList";
  if (user.type.value != TypeStatus.vendor.value) {
    path = "/selectRepairOrderPageList";
  } else if (status == -1) {
    path = "/selectWaitingOrderPageList";
  } else {
    path = "/selectUserRepairQuotePageList";
  }
  BaseRes res = await HttpManager.post(
    context,
    path: path,
    data: {
      "userId": user.id,
      "userType": user.type.value,
      "houseId": houseId,
      "status": status,
      "currentPage": currentPage,
      "pageSize": 10,
    },
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    return DataUtils.isList(res.data["dataList"]).map((json) {
      return Order.fromJson(DataUtils.isMap(json));
    }).toList();
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

Future<dynamic> insertRepairQuote(
  BuildContext context,
  String repairOrderId,
  String price,
  String desc, {
  CancelToken cancelToken,
}) async {
  BaseRes res = await HttpManager.post(
    context,
    path: "/insertRepairQuote",
    data: {
      "userId": (await User.getUser()).id,
      "repairOrderId": repairOrderId,
      "price": price,
      "desc": desc,
    },
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    return res.data;
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

Future<OrderDetail> selectRepairOrderById(
  BuildContext context,
  String orderId,
  String repairQuoteId, {
  CancelToken cancelToken,
}) async {
  BaseRes res = await HttpManager.post(
    context,
    path: "/selectRepairOrderById",
    data: {
      "orderId": DataUtils.isEmpty(repairQuoteId) ? orderId : null,
      "repairQuoteId": repairQuoteId,
      "userType": (await User.getUser()).type.value,
      "userId": (await User.getUser()).id,
    },
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    return OrderDetail.fromJson(res.data);
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

Future<QuotationList> selectRepairQuotePageList(
  BuildContext context,
  String id,
  int currentPage, {
  CancelToken cancelToken,
}) async {
  BaseRes res = await HttpManager.post(
    context,
    path: "/selectRepairQuotePageList",
    data: {
      "repairOrderId": id,
      "currentPage": currentPage,
      "pageSize": 10,
    },
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    return QuotationList(
      DataUtils.isList(res.data["pageView"]["dataList"]).map((json) {
        return Quotation.fromJson(json);
      }).toList(),
      res.data["transactor"],
    );
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

Future<dynamic> authorizedAgentsRepairOrder(
  BuildContext context,
  String id, {
  CancelToken cancelToken,
}) async {
  BaseRes res = await HttpManager.post(
    context,
    path: "/authorizedAgentsRepairOrder",
    data: {
      "id": id,
    },
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    return res.data;
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

Future<dynamic> repairOrderDesignateQuote(
  BuildContext context,
  String quotationId,
  String orderId, {
  CancelToken cancelToken,
}) async {
  BaseRes res = await HttpManager.post(
    context,
    path: "/repairOrderDesignateQuote",
    data: {
      "id": quotationId,
      "repairOrderId": orderId,
    },
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    return res.data;
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

///维修商维修结果提交
Future<dynamic> repairQuoteResultSubmit(
  BuildContext context,
  String orderId,
  String repairOrderId,
  String desc,
  List<File> images, {
  CancelToken cancelToken,
}) async {
  Map<String, dynamic> data = {
    "id": orderId,
    "repairOrderId": repairOrderId,
    "resultDesc": desc,
  };

  for (File f in images) {
    String a = await FileUtils.compressWithFileToBase64(f);
    data.putIfAbsent("photos.content[${images.indexOf(f)}].imgStr", () {
      return a;
    });
    data.putIfAbsent("photos.content[${images.indexOf(f)}].imageName", () {
      return f.path;
    });
  }
  BaseRes res = await HttpManager.post(
    context,
    path: "/repairQuoteResultSubmit",
    data: data,
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    return res.data;
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

///维修商选择资质证明的类型  data不能为空
Future<List<Tag>> getVendorCertificateType(
  BuildContext context, {
  CancelToken cancelToken,
}) async {
  final User user = await User.getUser();
  final String id = user.id;
  final int userType = user.type?.value ?? 0;
  BaseRes res = await HttpManager.post(
    context,
    path: "/selectRepairTypeList",
    data: {"userId": id, "userType": userType},
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    List<dynamic> a = res.data ?? [];
    return a.map((json) {
      return Tag.fromJson(json);
    }).toList();
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

///获取城市地区 ，获取Area地区
Future<List<CityArea>> getCityList(
  BuildContext context, {
//  bool isDoUserId,
  String pid,
  CancelToken cancelToken,
}) async {
  BaseRes res = await HttpManager.post(
    context,
    path: "/selectAreaList",
    data: {
//      "userId": isDoUserId ? (await User.getUser()).id : null,
      "pid": pid,
    },
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    List<dynamic> a = res.data ?? [];
    return a.map((json) {
      return CityArea.fromJson(json);
    }).toList();
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

Future<dynamic> finishOrCloseRepairOrderStatus(
  BuildContext context,
  String id,
  int status,
  String content, {
  CancelToken cancelToken,
}) async {
  BaseRes res = await HttpManager.post(
    context,
    path: "/finishOrCloseRepairOrderStatus",
    data: {
      "id": id,
      "status": status,
      "resultDesc": content,
    },
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    return res.data;
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

Future<dynamic> finishOrRejectQuestionInfoStatus(
  BuildContext context,
  String id,
  int status, {
  CancelToken cancelToken,
}) async {
  BaseRes res = await HttpManager.post(
    context,
    path: "/finishOrRejectQuestionInfoStatus",
    data: {
      "id": id,
      "status": status,
    },
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    return res.data;
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

//queryRepairUsers

Future<List<User>> queryRepairUsers(
  BuildContext context,
  int currentPage, {
  CancelToken cancelToken,
}) async {
  final User user = await User.getUser();
  final String id = user.id;
  final int userType = user.type?.value ?? 0;
  Map<String, dynamic> data = {
    "userId": id,
    "userType": userType,
    "currentPage": currentPage,
    "pageSize": 10,
  };

  SharedPreferences sp = await SharedPreferences.getInstance();
  List<dynamic> a =
      json.decode(sp.getString(FilterPage.vendor_type) ?? "[]") ?? [];
  List<Tag> aa = a.map((a) {
    return Tag.fromJson(a);
  }).toList();
  String b = sp.getString(FilterPage.vendor_area) ?? "[]";
  List<dynamic> bb = json.decode(b) ?? [];
  List<CityArea> bbb = bb.map((a) {
    return CityArea.fromJson(a);
  }).toList();
  data.putIfAbsent("types", () {
    return aa.map((tag) {
      return tag.id;
    }).toList();
  });
  data.putIfAbsent("cityList", () {
    return bbb.where((area) {
      return area.checked;
    }).map((area) {
      return area.id;
    }).toList();
  });

  data.putIfAbsent("districtList", () {
    List<String> _data = [];
    bbb.where((area) {
      return !area.checked;
    }).forEach((area) {
      area.districtList.forEach((area) {
        _data.add(area.id);
      });
    });
    return _data;
  });

  BaseRes res = await HttpManager.post(
    context,
    path: "/queryRepairUsers",
    data: data,
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    List<dynamic> a = res.data["dataList"] ?? [];
    return a.map((json) {
      return User.fromJson(json);
    }).toList();
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

Future<dynamic> saveRepairMessage(
  BuildContext context,
  String repairOrderId,
  String message,
  String receiveUserId, {
  CancelToken cancelToken,
}) async {
  final User user = await User.getUser();
  final String id = user.id;
  BaseRes res = await HttpManager.post(
    context,
    path: "/saveRepairMessage",
    data: {
      "sendUserId": id,
      "repairOrderId": repairOrderId,
      "message": message,
      "receiveUserId": receiveUserId,
    },
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    return res.data;
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

Future<User> getUserDetail(
  BuildContext context,
  String userId, {
  CancelToken cancelToken,
}) async {
  BaseRes res = await HttpManager.post(
    context,
    path: "/getUserDetail",
    data: {
      "userId": userId,
    },
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    return User.fromJson(res.data);
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

Future<List<LatLonHouse>> queryHouseLocal(
  BuildContext context, {
  CancelToken cancelToken,
}) async {
  final User user = await User.getUser();
  final String id = user.id;
  final int userType = user.type?.value ?? 0;
  Map<String, dynamic> data = {
    "userId": id,
    "userType": userType,
  };
  if (userType == TypeStatus.userType[0].value) {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<dynamic> a =
        json.decode(sp.getString(FilterPage.house_type) ?? "[]") ?? [];
    List<TypeStatus> aa = a.map((a) {
      return TypeStatus.fromJson(a);
    }).toList();
    String b = sp.getString(FilterPage.house_area) ?? "[]";
    List<dynamic> bb = json.decode(b) ?? [];
    List<CityArea> bbb = bb.map((a) {
      return CityArea.fromJson(a);
    }).toList();
    data.putIfAbsent("types", () {
      return aa.map((tag) {
        return tag.value;
      }).toList();
    });
    data.putIfAbsent("cityList", () {
      return bbb.where((area) {
        return area.checked;
      }).map((area) {
        return area.id;
      }).toList();
    });

    data.putIfAbsent("districtList", () {
      List<String> _data = [];
      bbb.where((area) {
        return !area.checked;
      }).forEach((area) {
        area.districtList.forEach((area) {
          _data.add(area.id);
        });
      });
      return _data;
    });
  }
  BaseRes res = await HttpManager.post(
    context,
    path: "/queryHouseLocal",
    data: data,
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    List<dynamic> a = res.data ?? [];
    return a.map((json) {
      LogUtils.log(json["repairStatus"]);
      LogUtils.log("\n################################\n");
      return LatLonHouse.fromJson(json);
    }).toList();
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

Future<List<Certificate>> selectCertificatePageList(
  BuildContext context, {
  CancelToken cancelToken,
}) async {
  Map<String, dynamic> data = {
    "userId": (await User.getUser()).id,
    "status": 4,
  };
  BaseRes res = await HttpManager.post(
    context,
    path: "/selectCertificatePageList",
    data: data,
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    List<dynamic> a = res.data["dataList"] ?? [];
    return a.map((json) {
      return Certificate.fromJson(json);
    }).toList();
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

Future<dynamic> deleteCertificate({
  BuildContext context,
  String id,
  CancelToken cancelToken,
}) async {
  BaseRes res = await HttpManager.post(
    context,
    path: "/deleteCertificate",
    data: {
      "id": id,
      "userId": (await User.getUser()).id,
    },
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    return res;
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

Future<dynamic> saveCertificate({
  BuildContext context,
  String id,
  String endDate,
  File imgStr,
  String imageName,
  String thumbUrl,
  String picUrl,
  String type,
  String certificateNo,
  CancelToken cancelToken,
}) async {
  BaseRes res = await HttpManager.post(
    context,
    path: "/saveCertificate",
    data: {
      "id": id,
      "userId": (await User.getUser()).id,
      "endDate": endDate,
      "imageName": imageName,
      "thumbUrl": thumbUrl,
      "picUrl": picUrl,
      "type": type,
      "certificateNo": certificateNo,
      "imgStr": await FileUtils.compressWithFileToBase64(imgStr),
    },
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    return res;
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

Future<dynamic> deleteQuestionInfoById({
  BuildContext context,
  String id,
  CancelToken cancelToken,
}) async {
  BaseRes res = await HttpManager.post(
    context,
    path: "/deleteQuestionInfoById",
    data: {
      "id": id,
      "userId": (await User.getUser()).id,
    },
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    return res;
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}

Future<dynamic> deleteRepairOrderById({
  BuildContext context,
  String id,
  CancelToken cancelToken,
}) async {
  BaseRes res = await HttpManager.post(
    context,
    path: "/deleteRepairOrderById",
    data: {
      "id": id,
      "userId": (await User.getUser()).id,
    },
    cancelToken: cancelToken,
  );
  if (res.code == "200") {
    return res;
  } else {
    throw FlutterError(res.msg.msgEn);
  }
}
