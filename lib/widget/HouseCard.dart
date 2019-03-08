import 'package:house/importLib.dart';

class HouseCard extends StatelessWidget {
  final House data;

  HouseCard(this.data);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        push(context, HouseDetail(data));
      },
      color: HouseColor.lightGray,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      padding: EdgeInsets.all(8),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            HouseCacheNetworkImage(
              DataUtils.getFirstImage(data.coverImg.content),
              width: 60,
              height: 60,
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    data.address,
                    style: createTextStyle(fontFamily: fontFamilySemiBold,height: 1),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  _buildLesseeName(),
                ],
              ),
            ),
          ],
        ),
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
        margin: EdgeInsets.only(top: 4),
        child: Text(
          "${TypeStatus.lessee.descEn} : ${data.getLesseeName()}",
          style: createTextStyle(color: HouseColor.gray, fontSize: 13),
        ),
      );
    }
  }
}