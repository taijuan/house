import 'package:house/importLib.dart';

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
  int _status = 1;

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
        _buildRadioBt(),
        SliverToBoxAdapter(
          child: Container(
            color: HouseColor.lightGray,
            child: TextFormField(
              enabled: true,
              controller: _controller,
              maxLines: 12,
              style: createTextStyle(),
              decoration: InputDecoration(
                enabled: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
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
                      ImagePicker.pickImage(
                        source: ImageSource.gallery,
                      ).then((image) {
                        if (image != null) {
                          _images.add(image);
                          setState(() {});
                        }
                      });
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

  Widget _buildRadioBt() {
    return SliverToBoxAdapter(
      child: Row(
        children: <Widget>[
          ///完成结果1.完成 2.未完成
          Expanded(
            child: Container(
              height: 64,
              alignment: Alignment.center,
              child: FlatButton.icon(
                onPressed: () {
                  if (_status == 2) {
                    _status = 1;
                    setState(() {});
                  }
                },
                icon: Image.asset(_status == 1
                    ? "image/house_auth_select.webp"
                    : "image/house_auth_unselect.webp"),
                label: Text(
                  HouseValue.of(context).finished,
                  style: createTextStyle(
                      fontSize: 17, fontFamily: fontFamilySemiBold),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 64,
              alignment: Alignment.center,
              child: FlatButton.icon(
                onPressed: () {
                  if (_status == 1) {
                    _status = 2;
                    setState(() {});
                  }
                },
                icon: Image.asset(_status == 2
                    ? "image/house_auth_select.webp"
                    : "image/house_auth_unselect.webp"),
                label: Text(
                  HouseValue.of(context).unFinished,
                  style: createTextStyle(
                      fontSize: 17, fontFamily: fontFamilySemiBold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _repairQuoteResultSubmit() async {
    showLoadingDialog(context);
    await repairQuoteResultSubmit(
      context,
      widget.orderId,
      widget.repairQuoteId,
      _status,
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