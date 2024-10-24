import 'dart:developer';

import 'package:aceit/models/course.dart';
import 'package:aceit/models/department.dart';
import 'package:aceit/models/faculty.dart';
import 'package:aceit/models/level.dart';
import 'package:aceit/models/school.dart';
import 'package:aceit/models/semester.dart';
import 'package:aceit/state/courses.dart';
import 'package:aceit/state/departments.dart';
import 'package:aceit/state/faculties.dart';
import 'package:aceit/state/levels.dart';
import 'package:aceit/state/quizzes.dart';
import 'package:aceit/state/schools.dart';
import 'package:aceit/state/semesters.dart';
import 'package:aceit/widgets/form_input_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewQuizPage extends HookConsumerWidget {
  const NewQuizPage({super.key});

  static String get routeName => 'new-quiz';
  static String get routeLocation => '/quiz/new';

  void resetDependentSelections(
    WidgetRef ref, {
    bool resetFaculty = false,
    bool resetDepartment = false,
    bool resetLevel = false,
    bool resetSemester = false,
    bool resetCourse = false,
  }) {
    if (resetFaculty) {
      ref.read(selectedFacultyProvider.notifier).state = null;
      resetDepartment = true;
    }
    if (resetDepartment) {
      ref.read(selectedDepartmentProvider.notifier).state = null;
      resetLevel = true;
    }
    if (resetLevel) {
      ref.read(selectedLevelProvider.notifier).state = null;
      resetSemester = true;
    }
    if (resetSemester) {
      ref.read(selectedSemesterProvider.notifier).state = null;
      resetCourse = true;
    }
    if (resetCourse) {
      ref.read(selectedCourseProvider.notifier).state = null;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);

    final schoolsAsync = ref.watch(schoolsProvider);
    final selectedSchool = ref.watch(selectedSchoolProvider);
    final facultiesAsync = ref.watch(facultiesProvider(selectedSchool));
    final selectedFaculty = ref.watch(selectedFacultyProvider);
    final departmentsAsync = ref.watch(departmentsProvider(selectedFaculty));
    final selectedDepartment = ref.watch(selectedDepartmentProvider);
    final levelsAsync = ref.watch(levelsProvider);
    final selectedLevel = ref.watch(selectedLevelProvider);
    final semestersAsync = ref.watch(semestersProvider);
    final selectedSemester = ref.watch(selectedSemesterProvider);
    final coursesAsync = ref.watch(coursesProvider((
      departmentId: selectedDepartment,
      levelId: selectedLevel,
      semesterId: selectedSemester
    )));
    final selectedCourse = ref.watch(selectedCourseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Quiz'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
          children: [
            schoolsAsync.when(
              data: (schools) => DropdownButtonFormField<String>(
                value: selectedSchool,
                decoration: const InputDecoration(labelText: 'Select School'),
                items: schools
                    .map((School school) => DropdownMenuItem<String>(
                          value: school.id,
                          child: Text(school.name,
                              overflow: TextOverflow.ellipsis),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  ref.read(selectedSchoolProvider.notifier).state = newValue;
                  resetDependentSelections(ref, resetFaculty: true);
                },
                validator: (value) =>
                    value == null ? 'Please select a school' : null,
              ),
              loading: () => const FormInputSkeleton(),
              error: (_, __) => const Text('Error loading schools'),
            ),
            const SizedBox(height: 16.0),
            facultiesAsync.when(
              data: (faculties) => DropdownButtonFormField<String>(
                value: selectedFaculty,
                decoration: const InputDecoration(labelText: 'Select Faculty'),
                items: faculties
                    .map((Faculty faculty) => DropdownMenuItem<String>(
                          value: faculty.id,
                          child: Text(faculty.name,
                              overflow: TextOverflow.ellipsis),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  ref.read(selectedFacultyProvider.notifier).state = newValue;
                  resetDependentSelections(ref, resetDepartment: true);
                },
                validator: (value) =>
                    value == null ? 'Please select a faculty' : null,
              ),
              loading: () => const FormInputSkeleton(),
              error: (err, __) {
                log(err.toString(), name: 'QuizzesPage');
                return const Text('Error loading faculties');
              },
            ),
            const SizedBox(height: 16.0),
            departmentsAsync.when(
              data: (departments) => DropdownButtonFormField<String>(
                value: selectedDepartment,
                decoration:
                    const InputDecoration(labelText: 'Select Department'),
                items: departments
                    .map((Department department) => DropdownMenuItem<String>(
                          value: department.id,
                          child: Text(department.name,
                              overflow: TextOverflow.ellipsis),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  ref.read(selectedDepartmentProvider.notifier).state =
                      newValue;
                  resetDependentSelections(ref, resetLevel: true);
                },
                validator: (value) =>
                    value == null ? 'Please select a department' : null,
              ),
              loading: () => const FormInputSkeleton(),
              error: (_, __) => const Text('Error loading departments'),
            ),
            const SizedBox(height: 16.0),
            levelsAsync.when(
              data: (levels) => DropdownButtonFormField<String>(
                value: selectedLevel,
                decoration: const InputDecoration(labelText: 'Select Level'),
                items: levels
                    .map((Level level) => DropdownMenuItem<String>(
                          value: level.id,
                          child:
                              Text(level.name, overflow: TextOverflow.ellipsis),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  ref.read(selectedLevelProvider.notifier).state = newValue;
                  resetDependentSelections(ref, resetSemester: true);
                },
                validator: (value) =>
                    value == null ? 'Please select a level' : null,
              ),
              loading: () => const FormInputSkeleton(),
              error: (_, __) => const Text('Error loading levels'),
            ),
            const SizedBox(height: 16.0),
            semestersAsync.when(
              data: (semesters) => DropdownButtonFormField<String>(
                value: selectedSemester,
                decoration: const InputDecoration(
                    labelText: 'Select Semester (Optional)'),
                items: semesters
                    .map((Semester semester) => DropdownMenuItem<String>(
                          value: semester.id,
                          child: Text(semester.name,
                              overflow: TextOverflow.ellipsis),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  ref.read(selectedSemesterProvider.notifier).state = newValue;
                  resetDependentSelections(ref, resetCourse: true);
                },
              ),
              loading: () => const FormInputSkeleton(),
              error: (_, __) => const Text('Error loading semesters'),
            ),
            const SizedBox(height: 16.0),
            coursesAsync.when(
              data: (courses) => DropdownButtonFormField<String>(
                value: selectedCourse,
                decoration: const InputDecoration(labelText: 'Select Course'),
                items: courses
                    .map((Course course) => DropdownMenuItem<String>(
                          value: course.id,
                          child: SizedBox(
                            width: 0.8.sw,
                            child: Text(
                              '${course.code} - ${course.title}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (newValue) =>
                    ref.read(selectedCourseProvider.notifier).state = newValue,
                validator: (value) =>
                    value == null ? 'Please select a course' : null,
              ),
              loading: () => const FormInputSkeleton(),
              error: (_, __) => const Text('Error loading courses'),
            ),
            const SizedBox(height: 32.0),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final String? quizId = await ref
                        .read(quizIdByCourseProvider(selectedCourse!).future);
                    if (quizId == null) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('No quiz found for selected course')),
                        );
                      }
                      return;
                    }
                    log('Quiz ID: $quizId', name: 'QuizzesPage');

                    if (context.mounted) {
                      context.push('/quiz/$quizId');
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please fill in all fields')),
                    );
                  }
                },
                child: const Text('Start Quiz'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
