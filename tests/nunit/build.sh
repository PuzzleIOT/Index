echo "Starting build for project tests"
echo "Dir: $PWD"

DIR=$PWD

msbuild src/PuzzleIOT.Index.Tests.sln /p:Configuration=Release
