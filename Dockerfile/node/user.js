var PORT = 3000;
var MONGODBURL = 'mongodb://172.254.0.4:27017/myapp';

var express = require('express');
var bodyParser = require('body-parser');

// DB connexion
var db
const MongoClient = require('mongodb').MongoClient
var ObjectID = require('mongodb').ObjectID
MongoClient.connect(MONGODBURL, (err, database) => {
  if (err) return console.log(err)
  db = database
  app.listen(PORT, () => {
    console.log('listening on ' + PORT)
  })
})

var app = express();
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
// path where files are not processed
app.use(express.static('client'));

// default root
app.get('/', function (req, res) {
  res.send('Hello World!');
});


// GET : read all
app.get('/users/', function (req,res){
    console.log("list users");
    db.collection('users').find().toArray((err, result) => {
        if (err) return console.log(err)

        console.log(result);
        res.send(result);
    })
})

// GET : read one
app.get('/users/:userId', function (req,res){
    console.log("user details : " + req.params.userId);
    db.collection('users').findOne({_id : new ObjectID(req.params.userId)},(err, result) => {
        if (err == null)
        {
            console.log(result);
            res.send(result);
        } 

        return console.log(err);
    }) 
})

// GET : many params example
app.get('/users2/:flag1.:flag2', function (req,res){
    res.send('users <br/>- flag1 : ' + req.params.flag1 + '<br/>- flag2 : ' + req.params.flag2);
})

// GET : many params alternative example
app.get('/users3/:flag1-:flag2', function (req,res){
    res.send('users <br/>- flag1 : ' + req.params.flag1 + '<br/>- flag2 : ' + req.params.flag2);
})

// POST : create
app.post('/users/', function(req, res){
    console.log('user created');
    console.log(req.body);
    
    db.collection('users').save(req.body, (err, result) => {
        if (err) return console.log(err)

        console.log('saved to database')
        res.redirect('/')
    })
})

// PUT : update one
app.put('/users/:userId', function(req, res){
    console.log('user updated : ' + req.params.userId);
    console.log(req.body);

    db.collection('users').findOneAndUpdate({_id : new ObjectID(req.params.userId)}, {
        $set: {
            lastname: req.body.lastname,
            firstname: req.body.firstname
        }
    }, {
        sort: {_id: -1},
        upsert: true
    }, (err, result) => {
        if (err) return res.send(err)
        res.send(result)
    })
})

// DELETE : delete
app.delete('/users/:userId', function(req, res){
    console.log('user deleted : ' + req.params.userId)
    db.collection('users').findOneAndDelete({_id : new ObjectID(req.params.userId)},
    (err, result) => {
        if (err) return res.send(500, err)
        
        res.send('user deleted')    
    })
})