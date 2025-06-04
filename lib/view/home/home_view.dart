import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Data/responce/api_status.dart';
import '../../View_Model/Controller/home/home_view model.dart';
import '../../View_Model/Controller/login/user_prefrrence/user_preference_view_model.dart';
import '../../resource/App_routes/routes_name.dart';
import '../../resource/compunents/InternetException_Wiget.dart';
import '../../resource/compunents/generalExceptation_Widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  UserPreferences userPreferences=UserPreferences();
  final homeController=Get.put(HomeController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeController.userListApi();
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("home"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
           userPreferences.removeuser().then((value) {
             // remove user ai kas ta api ar madhoma o kora jaba ,, job live a api ar madhoma koebo
             Get.offNamed(RouteName.loginView);
           }) ;
          }, icon: Icon(Icons.login_outlined))
        ],
      ),


      body: Obx(() {
        switch(homeController.rxReqrestStatus.value){
          case Status.LOADING:
            return Center(child: const CircularProgressIndicator());
          case Status.ERROR:
            if(homeController.error.value == "no internet"){
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: InternetExpentionWiedet(onPress: (){
                    homeController.refreshApi();
                  }),
                ),
              );
            }else{
              return Center(
                child: GenaralExceptation_Widget(onPress: (){
                  homeController.refreshApi();
                }),
              );
            }
          case Status.COMPLEATED:
            return ListView.builder(
              itemCount: homeController.userList.value.data!.length,
        itemBuilder: (context,index){
          return Card(
            color: Colors.teal,

            child: ListTile(
              title: Text(homeController.userList.value.data![index].firstName.toString(),style: TextStyle(color: Colors.white),),
              subtitle: Text(homeController.userList.value.data![index].email.toString(),style: TextStyle(color: Colors.white),),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(homeController.userList.value.data![index].avatar.toString()),

              ),
            ),
          );
        }

        );
        }
      }),

      // body: Column(
      //   children: [
      //     Container(
      //       child: Text("email_hint".tr,style:  TextStyle(color: Colors.green),),
      //     ),
      //     Container(
      //       height: Get.height*.2,
      //       width: Get.width*.4,
      //       child: Image.asset(ImageAssets.splashScreen),
      //     ),
      //
      //     InternetExpentionWiedet(onPress: () {  },),
      //     GenaralExceptation_Widget(onPress: () { },),
      //     RoundButton(title: "login",width: 200, onPress: (){}),
      //     RoundButton(title: "Singup",width: double.infinity, onPress: (){}),
      //
      //
      //
      //
      //   ],
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){
      //     throw InternetException("  murad");
      //   },
      // ),
    );
  }
}
