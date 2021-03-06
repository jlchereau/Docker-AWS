var express = require('express');

// Constants
var PORT = 8080;

// App
var app = express();
app.get('/', function (req, res) {
    res.send('Hello world with a great new feature on ' + process.env.HOSTNAME + ' with NODE_ENV=' + process.env.NODE_ENV + '\n');
});

app.listen(PORT);
console.log('Running on http://localhost:' + PORT);
