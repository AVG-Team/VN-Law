// import 'package:flutter/material.dart';
//
// import '../../../data/models/forum/post.dart';
// import '../../../data/models/user_info.dart';
//
//
// class CommentWidget extends StatelessWidget {
//   final Comment comment;
//   final Function(String) onReply;
//   final Function() onDelete;
//   final UserInfo? userInfo;
//
//   const CommentWidget({
//     super.key,
//     required this.comment,
//     required this.onReply,
//     required this.onDelete,
//     required this.userInfo,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(left: comment.parentId != null ? 16.0 : 0.0, bottom: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   comment.content,
//                   style: const TextStyle(fontSize: 14),
//                 ),
//               ),
//               if (comment.canDelete(userInfo))
//                 IconButton(
//                   icon: const Icon(Icons.delete, size: 18, color: Colors.red),
//                   onPressed: onDelete,
//                 ),
//             ],
//           ),
//           Row(
//             children: [
//               Text(
//                 'Tác giả: ${comment.authorName} • ${comment.createdAt.toLocal().toString().split('.')[0]}',
//                 style: const TextStyle(fontSize: 12, color: Colors.grey),
//               ),
//               const SizedBox(width: 8),
//               if (comment.level < 2) // Chỉ cho phép trả lời đến cấp 2
//                 TextButton(
//                   onPressed: () => onReply(comment.id),
//                   child: const Text('Trả lời', style: TextStyle(fontSize: 12)),
//                 ),
//             ],
//           ),
//           if (comment.replies.isNotEmpty)
//             Column(
//               children: comment.replies.reversed.map((reply) => CommentWidget(
//                 comment: reply,
//                 onReply: onReply,
//                 onDelete: () => context.read<PostDetailsProvider>().deleteComment(
//                     reply.postId, reply.id, userInfo!.accessToken),
//                 userInfo: userInfo,
//               )).toList(),
//             ),
//         ],
//       ),
//     );
//   }
// }