import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spendo/models/expense.dart';

class NewExpenses extends StatefulWidget {
  const NewExpenses({super.key, required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;
  @override
  State<NewExpenses> createState() => _NewExpensesState();
}

class _NewExpensesState extends State<NewExpenses> {
  //method 2 to store the input value
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  // method 1 to store the input value
  // var _enteredTitle = '';
  // void _saveTitleInput(String inputValue) {
  //   // This function will be used to save the title input
  //     _enteredTitle = inputValue;
  // }
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDialog() {
    // different alert box for different device(androis or iphone)
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text("Invalid input"),
          content: const Text(
            "Please make sure a valid title, amount, date and was entered...",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text("Okay"),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Invalid input"),
          content: const Text(
            "Please make sure a valid title, amount, date and was entered...",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text("Okay"),
            ),
          ],
        ),
      );
    }
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid =
        enteredAmount == null ||
        enteredAmount <=
            0; // if entered amount is null then amountidinvalid is assigned.
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      _showDialog();
      return;
    }
    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    // This function will be used to dispose the controller when the widget is removed from the widget tree
    _titleController.dispose();
    _amountController.dispose();
    // you should dispose the controller to free up resources
    // cause it can crash the app if you don't dispose it and memory leaks can occur
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final width = constraints.maxWidth;

        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
              child: Column(
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _titleController,
                            //method 1
                            // onChanged: _saveTitleInput,
                            maxLength: 50,
                            decoration: InputDecoration(
                              label: Text("Title"),
                              hintText: "Enter the title of the expense",
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefixText: '₹ ',
                              label: Text("Amount"),
                              hintText: "Enter the Amount of the expense",
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      //method 2
                      // controller argment to tell flutter about controller field set
                      controller: _titleController,
                      //method 1
                      // onChanged: _saveTitleInput,
                      maxLength: 50,
                      decoration: InputDecoration(
                        label: Text("Title"),
                        hintText: "Enter the title of the expense",
                      ),
                    ),
                  // TextField(maxLength: 50, keyboardType: TextInputType.text,),
                  if (width >= 600)
                    Row(
                      children: [
                        DropdownButton(
                          value: _selectedCategory, // to inital select the type
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category.name.toUpperCase()),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = value; // storing value
                            });
                          },
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                _selectedDate == null
                                    ? 'No Date Selected'
                                    : formatter.format(_selectedDate!),
                              ),
                              IconButton(
                                onPressed: _presentDatePicker,
                                icon: const Icon(Icons.calendar_month),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefixText: '₹ ',
                              label: Text("Amount"),
                              hintText: "Enter the Amount of the expense",
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                _selectedDate == null
                                    ? 'No Date Selected'
                                    : formatter.format(_selectedDate!),
                              ),
                              IconButton(
                                onPressed: _presentDatePicker,
                                icon: const Icon(Icons.calendar_month),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  if (width >= 600)
                    Row(
                      children: [
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(
                              context,
                            ); // it simply removes the overlay from the screen
                          },
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _submitExpenseData();
                          },
                          child: const Text("Save Expense"),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        DropdownButton(
                          value: _selectedCategory, // to inital select the type
                          items: Category.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category.name.toUpperCase()),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = value; // storing value
                            });
                          },
                        ),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(
                              context,
                            ); // it simply removes the overlay from the screen
                          },
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _submitExpenseData();
                          },
                          child: const Text("Save Expense"),
                        ),
                        // method 1 to store the inpput value
                        // ElevatedButton(
                        //   onPressed: () {
                        //     print(_enteredTitle);
                        //   },
                        //   child: Text("Add Expense"),
                        // ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
