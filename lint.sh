#!/bin/bash -e
echo "Applying opinionated Python code style..."
if [[ "${CI:=}" == "true" ]]; then
  black . --check --diff
else
  black .
fi

echo "Ruffing up the code..."
ruff check src
ruff check tests

echo "Checking Python types..."
mypy src
