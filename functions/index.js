const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();
exports.sendNotification = functions.firestore
  .document("messages/{senderID}/{receiverID}/{alertid}")
  .onCreate((snap, context) => {
    const doc = snap.data();
    console.log(doc);

    const text = doc.text;
    const token = doc.receiverToken;
    console.log(text);
    const payload = {
      notification: {
        title: "New Message",
        body: `${text}`,
        click_action: "FLUTTER_NOTIFICATION_CLICK",
      },
    };

    admin.messaging().sendToDevice(token, payload);
    console.log("Function executed successfully");
  });
