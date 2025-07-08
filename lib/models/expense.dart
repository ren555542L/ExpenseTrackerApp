import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

const uuid = Uuid();

final formatter =
    DateFormat.yMd(); // Date format for displaying dates in a user-friendly way

// through intl package
//enum is used to define a set of named constants
// This is useful for defining categories of expenses, such as food, travel, leisure, and work.
// Using an enum allows for better type safety and readability in the code.
enum Category { food, travel, leisure, work } // Default categories for expenses

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id; // Unique identifier for the expense -- 1/2/3/4/5...
  final String title;
  final double amount;
  final DateTime date;
  final Category category; // Default category, can be changed later
  // The category of the expense, which can be one of the predefined categories
  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  const ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
    : expenses = allExpenses
          .where((expense) => expense.category == category)
          .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
