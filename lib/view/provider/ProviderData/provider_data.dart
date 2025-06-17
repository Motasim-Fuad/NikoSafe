import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import 'package:nikosafe/resource/compunents/elevatedbutton.dart';
import 'package:nikosafe/view/provider/ProviderData/widgets/earningDataListTitle.dart';
import '../../../View_Model/Controller/provider/providerEarningDataController/providerEarningDataController.dart';
import '../../../models/Provider/providerEarningData/providerEarningData.dart';


class ProviderEarningDataView extends StatelessWidget {
  final ProviderEarningDataController controller = Get.put(ProviderEarningDataController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColor.backGroundColor
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
            title:  Text('Earnings',style: TextStyle(color: AppColor.primaryTextColor),),
          automaticallyImplyLeading: false,
          leading: CustomBackButton(),
          centerTitle: true,

        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              _buildBalanceCard(),
              const SizedBox(height: 16),
              _buildEarningsTable(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Optional: for background color
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColor.topLinear,

              ),
             child:SvgPicture.asset(ImageAssets.withdrowimg,fit: BoxFit.cover,) ,
            ),
            Positioned(

              top: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Balance",
                    style: TextStyle(color: AppColor.primaryTextColor),
                  ),
                  Text(
                    controller.currentBalance.value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,

                    ),
                  ),
                  SizedBox(height: 40),
                  CustomElevatedButton(
                    text: "Withdraw",
                    onPressed: controller.withdraw,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsTable() {
    return Expanded(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.earnings.isEmpty) {
          return const Center(child: Text('No earnings to display.'));
        }

        // Header stays fixed outside the scrollable Table body
        return Column(
          children: [
            // Fixed Header
            Container(
              color: Colors.white,
              child: Table(
                border: TableBorder.all(color: Colors.white),
                defaultColumnWidth: IntrinsicColumnWidth(),
                columnWidths: const {
                  0: FixedColumnWidth(60),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(2),
                  4: FlexColumnWidth(1.5),

                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Color(0xff2f4c3b)),
                    children: [

                      _buildHeaderCell("Avatar"),
                      _buildHeaderCell("Name"),
                      _buildHeaderCell("Account"),
                      _buildHeaderCell("Date"),
                      _buildHeaderCell("Amount"),

                    ],
                  ),
                ],
              ),
            ),

            // Scrollable Table Body
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Table(
                  border: TableBorder.all(color: Colors.white),
                  defaultColumnWidth: IntrinsicColumnWidth(),
                  columnWidths: const {
                    0: FixedColumnWidth(60),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(2),
                    3: FlexColumnWidth(2),
                    4: FlexColumnWidth(1.5),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: controller.earnings.map((earning) {
                    return
                      TableRow(
                        children: [
                          _wrapRowCell(
                            earning,
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundImage: earning.avatarUrl != null && earning.avatarUrl!.isNotEmpty
                                    ? AssetImage(earning.avatarUrl!) as ImageProvider
                                    : AssetImage('assets/images/default_avatar.png'),
                                backgroundColor: Colors.grey,
                              ),
                            ),
                          ),
                          _wrapRowCell(earning, _buildBodyCell(earning.name)),
                          _wrapRowCell(earning, _buildBodyCell(earning.accNumber)),
                          _wrapRowCell(earning, _buildBodyCell(earning.date)),
                          _wrapRowCell(earning, _buildBodyCell(earning.amount, isBold: true)),
                        ],
                      )
                    ;
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
  Widget _wrapRowCell(ProviderEarningDataModel earning, Widget child) {
    return InkWell(
      onTap: () => controller.showEarningDetails(earning),
      child: child,
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 4),
      child: Text(
        text,
        style:  TextStyle(color: AppColor.primaryTextColor),
      ),
    );
  }

  Widget _buildBodyCell(String text, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Text(
        text,
        style: TextStyle(
          color: AppColor.primaryTextColor,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }




}
