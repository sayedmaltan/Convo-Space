class ShopRegisterModel{
  late bool status;
  String? message;
  DataRegisterModel? data;

  ShopRegisterModel(Map<String, dynamic> value)
  {
    status=value['status'];
    message=value['message'];
    data=value['data']!=null ?DataRegisterModel(value['data']):null;
  }
}
//sayedahmed@gmail.com  12345678

class DataRegisterModel{
  late int id;
  late String name;
  late String email;
  late String phone;
  late String image;
  late String token;

  DataRegisterModel(Map<String, dynamic>? data)
  {
    id=data!['id'];
    name=data['name'];
    email=data['email'];
    phone=data['phone'];
    image=data['image'];
    token=data['token'];
  }

}