void main() {
  print(10 ~/ 3); 
  print(10 / 0);  // Outputs Infinity

  /*try {
    print(10 ~/ 0);
  } catch (e) {
    print("The error is $e");
  }
  finally{
    print("Finally block is executed");
  }
  print("Rabindra");
  */

  try {
    print(10 ~/ 0);
  } on Exception catch (e) {
    print("The error is $e");
  }catch(e){
    print("The the error is $e");
  }
  
  print("Rabindra");
}