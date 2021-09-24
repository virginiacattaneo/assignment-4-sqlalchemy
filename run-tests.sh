#!/bin/bash


if [[ ! -f "DB_CREATED" ]]; then
    python3 create_db.py
    echo 1 > "DB_CREATED"
fi

python3 -m robot test/test_assignment_4.robot
