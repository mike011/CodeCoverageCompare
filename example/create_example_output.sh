# cleanup
rm -rf ../docs/before
rm -rf ../docs/after

mkdir ../docs/before
mkdir ../docs/after

cp -R ./Before/example/fastlane/test_output/slather/*.html ../docs/before
cp -R ./After/example/fastlane/test_output/slather/*.html ../docs/after
cp -R ./After/example/fastlane/test_output/*.html ../docs/after
