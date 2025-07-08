import 'package:flutter/material.dart';
import 'package:spendo/models/expense.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});
  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(expense.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '\$${expense.amount.toStringAsFixed(2)}',
                ), // Displaying amount with two decimal places
                const Spacer(), // This will push the date to the right side
                Row(
                  children: [
                    Icon(
                      categoryIcons[expense.category],
                    ), // Displaying category icon
                    const SizedBox(
                      width: 8,
                    ), // Adding space between icon and date
                    Text(expense.formattedDate),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
