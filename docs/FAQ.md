# FAQ

**Does it work without a backend?** Yes - Mock mode is the default.
**How do I reset the demo data?** Clear the app storage / reinstall.
**Where do I put payment keys?** Only in `--dart-define` flags and Firebase secrets; never in the repo.
**Why are product photos from Unsplash?** They are demo data; replace `assets/mock/products.json` or use Firestore.
**The theme doesn't change on some widget.** Use `color.*` from `colors.dart` (not hard-coded colours); the app repaints on theme change.
**Support:** support@darklet.app (replace with your own address before publishing).
