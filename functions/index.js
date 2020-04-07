const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.updateFeeds = functions.database.ref('/tweets/{tweetId}/uid').onCreate((snapshot, context) => {
    const uid = snapshot.val();
    const tweetId = context.params.tweetId;

    return admin.database().ref('/user-followers/' + uid).once('value', snap => {
        snap.forEach(child => {
            const followerUid = child.key;
            const databaseRef = admin.database().ref('/user-feeds/' + followerUid).child(tweetId)
            databaseRef.set(1)
        });
    });
});

exports.updateFeedsAfterFollow = functions.database.ref('/user-following/{currentUid}/{uid}').onCreate((snapshot, context) => {
    const currentUid = context.params.currentUid;
    const uid = context.params.uid;

    return admin.database().ref('/user-tweets/' + uid).once('value', snap => {
        snap.forEach(child => {
            const tweetId = child.key;
            const databaseRef = admin.database().ref('/user-feeds/' + currentUid).child(tweetId)
            databaseRef.set(1)
        });
    });
});

exports.updateFeedsAfterUnfollow = functions.database.ref('/user-following/{currentUid}/{uid}').onDelete((snapshot, context) => {
    const currentUid = context.params.currentUid;
    const uid = context.params.uid;

    return admin.database().ref('/user-tweets/' + uid).once('value', snap => {
        snap.forEach(child => {
            const tweetId = child.key;
            const databaseRef = admin.database().ref('/user-feeds/' + currentUid)
            databaseRef.child(tweetId).remove();
        });
    });
});