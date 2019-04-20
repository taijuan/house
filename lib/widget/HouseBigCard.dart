import 'package:house/importLib.dart';

class HouseBigCard extends StatelessWidget {
  final House data;

  const HouseBigCard(this.data);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FlatButton(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: HouseColor.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          onPressed: () {
            push(context, HouseDetail(data));
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 16 / 9,
                child: houseCacheNetworkImage(
                  DataUtils.getFirstImage(data.coverImg.content),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Text(
                  data.address,
                  style: createTextStyle(
                    fontSize: 17,
                    fontFamily: fontFamilySemiBold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildLesseeName(),
              _buildTaskParentView(context),
            ],
          ),
        ),
        _buildOngoing,
        _buildBtn(context),
      ],
    );
  }

  Widget get _buildOngoing {
    if (_isOngoing()) {
      return Positioned(
        left: 0,
        top: 0,
        child: Container(
          height: 24,
          padding: EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.center,
          color: HouseColor.green,
          child: Text(
            data.repairStatus.descEn.toUpperCase(),
            style: createTextStyle(
              color: HouseColor.white,
              fontSize: 10,
            ),
          ),
        ),
      );
    } else {
      return Container(width: 0, height: 0);
    }
  }

  Widget _buildLesseeName() {
    int userType = User.getUserSync().type.value;
    if (userType == TypeStatus.vendor.value ||
        userType == TypeStatus.tenant.value ||
        DataUtils.isEmpty(data.getLesseeName())) {
      return SizedBox.shrink();
    } else {
      return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 12),
        margin: EdgeInsets.only(top: 4),
        child: Text(
          "${TypeStatus.tenant.descEn} : ${data.getLesseeName()}",
          style: createTextStyle(color: HouseColor.gray, fontSize: 13),
        ),
      );
    }
  }

  bool _isOngoing() =>
      data.repairStatus?.value == TypeStatus.houseOngoing.value;

  bool _isShow() => _isOngoing();

  Widget _buildTaskParentView(BuildContext context) {
    if (_isShow()) {
      return Container(height: 64);
    } else {
      return Container(height: 16);
    }
  }

  Widget _buildBtn(BuildContext context) {
    if (_isShow()) {
      return Positioned(
        child: RawMaterialButton(
          onPressed: () {
            _goToAction(context);
          },
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.5, color: HouseColor.green),
            borderRadius: BorderRadius.circular(4),
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.symmetric(horizontal: 8),
          constraints: BoxConstraints(minHeight: 28, maxHeight: 28),
          child: _buildBtnText(context),
        ),
        bottom: 16,
        right: 16,
      );
    } else {
      return Container(
        width: 0,
        height: 0,
      );
    }
  }

  void _goToAction(BuildContext context) {
    if (User.getUserSync().type.value == TypeStatus.agent.value) {
      push(context, CasesPage(data: data));
    } else if (User.getUserSync().type.value == TypeStatus.tenant.value) {
      push(context, CasesPage(data: data));
    } else {
      push(context, LandlordOrdersPage(data: data));
    }
  }

  Text _buildBtnText(BuildContext context) {
    if (User.getUserSync().type.value == TypeStatus.agent.value) {
      return Text(
        HouseValue.of(context).taskView,
        style: createTextStyle(color: HouseColor.green, fontSize: 13),
      );
    } else if (User.getUserSync().type.value == TypeStatus.tenant.value) {
      return Text(
        HouseValue.of(context).allRequests,
        style: createTextStyle(color: HouseColor.green, fontSize: 13),
      );
    } else {
      return Text(
        HouseValue.of(context).orderView,
        style: createTextStyle(color: HouseColor.green, fontSize: 13),
      );
    }
  }
}
