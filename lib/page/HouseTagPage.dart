import 'package:house/importLib.dart';

class HouseTagPage extends BaseStatefulWidget {
  final List<TypeStatus> data;

  HouseTagPage(this.data);

  @override
  BaseState createState() => _HouseTagPageState();
}

class _HouseTagPageState extends BaseAppBarAndBodyState<HouseTagPage> {
  final List<TypeStatus> _data = TypeStatus.houseType;

  @override
  void initState() {
    _data.forEach((tag) {
      tag.checked = false;
      tag.checked = widget.data.map((tag) {
        return tag.value;
      }).contains(tag.value);
    });
    super.initState();
  }

  @override
  BaseAppBar appBar(BuildContext context) {
    return TitleAppBar(
      context: context,
      title: TitleAppBar.appBarTitle(HouseValue.of(context).type),
      navigatorBack: TitleAppBar.navigatorBackBlack(context),
      menu: TitleAppBar.appBarMenu(context, onPressed: () {
        pop<List<TypeStatus>>(
          context,
          result: _data.where((tag) {
            return tag.checked;
          }).toList(),
        );
      }),
    );
  }

  @override
  Widget body(BuildContext context) {
    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) {
              if (index.isEven) {
                return _buildItem(_data[index ~/ 2]);
              } else {
                return Container(
                  height: .5,
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  color: HouseColor.divider,
                );
              }
            },
            childCount: _data.length * 2,
          ),
        )
      ],
    );
  }

  Widget _buildItem(TypeStatus data) {
    return FlatButton(
      onPressed: () {
        data.checked = !data.checked;
        setState(() {});
      },
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              data.descEn,
              style: createTextStyle(),
            ),
          ),
          Image.asset(
            data.checked
                ? "image/house_auth_select.webp"
                : "image/house_auth_unselect.webp",
            width: 18,
            height: 18,
          ),
        ],
      ),
    );
  }
}