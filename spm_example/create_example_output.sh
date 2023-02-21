# cleanup
rm -rf ../docs/before
rm -rf ../docs/after

mkdir -p ../docs/before/slather
mkdir -p ../docs/after/slather

cp -R ./Before/example/fastlane/test_output/slather/ ../docs/before/slather
cp -R ./After/example/fastlane/test_output/slather/ ../docs/after/slather
cp -R ./After/example/fastlane/test_output/*.html ../docs/after/
