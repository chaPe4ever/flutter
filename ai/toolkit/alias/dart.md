# Common zsh aliases for Flutter / Dart (build_runner, watch, etc.)

Add these to your ~/.zshrc or project-specific shell file if they don't exist.

```sh
# build_runner
alias brb='flutter pub run build_runner build --delete-conflicting-outputs'
alias brw='flutter pub run build_runner watch --delete-conflicting-outputs'
alias brc='flutter pub run build_runner clean'

# flutter / dart convenience
alias pubg='flutter pub get'
alias pubu='flutter pub upgrade'
alias fr='flutter run'
alias fa='flutter analyze'
alias ff='flutter format .'
alias ft='flutter test'

# common builds
alias bapk='flutter build apk --release'
alias bip='flutter build ipa'         # requires macOS & setup
alias bweb='flutter build web'
alias bapp='flutter build appbundle'

# misc
alias fclean='flutter clean'
alias fd='flutter doctor -v'
alias openios='open ios/Runner.xcworkspace'  # macOS: open Xcode workspace
```

Use: reload with `source ~/.zshrc` or open a new shell session.

- Important: Keep in mind that the brw (build_runner watch) command automatically runs indefinitely, so there is no need to run it in the background using `&`. So assume that it always builds and wait some seconds for the changes to be applied.