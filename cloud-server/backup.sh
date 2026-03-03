#!/bin/bash

rsync -auvhzP --exclude 'encoded_video/' --exclude 'thumbnail/'
