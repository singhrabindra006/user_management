import 'dart:io';

void main() {
  print("Enter the Destination Zone: ");
  String? destinationZone = stdin.readLineSync();

  print("Enter the Weight in Kg: ");
  double weightInKgs = double.parse(stdin.readLineSync()!);
  /*

  if (destinationZone == 'PQR') {
    print("Shipping Cost: ${weightInKgs * 10}");
  } 
  else if (destinationZone == 'XYZ') {
    print("Shipping Cost: ${weightInKgs * 5}");
  } 
  else if (destinationZone == 'ABC') {
    print("Shipping Cost: ${weightInKgs * 7}");
  } 
  else {
    print("Invalid Destination Zone.");
  }*/
  switch(destinationZone){
    case 'PQR':
    print("Shipping Cost: ${weightInKgs * 10}");

    case 'XYZ':
    print("Shipping Cost: ${weightInKgs * 5}");

    case 'ABC':
    print("Shipping Cost: ${weightInKgs * 7}");
    
    default:
    print("Invalid destination Zone");
  } 
  
  } 
  
