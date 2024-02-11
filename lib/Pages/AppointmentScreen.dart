import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mis_lab3/auth.dart';


class Appointment {
  final String subject;
  final String date;
  final String time;

  Appointment(this.subject, this.date, this.time);
}

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;

  const AppointmentCard(this.appointment, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appointment.subject,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('${appointment.date} ${appointment.time}', style:  const TextStyle(color: Colors.grey),),
        ],
      ),
    );
  }
}

class AppointmentList extends StatelessWidget {
  final List<Appointment> appointments;

  const AppointmentList({Key? key, required this.appointments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return AppointmentCard(appointments[index]);
        },
        itemCount: appointments.length,
      ),
    );
  }
}

class AddAppointmentDialog extends StatefulWidget {
  final Function(Appointment) onAddAppointment;

  const AddAppointmentDialog({Key? key, required this.onAddAppointment}) : super(key: key);

  @override
  _AddAppointmentDialogState createState() => _AddAppointmentDialogState();
}

class _AddAppointmentDialogState extends State<AddAppointmentDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Appointment'),
      content: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: timeController,
            decoration: const InputDecoration(labelText: 'Time'),
          ),
          TextField(
            controller: dateController,
            decoration: const InputDecoration(labelText: 'Date'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final String name = nameController.text;
            final String time = timeController.text;
            final String date = dateController.text;

            if (name.isNotEmpty && time.isNotEmpty && date.isNotEmpty) {
              final Appointment newAppointment = Appointment(name, date, time);

              widget.onAddAppointment(newAppointment);

              Navigator.of(context).pop();
            } else {
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  List<Appointment> appointments = [];

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _userId() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sign out'),
    );
  }

  void addAppointment(Appointment newAppointment) {
    setState(() {
      appointments.add(newAppointment);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Appointment App'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AddAppointmentDialog(onAddAppointment: addAppointment);
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: _userId(),
                ),
                _signOutButton(),
              ],
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child: SizedBox(),
          ),
        ),
        body: Column(
          children: [
            AppointmentList(appointments: appointments),
          ],
        ),
      ),
    );
  }
}

