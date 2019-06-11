#!/bin/bash

source oobash

alias foo=$(new class)
foo .bar = "baz"
foo .bar
foo .bar = "quz"
foo .bar
foo
