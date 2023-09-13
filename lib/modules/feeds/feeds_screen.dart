// ignore_for_file: must_be_immutable, avoid_print

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/cubit/layout_cubit.dart';
import '../../layout/cubit/states_layout.dart';
import '../../models/post_model.dart';
import '../../shared/style/colors.dart';
import '../../shared/style/icon_broken.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        LayoutCubit cubit = LayoutCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.posts.isNotEmpty && cubit.userModel != null,
          builder: (context) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 5.0,
                  margin: const EdgeInsets.all(8.0),
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      const Image(
                        image: NetworkImage(
                          'https://image.freepik.com/free-photo/horizontal-shot-smiling-curly-haired-woman-indicates-free-space-demonstrates-place-your-advertisement-attracts-attention-sale-wears-green-turtleneck-isolated-vibrant-pink-wall_273609-42770.jpg',
                        ),
                        fit: BoxFit.cover,
                        height: 200.0,
                        width: double.infinity,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'communicate with friends',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 8.0,
                  ),
                  itemBuilder: (context, index) =>
                      buildPostItem(cubit.posts[index], context, index),
                  itemCount: cubit.posts.length,
                ),
                const SizedBox(
                  height: 8.0,
                ),
              ],
            ),
          ),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildPostItem(PostModel model, context, index) {
    LayoutCubit cubit = LayoutCubit.get(context);

    if (cubit.commentControllers.length <= index) {
      cubit.commentControllers.add(TextEditingController());
      cubit.sendIconColors.add(Colors.grey);
    }
    TextEditingController commentController = cubit.commentControllers[index];

    Color color = cubit.sendIconColors[index];

    return BlocConsumer<LayoutCubit, LayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 5.0,
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${model.name}',
                                style: const TextStyle(
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              const Icon(
                                Icons.check_circle,
                                color: defaultColor,
                                size: 16.0,
                              ),
                            ],
                          ),
                          Text(
                            '${model.dateTime}',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      height: 1.4,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        IconBroken.More_Circle,
                        size: 16.0,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 15.0,
                  ),
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey[300],
                ),
                Text(
                  '${model.text}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                // if post has image
                if (model.postImage != '')
                  Container(
                    margin: const EdgeInsetsDirectional.only(
                      end: 10.0,
                      start: 10.0,
                      top: 15.0,
                    ),
                    height: 140.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      image: DecorationImage(
                        image: NetworkImage(
                          '${model.postImage}',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              children: [
                                const Icon(
                                  IconBroken.Heart,
                                  size: 16.0,
                                  color: Colors.red,
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                if (cubit.likes.isNotEmpty &&
                                    index < cubit.likes.length)
                                  Text(
                                    '${cubit.likes[index]}',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                if (cubit.likes.isEmpty)
                                  Text(
                                    '0',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                              ],
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Icon(
                                  IconBroken.Chat,
                                  size: 16.0,
                                  color: Colors.amber,
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                if (cubit.comments.isNotEmpty &&
                                    index < cubit.comments.length)
                                  Text(
                                    '${cubit.comments[index]} comment',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                if (cubit.comments.isEmpty)
                                  Text(
                                    '0 comment',
                                    //'${cubit.comments.length} comment',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                              ],
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 10.0,
                  ),
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey[300],
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage('${cubit.userModel!.image}'),
                              radius: 18.0,
                            ),
                            const SizedBox(
                              width: 15.0,
                            ),
                            Expanded(
                              child: TextFormField(
                                onChanged: (value) {
                                  cubit.sendIconColors[index] = value.isNotEmpty
                                      ? Colors.blue
                                      : Colors.grey;
                                  cubit.changeTextField();
                                },
                                onSaved: (value) {},
                                decoration: InputDecoration(
                                  hintText: commentController.text == ''
                                      ? ' Write Comment ... '
                                      : commentController.text,
                                ),
                                controller: commentController,
                              ),
                            ),
                            IconButton(
                                icon: Icon(Icons.send, color: color),
                                onPressed: () {
                                  if (commentController.text != '' &&
                                      commentController.text !=
                                          ' Write Comment ... ' &&
                                      color == Colors.blue) {
                                    cubit.commentPost(
                                      postId: cubit.postsId[index],
                                      comment: commentController.text,
                                    );
                                    cubit.getPosts();
                                    print("send comment");
                                    commentController.text =
                                        " Write Comment ... ";
                                  }
                                }),
                          ],
                        ),
                        onTap: () {},
                      ),
                    ),
                    InkWell(
                      child: Row(
                        children: [
                          const Icon(
                            IconBroken.Heart,
                            size: 16.0,
                            color: Colors.red,
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            'Like',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      onTap: () {
                        cubit.likePost(cubit.postsId[index]);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
