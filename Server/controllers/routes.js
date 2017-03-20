var request = require('request');
var userClient = require('./user');
var mapClient = require('./map');
var venueClient = require('./venue');

var maxRadius = 1000 // meters

module.exports = function(app, db) {
  app.get('/index', function(req, res) {
    res.send('<h1>hello, world!</h1>');
  });

  app.post('/userVerify', function(req, res) {
    var userId = req.body.userId;

    userClient.findUser(db, userId)
      .then(function(doc) {
        if (doc == null) {
          res.status(200).send("usernoexist");
        } else {
          var userType = doc.type;
          res.status(200).send(userType);
        }
      })
      .catch(function(err) {
        res.status(500).send(err);
      });
  });

  app.get('/venues', function(req, res) {
    if(!req.query.lat || !req.query.lng) {
      res.status(400).send();
      return;
    }

    var radius = req.query.radius || maxRadius;
    mapClient.getVenues(db, req.query.lat, req.query.lng, radius)
      .then(function(data) {
        res.json(data);
      })
      .catch(function(err) {
        res.status(500).send("db error getting up venues");
		});
  });

  app.post('/venues', function(req, res) {
    if(!req.body.name || !req.body.lat ||
       !req.body.lng || !req.body.genres)
    {
      res.status(400).send();
      return;
    }

    var venue = {
      'name': req.body.name,
      'lat': req.body.lat,
      'lng': req.body.lng,
    };

    mapClient.updateVenues(db, venue, req.body.genres)
      .then(function(data) {
        res.status(200).send();
      })
      .catch(function(err) {
        res.status(500).send("db error updating venue");
      });
  });

  app.post('/createVendor', function(req, res) {
    var newVendor;
    newVendor.name = req.body.name;
    newVendor.venueName =  req.body.venueName;
    newVendor.spotifyUserId = req.body.spotifyUserId;
    newVendor.lat = req.body.lat;
    newVendor.lng = req.body.lng;
    newVendor.musicTaste = [];

    userClient.createNewVendor(db, newVendor)
      .then(function(resObj) {
        console.log(resObj.message);
        return venueClient.tryNewVenue(db, resObj.newVendor);
      })
      .then(function(status) {
        console.log(status);
        res.status(200).send(status);
      })
      .catch(function(err) {
        console.log(err);
        res.status(500).send(err);
      });

  });

  app.post('/createExplorer', function(req, res) {
    var newExplorer;
    newExplorer.name = req.body.name;
    newExplorer.spotifyUserId = req.body.spotifyUserId;

    userClient.createNewExplorer(db, newExplorer)
      .then(function(status) {
        res.status(200).send(status);
      })
      .catch(function(err) {
        res.status(500).send(err);
      });
  });
};
