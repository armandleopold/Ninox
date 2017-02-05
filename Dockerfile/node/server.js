
var express = require('express'),  
  bodyParser = require('body-parser'),
  mongoose = require('mongoose'),
  port = process.env.PORT || 9090,
  app = express();


app.use(bodyParser.urlencoded({extended: true}));  
app.use(bodyParser.json());

app.use(express.static('public'));

mongoose.connect('mongodb://172.254.0.4:27017/predictions');  
var datachema = mongoose.Schema({  
  timePredicted: String,
  store_id: Number,
  value: Number
});
var Wallmart = mongoose.model('data', datachema);

var router = express.Router();  
router.route('/api')  
    .get(function(req, res){
      Wallmart.find(function(err, data){
        if(err){
          res.send(err);
        }
        res.send(data);
      });
    })
    .post(function(req, res){
      var wallmart = new Wallmart();
      wallmart.timePredicted = req.body.timePredicted;
      wallmart.store_id = req.body.store_id;
      wallmart.value = req.body.value;
      wallmart.save(function(err){
        if(err){
          res.send(err);
        }
        res.send({message : 'wallmart data created'});
      })
    });

router.route('/:wallmart_id')  
  .get(function(req, res){
    Wallmart.findOne({_id: req.params.book_id}, function(err, wallmart){
      if(err){
        res.send(err);
      }
      res.send(wallmart);
    });
  })
  .put(function(req, res){
    Wallmart.findOne({_id: req.params.wallmart_id}, function(err, wallmart){
      if(err){
        res.send(err);
      }
      wallmart.timePredicted = req.body.timePredicted;
      wallmart.store_id = req.body.store_id;
      wallmart.value = req.body.value;
      wallmart.save(function(err){
        if(err){
          res.send(err);
        }
        res.send({message: 'waallmart update'});
      });
    });
  })
  .delete(function(req, res){
    Wallmart.remove({_id: req.params.wallmart_id}, function(err){
      if(err){
        res.send(err);
      }
      res.send({message: 'wallmart deleted'});
    });
  });

app.use(router);  
app.listen(port, function(){  
  console.log('listening on port ' + port);
});   
