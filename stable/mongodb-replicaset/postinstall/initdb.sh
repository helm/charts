#!/bin/sh

until mongo --host $MONGO_HOST -u $ADMIN_USER -p $ADMIN_PASSWORD -authenticationDatabase admin --eval "print(\"waited for connection\")"
  do
    sleep 5
  done

mongo --host $MONGO_HOST -u $ADMIN_USER -p $ADMIN_PASSWORD -authenticationDatabase admin --eval="db.createUser({user: 'myTester', pwd: 'xyz123', roles: [ { role: 'readWrite', db: 'test' }, { role: 'read', db: 'reporting' } ] } )"
