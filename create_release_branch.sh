#!/bin/bash

# Extract the release version from the pom.xml or tag
RELEASE_VERSION=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout | sed 's/-SNAPSHOT//')

# Create and checkout the release branch
git checkout -b release-$RELEASE_VERSION

# Push the branch to the remote repository
git push origin release-$RELEASE_VERSION

# Checkout the main branch
git checkout main