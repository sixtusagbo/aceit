import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class QuizzesPage extends HookWidget {
  const QuizzesPage({super.key});

  static String get routeName => 'quizzes';
  static String get routeLocation => '/$routeName';

  @override
  Widget build(BuildContext context) {
    // New quiz form with select school, select level, select course, select semester(optional) and a button to start quiz. Use a dummy data for the select options for now.
    // Create global key for form
    final formKey = useMemoized(GlobalKey<FormState>.new);
    // Create the input states
    final school = useState('');
    final level = useState('');
    final course = useState('');
    final semester = useState('');

    // Dummy data for select options
    final schools = [
      'Nnamdi Azikiwe University',
      'University of Nigeria, Nsukka',
      'Ebonyi State University',
      'University of Lagos',
      'University of Ibadan',
      'University of Benin',
      'University of Abuja',
      'University of Port Harcourt',
    ];
    final levels = [
      '100 Level',
      '200 Level',
      '300 Level',
      '400 Level',
    ];
    final semesters = [
      'First Semester',
      'Second Semester',
    ];
    final courses = [
      'CSC 101 - Intro to Computer Science',
      'CSC 102 - Intro to Programming',
      'CSC 201 - DSA',
      'CSC 202 - Software Engineering',
      'CSC 301 - Operating Systems',
      'CSC 302 - Computer Networks',
      'CSC 401 - DBMS',
      'CSC 402 - Web Development',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Select school
              DropdownButtonFormField<String>(
                value: school.value.isEmpty ? null : school.value,
                decoration: const InputDecoration(labelText: 'Select School'),
                items: schools.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (newValue) {
                  school.value = newValue!;
                },
                validator: (value) => value == null || value.isEmpty
                    ? 'Please select a school'
                    : null,
              ),
              const SizedBox(height: 16.0),
              // Select level
              DropdownButtonFormField<String>(
                value: level.value.isEmpty ? null : level.value,
                decoration: const InputDecoration(labelText: 'Select Level'),
                items: levels.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (newValue) {
                  level.value = newValue!;
                },
                validator: (value) => value == null || value.isEmpty
                    ? 'Please select a level'
                    : null,
              ),
              const SizedBox(height: 16.0),
              // Select semester (optional)
              DropdownButtonFormField<String>(
                value: semester.value.isEmpty ? null : semester.value,
                decoration: const InputDecoration(
                    labelText: 'Select Semester (Optional)'),
                items: semesters.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (newValue) {
                  semester.value = newValue!;
                },
              ),
              const SizedBox(height: 16.0),
              // Select course
              DropdownButtonFormField<String>(
                value: course.value.isEmpty ? null : course.value,
                decoration: const InputDecoration(labelText: 'Select Course'),
                items: courses.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
                onChanged: (newValue) {
                  course.value = newValue!;
                },
                validator: (value) => value == null || value.isEmpty
                    ? 'Please select a course'
                    : null,
              ),
              const SizedBox(height: 32.0),
              // Start quiz button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Start the quiz
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Starting quiz...')),
                      );

                      // For now, navigate to the quiz page
                      context.push('${QuizzesPage.routeLocation}/1');
                    }
                  },
                  child: const Text('Start Quiz'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
