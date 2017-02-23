#!/bin/bash

touch tmp/restart.txt
sudo varnishadm 'ban req.url ~ "."'