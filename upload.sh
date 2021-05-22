#!/bin/bash

rm -rf public
hugo -D
cd public
rsync -avz --progress ./* root@aricodes.net:/opt/aricodes/
