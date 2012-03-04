#!/bin/sh
find . -depth 1 -name '*.pde' -exec mvim -p {} +
