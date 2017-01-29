var express = require('express'),  
  bodyParser = require('body-parser'),
  mongoose = require('mongoose'),
  port = process.env.PORT || 9090,
  app = express();


app.use(bodyParser.urlencoded({extended: true}));  
app.use(bodyParser.json());

app.use(express.static('public'));

mongoose.connect('mongodb://172.254.0.4:27017/wallmart');  
var wallmartSchema = mongoose.Schema({  
  Store: Number,
  Date: String,
  Dept: Number,
  Weekly_Sales: Number,
  IsHolidayx: String,
  Temperature: Number,
  Fuel_Price: Number,
  MarkDown1: Number,
  MarkDown2: Number,
  MarkDown3: Number,
  CPI: Number,
  Unemployment: Number,
  IsHolidayy: String,
  Type: String,
  Size: Number
});
var Wallmart = mongoose.model('Wallmart', wallmartSchema);

var router = express.Router();  
router.route('/api')  
    .get(function(req, res){
      Wallmart.find(function(err, wallmarts){
        if(err){
          res.send(err);
        }
        res.send(wallmarts);
      });
    })
    .post(function(req, res){
      var wallmart = new Wallmart();
      wallmart.Store = req.body.Store;
      wallmart.Date = req.body.Date;
      wallmart.Dept = req.body.Dept;
      wallmart.Weekly_Sales = req.body.Weekly_Sales;
      wallmart.IsHolidayx = req.body.IsHolidayx;
      wallmart.Temperature = req.body.Temperature;
      wallmart.Fuel_Price = req.body.Fuel_Price;
      wallmart.MarkDown1 = req.body.MarkDown1;
      wallmart.MarkDown1 = req.body.MarkDown2;
      wallmart.MarkDown1 = req.body.MarkDown3;
      wallmart.CPI = req.body.CPI;
      wallmart.Unemployment = req.body.Unemployment;
      wallmart.IsHolidayy = req.body.IsHolidayy;
      wallmart.Type = req.body.Type;
      wallmart.Size = req.body.Size;
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
      wallmart.Store = req.body.Store;
      wallmart.Date = req.body.Date;
      wallmart.Dept = req.body.Dept;
      wallmart.Weekly_Sales = req.body.Weekly_Sales;
      wallmart.IsHolidayx = req.body.IsHolidayx;
      wallmart.Temperature = req.body.Temperature;
      wallmart.Fuel_Price = req.body.Fuel_Price;
      wallmart.MarkDown1 = req.body.MarkDown1;
      wallmart.MarkDown1 = req.body.MarkDown2;
      wallmart.MarkDown1 = req.body.MarkDown3;
      wallmart.CPI = req.body.CPI;
      wallmart.Unemployment = req.body.Unemployment;
      wallmart.IsHolidayy = req.body.IsHolidayy;
      wallmart.Type = req.body.Type;
      wallmart.Size = req.body.Size;
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
