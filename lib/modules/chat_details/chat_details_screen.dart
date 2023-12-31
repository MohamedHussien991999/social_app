// ignore_for_file: must_be_immutable
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/style/colors.dart';
import 'package:social_app/shared/style/icon_broken.dart';

import '../../layout/cubit/layout_cubit.dart';
import '../../layout/cubit/states_layout.dart';
import '../../models/message_model.dart';
import '../../models/user_model.dart';

class ChatDetailsScreen extends StatelessWidget {
  ChatDetailsScreen({Key? key, required this.userModel}) : super(key: key);
  final UserModel userModel;
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        LayoutCubit.get(context).getMessages(receiverId: userModel.uId!);
        return BlocConsumer<LayoutCubit, LayoutStates>(
          listener: (context, state) {},
          builder: (context, state) {
            LayoutCubit cubit = LayoutCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        userModel.image ??
                            'https://i.pinimg.com/originals/f1/0f/f7/f10ff70a7155e5ab666bcdd1b45b726d.jpg ',
                      ),
                      radius: 20.0,
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      '${userModel.name}',
                    ),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    ConditionalBuilder(
                      condition: cubit.messages.isNotEmpty,
                      builder: (context) => Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            MessageModel message = cubit.messages[index];

                            if (cubit.userModel!.uId != message.receiverId) {
                              return buildMessage(message);
                            }
                            return buildMyMessage(message);
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10.0,
                          ),
                          itemCount: cubit.messages.length,
                        ),
                      ),
                      fallback: (context) => const Spacer(),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      padding: const EdgeInsetsDirectional.only(start: 10.0),
                      child: Column(
                        children: [
                          if (cubit.chatImage != null)
                            const SizedBox(
                              height: 10,
                            ),
                          if (cubit.chatImage != null)
                            Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                Image.file(
                                  cubit.chatImage!,
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                IconButton(
                                  onPressed: () {
                                    cubit.removeChatImage();
                                  },
                                  icon: const CircleAvatar(
                                    radius: 16.0,
                                    backgroundColor:
                                        Colors.red, // Customize the color
                                    child: Icon(
                                      Icons.close,
                                      size: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          if (cubit.chatImage != null)
                            const SizedBox(
                              height: 10,
                            ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: messageController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'type your message here ...',
                                  ),
                                ),
                              ),
                              Container(
                                height: 50.0,
                                color: defaultColor,
                                child: MaterialButton(
                                  minWidth: 1.0,
                                  onPressed: () {
                                    if (cubit.chatImage != null) {
                                      cubit.uploadImageMessage(
                                          receiverId: userModel.uId!,
                                          dateTime: DateTime.now().toString(),
                                          text: messageController.text);
                                      cubit.removeChatImage();
                                    }
                                    if (messageController.text != '') {
                                      LayoutCubit.get(context).sendMessage(
                                        receiverId: userModel.uId!,
                                        dateTime: DateTime.now().toString(),
                                        text: messageController.text,
                                      );
                                      messageController.text = '';
                                    }
                                  },
                                  child: const Icon(
                                    IconBroken.Send,
                                    size: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 1.0,
                              ),
                              Container(
                                height: 50.0,
                                color: defaultColor,
                                child: MaterialButton(
                                  minWidth: 1.0,
                                  onPressed: () async {
                                    await LayoutCubit.get(context)
                                        .getChatImage();
                                  },
                                  child: const Icon(
                                    IconBroken.Image_2,
                                    size: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMessage(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 10.0,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadiusDirectional.only(
                topEnd: Radius.circular(10.0),
                topStart: Radius.circular(10.0),
                bottomEnd: Radius.circular(10.0),
              ),
            ),
            child: Column(
              children: [
                if (model.imageUrl != '' && model.imageUrl != null)
                  Image.network(
                    '${model.imageUrl}',
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.cover,
                  ),
                Text('${model.text}'),
              ],
            )),
      );

  Widget buildMyMessage(MessageModel model) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 10.0,
            ),
            decoration: BoxDecoration(
              color: defaultColor.withOpacity(0.2),
              borderRadius: const BorderRadiusDirectional.only(
                topEnd: Radius.circular(10.0),
                topStart: Radius.circular(10.0),
                bottomStart: Radius.circular(10.0),
              ),
            ),
            child: Column(
              children: [
                if (model.imageUrl != '' && model.imageUrl != null)
                  Image.network(
                    '${model.imageUrl}',
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.cover,
                  ),
                Text('${model.text}'),
              ],
            )),
      );
}
