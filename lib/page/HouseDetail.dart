import 'package:house/importLib.dart';

class HouseDetail extends BaseStatefulWidget {
  final House data;

  HouseDetail(this.data);

  @override
  _HouseDetailState createState() {
    return _HouseDetailState();
  }
}

class _HouseDetailState extends BaseAppBarAndBodyState<HouseDetail> {
  final GlobalKey<RefreshIndicatorState> _globalKey =
      GlobalKey<RefreshIndicatorState>();
  House _data;

  @override
  void initState() {
    _data = widget.data;
    Future.delayed(Duration()).whenComplete(() {
      _globalKey.currentState.show();
    });
    super.initState();
  }

  @override
  BaseAppBar appBar(BuildContext context) {
    return TitleAppBar(
      context: context,
      title: TitleAppBar.appBarTitle(
        HouseValue.of(context).houseDetail,
      ),
      navigatorBack: TitleAppBar.navigatorBackBlack(context),
    );
  }

  @override
  Widget body(BuildContext context) {
    return RefreshIndicator(
        key: _globalKey,
        semanticsLabel: "",
        child: CustomScrollView(
          slivers: <Widget>[
            _buildViewPager(),
            _buildMap(),
            _buildBasic(),
            _buildLandlord(),
            _buildLessee(),
            _buildAgency(),
            _buildContract(),
            _buildDivider(),
            _buildFeatureName(),
            _buildFeature(),
            _buildDivider(),
          ],
        ),
        onRefresh: () async {
          await houseDetail(
            context,
            widget.data.id,
            cancelToken: cancelToken,
          ).then((v) {
            _data = v;
            setState(() {});
          }).catchError((e) {
            showToast(context, e.toString());
          });
        });
  }

  @override
  Widget bottomNavigationBar(BuildContext context) {
    return SizedBox.shrink();
  }

  SliverToBoxAdapter _buildDivider() {
    return SliverToBoxAdapter(
      child: Container(
        height: .5,
        color: HouseColor.divider,
      ),
    );
  }

  Widget _buildLandlord() {
    if (User.getUserSync().type.value == TypeStatus.userType[1].value) {
      return SliverToBoxAdapter();
    } else {
      return _buildContact(
        TypeStatus.userType[1].descEn,
        _data.landlordFirstName,
        _data.landlorPhone,
        _data.landlordEmail,
      );
    }
  }

  Widget _buildAgency() {
    if (User.getUserSync().type.value == TypeStatus.userType[0].value) {
      return SliverToBoxAdapter();
    } else {
      return _buildContact(
        TypeStatus.userType[0].descEn,
        _data.agencyFirstName,
        _data.agencyPhone,
        _data.agencyEmail,
      );
    }
  }

  Widget _buildLessee() {
    if (User.getUserSync().type.value == TypeStatus.userType[2].value) {
      return SliverToBoxAdapter();
    } else {
      return _buildContact(
        TypeStatus.userType[2].descEn,
        _data.tenantFirstName,
        _data.tenantPhone,
        _data.tenantEmail,
      );
    }
  }

  Widget _buildViewPager() {
    if (DataUtils.isEmptyList(_data?.image?.content)) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: 0,
        ),
      );
    } else {
      return SliverToBoxAdapter(
        child: ImagePageView(
          _data.image.content.map((a) {
            return a.picUrl;
          }).toList(),
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.width * 9 / 16,
          onPressed: () {},
        ),
      );
    }
  }

  Widget _buildMap() {
    return SliverToBoxAdapter(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width / 1080 * 145,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "image/house_map.webp",
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: SizedBox.expand(
          child: FlatButton(
            padding: EdgeInsets.symmetric(horizontal: 12),
            onPressed: () {
              IntentUtils.geo(_data.address);
            },
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    _data.address,
                    style: createTextStyle(
                      fontFamily: fontFamilySemiBold,
                      height: 1,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Image.asset(
                  "image/house_location.webp",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasic() {
    return SliverPadding(
      padding: EdgeInsets.only(left: 12, top: 12, right: 12),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            switch (index) {
              case 0:
                return Row(
                  children: <Widget>[
                    Image.asset("image/house_bed.webp"),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      _data.bedroomNum.toString() + HouseValue.of(context).bed,
                      style: createTextStyle(fontSize: 13),
                    )
                  ],
                );
              case 1:
                return Row(
                  children: <Widget>[
                    Image.asset("image/house_car.webp"),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      _data.parkingNum.toString() + HouseValue.of(context).car,
                      style: createTextStyle(fontSize: 13),
                    )
                  ],
                );
              case 2:
                return Row(
                  children: <Widget>[
                    Image.asset("image/house_bath.webp"),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      _data.bathroomNum.toString() +
                          HouseValue.of(context).bath,
                      style: createTextStyle(fontSize: 13),
                    )
                  ],
                );
              case 3:
                return Row(
                  children: <Widget>[
                    Image.asset(
                      "image/house_built.webp",
                      width: 20,
                      height: 20,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      HouseValue.of(context).built + _data.completionTime,
                      style: createTextStyle(fontSize: 13),
                    )
                  ],
                );
              case 4:
                return Row(
                  children: <Widget>[
                    Image.asset("image/house_sqft.webp"),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      _data.floorArea.toString() + HouseValue.of(context).sQft,
                      style: createTextStyle(fontSize: 13),
                    )
                  ],
                );
            }
          },
          childCount: 5,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 7,
        ),
      ),
    );
  }

  Widget _buildContact(String typeName, String name, String tel, String email) {
    return SliverPadding(
      padding: EdgeInsets.only(left: 12, top: 12, right: 12),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "$typeName：${name.isEmpty ? email : name}",
              style: createTextStyle(
                fontSize: 15,
                fontFamily: fontFamilyBold,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            tel.isEmpty
                ? SizedBox.shrink()
                : RawMaterialButton(
                    onPressed: () {
                      IntentUtils.tel(tel);
                    },
                    constraints: BoxConstraints(),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 64,
                          child: Text(
                            HouseValue.of(context).phone,
                            style: createTextStyle(fontSize: 13),
                          ),
                        ),
                        Text(
                          tel,
                          style: createTextStyle(fontSize: 13),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Image.asset("image/house_phone.webp"),
                      ],
                    ),
                  ),
            SizedBox(height: 6),
            RawMaterialButton(
              onPressed: () {
                IntentUtils.mailTo(email);
              },
              constraints: BoxConstraints(),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              child: Row(
                children: <Widget>[
                  Container(
                    width: 64,
                    child: Text(
                      HouseValue.of(context).email,
                      style: createTextStyle(fontSize: 13),
                    ),
                  ),
                  Text(
                    email,
                    style: createTextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Image.asset("image/house_email.webp"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildContract() {
    return SliverPadding(
      padding: EdgeInsets.only(left: 12, top: 16, right: 12, bottom: 12),
      sliver: SliverToBoxAdapter(
        child: Text(
          HouseValue.of(context).contractNo + (_data.contractNo ?? ""),
          style: createTextStyle(color: HouseColor.green),
        ),
      ),
    );
  }

  Widget _buildFeatureName() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(left: 12, top: 12, right: 24, bottom: 8),
        constraints: BoxConstraints(),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                HouseValue.of(context).features,
                style: createTextStyle(
                  fontSize: 15,
                  fontFamily: fontFamilyBold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature() {
    List<String> a = [];
    if (DataUtils.isEmpty(_data.features)) {
      a = [];
    } else {
      a = _data.features.split("\r\n");
    }
    return SliverPadding(
      padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index.isEven) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Text(
                  a[index ~/ 2],
                  style: createTextStyle(),
                ),
              );
            } else {
              return SizedBox(
                height: 8,
              );
            }
          },
          childCount: a.length * 2,
        ),
      ),
    );
  }
}
