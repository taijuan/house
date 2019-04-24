import 'package:house/importLib.dart';

class PublishCasePage extends BaseStatefulWidget {
  final House data;

  PublishCasePage(this.data);

  @override
  _PublishCasePageState createState() {
    return _PublishCasePageState();
  }
}

class _PublishCasePageState extends BaseAppBarAndBodyState<PublishCasePage> {
  final List<File> images = [];
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  BaseAppBar appBar(BuildContext context) {
    return TitleAppBar(
      context: context,
      title: TitleAppBar.appBarTitle(
        HouseValue.of(context).repairDetail,
      ),
      navigatorBack: TitleAppBar.navigatorBackBlack(context),
    );
  }

  @override
  Widget body(BuildContext context) {
    return CustomScrollView(
      physics: ClampingScrollPhysics(),
      slivers: <Widget>[
        buildSliverToBoxAdapter(
          context,
          Text(
            HouseValue.of(context).description,
            style: createTextStyle(color: HouseColor.gray),
          ),
          bottom: 8,
        ),
        buildSliverToBoxAdapter(
          context,
          TextFormField(
            enabled: true,
            controller: controller,
            decoration: InputDecoration(
              enabled: true,
              contentPadding: EdgeInsets.all(8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                gapPadding: 0,
                borderSide: BorderSide(
                  width: 1,
                  color: HouseColor.divider,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                gapPadding: 0,
                borderSide: BorderSide(
                  width: 1,
                  color: HouseColor.green,
                ),
              ),
              hintStyle: createTextStyle(color: HouseColor.gray),
            ),
            style: createTextStyle(),
            maxLines: 10,
            maxLength: 300,
          ),
          top: 0,
          bottom: 12,
        ),
        buildSliverToBoxAdapter(
          context,
          Text(
            HouseValue.of(context).pleaseUploadPhotos,
            style: createTextStyle(),
          ),
          top: 0,
          bottom: 0,
        ),
        SliverPadding(
          padding: EdgeInsets.all(12),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == images.length) {
                  return FlatButton(
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
                            this.images.clear();
                            this.images.addAll(
                                  data.map((a) => File(a.path)),
                                );
                          });
                        },
                      );
                    },
                    color: HouseColor.lightGray,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "image/house_photo.webp",
                        ),
                        Text(
                          HouseValue.of(context).photos,
                          style: createTextStyle(
                            color: HouseColor.gray,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Image.file(
                    images[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  );
                }
              },
              childCount: images.length + 1,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
          ),
        )
      ],
    );
  }

  List<AssetData> _getAssetDataList() {
    return images.map((a) => AssetData.fromJson({"path": a.path})).toList();
  }

  SliverToBoxAdapter buildSliverToBoxAdapter(
    BuildContext context,
    Widget child, {
    double left = 12,
    double top = 12,
    double right = 12,
    double bottom = 12,
  }) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(
          left: left,
          top: top,
          right: right,
          bottom: bottom,
        ),
        child: child,
      ),
    );
  }

  @override
  Widget bottomNavigationBar(BuildContext context) {
    return Container(
      height: 48,
      color: HouseColor.green,
      child: FlatButton(
        onPressed: commit,
        child: Text(
          HouseValue.of(context).submit,
          style: createTextStyle(color: HouseColor.white),
        ),
      ),
    );
  }

  void commit() {
    String description = controller.text;
    if (DataUtils.isEmpty(description)) {
      showToast(context,
          HouseValue.of(context).type + HouseValue.of(context).description);
      return;
    }
    if (images.isEmpty) {
      showToast(context, HouseValue.of(context).pleaseUploadPhotos);
      return;
    }
    showLoadingDialog(context);
    insertQuestionInfo(
      context,
      widget.data?.id,
      description,
      images,
      cancelToken: cancelToken,
    )
      ..then((value) {
        pop(context);
        pop(context);
        showToastSuccess(context);
        Provide.value<ProviderOrderReLoad>(context).reLoad();
      })
      ..catchError((e) {
        pop(context);
        showToast(context, e.toString());
      });
  }
}
