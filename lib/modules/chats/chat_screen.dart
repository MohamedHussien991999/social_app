import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/layout_cubit.dart';
import '../../layout/cubit/states_layout.dart';
import '../../models/user_model.dart';
import '../../shared/components/components.dart';
import '../chat_details/chat_details_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        LayoutCubit cubit = LayoutCubit.get(context);
        return ConditionalBuilder(
            condition: cubit.users.isNotEmpty,
            builder: (context) => ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (context, index) => myDivider(),
                  itemBuilder: (context, index) =>
                      buildChatItem(cubit.users[index], context),
                  itemCount: cubit.users.length,
                ),
            fallback: (context) =>
                const Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget buildChatItem(UserModel model, context) => InkWell(
        onTap: () {
          navigateTo(context, ChatDetailsScreen(userModel: model));
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  '${model.image}',
                ),
                radius: 25.0,
              ),
              const SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: Text(
                  '${model.name}',
                  style: const TextStyle(
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
