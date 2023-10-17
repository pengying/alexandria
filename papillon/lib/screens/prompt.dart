import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:papillon/appstate.dart';
import 'package:papillon/models/book_model.dart';
import 'package:papillon/screens/book_reader.dart';
import 'package:provider/provider.dart';
import '../graph.dart';

class Prompt extends StatefulWidget {
  @override
  State<Prompt> createState() => _PromptState();
}

class _PromptState extends State<Prompt> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final promptController = TextEditingController();
  final systemPromptController = TextEditingController(text: '''
You are a kids book author.   Your user will give you ideas for books that you'll then write.  You write engaging stories that sometimes rhyme and use anapestic tetrameter.  

You are inspired by authors like Dr. Seuss, Roald Dhal and Mo Willems.  Your books sometimes include life lessons.  

Your books are age appropriate and coherent.  You try to add scientific insight into your stories. Your stories provide detail about how the characters are achieve their goals.  Your stories are at least 10 pages long.  Your stories typically have two or more characters with the characters exhibiting good social behavior.

Your stories have a five act structure:
Act I: Exposition. 
Act II: Rising action.
Act III: Climax.
Act IV: Falling action. The elements of act four—also called the falling action—include the series of events that lead to the resolution.
Act V: Resolution.

Break the book into pages.  For each page add a section verbally describing of the scene to use in stable diffusion.  Add a section at the end to describe the character's appearance in simple terms.  Return the response in JSON format like the following example.

JSON Example: """
{
  "title": "Title",
  "pages":[
      {
          "text": "Page text",
          "sceneDescription": "Verbally describe visuals"
      }
  ],
  "characters": [
      {
          "name":"Character name",
          "description": "characters description"
      }
  ]
}
"""
''');
  final editPromptController = TextEditingController(text: '''
You are a kids book editor that checks if a story is coherent and appropriate.  If it isn't, you modify the story to improve it's coherency.  You try to keep the same rhyming scheme if the story rhymes.  If you need to escape code use a backtick.  You also add additional detail and extend the story's length.  Verify that the json is correct.

The user will provide a story in json format and you will output the edited story in json. If no edits are needed you return the original json input.

JSON Example: """
  {
    "title": "Title",
    "pages":[
        {
            "text": "Page text",
            "sceneDescription": "Verbally describe visuals"
        }
    ],
    "characters": [
        {
            "name":"Character name",
            "description": "characters description"
        }
    ]
  }
  """
''');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    ageController.dispose();
    promptController.dispose();
    systemPromptController.dispose();
    editPromptController.dispose();
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
        userPrompt: promptController.text,
        systemPrompt: systemPromptController.text,
        editPrompt: editPromptController.text);

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
        BookModel book = BookModel.fromQueryResult(
            queryResult: value.data!['generateBookFromPrompt']!);
        Provider.of<MyAppState>(context, listen: false).addBook(book);
        Navigator.pop(context);
        log(json.encode(value.data));
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => BookReader(book: book)));
      },
    ).catchError((error) {
       Navigator.pop(context);
      log(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: FocusTraversalGroup(
            policy: OrderedTraversalPolicy(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          controller: systemPromptController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text.rich(
                              TextSpan(
                                children: <InlineSpan>[
                                  WidgetSpan(
                                    child: Text(
                                      'System Prompt',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          maxLines: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          controller: editPromptController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text.rich(
                              TextSpan(
                                children: <InlineSpan>[
                                  WidgetSpan(
                                    child: Text(
                                      'Edit Prompt',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          maxLines: 20,
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
            )));
  }
}
