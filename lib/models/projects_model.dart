class ProjectsModel {
  final String thumbnail;
  final String title;
  final String subtitle;
  final String? androidLink;
  final String? iosLink;
  final String? sourceCode;
  final String? webLink;
  final String? projectType;
  final String projectId;

  ProjectsModel({
    required this.thumbnail,
    required this.title,
    required this.subtitle,
    this.androidLink,
    this.iosLink,
    this.sourceCode,
    this.webLink,
    this.projectType,
    required this.projectId,
  });

  factory ProjectsModel.fromJson(Map<String, dynamic> json) {
    return ProjectsModel(
      thumbnail: json['thumbnail'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      androidLink: json['androidLink'],
      iosLink: json['iosLink'],
      sourceCode: json['sourceCode'],
      webLink: json['webLink'],
      projectType: json['projectType'],
      projectId: json['projectId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'thumbnail': thumbnail,
      'title': title,
      'subtitle': subtitle,
      'androidLink': androidLink,
      'iosLink': iosLink,
      'sourceCode': sourceCode,
      'webLink': webLink,
      'projectType': projectType,
      'projectId': projectId,
    };
  }
}
