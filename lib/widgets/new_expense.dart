import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  final void Function(Expense expense) onAddExpense;
  const NewExpense({super.key, required this.onAddExpense});

  // final void Function(String title, double amount, DateTime date) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  Category _selectedCategory = Category.food;
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  bool _isTitleEmpty = false;
  bool _isAmountEmpty = false;
  bool _isDateEmpty = false;

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
      _selectedDate = pickedDate ?? DateTime.now();
      // If no date is picked, default to now
    });
  }

  void _addExpense() {
    setState(() {
      _isTitleEmpty = _titleController.text.isEmpty;
      _isAmountEmpty = _amountController.text.isEmpty;
      _isDateEmpty = _selectedDate == null;
    });

    if (_isTitleEmpty || _isAmountEmpty || _isDateEmpty) {
      return; // Exit if validation fails
    }

    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: InputDecoration(
              label: const Text('Title'),
              errorText: _isTitleEmpty ? 'Title cannot be empty' : null,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: '\$ ',
                    label: const Text('Amount'),
                    errorText: _isAmountEmpty ? 'Amount cannot be empty' : null,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                _selectedDate == null
                    ? 'No date selected'
                    : formatter.format(_selectedDate!),
                style: TextStyle(
                  color: _isDateEmpty
                      ? Colors.red
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),

              IconButton(
                onPressed: _presentDatePicker,
                icon: Icon(Icons.calendar_month),
                tooltip: 'Select Date',
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                items: Category.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Row(
                      children: [
                        Icon(categoryIcons[category]),
                        const SizedBox(width: 8),
                        Text(category.name.toUpperCase()),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  _addExpense();
                  // Navigator.pop(context);
                },
                child: const Text('Save Expense'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
