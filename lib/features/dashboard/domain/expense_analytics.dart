class MonthlyExpense {
  final String month;
  final double totalCost;

  MonthlyExpense({required this.month, required this.totalCost});

  factory MonthlyExpense.fromJson(Map<String, dynamic> json) {
    return MonthlyExpense(
      month: json['month'],
      totalCost: (json['total_cost'] as num).toDouble(),
    );
  }
}

class CategoryExpense {
  final String category;
  final double totalCost;

  CategoryExpense({required this.category, required this.totalCost});

  factory CategoryExpense.fromJson(Map<String, dynamic> json) {
    return CategoryExpense(
      category: json['category'],
      totalCost: (json['total_cost'] as num).toDouble(),
    );
  }
}

class ExpenseAnalytics {
  final List<MonthlyExpense> monthlyExpenses;
  final List<CategoryExpense> categoryExpenses;

  ExpenseAnalytics({
    required this.monthlyExpenses,
    required this.categoryExpenses,
  });

  factory ExpenseAnalytics.fromJson(Map<String, dynamic> json) {
    return ExpenseAnalytics(
      monthlyExpenses: (json['monthly_expenses'] as List)
          .map((i) => MonthlyExpense.fromJson(i))
          .toList(),
      categoryExpenses: (json['category_expenses'] as List)
          .map((i) => CategoryExpense.fromJson(i))
          .toList(),
    );
  }
}
