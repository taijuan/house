class BaseRes {
  dynamic data;
  String code;
  Msg msg;
  String token;

  BaseRes(this.data, this.code, this.msg);

  BaseRes.fromJson(Map<String, dynamic> json)
      : data = json["data"],
        code = json['code'],
        msg = Msg.fromJson(json["msg"] ?? {}),
        token = json["token"];

  Map<String, dynamic> toJson() => {
        'data': data,
        'code': code,
        'msg': msg.toJson(),
        'token': token,
      };
}

class Msg {
  String code;
  String msgZh;
  String msgEn;

  Msg(this.code, this.msgZh, this.msgEn);

  Msg.fromJson(Map<String, dynamic> json)
      : code = json["code"],
        msgZh = json["msgZh"],
        msgEn = json["msgEn"];

  Map<String, dynamic> toJson() => {
        "code": code,
        "msgZh": msgZh,
        "msgEn": msgEn,
      };
}
