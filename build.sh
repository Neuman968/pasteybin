#!/bin/bash

# Usage function to display help documentation
usage() {
  echo "Usage: $0 [OPTIONS]"
  echo "Options:"
  echo "  --multiplatform          Runs ./gradlew jib with all target platforms. Requires remote registry login"
  echo "  -h, --help               Display this help message"
  exit 1
}

multiplatform=false

# Parse command line options
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -h|--help)
      usage
      ;;
    --multiplatform)
      multiplatform=true
      shift # past argument
      shift # past value
      ;;
    *)
      echo "Unknown option: $key"
      usage
      ;;
  esac
done

pushd ui
flutter build web
popd

cp -R ui/build/web api/static

pushd api
  echo "building...";
  if [[ "$multiplatform" == "true" ]]; then
    ./gradlew clean jib -Pmultiplatform_build=true
  else
    ./gradlew clean jibDockerBuild
  fi
popd

exit 0;

