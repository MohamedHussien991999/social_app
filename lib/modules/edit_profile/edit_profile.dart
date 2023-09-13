// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../layout/cubit/layout_cubit.dart';
import '../../layout/cubit/states_layout.dart';
import '../../models/user_model.dart';
import '../../shared/components/components.dart';
import '../../shared/style/icon_broken.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        LayoutCubit cubit = LayoutCubit.get(context);
        UserModel userModel = LayoutCubit.get(context).userModel!;
        File? profileImage = LayoutCubit.get(context).profileImage;
        File? coverImage = LayoutCubit.get(context).coverImage;
        nameController.text = '${userModel.name}';
        bioController.text = '${userModel.bio}';
        phoneController.text = '${userModel.phone}';

        return Scaffold(
          appBar: defaultAppBar(
            context: context,
            title: 'Edit Profile',
            actions: [
              defaultTextButton(
                title: 'Update',
                onPressed: () async {
                  if (cubit.profileImage == null && cubit.coverImage == null) {
                    await cubit.updateUserData(
                      name: nameController.text,
                      phone: phoneController.text,
                      bio: bioController.text,
                    );
                  } else if (cubit.profileImage != null &&
                      cubit.coverImage == null) {
                    await cubit.uploadProfileImage(
                      name: nameController.text,
                      phone: phoneController.text,
                      bio: bioController.text,
                    );
                  } else if (cubit.profileImage == null &&
                      cubit.coverImage != null) {
                    await cubit.uploadCoverImage(
                      name: nameController.text,
                      phone: phoneController.text,
                      bio: bioController.text,
                    );
                    nameController.text = '${userModel.name}';
                    bioController.text = '${userModel.bio}';
                    phoneController.text = '${userModel.phone}';
                  } else if (cubit.profileImage != null &&
                      cubit.coverImage != null) {
                    await cubit.uploadProfileImage(
                      name: nameController.text,
                      phone: phoneController.text,
                      bio: bioController.text,
                    );
                    await cubit.uploadCoverImage(
                      name: nameController.text,
                      phone: phoneController.text,
                      bio: bioController.text,
                    );
                  }

                  Navigator.pop(context);
                },
              ),
              const SizedBox(
                width: 15.0,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (state is UserUpdateLoadingState)
                    const LinearProgressIndicator(),
                  if (state is UserUpdateLoadingState)
                    const SizedBox(
                      height: 10.0,
                    ),
                  SizedBox(
                    height: 190.0,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 140.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                  image: DecorationImage(
                                    image: (coverImage == null
                                            ? NetworkImage(
                                                '${userModel.cover}',
                                              )
                                            : FileImage(coverImage))
                                        as ImageProvider<Object>,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  cubit.getCoverImage();
                                },
                                icon: const CircleAvatar(
                                  radius: 20.0,
                                  child: Icon(
                                    IconBroken.Camera,
                                    size: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 64.0,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 60.0,
                                backgroundImage: (profileImage == null
                                        ? NetworkImage(
                                            '${userModel.image}',
                                          )
                                        : FileImage(profileImage))
                                    as ImageProvider<Object>?,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                cubit.getProfileImage();
                              },
                              icon: const CircleAvatar(
                                radius: 20.0,
                                child: Icon(
                                  IconBroken.Camera,
                                  size: 16.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  defaultTextFormField(
                    controller: nameController,
                    type: TextInputType.name,
                    label: 'Name',
                    prefix: IconBroken.User,
                    validate: (String? value) {
                      if (value != null) {
                        return 'name must be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  defaultTextFormField(
                    controller: bioController,
                    type: TextInputType.text,
                    label: 'Bio',
                    prefix: IconBroken.Info_Circle,
                    validate: (String? value) {
                      if (value != null) {
                        return 'bio must be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  defaultTextFormField(
                    controller: phoneController,
                    type: TextInputType.number,
                    label: 'Phone',
                    prefix: IconBroken.Call,
                    validate: (String? value) {
                      if (value != null) {
                        return 'phone must be empty';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
