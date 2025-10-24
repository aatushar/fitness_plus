// ==================== ADD EXERCISES PAGE ====================
// Save as: add_exercises_page.dart

import 'package:flutter/material.dart';

class AddExercisesPage extends StatefulWidget {
  const AddExercisesPage({Key? key}) : super(key: key);

  @override
  State<AddExercisesPage> createState() => _AddExercisesPageState();
}

class _AddExercisesPageState extends State<AddExercisesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  List<Map<String, dynamic>> _selectedExercises = [];

  final List<Map<String, dynamic>> _exercises = [
    {'name': 'Ab Wheel', 'category': 'Abs', 'image': '🏋️', 'difficulty': 'Hard'},
    {'name': 'Alternating Punch', 'category': 'Shoulders', 'image': '🥊', 'difficulty': 'Medium'},
    {'name': 'Alternating V Up • Band', 'category': 'Abs', 'image': '💪', 'difficulty': 'Hard'},
    {'name': 'Arm Circles', 'category': 'Shoulders', 'image': '🔄', 'difficulty': 'Easy'},
    {'name': 'Arnold Press • Dumbbell', 'category': 'Shoulders', 'image': '🏋️', 'difficulty': 'Hard'},
    {'name': 'Back Extension', 'category': 'Lower back', 'image': '🧘', 'difficulty': 'Medium'},
    {'name': 'Back Extension On Floor', 'category': 'Lower back', 'image': '🧘', 'difficulty': 'Easy'},
    {'name': 'Back Extension • Band', 'category': 'Lower back', 'image': '💪', 'difficulty': 'Medium'},
    {'name': 'Back Extension • Machine', 'category': 'Lower back', 'image': '⚙️', 'difficulty': 'Medium'},
    {'name': 'Backward Lunge', 'category': 'Glutes', 'image': '🦵', 'difficulty': 'Easy'},
    {'name': 'Backward Lunge with Leg Lift', 'category': 'Quadriceps', 'image': '🦵', 'difficulty': 'Medium'},
    {'name': 'Backward Lunge • Cable', 'category': 'Glutes', 'image': '💪', 'difficulty': 'Hard'},
    {'name': 'Backward Lunge • Dumbbell', 'category': 'Glutes', 'image': '🏋️', 'difficulty': 'Hard'},
    {'name': 'Backward Lunge • Kettlebell', 'category': 'Glutes', 'image': '⚫', 'difficulty': 'Hard'},
    {'name': 'Backward Lunge • Smith Machine', 'category': 'Glutes', 'image': '⚙️', 'difficulty': 'Hard'},
    {'name': 'Ball Slams', 'category': 'Full Body', 'image': '🏐', 'difficulty': 'Medium'},
    {'name': 'Bench Jump', 'category': 'Glutes', 'image': '📦', 'difficulty': 'Hard'},
    {'name': 'Bench Pistol Squat', 'category': 'Glutes', 'image': '🦵', 'difficulty': 'Hard'},
    {'name': 'Bench Press (Close Grip) • Barbell', 'category': 'Triceps', 'image': '🏋️', 'difficulty': 'Hard'},
    {'name': 'Bench Press (Close Grip) • Dumbbell', 'category': 'Triceps', 'image': '🏋️', 'difficulty': 'Hard'},
    {'name': 'Bench Press • Barbell', 'category': 'Chest', 'image': '🏋️', 'difficulty': 'Hard'},
    {'name': 'Bicep Curl • Barbell', 'category': 'Biceps', 'image': '💪', 'difficulty': 'Medium'},
    {'name': 'Bicep Curl • Dumbbell', 'category': 'Biceps', 'image': '🏋️', 'difficulty': 'Medium'},
    {'name': 'Cable Fly', 'category': 'Chest', 'image': '💪', 'difficulty': 'Medium'},
    {'name': 'Calf Raise', 'category': 'Calves', 'image': '🦵', 'difficulty': 'Easy'},
    {'name': 'Chest Dip', 'category': 'Chest', 'image': '💪', 'difficulty': 'Hard'},
    {'name': 'Crunch', 'category': 'Abs', 'image': '🧘', 'difficulty': 'Easy'},
    {'name': 'Deadlift • Barbell', 'category': 'Back', 'image': '🏋️', 'difficulty': 'Hard'},
    {'name': 'Leg Press', 'category': 'Quadriceps', 'image': '⚙️', 'difficulty': 'Medium'},
    {'name': 'Plank', 'category': 'Abs', 'image': '🧘', 'difficulty': 'Medium'},
    {'name': 'Pull Up', 'category': 'Back', 'image': '💪', 'difficulty': 'Hard'},
    {'name': 'Push Up', 'category': 'Chest', 'image': '💪', 'difficulty': 'Medium'},
    {'name': 'Squat • Barbell', 'category': 'Quadriceps', 'image': '🏋️', 'difficulty': 'Hard'},
    {'name': 'Tricep Dip', 'category': 'Triceps', 'image': '💪', 'difficulty': 'Medium'},
  ];

  List<Map<String, dynamic>> _filteredExercises = [];

  @override
  void initState() {
    super.initState();
    _filteredExercises = _exercises;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterExercises(String query) {
    setState(() {
      _filteredExercises = _exercises.where((exercise) {
        final matchesSearch = exercise['name'].toString().toLowerCase().contains(query.toLowerCase());
        final matchesCategory = _selectedFilter == 'All' || exercise['category'] == _selectedFilter;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _toggleExercise(Map<String, dynamic> exercise) {
    setState(() {
      if (_selectedExercises.contains(exercise)) {
        _selectedExercises.remove(exercise);
      } else {
        _selectedExercises.add(exercise);
      }
    });
  }

  void _addSelectedExercises() {
    if (_selectedExercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one exercise'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.pop(context, _selectedExercises);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add exercises',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _filterExercises,
              decoration: InputDecoration(
                hintText: 'Search exercises',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // Filter Chip
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                children: [
                  _buildFilterChip('All', _exercises.length),
                  _buildFilterChip('Abs', _exercises.where((e) => e['category'] == 'Abs').length),
                  _buildFilterChip('Back', _exercises.where((e) => e['category'] == 'Back').length),
                  _buildFilterChip('Chest', _exercises.where((e) => e['category'] == 'Chest').length),
                  _buildFilterChip('Legs', _exercises.where((e) => e['category'] == 'Quadriceps' || e['category'] == 'Glutes').length),
                ],
              ),
            ),
          ),

          // Exercise List
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                itemCount: _filteredExercises.length,
                itemBuilder: (context, index) {
                  final exercise = _filteredExercises[index];
                  final isSelected = _selectedExercises.contains(exercise);

                  // Group by first letter
                  final showLetter = index == 0 ||
                      _filteredExercises[index - 1]['name'][0] != exercise['name'][0];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showLetter)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          color: Colors.grey[100],
                          child: Text(
                            exercise['name'][0],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      InkWell(
                        onTap: () => _toggleExercise(exercise),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey[200]!),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Checkbox
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? Colors.blue : Colors.grey[400]!,
                                    width: 2,
                                  ),
                                  color: isSelected ? Colors.blue : Colors.transparent,
                                ),
                                child: isSelected
                                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                                    : null,
                              ),
                              const SizedBox(width: 16),

                              // Exercise Image
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    exercise['image'],
                                    style: const TextStyle(fontSize: 30),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Exercise Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      exercise['name'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      exercise['category'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Difficulty Badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getDifficultyColor(exercise['difficulty']).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  exercise['difficulty'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _getDifficultyColor(exercise['difficulty']),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),

      // Bottom Add Button
      bottomNavigationBar: _selectedExercises.isNotEmpty
          ? Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _addSelectedExercises,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'ADD ${_selectedExercises.length} EXERCISE${_selectedExercises.length > 1 ? 'S' : ''}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      )
          : null,
    );
  }

  Widget _buildFilterChip(String label, int count) {
    final isSelected = _selectedFilter == label;
    return FilterChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = label;
          _filterExercises(_searchController.text);
        });
      },
      backgroundColor: Colors.grey[200],
      selectedColor: Colors.grey[800],
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide.none,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'Hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}