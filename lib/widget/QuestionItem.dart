import 'package:house/importLib.dart';

class QuestionItem extends BaseStatefulWidget {
  final Question data;

  QuestionItem(this.data);

  @override
  _QuestionItemState createState() {
    return _QuestionItemState();
  }
}

class _QuestionItemState extends BaseState<QuestionItem> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () async {
        await push(context, CaseDetailPage(widget.data));
      },
      padding: EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        height: 60,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            HouseCacheNetworkImage(
              DataUtils.getFirstImage(widget.data.photos.content),
              width: 80,
              height: 60,
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    widget.data.description,
                    style: createTextStyle(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        widget.data.status.descEn ?? "",
                        style: createTextStyle(fontFamily: fontFamilySemiBold),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        widget.data.createDate,
                        style: createTextStyle(
                          color: HouseColor.gray,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
