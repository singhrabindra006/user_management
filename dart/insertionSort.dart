void insertionSort(arry){
  int n = arry.length;
  print("Length Of the Array is $n");
  for (int i = 1; i<n; i++){
    int key = arry[i];
    print(key);
    int j;
    for (j=i-1; j >=0 &&arry[j]>key; j--){
      arry[j+1]= arry[j];
    }
    arry[j+1]= key;
  }
}

void main(){
  List arry = [9, 14 , 7, 13, 6, 7, 3];
  print("Array Before Sorted: $arry");
  insertionSort(arry);
  print("Array After Sorted: $arry");

}