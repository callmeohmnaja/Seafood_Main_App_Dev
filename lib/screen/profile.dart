import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Text('Profile Page Content'),
      ),
    );
  }
}
// class WelcomeScreen extends StatelessWidget {
//   final auth = FirebaseAuth.instance;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Welcome')),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Center(
//           child: Column(
//             children: [
//               Text(
//                 'อีเมลของคุณคือ ' + auth.currentUser!.email.toString(),
//                 style: TextStyle(fontSize: 20),
//               ),
//               ElevatedButton(
//                   onPressed: () {
//                     Navigator.pushReplacement(context,
//                         MaterialPageRoute(builder: (context) {
//                       return HomeScreen();
//                     }));
//                   },
//                   child: Text('ออกจากระบบ'))
//                    ],
            
          
//           ),
//         ),
//       ),
//     );
//   }
// }

