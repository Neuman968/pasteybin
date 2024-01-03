#!/bin/bash

# Usage function to display help documentation
usage() {
  echo "Usage: $0 [OPTIONS]"
  echo "Options:"
  echo "  --api-host      Specify the API host"
  echo "  -h, --help      Display this help message"
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

