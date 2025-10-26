import 'package:flutter/material.dart';

class AddExercisesPage extends StatefulWidget {
  const AddExercisesPage({Key? key}) : super(key: key);

  @override
  State<AddExercisesPage> createState() => _AddExercisesPageState();
}

class _AddExercisesPageState extends State<AddExercisesPage> {
  // Color Constants matching Dashboard
  static const Color _backgroundColor = Color(0xFF1A1A2E);
  static const Color _primaryColor = Color(0xFFE94560);
  static const Color _secondaryColor = Color(0xFF16213E);

  final List<Exercise> _exercises = [
    Exercise(name: 'Push-ups', category: 'Chest', sets: 3, reps: 12, isFavorite: false),
    Exercise(name: 'Bench Press', category: 'Chest', sets: 4, reps: 10, isFavorite: false),
    Exercise(name: 'Shoulder Press', category: 'Shoulder', sets: 3, reps: 10, isFavorite: false),
    Exercise(name: 'Lateral Raises', category: 'Shoulder', sets: 3, reps: 12, isFavorite: false),
    Exercise(name: 'Squats', category: 'Lower', sets: 4, reps: 12, isFavorite: false),
    Exercise(name: 'Lunges', category: 'Lower', sets: 3, reps: 10, isFavorite: false),
    Exercise(name: 'Plank', category: 'Full Body', sets: 3, time: '60 sec', isFavorite: false),
    Exercise(name: 'Burpees', category: 'Full Body', sets: 3, reps: 15, isFavorite: false),
  ];

  List<Exercise> _filteredExercises = [];
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _filteredExercises = _exercises;
  }

  void _filterExercises(String category) {
    setState(() {
      _selectedCategory = category;
      _filteredExercises = category == 'All'
          ? _exercises
          : _exercises.where((exercise) => exercise.category == category).toList();
    });
  }

  void _toggleFavorite(Exercise exercise) {
    setState(() {
      exercise.isFavorite = !exercise.isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _secondaryColor,
        elevation: 0,
        title: const Text(
          'Add Exercises',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: _secondaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search exercises',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  icon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          // Category Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryChip('All', _selectedCategory == 'All'),
                  _buildCategoryChip('Chest', _selectedCategory == 'Chest'),
                  _buildCategoryChip('Shoulder', _selectedCategory == 'Shoulder'),
                  _buildCategoryChip('Lower', _selectedCategory == 'Lower'),
                  _buildCategoryChip('Full Body', _selectedCategory == 'Full Body'),
                ],
              ),
            ),
          ),

          // Exercise List
          Expanded(
            child: _filteredExercises.isEmpty
                ? Center(
              child: Text(
                'No exercises found',
                style: TextStyle(color: Colors.grey[400], fontSize: 18),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: _filteredExercises.length,
              itemBuilder: (context, index) {
                final exercise = _filteredExercises[index];
                return _buildExerciseCard(exercise);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _primaryColor,
        onPressed: () {
          // TODO: Implement add new exercise functionality
          _showAddExerciseBottomSheet();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddExerciseBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _secondaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New Exercise',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildBottomSheetTextField('Exercise Name'),
            const SizedBox(height: 15),
            _buildBottomSheetTextField('Category'),
            const SizedBox(height: 15),
            _buildBottomSheetTextField('Sets'),
            const SizedBox(height: 15),
            _buildBottomSheetTextField('Reps'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement exercise addition logic
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Add Exercise',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetTextField(String hint) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[600]),
        filled: true,
        fillColor: _backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => _filterExercises(label),
        backgroundColor: _secondaryColor,
        selectedColor: _primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildExerciseCard(Exercise exercise) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: _secondaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  exercise.category,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  exercise.time != null
                      ? '${exercise.sets} sets, ${exercise.time}'
                      : '${exercise.sets} sets, ${exercise.reps} reps',
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              exercise.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: exercise.isFavorite ? _primaryColor : Colors.white,
            ),
            onPressed: () => _toggleFavorite(exercise),
          ),
        ],
      ),
    );
  }
}

class Exercise {
  final String name;
  final String category;
  final int sets;
  int? reps;
  String? time;
  bool isFavorite;

  Exercise({
    required this.name,
    required this.category,
    required this.sets,
    this.reps,
    this.time,
    this.isFavorite = false,
  });
}