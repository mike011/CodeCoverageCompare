cd ./Before/Example
fastlane test
cd ../../

cd ./After/Example
fastlane test
cd ../../

BEFORE='./Before/Example/fastlane/test_output/Example (Before).test_result.xcresult'
xcrun xccov view  --report "$BEFORE" --json > before.json

AFTER='./After/Example/fastlane/test_output/Example (After).test_result.xcresult'
xcrun xccov view  --report "$AFTER" --json > after.json

EQUIVALENCE=/Users/michael/Documents/git/CodeCoverageCompare/example/Before,/Users/michael/Documents/git/CodeCoverageCompare/example/After
xcrun xccov diff --path-equivalence $EQUIVALENCE --json "$BEFORE" "$AFTER" >> coverage.json
