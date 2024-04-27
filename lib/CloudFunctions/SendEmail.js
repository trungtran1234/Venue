const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendVerificationEmail = functions.https.onCall(async (data, context) => {
  // Check if the user is authenticated
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'The user must be signed in.');
  }

  const email = data.email; // Assuming the email is passed in the data payload
  const code = Math.floor(100000 + Math.random() * 900000).toString(); // Generate a 6-digit code
  
  // Save the code in Firestore (or any other database you prefer)
  const userRef = admin.firestore().collection('users').doc(context.auth.uid);
  await userRef.set({ verificationCode: code }, { merge: true });

  // Send the email using your preferred email service provider
  // For example, if using SendGrid:
  /*
  sgMail.send({
    to: email,
    from: 'your-email@example.com',
    subject: 'Your verification code',
    text: `Your verification code is ${code}`,
  });
  */

  return { result: 'Verification email sent.' };
});