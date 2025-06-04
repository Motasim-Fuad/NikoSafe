
class AppException implements Exception{

  final _massage;
  final _prefix;

  AppException([this._massage ,this._prefix]);

  String toString(){
    return '$_prefix$_massage';
  }
}
class InternetException extends AppException{
  InternetException([String? massage])  : super(massage,"no internet");
}

class RequestTimeOut extends AppException{
  RequestTimeOut([String? massage])  : super(massage,"request time out");
}

class SurverExecption extends AppException{
  SurverExecption([String? massage])  : super(massage,"Internal server error");
}

class InvaliedUrlException extends AppException{
  InvaliedUrlException([String? massage])  : super(massage,"Url not found");
}

class FatchDataExceptation extends AppException{
  FatchDataExceptation([String? massage])  : super(massage,"whitle cominucate server error has occrud");
}

