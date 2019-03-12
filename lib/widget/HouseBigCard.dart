import 'package:house/importLib.dart';

class HouseBigCard extends StatelessWidget {
  final House data;
  final VoidCallback onPressed;

  const HouseBigCard(this.data, {this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: HouseColor.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      onPressed: onPressed ??
          () {
            push(context, HouseDetail(data));
          },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            children: <Widget>[
              HouseCacheNetworkImage(
                DataUtils.getFirstImage(data.coverImg.content),
                aspectRatio: 16 / 9,
              ),
              _isOngoing()
                  ? Container(
                      height: 24,
                      width: 80,
                      alignment: Alignment.center,
                      color: HouseColor.green,
                      child: Text(
                        data.repairStatus.descEn.toUpperCase(),
                        style: createTextStyle(
                          color: HouseColor.white,
                          fontSize: 10,
                        ),
                      ),
                    )
                  : Container(width: 0, height: 0),
            ],
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
          _buildTaskButton(context),
        ],
      ),
    );
  }

  Widget _buildLesseeName() {
    int userType = User.getUserSync().type.value;
    if (userType == TypeStatus.vendor.value ||
        userType == TypeStatus.lessee.value ||
        DataUtils.isEmpty(data.getLesseeName())) {
      return SizedBox.shrink();
    } else {
      return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 12),
        margin: EdgeInsets.only(top: 4),
        child: Text(
          "${TypeStatus.lessee.descEn} : ${data.getLesseeName()}",
          style: createTextStyle(color: HouseColor.gray, fontSize: 13),
        ),
      );
    }
  }

  bool _isOngoing() =>
      data.repairStatus?.value == TypeStatus.houseStatus[1].value;

  bool _isShow() =>
      _isOngoing() && User.getUserSync().type.value == TypeStatus.agency.value;

  Widget _buildTaskButton(BuildContext context) {
    if (_isShow()) {
      return FlatButton(
        onPressed: () {},
        padding: EdgeInsets.only(left: 12, top: 12, right: 12, bottom: 16),
        highlightColor: HouseColor.transparent,
        splashColor: HouseColor.transparent,
        child: Container(
          height: 30,
          alignment: AlignmentDirectional.topEnd,
          child: OutlineButton(
            onPressed: () {
              push(context, TaskListBarHome(data));
            },
            padding: EdgeInsets.symmetric(horizontal: 12),
            highlightedBorderColor: HouseColor.green,
            disabledBorderColor: HouseColor.green,
            borderSide: BorderSide(color: HouseColor.green),
            child: Text(
              HouseValue.of(context).taskView,
              style: createTextStyle(color: HouseColor.green, fontSize: 13),
            ),
          ),
        ),
      );
    } else {
      return Container(height: 16);
    }
  }
}
