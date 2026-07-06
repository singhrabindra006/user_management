void main(){
  print(constant.Area());
  // if we dont used the static key than we can not print of any variable or function

}

class constant {
   constant (){
    print("constructor called");
   }
   static int height = 10;
   static int width = 8;

   static int Area(){
    return height * width;
   }

}