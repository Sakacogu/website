final List<Map<String, dynamic>> categories = [
  {'label': 'Allar vörur', 'categoryId': '0'},
  {'label': 'Konur', 'categoryId': '1'},
  {'label': 'Karlar', 'categoryId': '2'},
  {'label': 'Börn', 'categoryId': '3'},
];

final Map<String, List<String>> categorySubcategories = {
  '0': ['All'],
  '1': ['peysur', 'skyrtur', 'yfirhafnir', 'buxur', 'kjólar', 'fylgihlutir'], // Konur
  '2': ['peysur', 'skyrtur', 'yfirhafnir', 'buxur', 'fylgihlutir'], // Karlar
  '3': ['peysur', 'skyrtur', 'yfirhafnir', 'buxur', 'kjólar', 'fylgihlutir'], // Börn
};
