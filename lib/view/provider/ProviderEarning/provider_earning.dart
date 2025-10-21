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

  final ScrollController _bodyHorizontalScrollController = ScrollController();
  final ScrollController _bodyVerticalScrollController = ScrollController();

  @override
  void dispose() {
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
          actions: [
            IconButton(
              icon: Icon(Icons.history, color: AppColor.primaryTextColor),
              onPressed: controller.navigateToWithdrawals,
              tooltip: 'Withdrawal History',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildBalanceCard(),
                const SizedBox(height: 16),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
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
    return Obx(() => ClipRRect(
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
                    '\$${controller.balance.value.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Total Earnings: \$${controller.totalEarnings.value.toStringAsFixed(2)}',
                    style: TextStyle(color: AppColor.primaryTextColor, fontSize: 12),
                  ),
                  Text(
                    'Total Withdrawals: \$${controller.totalWithdrawals.value.toStringAsFixed(2)}',
                    style: TextStyle(color: AppColor.primaryTextColor, fontSize: 12),
                  ),
                  SizedBox(height: 20),
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
    ));
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
              // HEADER
              Table(
                border: TableBorder.all(color: Colors.white),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const {
                  0: FixedColumnWidth(60),
                  1: FixedColumnWidth(150),
                  2: FixedColumnWidth(120),
                  3: FixedColumnWidth(120),
                  4: FixedColumnWidth(100),
                },
                children: [
                  TableRow(
                    decoration: const BoxDecoration(color: Color(0xff2f4c3b)),
                    children: [
                      _buildHeaderCell("ID"),
                      _buildHeaderCell("Customer"),
                      _buildHeaderCell("Task"),
                      _buildHeaderCell("Date"),
                      _buildHeaderCell("Amount"),
                    ],
                  ),
                ],
              ),

              // BODY
              SizedBox(
                height: 400,
                child: SingleChildScrollView(
                  controller: _bodyVerticalScrollController,
                  scrollDirection: Axis.vertical,
                  child: Table(
                    border: TableBorder.all(color: Colors.white),
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FixedColumnWidth(60),
                      1: FixedColumnWidth(150),
                      2: FixedColumnWidth(120),
                      3: FixedColumnWidth(120),
                      4: FixedColumnWidth(100),
                    },
                    children: controller.earnings.map((earning) {
                      return TableRow(
                        children: [
                          _wrapRowCell(earning, _buildBodyCell(earning.id.toString())),
                          _wrapRowCell(earning, _buildBodyCell(earning.customerName)),
                          _wrapRowCell(earning, _buildBodyCell(earning.taskTitle)),
                          _wrapRowCell(earning, _buildBodyCell(earning.formattedDate)),
                          _wrapRowCell(earning, _buildBodyCell(earning.formattedAmount, isBold: true)),
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

