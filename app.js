var express = require('express');
var semver = require('semver');
var url = require('url');

var app = express();

var latest;

app.get('/', function (req, res) {
    res.send('Hello World!');
});

app.get('/updater', function (req, res) {
    var parts = url.parse(req.url, true);
    var query = parts.query;

    if (semver.lt(query.version, latest)) {
        //update
        
    }

    res.send(query);
});

app.listen(3000, function () {
    // fetch latest version
    latest = '1.2.3';

    console.log('Example app listening on port 3000!');
});