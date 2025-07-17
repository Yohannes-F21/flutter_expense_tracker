import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expense_list/expense_item.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({
    super.key,
    required this.expenses,
    required this.onDeleteExpense,
  });
  final List<Expense> expenses;
  final void Function(Expense expense) onDeleteExpense;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: expenses.length, // Placeholder for the number of expenses
        itemBuilder: (ctx, index) {
          return Dismissible(
            key: ValueKey(expenses[index].id), // Unique key for each item
            direction:
                DismissDirection.endToStart, // Only allow swipe right-to-left
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              // Remove the item from your data list
              onDeleteExpense(expenses[index]);
            },
            child: ExpenseItem(expense: expenses[index]),
          );
        },
      ),
    );
  }
}
