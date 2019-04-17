import 'package:house/importLib.dart';
import 'package:image_picker_flutter/model/AssetData.dart';

class VendorRepairResults extends BaseStatefulWidget {
  ///订单id
  final String orderId;

  ///报价id
  final String repairQuoteId;

  VendorRepairResults(this.orderId, this.repairQuoteId);

  @override
  _VendorRepairResultsState createState() => _VendorRepairResultsState();
}

class _VendorRepairResultsState
    extends BaseAppBarAndBodyState<VendorRepairResults> {
  final TextEditingController _controller = TextEditingController();
  final List<File> _images = [];

  @override
  BaseAppBar appBar(BuildContext context) {
    return TitleAppBar(
      context: context,
      title: TitleAppBar.appBarTitle(
        HouseValue.of(context).repairResults,
      ),
      navigatorBack: TitleAppBar.navigatorBackBlack(context),
      menu: TitleAppBar.appBarMenu(
        context,
        onPressed: () async {
          _repairQuoteResultSubmit();
        },
        menu: Text(
          HouseValue.of(context).submit,
          style: createTextStyle(
            color: HouseColor.green,
            fontSize: 17,
            fontFamily: fontFamilySemiBold,
          ),
        ),
      ),
    );
  }

  @override
  Widget body(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: HouseColor.lightGray,
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextFormField(
              enabled: true,
              controller: _controller,
              maxLines: 12,
              maxLength: 400,
              style: createTextStyle(),
              decoration: InputDecoration(
                  enabled: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(8),
                  hintText: "Please enter description"),
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == _images.length) {
                  return FlatButton(
                    color: HouseColor.lightGray,
                    onPressed: () {
                      ImagePicker.mulPicker(
                        context,
                        data: _getAssetDataList(),
                        limit: 9,
                        type: ImagePickerType.onlyImage,
                        placeholder: AssetImage(
                            "image/house_loading_image_placeholder.webp"),
                        appBarColor: HouseColor.blue,
                        mulCallback: (data) {
                          setState(() {
                            this._images.clear();
                            this._images.addAll(
                                  data.map((a) => File(a.path)),
                                );
                          });
                        },
                      );
                    },
                    child: Image.asset(
                      "image/house_photo.webp",
                    ),
                  );
                } else {
                  return Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: <Widget>[
                      Image.file(
                        _images[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: FlatButton(
                          color: HouseColor.halfTransparent,
                          onPressed: () {
                            _images.removeAt(index);
                            setState(() {});
                          },
                          child: Text(
                            "X",
                            style: createTextStyle(
                              color: HouseColor.red,
                              fontSize: 20,
                            ),
                          ),
                          padding: EdgeInsets.only(),
                        ),
                      )
                    ],
                  );
                }
              },
              childCount: _images.length + 1,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
          ),
        )
      ],
    );
  }

  List<AssetData> _getAssetDataList() {
    return _images.map((a) => AssetData.fromJson({"path": a.path})).toList();
  }

  void _repairQuoteResultSubmit() async {
    showLoadingDialog(context);
    await repairQuoteResultSubmit(
      context,
      widget.orderId,
      widget.repairQuoteId,
      _controller.text,
      _images,
      cancelToken: cancelToken,
    ).then((value) {
      pop(context);
      pop(context);
    }).catchError((e) {
      pop(context);
      showToast(context, e.toString());
    });
  }
}
