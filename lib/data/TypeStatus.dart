///#用户状态
///无资质(0, "无资质","No qualification"),
/// 审核中(1, "审核中","In the review"),
///审核通过(2, "审核通过","Approved"),
///审核未通过(3, "审核未通过","Audit failed");

/// #订单状态
/// 待维修商投标(0, "待维修商投标", "To be tendered by the maintainer"),
/// 待选择维修商(1, "待选择维修商", "To select maintainer"),
/// 维修中(2, "维修中", "In the maintenance"),
/// 待中介确认维修结果(3, "待维修商投标", "Wait for the intermediary to confirm the maintenance results"),
/// 已完成订单(4, "已完成订单", "Completed order"),
/// 中止(5, "中止", "break down");

/// #用户发布问题状态
///正常(0, "正常","NEW"),
///维修中(1, "维修中","PROGRESSING"),
///完成(2, "完成","FINISHED"),
///拒绝(3, "拒绝","BEJECTED");

///#房屋状态
///正常(0, "正常","normal"),
///维修中(1, "维修中","PROGRESSING");
///

class TypeStatus {
  int value;
  String desc;
  String descEn;
  bool checked = false;

  TypeStatus(this.value, this.desc, this.descEn);

  TypeStatus.fromJson(Map<String, dynamic> json)
      : value = json["value"],
        desc = json["desc"],
        descEn = json["descEn"] == "Lessee" ? "Tenant" : json["descEn"],
        checked = json["checked"] ?? false;

  Map<String, dynamic> toJson() => {
        "value": value,
        "desc": desc,
        "descEn": descEn,
        "checked": checked,
      };

  static final agency = TypeStatus(1, "中介", "Agency");
  static final landlord = TypeStatus(2, "房东", "Landlord");
  static final tenant = TypeStatus(3, "房客", "Tenant");
  static final vendor = TypeStatus(4, "维修商", "Vendor");
  static final List<TypeStatus> userType = [
    agency,
    landlord,
    tenant,
    vendor,
  ];
  static final List<TypeStatus> userStatus = [
    TypeStatus(0, "无资质", "No qualification"),
    TypeStatus(1, "审核中", "In the review"),
    TypeStatus(2, "审核通过", "Approved"),
    TypeStatus(3, "审核未通过", "Audit failed"),
  ];

  static final questionNew = TypeStatus(0, "正常", "NEW");
  static final questionProgressing = TypeStatus(1, "维修中", "PROGRESSING");
  static final questionFinished = TypeStatus(2, "完成", "FINISHED");
  static final questionRejected = TypeStatus(3, "拒绝", "REJECTED");
  static final List<TypeStatus> questionStatus = [
    questionNew,
    questionProgressing,
    questionFinished,
    questionRejected,
  ];

  static final orderWaiting =
      TypeStatus(0, "待维修商投标", "To be tendered by the maintainer");
  static final orderSelecting = TypeStatus(1, "待选择维修商", "To select maintainer");
  static final orderProgressing = TypeStatus(2, "维修中", "In the maintenance");
  static final orderConfirming = TypeStatus(3, "待维修商确认",
      "Wait for the intermediary to confirm the maintenance results");
  static final orderFinished = TypeStatus(4, "已完成订单", "Completed order");
  static final orderRejected = TypeStatus(5, "中止", "break down");
  static final List<TypeStatus> orderStatus = [
    orderWaiting,
    orderSelecting,
    orderProgressing,
    orderConfirming,
    orderFinished,
    orderRejected,
  ];

  static final houseNormal = TypeStatus(0, "正常", "normal");
  static final houseOngoing = TypeStatus(1, "维修中", "ongoing");
  static final List<TypeStatus> houseStatus = [houseNormal, houseOngoing];

  ///House，Apartment，Townhouse，Land，Rural
  static final List<TypeStatus> houseType = [
    TypeStatus(1, "房子", "House"),
    TypeStatus(2, "公寓", "Apartment"),
    TypeStatus(3, "联排别墅", "Townhouse"),
    TypeStatus(4, "农场房", "Land"),
    TypeStatus(5, "城镇房", "Rural"),
  ];

  static final repairToQuote = TypeStatus(-1, "待确认", "To Quote");
  static final repairPending = TypeStatus(0, "待确认", "Pending");
  static final repairProcessing = TypeStatus(1, "维修中", "Processing");
  static final repairRejected = TypeStatus(2, "拒绝", "Rejected");
  static final repairConfirm =
      TypeStatus(3, "待中介确认维修结果", "To be confirmed by agency");
  static final repairFinished = TypeStatus(4, "已完成", "Finished");
  static final repairClosed = TypeStatus(5, "中止", "Closed");

  static final repairOrderStatus = [
    repairToQuote,
    repairPending,
    repairProcessing,
    repairRejected,
    repairConfirm,
    repairFinished,
    repairClosed,
  ];
}
