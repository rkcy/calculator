#!/bin/bash

test $(curl localhos:8765/sum?a=1\&b=2) -eq 3