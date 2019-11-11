cd ./Before/Example
fastlane test
cd ../../

cd ./After/Example
fastlane test
cd ../../

xcrun xccov diff --path-equivalence /Users/michael/Documents/git/CodeCoverageCompare/example/Before,/Users/michael/Documents/git/CodeCoverageCompare/example/After --json ./Before/Example/fastlane/test_output/Example.test_result.xcresult ./After/Example/fastlane/test_output/Example.test_result.xcresult >> coverage.json
