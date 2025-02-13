#!/bin/bash

working_dir=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd ${working_dir}/..

# Extract the release version from the pom.xml or tag
RELEASE_VERSION=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout | sed 's/-SNAPSHOT//')

# Create and checkout the release branch
git checkout -b release-$RELEASE_VERSION

# Push the branch to the remote repository
git push origin release-$RELEASE_VERSION

# Checkout the main branch
git checkout main


incr_pom_version()
{
  nums=$(echo $1 | tr "." "\n")
  # add items in nums to a new array
  arr=()
  for n in $nums
  do
      arr+=($n)
  done
  # incr the last item
  len=${#arr[*]}
  arr[len-1]=$((${arr[len-1]}+1))

  new_version=""
  for i in $(seq 0 $((${#arr[*]}-1)))
  do
      if [ $i -eq $((${#arr[*]}-1)) ]; then
          new_version="${new_version}${arr[i]}"
      else
          new_version="${new_version}${arr[i]}."
      fi
  done
   new_version="${new_version}-SNAPSHOT"
   echo $new_version
}

# get the new version generated by the incr_pom_version function
incrVersion=$(incr_pom_version $RELEASE_VERSION)

 mvn release:prepare -DreleaseVersion=$RELEASE_VERSION -Dtag=$RELEASE_VERSION -DdevelopmentVersion=$incrVersion -DautoVersionSubmodules=true

 mvn release:perform

# update pomVersion file with the new version
 NEXT_RELEASE_VERSION=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout )
 echo $NEXT_RELEASE_VERSION
 echo $NEXT_RELEASE_VERSION > pomVersion
 git add pomVersion
 git commit -m "update pomVersion to ${NEXT_RELEASE_VERSION}"
 git push origin main