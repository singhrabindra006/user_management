
void bubbleSort(arry){
  int n = arry.length;
  print("Lenth of Array is: $n");
  for(int i = 0; i<n-1; i++){
    for (int j=0; j<n-i-1; j++){
      if(arry[j]>arry[j+1]){
        int temp = arry[j];
        arry[j]=arry[j+1];
        arry[j+1]=temp;
      }
    }
  }
}

void main(){
  List arry = [6,12,13,7,8,10,12];
  print("Before Sorted: $arry");
  bubbleSort(arry);
  print("After Sorted: $arry");
 
}