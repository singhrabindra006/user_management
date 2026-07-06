import 'class.dart';

void main() {
  Cookie cook = Cookie("Circle", 10);
  cook.baking();
  print(cook.shape);
  print(cook.size);
  Calculator cal = Calculator(10 , 12);
  print("Area: ${cal.calculateArea()}");
  print(cal.height);
  cal.setHeight= 13;
  print("Area: ${cal.calculateArea()}");

}