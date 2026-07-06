void main(){
  Car car = Car();
  car.details();
  Truck truck = Truck();
  truck.engine();
  Bus bus = Bus();
  bus.details();


}
//when we used to change the fuction functionality with same function name of superior class we  need to used the implement key and override the method and change it .
class Vehicle{
  int speed = 10;
  bool isEngineWorking = false;
  bool isLightOn = true;
  int speed1 = 10;

  void accelerate(){
    speed+=10;
  }
}
class Vehicle2 {
  int heightofVihicle = 10;
  int windowinVeichle = 6;

  }

class Car extends Vehicle{
  int numberOdWheel = 4;
  void details(){
    print("Car has $numberOdWheel which is running with Speed of $speed1 Km per hours.");
  }
}

class Truck implements Vehicle{
  @override
  int speed = 10;

  @override
  void accelerate() {
    speed +=10;
  }
  @override
  bool isEngineWorking = true;

  @override 
  bool isLightOn = true;
   @override 
  int speed1 = 100;

  void engine(){
    print("The Speed of Car is $speed1 is engine working $isEngineWorking. ");
  }
  
}

class Bus extends Vehicle implements Vehicle2 {
  int numberOfWheels = 6; 

  void details() {
    print("Bus has $numberOfWheels wheels running at $speed1 Km/h.");
  }

  @override
  int heightofVihicle = 10;

  @override
  int windowinVeichle = 6;
}