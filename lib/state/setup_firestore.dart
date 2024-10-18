import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SetupFirestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> setupInitialData() async {
    final alreadySetup = await _firestore.collection('schools').get();
    if (alreadySetup.docs.isNotEmpty) {
      if (kDebugMode) {
        log('Initial data already setup.', name: 'FirestoreSetup');
      }
      return;
    }
    await _setupSchoolsAndHierarchy();
    await _setupQuizzes();
    if (kDebugMode) {
      log('Initial data setup complete.', name: 'FirestoreSetup');
    }
  }

  Future<void> _setupSchoolsAndHierarchy() async {
    // Setup Schools
    Map<String, String> schoolIds = await _setupSchools();

    // Setup Faculties
    Map<String, String> facultyIds =
        await _setupFaculties(schoolIds['Nnamdi Azikiwe University']!);

    // Setup Departments
    Map<String, String> departmentIds =
        await _setupDepartments(facultyIds['Faculty of Physical Sciences']!);

    // Setup Levels
    Map<String, String> levelIds = await _setupLevels();

    // Setup Semesters
    Map<String, String> semesterIds = await _setupSemesters();

    // Setup Courses
    await _setupCourses(schoolIds['Nnamdi Azikiwe University']!,
        departmentIds['Computer Science']!, levelIds, semesterIds);
  }

  Future<Map<String, String>> _setupSchools() async {
    final schools = [
      {'name': 'Nnamdi Azikiwe University'},
      {'name': 'University of Nigeria, Nsukka'},
    ];

    Map<String, String> schoolIds = {};
    for (var school in schools) {
      DocumentReference docRef =
          await _firestore.collection('schools').add(school);
      schoolIds[school['name'] as String] = docRef.id;
    }
    return schoolIds;
  }

  Future<Map<String, String>> _setupFaculties(String schoolId) async {
    final faculties = [
      {'name': 'Faculty of Physical Sciences', 'school_id': schoolId},
      {'name': 'Faculty of Engineering', 'school_id': schoolId},
    ];

    Map<String, String> facultyIds = {};
    for (var faculty in faculties) {
      DocumentReference docRef =
          await _firestore.collection('faculties').add(faculty);
      facultyIds[faculty['name'] as String] = docRef.id;
    }
    return facultyIds;
  }

  Future<Map<String, String>> _setupDepartments(String facultyId) async {
    final departments = [
      {'name': 'Computer Science', 'faculty_id': facultyId},
      {'name': 'Mathematics', 'faculty_id': facultyId},
    ];

    Map<String, String> departmentIds = {};
    for (var department in departments) {
      DocumentReference docRef =
          await _firestore.collection('departments').add(department);
      departmentIds[department['name'] as String] = docRef.id;
    }
    return departmentIds;
  }

  Future<Map<String, String>> _setupLevels() async {
    final levels = [
      {'name': '100 Level'},
      {'name': '200 Level'},
      {'name': '300 Level'},
      {'name': '400 Level'},
      {'name': '500 Level'},
    ];

    Map<String, String> levelIds = {};
    for (var level in levels) {
      DocumentReference docRef =
          await _firestore.collection('levels').add(level);
      levelIds[level['name'] as String] = docRef.id;
    }
    return levelIds;
  }

  Future<Map<String, String>> _setupSemesters() async {
    final semesters = [
      {'name': 'First Semester'},
      {'name': 'Second Semester'},
    ];

    Map<String, String> semesterIds = {};
    for (var semester in semesters) {
      DocumentReference docRef =
          await _firestore.collection('semesters').add(semester);
      semesterIds[semester['name'] as String] = docRef.id;
    }
    return semesterIds;
  }

  Future<void> _setupCourses(String schoolId, String departmentId,
      Map<String, String> levelIds, Map<String, String> semesterIds) async {
    final courses = [
      {
        'code': 'CSC 101',
        'title': 'Introduction to Computer Science',
        'level_id': levelIds['100 Level'],
        'semester_id': semesterIds['First Semester']
      },
      {
        'code': 'MAT 101',
        'title': 'Elementary Mathematics I',
        'level_id': levelIds['100 Level'],
        'semester_id': semesterIds['First Semester']
      },
      {
        'code': 'CSC 102',
        'title': 'Introduction to Programming',
        'level_id': levelIds['100 Level'],
        'semester_id': semesterIds['Second Semester']
      },
      {
        'code': 'MAT 102',
        'title': 'Elementary Mathematics II',
        'level_id': levelIds['100 Level'],
        'semester_id': semesterIds['Second Semester']
      },
      {
        'code': 'CSC 301',
        'title': 'Data Structures',
        'level_id': levelIds['300 Level'],
        'semester_id': semesterIds['First Semester']
      },
      {
        'code': 'MAT 301',
        'title': 'Advanced Calculus',
        'level_id': levelIds['300 Level'],
        'semester_id': semesterIds['First Semester']
      },
      {
        'code': 'CSC 302',
        'title': 'Algorithms',
        'level_id': levelIds['300 Level'],
        'semester_id': semesterIds['Second Semester']
      },
      {
        'code': 'MAT 302',
        'title': 'Complex Analysis',
        'level_id': levelIds['300 Level'],
        'semester_id': semesterIds['Second Semester']
      },
      {
        'code': 'CSC 401',
        'title': 'Software Engineering',
        'level_id': levelIds['400 Level'],
        'semester_id': semesterIds['First Semester']
      },
      {
        'code': 'MAT 401',
        'title': 'Numerical Analysis',
        'level_id': levelIds['400 Level'],
        'semester_id': semesterIds['First Semester']
      },
    ];

    for (var course in courses) {
      await _firestore.collection('courses').add({
        ...course,
        'school_id': schoolId,
        'department_id': departmentId,
      });
    }
  }

  Future<void> _setupQuizzes() async {
    QuerySnapshot courseSnapshot = await _firestore.collection('courses').get();

    final questions = [
      {
        'type': 'mcq',
        'question': 'What is the primary function of a computer\'s CPU?',
        'options': [
          'Data storage',
          'Processing data',
          'Displaying graphics',
          'Network communication'
        ],
        'answer': 1,
      },
      {
        'type': 'mcq',
        'question': 'Which of the following is not a programming language?',
        'options': ['C', 'Python', 'Javascript', 'Photoshop'],
        'answer': 3,
      },
      {
        'type': 'mcq',
        'question': 'What does SQL stand for?',
        'options': [
          'Structured Query Language',
          'Simple Question Language',
          'System Quality Language',
          'Software Query Logic'
        ],
        'answer': 0,
      },
      {
        'type': 'mcq',
        'question': 'Which data structure uses LIFO (Last In, First Out)?',
        'options': ['Queue', 'Stack', 'Linked List', 'Tree'],
        'answer': 1,
      },
      {
        'type': 'mcq',
        'question': 'What is the time complexity of binary search?',
        'options': ['O(n)', 'O(log n)', 'O(n^2)', 'O(1)'],
        'answer': 1,
      },
    ];

    for (var courseDoc in courseSnapshot.docs) {
      DocumentReference quizRef = await _firestore.collection('quizzes').add({
        'type': 'practice',
        'owner': 'system',
        'course_id': courseDoc.id,
        'year': 2024,
      });

      for (var question in questions) {
        await quizRef.collection('questions').add(question);
      }
    }
  }
}
