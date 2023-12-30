#!/bin/bash

# Usage function to display help documentation
usage() {
  echo "Usage: $0 [OPTIONS]"
  echo "Options:"
  echo "  --api-host      Specify the API host"
  echo "  -h, --help      Display this help message"
  exit 1
}

# Parse command line options
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --api-host)
      API_HOST="$2"
      shift # past argument
      shift # past value
      ;;
    -h|--help)
      usage
      ;;
    *)
      echo "Unknown option: $key"
      usage
      ;;
  esac
done

# Check if API host is provided
if [ -z "$API_HOST" ]; then
  echo "Error: API host not specified."
  usage
fi

# Check if the host starts with a protocol
if [[ "$API_HOST" == *://* ]]; then
  echo "Error: API host cannot start with a protocol."
  usage
fi

# Your script logic goes here
echo "API Host: $API_HOST"

#docker build -t pasteybin-ui-base --build-arg API_HOST=$API_HOST .

#docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t pasteybin-ui-base --build-arg API_HOST=$API_HOST .

#docker buildx build --platform linux/arm64 -t pasteybin-ui-base --build-arg API_HOST=$API_HOST .

pushd ui
flutter build web --dart-define=API_HOST=johnspi 
popd

cp -R ui/build/web api/static

pushd api
./gradlew clean jibDockerBuild
popd

exit 0;

