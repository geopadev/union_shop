# Firebase Setup Checklist

Print this out or keep it open while setting up Firebase!

## ☐ Part 1: Create Firebase Project (5 min)

1. ☐ Go to https://console.firebase.google.com
2. ☐ Sign in with Google account
3. ☐ Click "Add project"
4. ☐ Name it: `union-shop`
5. ☐ Click "Continue"
6. ☐ Disable Google Analytics
7. ☐ Click "Create project"
8. ☐ Wait for "Your new project is ready"
9. ☐ Click "Continue"

## ☐ Part 2: Enable Authentication (3 min)

10. ☐ Click "Authentication" in left sidebar (under "Build")
11. ☐ Click "Get started"
12. ☐ Click on "Email/Password" provider
13. ☐ Toggle ON "Email/Password"
14. ☐ Click "Save"
15. ☐ Verify "Email/Password" shows as "Enabled" ✅

## ☐ Part 3: Create Firestore Database (3 min)

16. ☐ Click "Firestore Database" in left sidebar
17. ☐ Click "Create database"
18. ☐ Select "Start in production mode"
19. ☐ Click "Next"
20. ☐ Choose location: `europe-west2 (London)` (or closest to you)
21. ☐ Click "Enable"
22. ☐ Wait 1-2 minutes for database creation
23. ☐ See empty database with "Start collection" button

## ☐ Part 4: Configure Security Rules (2 min)

24. ☐ Click "Rules" tab (at top of Firestore page)
25. ☐ Delete all existing code
26. ☐ Copy and paste the security rules from requirements.md
27. ☐ Click "Publish"
28. ☐ Confirm by clicking "Publish" again
29. ☐ See "Rules published successfully" ✅

## ☐ Part 5: Install FlutterFire CLI (2 min)

30. ☐ Open terminal/PowerShell
31. ☐ Run: `dart pub global activate flutterfire_cli`
32. ☐ Wait 30 seconds for installation
33. ☐ See installation success message

## ☐ Part 6: Configure Firebase for Flutter (5 min)

34. ☐ Navigate to project folder: `cd c:\Users\Georg\Desktop\L5 Programing\cs1_union_shop\union_shop`
35. ☐ Run: `flutterfire configure`
36. ☐ Login to Firebase in browser (if prompted)
37. ☐ Close browser after "Success!"
38. ☐ Select your project with arrow keys + SPACE
39. ☐ Press ENTER
40. ☐ Select "web" platform with arrow keys + SPACE
41. ☐ Press ENTER
42. ☐ Wait for "Firebase configuration file generated successfully" ✅

## ☐ Part 7: Verify Files Created (1 min)

43. ☐ Check `lib/firebase_options.dart` exists
44. ☐ Check `.firebaserc` exists
45. ☐ Check `firebase.json` exists
46. ☐ Run: `flutter pub get`

## ☐ Part 8: Test Firebase Connection (3 min)

47. ☐ Run: `flutter run -d chrome`
48. ☐ Open Chrome DevTools (F12)
49. ☐ Check Console tab
50. ☐ See "Firebase initialized: [DEFAULT]" ✅
51. ☐ See "Firebase Auth available: [DEFAULT]" ✅
52. ☐ See "Firestore available: [DEFAULT]" ✅

---

## 🎉 SUCCESS!

If you checked all boxes and saw all the ✅ messages, Firebase is fully set up!

**Total Time:** ~25 minutes

**What You Have:**
- ✅ Firebase Project
- ✅ Email/Password Authentication
- ✅ Firestore Database
- ✅ Security Rules
- ✅ Flutter App Connected to Firebase

**Next:** Implement S-48 (Authentication Service Layer)

---

## 🚨 Troubleshooting

**Problem:** Can't find Authentication in sidebar  
**Fix:** Click on "Build" section to expand it

**Problem:** FlutterFire CLI not found  
**Fix:** Restart terminal or use full path: `dart pub global run flutterfire_cli configure`

**Problem:** No project appears when running flutterfire configure  
**Fix:** Make sure you're logged into the correct Google account

**Problem:** "Permission denied" in Firestore  
**Fix:** Check your security rules match exactly (step 26)

**Problem:** Firebase packages not found  
**Fix:** Run `flutter clean` then `flutter pub get`

---

## 📞 Need Help?

1. Check requirements.md for detailed explanations
2. Check console logs for error messages
3. Ask on Discord with error message
4. Make sure you're using correct Google account
