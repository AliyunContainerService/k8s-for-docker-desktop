#!/bin/bash

file="images.properties"

if [ -f "$file" ]
then
  echo "$file found."

  while IFS='=' read -r key value
  do
    #echo "${key}=${value}"
    docker pull ${key}
    docker tag ${key} ${value}
    docker push ${value}
  done < "$file"

else
  echo "$file not found."
fi

