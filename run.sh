#!/bin/bash

export FLASK_APP=app
export FLASK_ENV=development
export FLASK_RUN_PORT=4000

if [[ ! -f "DB_CREATED" ]]; then
    python3 create_db.py
    echo 1 > "DB_CREATED"
fi

flask run
