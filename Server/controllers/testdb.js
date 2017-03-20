var Q = require('q');
var MongoClient = require('mongodb').MongoClient;
var mongoUrl = 'mongodb://rishdosh:Moniter123@ds131320.mlab.com:31320/sphere';
var userapi = require('./user.js');
var venueapi = require('./venue.js');

MongoClient.connect(mongoUrl, function (err, db) {
  if (err) return console.log(err);
  else {
    // testInsertOneFindOne(db);
    // clearUsers(db);
    // testVenue(db);
    testVenueVendor(db);
  }
});

var testVenueVendor = function(db) {
  vendorObj1 = {
    "type": "vendor",
    "name": "Rishin",
    "venueName": "Common Cup Coffee",
    "spotifyUserId": "rdoshi023",
    'lat': -90.23,
    'lng': 78.12,
    "musicTaste": [],
    "currPlaylistId": "sdk98dfdj9",
  };

  vendorObj2 = {
    "type": "vendor",
    "name": "Chuckry",
    "venueName": "Common Cup Coffee",
    "spotifyUserId": "vengadamn",
    'lat': -90.23,
    'lng': 78.12,
    "musicTaste": [],
    "currPlaylistId": "sdk98dfdj9",
  };

  clearVenues(db)
    .then(function(status) {
      console.log(status);
      return clearUsers(db);
    })
    .then(function(status) {
      console.log(status);
      return testInsertVendor(db, vendorObj1);
    })
    .then(function(status) {
      console.log(status);
      return testVenueInsert(db, vendorObj1);
    })
    .then(function(status) {
      console.log(status);
      return testInsertVendor(db, vendorObj2);
    })
    .then(function(status) {
      console.log(status);
      return testVenueInsert(db, vendorObj2);
    })
    .then(function(status) {
      console.log(status);
      db.close();
    })
    .catch(function(err) {
      console.log(err);
    });
}

var clearVenues = function(db) {
  var deferred = Q.defer();
  db.collection("venues").remove({}, function(err, r) {
    if (err) deferred.reject(err);
    else deferred.resolve("success: clearVenues");
  });
  return deferred.promise;
}

var testVenue = function(db) {
  clearVenues(db)
    .then(function(status) {
      console.log(status);
      return testVenueInsert(db);
    })
    .then(function(status) {
      console.log(status);
      return testVenueExist(db);
    })
    .then(function(venue) {
      console.log(venue);
      return testVenueAddExplorerTag(db);
    })
    .then(function(status) {
      console.log(status);
      db.close();
    })
    .catch(function(err) {
      console.log(err);
    });
}

var testVenueInsert = function(db, vendorObj) {
  return venueapi.tryNewVenue(db, vendorObj);
}

var testVenueExist = function(db) {
  var loc = {
    lat: -90.23,
    lng: 78.12
  };

  return venueapi.findVenue(db, loc);
}

var testVenueAddExplorerTag = function(db) {
  var tag = "classical";
  var loc = {
    lat: -90.23,
    lng: 78.12
  };

  return venueapi.addExplorerTag(db, loc, tag);
}

var testInsertOneFindOne = function(db) {
  testInsertExplorer(db)
    .then(function(status) {
      console.log(status);
      return testInsertVendor(db);
    })
    .then(function(status) {
      console.log(status);
      return testFindExplorer(db);
    })
    .then(function(results) {
      console.log(results);
      return testFindVendor(db);
    })
    .then(function(results) {
      console.log(results);
      db.close();
    })
    .catch(function(err) {
      console.log(err);
    });
}

var clearUsers = function(db) {
  var deferred = Q.defer();
  db.collection("users").deleteMany({'type': 'explorer'}, function(err, r) {
    if (err) deferred.reject(err);
    else {
      db.collection("users").deleteMany({'type': 'vendor'}, function(err, r) {
        if (err) deferred.reject(err);
        else deferred.resolve("success: clearUsers");
      });
    }
  });
  return deferred.promise;
}

var testInsertVendor = function(db, vendorObj) {
  return userapi.createNewVendor(db, vendorObj);
}

var testInsertExplorer = function(db) {
  explorerObj = {
    'type': 'explorer',
    'name': 'Steve',
    'spotifyUserId': 'sgodbold',
    'musicTaste': []
  };

  return userapi.createNewExplorer(db, explorerObj)
}

var testFindVendor = function(db) {
  var userId = "sgodbold";
  return userapi.findUser(db, userId);
}

var testFindExplorer = function(db) {
  var userId = "rdoshi023";
  return userapi.findUser(db, userId);
}
