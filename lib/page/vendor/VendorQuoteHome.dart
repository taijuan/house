import 'package:flutter/services.dart';
import 'package:house/importLib.dart';

class VendorQuoteHome extends BaseStatefulWidget {
  final String orderId;

  VendorQuoteHome(this.orderId);

  @override
  _VendorQuoteHomeState createState() => _VendorQuoteHomeState();
}

class _VendorQuoteHomeState extends BaseAppBarAndBodyState<VendorQuoteHome> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  BaseAppBar appBar(BuildContext context) {
    return TitleAppBar(
      context: context,
      title: TitleAppBar.appBarTitle(
        HouseValue.of(context).quote,
      ),
      navigatorBack: TitleAppBar.navigatorBackBlack(context),
      menu: TitleAppBar.appBarMenu(context,
          menu: Text(
            HouseValue.of(context).submit,
            style: createTextStyle(color: HouseColor.green),
          ), onPressed: () async {
        if (DataUtils.isEmpty(_priceController.text)) {
          showMsgToast(context, HouseValue.of(context).type + "price");
          return;
        }
        if (DataUtils.isEmpty(_descController.text)) {
          showMsgToast(
            context,
            HouseValue.of(context).type +
                HouseValue.of(context).quotationDetail,
          );
          return;
        }
        showLoadingDialog(context);
        await insertRepairQuote(
          context,
          widget.orderId,
          _priceController.text,
          _descController.text,
          cancelToken: cancelToken,
        ).then((v) {
          pop(context);
          pop(context);
          Provide.value<ProviderOrderReLoad>(context).reLoad();
        }).catchError((e) {
          pop(context);
          showMsgToast(context, e.toString());
        });
      }),
    );
  }

  @override
  Widget body(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverPadding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: <Widget>[
                Text(
                  HouseValue.of(context).quotation,
                  style: createTextStyle(
                      fontSize: 17, fontFamily: fontFamilySemiBold),
                ),
                Container(
                  width: 80,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  color: HouseColor.lightGray,
                  child: TextFormField(
                    enabled: true,
                    maxLines: 1,
                    decoration: InputDecoration(
                      enabled: true,
                      contentPadding: EdgeInsets.all(8),
                      border: InputBorder.none,
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(8),
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    controller: _priceController,
                  ),
                ),
                Text(
                  "AUD",
                  style: TextStyle(
                    color: HouseColor.red,
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            color: HouseColor.lightGray,
            child: TextFormField(
              enabled: true,
              maxLines: 10,
              decoration: InputDecoration(
                enabled: true,
                contentPadding: EdgeInsets.all(8),
                border: InputBorder.none,
                hintText: HouseValue.of(context).quotationDetail,
              ),
              controller: _descController,
            ),
          ),
        ),
      ],
    );
  }
}
