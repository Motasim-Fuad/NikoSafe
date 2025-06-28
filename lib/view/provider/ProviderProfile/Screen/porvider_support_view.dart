import 'package:flutter/material.dart';
import 'package:nikosafe/resource/compunents/RoundButton.dart';
import 'package:nikosafe/utils/utils.dart';
import '../../../../resource/Colors/app_colors.dart';
import '../../../../resource/compunents/coustomTextField.dart';
import '../../../../resource/compunents/customBackButton.dart';

class PorviderSupportView extends StatefulWidget {
  PorviderSupportView({super.key});

  @override
  State<PorviderSupportView> createState() => _PorviderSupportViewState();
}

class _PorviderSupportViewState extends State<PorviderSupportView> {
  final TextEditingController _titleText =TextEditingController();

  final TextEditingController _descriptionText =TextEditingController();
  final _titleFocus =FocusNode();
  final _descriptionFocus =FocusNode();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColor.backGroundColor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: CustomBackButton(),
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text("Support",style: TextStyle(color: AppColor.primaryTextColor),),
        ),
        body: Padding(padding: EdgeInsets.all(16),child: SingleChildScrollView(
          child: Column(
            children: [


              CustomTextField(
                label: "Issue Title",
                fillColor: AppColor.topLinear,
                controller: _titleText,
                focusNode: _titleFocus,
                onSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_descriptionFocus);
                },
              ),
              SizedBox(height: 20,),
              CustomTextField(
                fillColor: AppColor.topLinear,
                label: "User Description",
                focusNode: _descriptionFocus,
                controller: _descriptionText,
                maxLines: 6,
                minLines: 5,

              ),
              SizedBox(height: 50,),

              RoundButton(title: "Submit",width: double.infinity, onPress: (){
                Utils.successSnackBar("Support", "Submit You Issue Successfully");
                FocusScope.of(context).unfocus();
                _titleText.clear();
                _descriptionText.clear();
              }),


            ],
          ),
        ),),
      ),
    );
  }
}
