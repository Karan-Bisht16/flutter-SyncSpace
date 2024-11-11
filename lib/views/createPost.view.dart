import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncspace/controllers/subspace.controller.dart';
import 'package:syncspace/models/api.response.model.dart';
import 'package:syncspace/provider/theme.provider.dart';
import 'package:syncspace/widgets/customAppBar.widget.dart';
import 'package:syncspace/widgets/customDrawer.widget.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  bool loadingJoinedSubspaces = false;
  int pageNumber = 1;
  int pageCount = 1;
  List<SubspaceModel> joinedSubspaces = [];

  final TextEditingController titleController = TextEditingController();
  bool focusedHtmlEditor = false;
  final HtmlEditorController textController = HtmlEditorController(
    processNewLineAsBr: true,
  );

  @override
  void initState() {
    super.initState();
    getJoinedSubspaces();
  }

  void getJoinedSubspaces() async {
    setState(() {
      loadingJoinedSubspaces = true;
    });
    Subspace subspace = Subspace();

    while (pageNumber == 1 || pageNumber <= pageCount) {
      var response = await subspace.fetchSubspaces(
        pageNumber,
        {'userId': widget.userId},
      );
      if (mounted) {
        setState(() {
          joinedSubspaces.addAll(response.responseData.subspaces);
          pageNumber += 1;
          pageCount = response.responseData.count;
        });
      }
    }
    setState(() {
      loadingJoinedSubspaces = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(
      context,
      listen: false,
    );
    final int theme = themeProvider.theme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(label: 'Create Post'),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              autocompleteForSubspaces(theme),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: titleController,
                cursorColor: Theme.of(context).colorScheme.primary,
                keyboardType: TextInputType.name,
                decoration: decorationForTextFormField(context, 'Title'),
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Enter username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              HtmlEditor(
                controller: textController,
                callbacks: Callbacks(onFocus: () {
                  setState(() {
                    focusedHtmlEditor = true;
                  });
                }, onBlur: () {
                  setState(() {
                    focusedHtmlEditor = false;
                  });
                }),
                htmlEditorOptions: const HtmlEditorOptions(
                  hint: 'Start writing...',
                  initialText: '',
                ),
                htmlToolbarOptions: const HtmlToolbarOptions(
                  defaultToolbarButtons: [
                    FontSettingButtons(fontSizeUnit: false),
                    FontButtons(clearAll: false),
                    ListButtons(),
                    ParagraphButtons(),
                    InsertButtons(
                      picture: false,
                      audio: false,
                      video: false,
                      otherFile: false,
                    ),
                    OtherButtons(
                      codeview: false,
                      fullscreen: false,
                      help: false,
                    ),
                  ],
                ),
                otherOptions: OtherOptions(
                  height: MediaQuery.sizeOf(context).height / 2,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: !focusedHtmlEditor
                          ? Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest
                          : Theme.of(context).colorScheme.primary,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: MaterialButton(
                      onPressed: () {},
                      child: const Text('CLEAR'),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: MaterialButton(
                      onPressed: () {},
                      child: Text(
                        'POST',
                        style: TextStyle(
                          color: theme == 2
                              ? Colors.white
                              : Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      endDrawer: const CustomDrawer(),
    );
  }

  static String displayString(SubspaceModel option) => option.subspaceName!;
  Widget autocompleteForSubspaces(int theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Subspace'),
        Container(
          width: MediaQuery.sizeOf(context).width / 2,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: !loadingJoinedSubspaces
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Autocomplete<SubspaceModel>(
                    displayStringForOption: displayString,
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return const Iterable<SubspaceModel>.empty();
                      }
                      return joinedSubspaces.where((SubspaceModel option) {
                        return option.subspaceName
                            .toString()
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (SubspaceModel selection) {
                      // setState(() {})
                      debugPrint('You just selected ${selection.id}');
                    },
                  ),
                )
              : LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
        ),
      ],
    );
  }

  InputDecoration decorationForTextFormField(
    BuildContext context,
    String label,
  ) {
    return InputDecoration(
      label: Text(label),
      border: const OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
