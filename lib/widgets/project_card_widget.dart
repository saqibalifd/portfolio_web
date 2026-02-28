import 'package:flutter/material.dart';
import 'package:myportfolio/constants/colors.dart';
import 'package:myportfolio/utils/project_utils.dart';
import 'package:web/web.dart' as web;

class ProjectCardWidget extends StatelessWidget {
  final ProjectUtils project;
  const ProjectCardWidget({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      height: 290,
      width: 260,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: CustomColor.bgLight2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          //project image
          Image.asset(
            project.image,
            height: 140,
            width: 260,
            fit: BoxFit.cover,
          ),
          //title
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 15, 12, 12),
            child: Text(
              project.title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: CustomColor.whitePrimary,
              ),
            ),
          ),
          //subtitle
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Text(
              overflow: TextOverflow.ellipsis,
              project.subtitle,
              style: TextStyle(fontSize: 12, color: CustomColor.whiteSecondary),
            ),
          ),
          Spacer(),
          //footer
          Container(
            color: CustomColor.bgLight1,
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            child: Row(
              children: [
                Text(
                  'Available on:',
                  style: TextStyle(
                    color: CustomColor.yellowSecondary,
                    fontSize: 10,
                  ),
                ),
                Spacer(),

                if (project.iosLink != null)
                  InkWell(
                    onTap: () {
                      web.window.open(project.iosLink!, "_blank");
                    },
                    child: Image.asset('assets/icons/apple.png', width: 19),
                  ),
                if (project.androidLink != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: InkWell(
                      onTap: () {
                        web.window.open(project.androidLink!, "_blank");
                      },
                      child: Image.asset('assets/icons/android.png', width: 19),
                    ),
                  ),
                if (project.webLink != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: InkWell(
                      onTap: () {
                        web.window.open(project.webLink!, "_blank");
                      },
                      child: Image.asset(
                        'assets/icons/website-optimization.png',
                        width: 19,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
