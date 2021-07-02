#!/bin/bash

file="images.properties"

if [ -f "$file" ]
then
  echo "$file found."
  #remove "\r" by perl
  perl -pi -e 's/\r//' $file
  while IFS='=' read -r key value
  do
    #echo "${key}=${value}"
    docker pull ${value}
    docker tag ${value} ${key}
    docker rmi ${value}
  done < "$file"

else
  echo "$file not found."
fi

