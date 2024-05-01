import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enums/menu_action.dart';
import 'dart:developer' as devtools show log;
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/notes_services.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _noteService;
  String get userEmail =>
      AuthService.firebase().currentUser!.email!; // force and wrap email

  @override
  void initState() {
    // to open DB
    // TODO: implement initState

    _noteService = NotesService();
    _noteService.open();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _noteService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text("Your Notes"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(newNotesRoute); // not removeUntil because we want to alow the user to move back
            },
            icon: Icon(Icons.add),
          ),
          PopupMenuButton(onSelected: (value) async {
            // value is a an enumeration value, whatever I select from the enums values
            devtools.log(value.toString());

            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await showLogoutDialog(context);
                devtools.log(shouldLogout.toString());
                if (shouldLogout) {
                  await AuthService.firebase().logOut();

                  // ignore: use_build_context_synchronously
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                }
                break;
              case MenuAction.misc:
                break;
            }
          }, itemBuilder: (context) {
            return [
              const PopupMenuItem<MenuAction>(
                value: MenuAction.logout, // coder sees this
                child: Text("Log Out"), // user sees this
              ),
              const PopupMenuItem<MenuAction>(
                value: MenuAction.misc, // coder sees this
                child: Text("Misc"), // user sees this
              )
            ]; // since popmenuentry requires a list return type
          })
        ],
      ),
      body: FutureBuilder(
        future: _noteService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _noteService.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Text('Waiting for all notes...');

                    default:
                      return CircularProgressIndicator();
                  }
                },
              );

            default:
              return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Sign Out'),
              content: const Text('Are you sure you want to sign out?'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pop(true); // to return a value to the show dialogue
                    },
                    child: const Text('Sign Out')),
              ],
            );
          })
      .then((value) =>
          value ??
          false); // show dialogue's value can be null, for instance, i press somewhere else on the screen instead of the pop up
}
