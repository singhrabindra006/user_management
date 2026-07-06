void main(){
  //Object Oriented Programmin in Dart(OOP)
  //Polymorphism
  //it is actully the uses of same function or method withs many forms in other extended or implemented classes by methode override and method overloding.
  Cat cat = Cat();
  cat.sound();
  Dog dog = Dog();
  dog.sound();
  //Abstraction 
  //actually in abstraction the class can hide theri details and cannot create the instance of their own class like simple class but can excess the feature of their own class
  Vehicle vehicle =  Car();
  vehicle.engine();

  //Encapsulation
  //actually encapsulation is the hiding of the methode and functions of any file inside it by using key word _data and and excess in other file by using getter and setter to protect unusual excess of data

  //Inheritance
  // inheritance is the excess the feature of parent class by using the key words extend and implements

}
abstract class Vehicle {
  void engine();
}

class Car extends Vehicle{
  @override
  void engine() {
    print("Engine is Working");
   
}}

class Animal{
  void sound(){
    print('Animal make sound.');
  }
}

class Cat extends Animal{
  @override
  void sound(){
    print("Cat making Sound");
  }
}

class Dog implements Animal{
   @override
  void sound(){
    print("Dog make Sound");
  }
}