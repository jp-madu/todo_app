import 'package:flutter/material.dart';

import 'package:todo_app/services/todo_services.dart';

import '../utilities/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: 'Title',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              hintText: 'Title',
            ),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            child: Text(isEdit ? 'Update' : 'Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> updateData() async {
    //get the date from form
    final todo = widget.todo;
    if (todo == null) {
      print('You cannot call updated with todo data');
      return;
    }
    final id = todo['_id'];

    //submit updated data to the server
    final isSuccess = await TodoService.updateTodo(id, body);

    ///show success message or fail message
    if (isSuccess) {
      showSuccessMessage(context, message: 'Update Succesful');
    } else {
      showErrorMessage(context, message: 'Error in updating task');
    }
  }

  Future<void> submitData() async {
    //get the date from form

    //submit data to server
    final isSuccess = await TodoService.addTodo(body);

    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage(context, message: 'Creation Succesful');
    } else {
      showErrorMessage(context, message: 'Creation failed');
    }
  }

  Map get body {
    //get the date from form
    final title = titleController.text;

    final description = descriptionController.text;

    return {
      "title": title,
      "description": description,
      "is_completed": false,
    };
  }
}
