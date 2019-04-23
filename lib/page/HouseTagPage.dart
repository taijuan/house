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
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) => _buildItem(_data[index]),
      separatorBuilder: (context, index) => Container(
            height: .5,
            margin: EdgeInsets.symmetric(horizontal: 12),
            color: HouseColor.divider,
          ),
      itemCount: _data.length,
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
          data.checked
              ? Icon(
                  HouseIcons.checkOkIcon,
                  color: HouseColor.green,
                  size: 18,
                )
              : Icon(
                  HouseIcons.unCheckIcon,
                  color: HouseColor.gray,
                  size: 18,
                ),
        ],
      ),
    );
  }
}
