import 'package:moawen/model/status.dart';

class ADSModel {

  ADSModel({
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.period,
    required this.price,
    required this.userId,
    required this.status,
    required this.paying
  });

   String id ;
   String description ;
   String imageUrl ;
   String period ;
   double price ;
   String userId;
   StatusEnum status;
   bool paying;

  // ADSModel.json(Map data) {
  //   id = data['id'].toString();
  //   description = data['description'].toString();
  //   imageUrl = data['imageUrl'].toString();
  //   period = data['period'].toString();
  //   price =  data['price'];
  //   userId = data['userId'].toString();
  //   status = StatusEnum.values.byName( data['status']);
  //   paying = data['paying'];
  // }

  factory ADSModel.fromJson(Map<String, dynamic> json) => ADSModel(
      id : json['id'],
      description : json['description'].toString(),
      imageUrl : json['imageUrl'].toString(),
      period : json['period'].toString(),
      price :  json['price'],
      userId : json['userId'].toString(),
      status : StatusEnum.values.byName( json['status']),
      paying : json['paying'],
  );


  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "imageUrl": imageUrl,
    "period": period,
    "price": price,
    "userId": userId,
    "status": status.name,
    "paying": paying  };
}
