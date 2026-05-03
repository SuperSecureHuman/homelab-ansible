#!/bin/bash
nc -z -w 2 127.0.0.1 53 && exit 0 || exit 1
