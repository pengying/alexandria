import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:papillon/appstate.dart';
import 'package:papillon/models/book_model.dart';
import 'package:papillon/screens/book_reader.dart';
import 'package:provider/provider.dart';
import 'graph.dart';

class Prompt extends StatefulWidget {
  @override
  State<Prompt> createState() => _PromptState();
}

class _PromptState extends State<Prompt> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final promptController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    ageController.dispose();
    promptController.dispose();

    super.dispose();
  }

  void generateBook() {
    // Validate will return true if the form is valid, or false if
    // the form is invalid.
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Generating Book.  Hold on this may take a while')),
      );
    }

    log('name: ${nameController.text}');

    // Pass prompt to BE
    var gPromise = generateBookFromPrompt(
        name: nameController.text,
        age: int.parse(ageController.text),
        prompt: promptController.text);

    // While waiting for the net work response show a dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              Text("Generating Book.  Hold on this may take a while"),
            ],
          ),
        );
      },
    );

    // Resolve the promise then hide the dialog.
    gPromise.then(
      (value) {
        BookModel book = BookModel.fromQueryResult(queryResult: value.data!['generateBookFromPrompt']!);
        Provider.of<MyAppState>(context, listen: false).addBook(book);
        Navigator.pop(context);
        log(json.encode(value.data));
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => BookReader(book: book)));
      },
    ).catchError((error) {
      log(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(height: 10),
          Text(
            "Story Prompt",
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              // autofocus: true,
              controller: nameController,
              decoration: const InputDecoration(
                label: Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      WidgetSpan(
                        child: Text(
                          'Name',
                        ),
                      ),
                      WidgetSpan(
                        child: Text(
                          '*',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.name,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              controller: ageController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      WidgetSpan(
                        child: Text(
                          'Age',
                        ),
                      ),
                      WidgetSpan(
                        child: Text(
                          '*',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an age';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              controller: promptController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text.rich(
                  TextSpan(
                    children: <InlineSpan>[
                      WidgetSpan(
                        child: Text(
                          'Story Prompt',
                        ),
                      ),
                      WidgetSpan(
                        child: Text(
                          '*',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
                hintText:
                    'A story about kids riding a magic school bus to space and exploring the solar system',
              ),
              maxLines: 4,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a prompt';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: generateBook,
              child: const Text('Generate'),
            ),
          ),
        ]),
      ),
    );
  }
}
