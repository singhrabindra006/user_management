void main(){
  final human = Human('Rabindar', 23);
  final Human(:age, :name) = human;
  print("Name: $name, Age: $age");

  final listItem = ListItems();
  listItem.checkItems();
}
//patter matching 
class Human{
  final String name;
  final int age;
  Human(this.name, this.age);
}

class ListItems {
  List<String> listItems = ['Hi', 'MAN'];

  void checkItems() {
    switch (listItems) {
      case ['Hi', 'MAN']:
        print('Done!');
        break;

      default:
        print('No match');
    }}}