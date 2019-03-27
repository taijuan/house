import 'package:flutter/cupertino.dart';
import 'package:house/importLib.dart';
import 'package:intl/intl.dart';

class CertificatePage extends BaseStatefulWidget {
  final Certificate data;
  final bool isShowSubmit;

  CertificatePage({this.data, this.isShowSubmit = true});

  @override
  BaseState createState() => _CertificatePageState();
}

class _CertificatePageState extends BaseAppBarAndBodyState<CertificatePage> {
  @override
  BaseAppBar appBar(BuildContext context) => TitleAppBar(
        context: context,
        navigatorBack: TitleAppBar.navigatorBackBlack(context),
        title: TitleAppBar.appBarTitle(HouseValue.of(context).certificate),
        menu: widget.isShowSubmit
            ? TitleAppBar.appBarMenu(
                context,
                onPressed: _saveCertificateDialog,
                menu: Text(
                  HouseValue.of(context).submit,
                  style: createTextStyle(color: HouseColor.green),
                ),
              )
            : null,
      );

  _saveCertificateDialog() {
    showAlertDialog(
      context,
      content: HouseValue.of(context).areYouSureToModifyThisCertificate,
      onOkPressed: _saveCertificate,
    );
  }

  _saveCertificate() {
    if (DataUtils.isEmpty(widget.data.type)) {
      showToast(context, "");
      return;
    }
    if (DataUtils.isEmpty(widget.data.certificateNo)) {
      showToast(context, "");
      return;
    }
    if (DataUtils.isEmpty(widget.data.endDate)) {
      showToast(context, "");
      return;
    }
    if (DataUtils.isEmpty(widget.data.picUrl) && widget.data.imgStr == null) {
      showToast(context, "");
      return;
    }
    showLoadingDialog(context);
    saveCertificate(
      context: context,
      id: widget.data.id,
      endDate: widget.data.endDate,
      imgStr: widget.data.imgStr,
      imageName: widget.data.imageName,
      thumbUrl: widget.data.thumbUrl,
      picUrl: widget.data.picUrl,
      type: widget.data.type,
      certificateNo: widget.data.certificateNo,
      cancelToken: cancelToken,
    )
      ..then((v) {
        pop(context);
        pop(context, result: true);
      })
      ..catchError((e) {
        pop(context);
        showToast(context, e.toString());
      });
  }

  @override
  Widget body(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(),
      children: <Widget>[
        _nameAndValue(
          onPressed: () {
            push<List<Tag>>(
              context,
              TagHome(
                selectData: widget.data.type == null
                    ? []
                    : [
                        Tag.fromJson({"id": widget.data.type}),
                      ],
                isSingle: true,
              ),
            ).then((tags) {
              if (tags == null) {
              } else if (tags.isEmpty) {
                widget.data.type = null;
                widget.data.typeName = "";
                setState(() {});
              } else {
                widget.data.type = tags.first.id;
                widget.data.typeName = tags.first.name;
                setState(() {});
              }
            });
          },
          name: HouseValue.of(context).type,
          value: widget.data.typeName,
        ),
        _nameAndValue(
          onPressed: () {
            push<String>(
              context,
              TextFieldPage(
                HouseValue.of(context).licenseNo,
                value: widget.data.certificateNo,
                maxLength: 40,
                maxLines: 2,
              ),
            ).then((licenseNo) {
              if (licenseNo != null) {
                widget.data.certificateNo = licenseNo;
                setState(() {});
              }
            });
          },
          name: HouseValue.of(context).licenseNo,
          value: widget.data.certificateNo,
        ),
        _nameAndValue(
          onPressed: _buildShowDatePop,
          name: HouseValue.of(context).expireDate,
          value: widget.data.endDate,
        ),
        _nameAndValue(
          onPressed: () {
            ImagePicker.pickImage(
              source: ImageSource.gallery,
            ).then((f) {
              if (f != null) {
                widget.data.imgStr = f;
                widget.data.imageName = f.path;
                setState(() {});
              }
            });
          },
          name: HouseValue.of(context).certificate,
          value: "",
        ),
        Card(
          margin: EdgeInsets.all(12),
          child: _getImage(),
          elevation: 0,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          borderOnForeground: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: HouseColor.divider,
              width: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _nameAndValue({
    VoidCallback onPressed,
    String name,
    String value,
    bool showNull = false,
  }) {
    if (showNull) {
      return Container(
        width: 0,
        height: 0,
      );
    }
    return RawMaterialButton(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      constraints: BoxConstraints(maxWidth: 0, minHeight: 48),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: widget.isShowSubmit ? onPressed : null,
      shape: Border(
        bottom: BorderSide(
          color: HouseColor.divider,
          width: 0.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            name ?? "",
            style: createTextStyle(color: HouseColor.gray),
          ),
          Container(width: 24),
          Expanded(
            child: Text(
              value ?? "",
              textAlign: TextAlign.right,
              style: createTextStyle(),
            ),
          ),
          Container(width: 8),
          Transform.rotate(
            angle: pi,
            child: Icon(
              HouseIcons.backIcon,
              color: HouseColor.gray,
              size: 14,
            ),
          )
        ],
      ),
    );
  }

  Widget _getImage() {
    if (widget.data.imgStr != null) {
      return FadeInImage(
        placeholder: AssetImage("image/house_loading_image_placeholder.webp"),
        image: FileImage(widget.data.imgStr),
      );
    } else if (DataUtils.getImageUrl(widget.data.picUrl).isNotEmpty) {
      return HouseCacheNetworkImage(DataUtils.getImageUrl(widget.data.picUrl));
    } else {
      return Container(width: 0, height: 0);
    }
  }

  _buildShowDatePop() {
    return showCupertinoModalPopup<void>(
        context: context,
        builder: (context) {
          return _buildBottomPicker(
            CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: buildParse(widget.data.endDate),
              onDateTimeChanged: (DateTime newDateTime) {
                setState(
                  () => widget.data.endDate =
                      DateFormat("MMM d,yyyy").format(newDateTime),
                );
              },
            ),
          );
        });
  }

  DateTime buildParse(String input) {
    try {
      return DateFormat("MMM d,yyyy").parse(input);
    } catch (e) {
      return DateTime.now();
    }
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: 240,
      color: HouseColor.transparent,
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: picker,
        ),
      ),
    );
  }
}
