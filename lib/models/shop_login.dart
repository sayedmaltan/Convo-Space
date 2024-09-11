class ShopLoginModel{
  late bool status;
   String? message;
  DataLoginModel? data;

  ShopLoginModel(Map<String, dynamic> value)
  {
    status=value['status'];
    message=value['message'];
    data=value['data']!=null ?DataLoginModel(value['data']):null;
  }
}
//sayedahmed@gmail.com  12345678

class DataLoginModel{
  late int id;
  late String name;
  late String email;
  late String phone;
  late String image;
  late int points;
  late int credit;
  late String token;

  DataLoginModel(Map<String, dynamic>? data)
  {
    id=data!['id'];
    name=data['name'];
    email=data['email'];
    phone=data['phone'];
    image=data['image'];
    points=data['points'];
    credit=data['credit'];
    token=data['token'];
  }

}