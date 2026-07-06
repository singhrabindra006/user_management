void main(){
  printName();
  //get value at the index one
  var details1 = detailName();
  print(details1.$1);
  //destructuring the function similar like javascript
  var (age, name , present)= detailName();
  print(age);
  details(name: "Rabindar", age: 23, greeting: "Hello");
 
}

//not return any things at all
  void printName(){
    print("Rabindra Kumar Mahato");
  }
  (int, String, bool) detailName(){
    return (12, "Rabindar", true );
  }

  void details({required String name , required int age, required String greeting}){
    print(name);
    print(age);
    print(greeting);
    print("Name: $name Age: $age Greeting: $greeting");
  }

