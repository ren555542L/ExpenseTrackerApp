import 'package:flutter/material.dart';
import 'package:spendo/models/expense.dart';
import 'package:spendo/widgets/expenses_list/expenses_list.dart';
import 'package:spendo/widgets/new_expenses.dart';
import 'package:spendo/widgets/chart/chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [];
  void _openAddExpenseOverlay() {
    // useSafeArea:
    // true;
    // This function will be used to open the overlay for adding a new expense
    showModalBottomSheet(
      // context is already provided by the build method of the widget
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return NewExpenses(onAddExpense: _addExpense);
      },
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      // it appears as a message after sometihing if performed
      SnackBar(
        // it opens a bar with a message on it and can do various things
        duration: Duration(seconds: 3),
        content: Text('Expense deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // width and height of system or device
    final width = MediaQuery.of(context).size.width;
    Widget mainContent = Center(
      child: Text("No expense found, Start adding some!"),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Expenses Tracker"),
        //appBar is the widget that displays the app bar at the top of the screen
        // AppBar is a material design app bar that can be used to display the title of the screen and actions.
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _openAddExpenseOverlay,
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(child: mainContent),
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _registeredExpenses)),
                Expanded(child: mainContent),
              ],
            ),
    );
  }
}
