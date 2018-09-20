#!/usr/bin/env bash

PORT=5000

if which ruby 2> /dev/null >&2
then
  ruby -run -e httpd . -p $PORT
else
  if which python 2> /dev/null >&2
  then
    if python -V 2>&1 | egrep "^Python 2"
    then
      python -m SimpleHTTPServer $PORT
    else
      python -m http.server $PORT
    fi
  else
    if which http-server 2> /dev/null >&2
    then
      http-server -p $PORT
    else
      echo 'Not found available http server.'
    fi        
  fi
fi

