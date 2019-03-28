import 'dart:math';

import 'package:house/importLib.dart';

class PublishOrderHome extends BaseStatefulWidget {
  final String questionId;

  PublishOrderHome(this.questionId);

  @override
  _PublishOrderHomeState createState() {
    return _PublishOrderHomeState();
  }
}

class _PublishOrderHomeState extends BaseAppBarAndBodyState<PublishOrderHome> {
  final List<OrderContent> _data = [OrderContent()];

  @override
  void initState() {
    backgroundColor = HouseColor.lightGray;
    super.initState();
  }

  @override
  BaseAppBar appBar(BuildContext context) {
    return TitleAppBar(
      context: context,
      navigatorBack: TitleAppBar.navigatorBackBlack(
        context,
        onPressed: () {
          pop(
            context,
            result: _data.any((a) => !a.isEnable),
          );
        },
        willPop: true,
      ),
      title: TitleAppBar.appBarTitle(
        HouseValue.of(context).publish,
      ),
      decoration: BoxDecoration(color: HouseColor.white),
    );
  }

  @override
  Widget body(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index.isEven) {
                return _PublishOrderItem(
                  widget.questionId,
                  _data[index ~/ 2],
                );
              } else {
                return Container(
                  height: (index == _data.length * 2 - 1) ? 0 : 8,
                  color: HouseColor.lightGray,
                );
              }
            },
            childCount: _data.length * 2,
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: OutlineButton(
                onPressed: () {
                  _data.add(OrderContent());
                  setState(() {});
                },
                borderSide: BorderSide(color: HouseColor.green),
                child: Text(
                  "+",
                  style: createTextStyle(
                    color: HouseColor.green,
                    fontSize: 17,
                    fontFamily: fontFamilySemiBold,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _PublishOrderItem extends BaseStatefulWidget {
  final String questionId;
  final OrderContent data;

  _PublishOrderItem(this.questionId, this.data);

  @override
  _PublishOrderItemState createState() {
    return _PublishOrderItemState();
  }
}

class _PublishOrderItemState extends BaseState<_PublishOrderItem> {
  TextEditingController _titleController, _desController;

  @override
  void initState() {
    if (_titleController == null) {
      _titleController = TextEditingController(text: widget.data.description);
      _titleController.addListener(() {
        widget.data.title = _titleController.text;
      });
    }
    if (_desController == null) {
      _desController = TextEditingController(text: widget.data.description);
      _desController.addListener(() {
        widget.data.description = _desController.text;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _desController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HouseColor.white,
      child: Column(
        children: <Widget>[
          ///
          SizedBox(
            height: 48,
            child: FlatButton(
              padding: EdgeInsets.symmetric(horizontal: 16),
              onPressed: widget.data.isEnable
                  ? () {
                      push<List<Tag>>(
                        context,
                        TagHome(selectData: widget.data.tags),
                      ).then((tags) {
                        if (tags != null) {
                          widget.data.tags = tags;
                          setState(() {});
                        }
                      });
                    }
                  : null,
              child: Row(
                children: <Widget>[
                  Text(
                    HouseValue.of(context).type,
                    style: createTextStyle(color: HouseColor.gray),
                  ),
                  SizedBox(
                    width: 24,
                  ),
                  Expanded(
                    child: Text(
                      _reduceName(),
                      style: createTextStyle(fontFamily: fontFamilySemiBold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
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
            ),
          ),
          Container(
            height: 1,
            color: HouseColor.divider,
            margin: EdgeInsets.symmetric(horizontal: 16),
          ),

          ///
          Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            child: Text(
              HouseValue.of(context).title,
              style: createTextStyle(color: HouseColor.gray),
            ),
          ),

          ///
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: HouseColor.lightGray,
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextFormField(
              enabled: widget.data.isEnable,
              controller: _titleController,
              decoration: InputDecoration(
                enabled: widget.data.isEnable,
                contentPadding: EdgeInsets.all(8),
                border: InputBorder.none,
              ),
              style: createTextStyle(),
              maxLines: 3,
              maxLength: 100,
            ),
          ),

          ///
          Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            child: Text(
              HouseValue.of(context).description,
              style: createTextStyle(color: HouseColor.gray),
            ),
          ),

          ///
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: HouseColor.lightGray,
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextFormField(
              enabled: widget.data.isEnable,
              controller: _desController,
              decoration: InputDecoration(
                enabled: widget.data.isEnable,
                contentPadding: EdgeInsets.all(8),
                border: InputBorder.none,
              ),
              style: createTextStyle(),
              maxLines: 9,
              maxLength: 300,
            ),
          ),

          ///
          Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            child: SizedBox(
              width: double.infinity,
              child: FlatButton(
                onPressed: widget.data.isEnable ? _publish : null,
                color: HouseColor.green,
                disabledColor: HouseColor.divider,
                child: Text(
                  HouseValue.of(context).publish,
                  style: createTextStyle(color: HouseColor.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _reduceName() {
    if (widget.data.tags.isEmpty) {
      return "";
    } else {
      return widget.data.tags.map((tag) {
        return tag.name;
      }).reduce((a, b) {
        return "$a,$b";
      });
    }
  }

  void _publish() async {
    if (widget.data.tags.isEmpty) {
      return;
    }
    if (DataUtils.isEmpty(_titleController.text)) {
      return;
    }
    if (DataUtils.isEmpty(_desController.text)) {
      return;
    }
    showLoadingDialog(context);
    await insertRepairOrder(
      context,
      widget.questionId,
      _reduceId(),
      widget.data.title,
      widget.data.description,
      cancelToken: cancelToken,
    ).then((v) {
      pop(context);
      showToastSuccess(context);
      setState(() {
        widget.data.isEnable = false;
      });
    }).catchError((e) {
      pop(context);
      showToast(context, e.toString());
    });
  }

  String _reduceId() {
    if (widget.data.tags.isEmpty) {
      return "";
    } else {
      return widget.data.tags.map((tag) {
        return tag.id;
      }).reduce((a, b) {
        return "$a,$b";
      });
    }
  }
}

class OrderContent {
  List<Tag> tags = [];
  String title = "";
  String description = "";
  bool isEnable = true;
}
