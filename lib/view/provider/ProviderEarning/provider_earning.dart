import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nikosafe/resource/Colors/app_colors.dart';
import 'package:nikosafe/resource/asseets/image_assets.dart';
import 'package:nikosafe/resource/compunents/customBackButton.dart';
import 'package:nikosafe/resource/compunents/elevatedbutton.dart';
import '../../../View_Model/Controller/provider/providerEarningDataController/providerEarningDataController.dart';
import '../../../models/Provider/providerEarningData/providerEarningData.dart';

class ProviderEarningDataView extends StatefulWidget {
  @override
  State<ProviderEarningDataView> createState() => _ProviderEarningDataViewState();
}

class _ProviderEarningDataViewState extends State<ProviderEarningDataView> {
  final ProviderEarningDataController controller = Get.put(ProviderEarningDataController());

  final ScrollController _headerScrollController = ScrollController();
  final ScrollController _bodyHorizontalScrollController = ScrollController();
  final ScrollController _bodyVerticalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Sync header scroll with body scroll
    _bodyHorizontalScrollController.addListener(() {
      if (_headerScrollController.hasClients &&
          _headerScrollController.offset != _bodyHorizontalScrollController.offset) {
        _headerScrollController.jumpTo(_bodyHorizontalScrollController.offset);
      }
    });
  }

  @override
  void dispose() {
    _headerScrollController.dispose();
    _bodyHorizontalScrollController.dispose();
    _bodyVerticalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColor.backGroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Earnings', style: TextStyle(color: AppColor.primaryTextColor)),
          automaticallyImplyLeading: false,
          leading: CustomBackButton(),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildBalanceCard(),
                const SizedBox(height: 16),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6, // 60% screen height
                  child: _buildEarningsTable(),
                ),
              ],
            ),
          ),
        ),


      ),
    );
  }

  Widget _buildBalanceCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(color: AppColor.topLinear),
              child: SvgPicture.asset(ImageAssets.withdrowimg, fit: BoxFit.cover),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Your Balance", style: TextStyle(color: AppColor.primaryTextColor)),
                  Text(
                    controller.currentBalance.value,
                    style: TextStyle(color: Colors.white, fontSize: 20),
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
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.earnings.isEmpty) {
        return const Center(child: Text('No earnings to display.'));
      }

      return Scrollbar(
        controller: _bodyVerticalScrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _bodyHorizontalScrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER ROW
              Table(
                border: TableBorder.all(color: Colors.white),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const {
                  0: FixedColumnWidth(60),
                  1: FixedColumnWidth(120),
                  2: FixedColumnWidth(120),
                  3: FixedColumnWidth(120),
                  4: FixedColumnWidth(100),
                },
                children: [
                  TableRow(
                    decoration: const BoxDecoration(color: Color(0xff2f4c3b)),
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

              // BODY ROWS
              SizedBox(
                height: 400, // or MediaQuery-based height
                child: SingleChildScrollView(
                  controller: _bodyVerticalScrollController,
                  scrollDirection: Axis.vertical,
                  child: Table(
                    border: TableBorder.all(color: Colors.white),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FixedColumnWidth(60),
                      1: FixedColumnWidth(120),
                      2: FixedColumnWidth(120),
                      3: FixedColumnWidth(120),
                      4: FixedColumnWidth(100),
                    },
                    children: controller.earnings.map((earning) {
                      return TableRow(
                        children: [
                          _wrapRowCell(
                            earning,
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundImage: earning.avatarUrl != null && earning.avatarUrl!.isNotEmpty
                                    ? AssetImage(earning.avatarUrl!) as ImageProvider
                                    : const AssetImage('assets/images/default_avatar.png'),
                                backgroundColor: Colors.grey,
                              ),
                            ),
                          ),
                          _wrapRowCell(earning, _buildBodyCell(earning.name)),
                          _wrapRowCell(earning, _buildBodyCell(earning.accNumber)),
                          _wrapRowCell(earning, _buildBodyCell(earning.date)),
                          _wrapRowCell(earning, _buildBodyCell(earning.amount, isBold: true)),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
  Widget _wrapRowCell(ProviderEarningDataModel earning, Widget child) {
    return InkWell(
      onTap: () => controller.showEarningDetails(earning),
      child: child,
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Text(
        text,
        style: TextStyle(color: AppColor.primaryTextColor, fontWeight: FontWeight.bold),
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
