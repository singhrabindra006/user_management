/*Future <void> main()async{
  //Future (Promises)
  // sending the request for
  print("Hello!!!");
  final result= await giveAResultAfter2Sec();
  print(result);
  print("Hey");
  print("Hello");
  print("Greeting");
}

Future<String> giveAResultAfter2Sec(){
  return Future.delayed(Duration(seconds: 2), ()async{
    return "Hey!!!";
  });
  }*/


  //using then
void main() {
  // Future (Promises)

  print("Hello!!!");

  giveAResultAfter2Sec().then((value) => print(value));

  print("Hey");
  print("Hello");
  print("Greeting");
}

Future<String> giveAResultAfter2Sec() {
  return Future.delayed(
    Duration(seconds: 2),
    () => "Hey!!!",
  );
}