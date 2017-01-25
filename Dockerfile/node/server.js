'use strict';

const express = require('express');

// Constants
const PORT = 9090;

// App
const app = express();
app.get('/', function (req, res) {
  res.send('Hello world toto\n');
});

app.listen(PORT);
console.log('Running on http://localhost:' + PORT);