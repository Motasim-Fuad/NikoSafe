
import 'api_status.dart';

class ApiResponce<T> {
  // generic class ar T dynamic data
  Status? status;
  T? data;
  String? massage;

  ApiResponce(this.status,this.data,this.massage);

  ApiResponce.loading() :status= Status.LOADING;
  ApiResponce.completed(this.data) :status= Status.COMPLEATED;
  ApiResponce.error(this.massage) :status= Status.ERROR;
  @override
  String toString(){
    return "Status : $status \n Massage: $massage \n Data:$data";
  }
}