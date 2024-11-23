import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../presentation/blocs/user/user_bloc.dart';
import '../../../presentation/blocs/user/user_event.dart';
import '../../../presentation/blocs/user/user_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserInitial) {
            // Fetch user khi trang được load
            context.read<UserBloc>().add(const FetchUserEvent('user123'));
            return const Center(child: Text('Initializing...'));
          } else if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('User Name: ${state.user.name}'),
                  Text('User Email: ${state.user.email}'),
                ],
              ),
            );
          } else if (state is UserError) {
            return Center(
              child: Text('Error: ${state.message}'),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}