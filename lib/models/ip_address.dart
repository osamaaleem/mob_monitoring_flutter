class IPAddress{
  static late String _ipAdd;

  static void setIP(String ip){
    _ipAdd = ip;
  }
  static String getIP(){
    return _ipAdd;
  }
}