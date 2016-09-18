var express = require('express');
var semver = require('semver');
var bodyParser = require('body-parser');
var url = require('url');
var fs = require('fs');
var mongo = require('mongodb').MongoClient;

var app = express();
app.use(bodyParser.json());

var clientProgram = './client/program.lua';
var mongoUrl = 'mongodb://localhost:27017/home-iot';

var db;

mongo.connect(mongoUrl, function (err, database) {
    if (err !== null) {
        console.error('MongoDB not responding');
        process.exit();
    }
    db = database;
})

app.get('/', function (req, res) {
    res.send('Hello World!');
});

app.get('/updater/:version', function (req, res) {        
    var data = fs.readFileSync(clientProgram, 'utf8');
    var latest = data.split('\n')[0].split(' ')[1];

    console.log('client has: ' + req.params.version +' latest is: ' + latest);

    if (true){//semver.lt(req.params.version, latest)) {
        //update
        console.log('update!');
        res.status(200).sendFile(clientProgram, { root: __dirname});
    } else {
        res.status(204).end();
    }
});

app.post('/data', function (req, res) {
    console.log('data!');
    console.log(req.body);
});

app.listen(3000, function () {
    console.log('Example app listening on port 3000!');
});