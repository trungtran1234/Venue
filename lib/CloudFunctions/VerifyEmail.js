exports.verifyEmailCode = functions.https.onCall(async (data, context) => {
    // Check if the user is authenticated
    if (!context.auth) {
      throw new functions.https.HttpsError('unauthenticated', 'The user must be signed in.');
    }
  
    const submittedCode = data.code;
    const userRef = admin.firestore().collection('users').doc(context.auth.uid);
    const userDoc = await userRef.get();
  
    if (!userDoc.exists) {
      throw new functions.https.HttpsError('not-found', 'User not found.');
    }
  
    const user = userDoc.data();
    if (user.verificationCode === submittedCode) {
      // Code is correct
      await userRef.update({ verificationCode: admin.firestore.FieldValue.delete() });
      return { result: 'Verification successful.' };
    } else {
      // Code is incorrect
      throw new functions.https.HttpsError('invalid-argument', 'Invalid code.');
    }
  });