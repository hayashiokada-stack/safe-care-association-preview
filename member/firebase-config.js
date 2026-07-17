import { initializeApp, getApps } from "https://www.gstatic.com/firebasejs/10.14.1/firebase-app.js";
import { getAuth } from "https://www.gstatic.com/firebasejs/10.14.1/firebase-auth.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/10.14.1/firebase-firestore.js";

const firebaseConfig={
  apiKey:"AIzaSyA1APwKMh6ra8K6VFmxbK52iW9dHnQbyrM",
  authDomain:"safecare-association-backend.firebaseapp.com",
  projectId:"safecare-association-backend",
  storageBucket:"safecare-association-backend.firebasestorage.app",
  messagingSenderId:"848186949487",
  appId:"1:848186949487:web:b61dd5911b7d35d0b7f29a"
};

const app=getApps()[0]||initializeApp(firebaseConfig);
export const auth=getAuth(app);
auth.languageCode="ko";
export const db=getFirestore(app);
