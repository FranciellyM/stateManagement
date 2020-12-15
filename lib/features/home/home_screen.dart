import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_management/features/app/bloc/session_bloc.dart';
import 'package:state_management/features/app/bloc/session_event.dart';

class HomeScreen extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = context.select((SessionBloc bloc) => bloc.state.localUserVO);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => context
                .read<SessionBloc>()
                .add(SessionLogoutRequested()),
          )
        ],
      ),
      body: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            getAvatar(photo: user.photoUrl),
            const SizedBox(height: 4.0),
            Text(user.email, style: textTheme.headline6),
            const SizedBox(height: 4.0),
            Text(user.displayName ?? '', style: textTheme.headline5),
          ],
        ),
      ),
    );
  }

  Widget getAvatar({ String photo }) => CircleAvatar(
    radius: 48.0,
    backgroundImage: photo != null ? NetworkImage(photo) : null,
    child: photo == null
        ? const Icon(Icons.person_outline, size: 48.0)
        : null,
  );
}
