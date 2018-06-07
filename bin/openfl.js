#!/usr/bin/env node

var child_process = require ("child_process");
child_process.fork (__dirname + "/tools.js", process.argv);