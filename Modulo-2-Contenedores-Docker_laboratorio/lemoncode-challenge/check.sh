#!/bin/bash
set -x
TEST=$(curl -s localhost:8080 | grep -i "Contenedores" | sed -e 's/^[[:space:]]*//i')
if [["$TEST" == "Contenedores"]]; then
       	echo "Success!"
else
	echo "Any problem with deploy"
fi
