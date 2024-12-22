import 'package:flutter/material.dart';

class MyData extends DataTableSource {
  // final List<String> fruits = ["Apple", "Banana"]; single item is like this

  final List<List<dynamic>> fruits = [
    // to create a neasted list you use this

    [1, 'Apple', 1.2, 52],
    [2, 'Banana', 0.5, 89],
    [3, 'Carrot', 0.3, 41],
    [4, 'Kiwi', 1.5, 61],
    [5, 'Apricot', 1.0, 48],
    [6, 'Pineapple', 2.5, 50],
    [7, 'Mango', 1.8, 60],
    [8, 'Orange', 0.8, 47],
    [9, 'Peach', 1.0, 39],
    [10, 'Strawberry', 2.0, 32],
    [11, 'Grape', 1.5, 69],
    [12, 'Watermelon', 3.0, 30],
    [13, 'Papaya', 2.0, 43],
    [14, 'Blueberry', 2.5, 57],
    [15, 'Raspberry', 2.2, 52],
    [16, 'Blackberry', 2.3, 43],
    [17, 'Plum', 1.2, 46],
    [18, 'Cherry', 2.0, 50],
    [19, 'Melon', 2.8, 50],
    [20, 'Lemon', 0.6, 29],
    [21, 'Lime', 0.5, 30],
    [22, 'Pear', 1.0, 57],
    [23, 'Cantaloupe', 2.0, 34],
    [24, 'Tangerine', 1.2, 53],
    [25, 'Grapefruit', 1.5, 42],
    [26, 'Dragonfruit', 3.0, 50],
    [27, 'Lychee', 2.8, 66],
    [28, 'Pomegranate', 3.5, 83],
    [29, 'Jackfruit', 2.5, 95],
    [30, 'Coconut', 3.0, 354],
    [31, 'Fig', 2.0, 74],
    [32, 'Date', 1.8, 277],
    [33, 'Guava', 1.5, 68],
    [34, 'Passion Fruit', 2.5, 97],
    [35, 'Starfruit', 2.3, 31]
  ];

  int get numberOfRows => fruits.length;

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(fruits[index][0].toString())),
      DataCell(Text(fruits[index][1])),
      DataCell(Text(fruits[index][2].toString())),
      DataCell(Text(fruits[index][3].toString()))
    ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => fruits.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
