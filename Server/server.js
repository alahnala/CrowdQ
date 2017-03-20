var express = require('express')
  , https = require('https')
  , path = require('path');

var fs = require('fs');

var app = express();

var MongoClient = require('mongodb').MongoClient;
var mongoUrl = 'mongodb://rishdosh:Moniter123@ds131320.mlab.com:31320/sphere';

var db;

var sslOptions = {
  key: fs.readFileSync('/etc/ssl/privkey.pem'),
  cert: fs.readFileSync('/etc/ssl/fullchain.pem')
};

var port = process.env.PORT || 3000;

app.configure(function(){
  app.set('port', port);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(path.join(__dirname, 'public')));
});

app.configure('development', function(){
  app.use(express.errorHandler());
});

MongoClient.connect(mongoUrl, function (err, database) {
  if (err) return console.log(err)
  db = database
  require('./controllers/routes')(app, db);
  https.createServer(sslOptions, app).listen(port, function() {
    console.log('Super secure server wizardy happens on port ' + port)
  });
})
