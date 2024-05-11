#!/bin/bash

# Any command that fails will immediately exit
set -e

# Usage function to display help documentation
function usage {
  echo "Usage: $0 [OPTIONS]"
  echo -e "\nOptions:"
  echo "-h|--help                 Display help"
  echo "--multiplatform           Enable multiplatform build"
  echo -e "\nThis script builds a Flutter web app and a backend API. By default, it builds a Docker image for the API using jibDockerBuild task. If the --multiplatform option is provided, it uses the jib task with -Pmultiplatform_build=true instead."
  exit $1
}

multiplatform=false

# Parse command line options
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -h|--help)
      usage 0
      ;;
    --multiplatform)
      multiplatform=true
      shift # past value
      ;;
    *)
      echo "Unknown option: $key"
      usage 1
      ;;
  esac
done

# Require Flutter
# Checks for required commands
command -v flutter >/dev/null 2>&1 || { echo >&2 "Flutter required but it's not installed. Aborting."; exit 1; }

pushd ui
flutter build web
popd

cp -R ui/build/web/* api/static/

pushd api
  if [[ "$multiplatform" == "true" ]]; then
    ./gradlew clean jib -Pmultiplatform_build=true
  else
    ./gradlew clean jibDockerBuild
  fi
popd

exit 0;
