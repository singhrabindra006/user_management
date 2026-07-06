

class Cookie {
  String shape;
  double size;
  Cookie(this.shape, this.size){
    print("Cookie constructor is called.");
  }

  void baking() {
    print("Baking has started.");
  }

  bool isCooling() {
    return false;
  }
}

class Calculator {
  int _height;
  int _width;
  Calculator(this._height,this._width);

  int calculateArea(){
    return _height * _width;
  }
  //Getter and Setter 
  int get height => _height;

  set setHeight (int height){
    _height = height;
  }


}