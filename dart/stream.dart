void main() async{
  countDown().listen((event) {
    print(event);
  } ,onDone:(){
    print("I Have completed it.");
  });
}
//it update the many value over a time and future is used one for single event 
//example if we order the food it request once and we get responce once that is future 
//Steam is uded for live streaming on any platform updating the chunk of data every single interval of time

Stream<int> countDown() async*{
  for(int i =5; i>0; i--){
    yield i;
    await Future.delayed(Duration(seconds: 1));
  }
}