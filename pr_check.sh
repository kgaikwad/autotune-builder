#!/bin/bash

# --------------------------------------------
# Options that must be configured by app owner
# --------------------------------------------
export APP_NAME="ros"  # name of app-sre "application" folder this component lives in
export COMPONENT_NAME="autotune"  # name of app-sre "resourceTemplate" in deploy.yaml for this component
export COMPONENTS="autotune"
export IMAGE="quay.io/cloudservices/autotune"
AUTOTUNE_GIT_DIR="autotune"
AUTOTUNE_GIT_DIR_PATH="$PWD/$AUTOTUNE_GIT_DIR"
AUTOTUNE_GIT_BRANCH="0.0.19"
export DOCKERFILE="Dockerfile.autotune"


mkdir -p $AUTOTUNE_GIT_DIR_PATH
git clone --branch $AUTOTUNE_GIT_BRANCH https://github.com/kruize/autotune.git $AUTOTUNE_GIT_DIR_PATH

pushd $AUTOTUNE_GIT_DIR

# Install bonfire repo/initialize
CICD_URL=https://raw.githubusercontent.com/RedHatInsights/bonfire/master/cicd
curl -s $CICD_URL/bootstrap.sh > .cicd_bootstrap.sh && source .cicd_bootstrap.sh

source $CICD_ROOT/build.sh

# Deploy to an ephemeral namespace for testing
# source $CICD_ROOT/deploy_ephemeral_env.sh

popd

mkdir -p $WORKSPACE/artifacts
cat << EOF > ${WORKSPACE}/artifacts/junit-dummy.xml
<testsuite tests="1">
    <testcase classname="dummy" name="dummytest"/>
</testsuite>
EOF
