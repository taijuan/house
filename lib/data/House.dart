import 'package:house/importLib.dart';
import 'package:house/utils/DataUtils.dart';

class House {
  String id;
  String title;
  String landlordId;
  String landlordFirstName;
  String landlordLastName;
  String landlordEmail;
  String landlorPhone;
  String agencyId;
  String agencyFirstName;
  String agencyLastName;
  String agencyEmail;
  String agencyPhone;
  String tenantId;
  String tenantFirstName;
  String tenantLastName;
  String tenantEmail;
  String tenantPhone;
  ImageContent coverImg;
  ImageContent image;
  int status;
  TypeStatus repairStatus;
  int bedroomNum;
  int bathroomNum;
  int parkingNum;
  String floorArea;
  String completionTime; //"2018-10-23"
  String configure;
  String features;
  TypeStatus type;
  String fullAddress;
  String street;
  String address;
  String postalcode;
  String createTime;
  String desc;
  String contractNo;
  List<Repair> repairOrderList;

  House.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"],
        landlordFirstName = json["landlordFirstName"] ?? "",
        landlordLastName = json["landlordLastName"] ?? "",
        landlordEmail = json["landlordEmail"] ?? "",
        landlorPhone = json["landlorPhone"] ?? "",
        agencyId = json["agencyId"],
        landlordId = json["landlordId"],
        agencyFirstName = json["agencyFirstName"] ?? "",
        agencyLastName = json["agencyLastName"] ?? "",
        agencyEmail = json["agencyEmail"] ?? "",
        agencyPhone = json["agencyPhone"] ?? "",
        tenantId = json["tenantId"],
        tenantFirstName = json["tenantFirstName"] ?? "",
        tenantLastName = json["tenantLastName"] ?? "",
        tenantEmail = json["tenantEmail"] ?? "",
        tenantPhone = json["tenantPhone"] ?? "",
        coverImg = ImageContent.fromJson(DataUtils.isMap(json["coverImg"])),
        image = ImageContent.fromJson(DataUtils.isMap(json["image"])),
        status = json["stauts"] ?? 0,
        repairStatus =
            TypeStatus.fromJson(DataUtils.isMap(json["repairStatus"])),
        bedroomNum = json["bedroomNum"],
        bathroomNum = json["bathroomNum"],
        parkingNum = json["parkingNum"],
        floorArea = json["floorArea"],
        completionTime = json["completionTime"],
        configure = json["configure"],
        features = json["features"],
        type = TypeStatus.fromJson(DataUtils.isMap(json["type"])),
        street = json["street"],
        address = (json["address"] ?? "") +
            (json["street"] ?? "") +
            (json["fullAddress"] ?? ""),
        postalcode = json["postalcode"],
        createTime = json["createTime"],
        desc = json["desc"],
        contractNo = json["contractNo"],
        repairOrderList = DataUtils.isList(json["repairOrderList"]).map((v) {
          return Repair.fromJson(v);
        }).toList();

  String getLesseeName() {
    if (DataUtils.isEmpty(tenantFirstName) &&
        DataUtils.isEmpty(tenantLastName)) {
      return tenantEmail ?? "";
    } else if (DataUtils.isEmpty(tenantFirstName)) {
      return tenantLastName;
    } else if (DataUtils.isEmpty(tenantLastName)) {
      return tenantFirstName;
    } else {
      return "$tenantFirstName · $tenantLastName";
    }
  }
}
