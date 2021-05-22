#!/bin/bash

rm -rf public
hugo
cd public
rsync -avz --progress ./* root@aricodes.net:/opt/aricodes/
