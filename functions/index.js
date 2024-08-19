/* eslint-disable indent */
/* eslint-disable max-len */

const functions = require("firebase-functions");
const admin = require("firebase-admin");

exports.onWriteLikes = functions.firestore
  .document("Post/{postId}/Likes/{likesId}")
  .onWrite(async (change, context) => {
    const postId = context.params.postId;
    const postRef = admin.firestore.collection("Post").doc(postId);

    if (change.after.exists) {
      // create using onCreate method
      return postRef.update({
        likes: admin.firestore.FieldValue.increment(1),
      });
    } else if (!change.after.exists) {
      // delete: using onDelete method
      return postRef.update({
        likes: admin.firestore.FieldValue.increment(-1),
      });
    } else {
      return null;
    }
  });
