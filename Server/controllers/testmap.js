var MongoClient = require('mongodb').MongoClient;
var mongoUrl = 'mongodb://rishdosh:Moniter123@ds131320.mlab.com:31320/sphere';
var mapClient = require('./map.js');
const assert = require('assert');
var Q = require('q');

var dude1 = {
  "name": "dude",
  "lat": 42.27479,
  "lng": -83.73428,
  "genres": ["rock"],
  "vendorIds": [1, 2, 3, 4, 5],
};
var dude2 = {
  "name": "dude",
  "lat": 42.27479,
  "lng": -83.73428,
  "genres": ["rap"],
  "vendorIds": [1, 2, 3, 4, 5],
};
var brownJug = {
  "lat": 42.29117,
  "lng": -83.71572,
  "genres": ["default"],
};
var blueLep = {
  "lat": 42.27489,
  "lng": -83.73353,
  "genres": ["default"],
};
var charlies = {
  "lat": 42.27480,
  "lng": -83.73483,
  "genres": ["default"],
};
var whiteHouse = {
  "lat": 38.89768,
  "lng": -77.03653,
  "genres": ["default"],
};
var cancun = {
  "lat": 21.16191,
  "lng": -86.85153,
  "genres": ["default"],
};

MongoClient.connect(mongoUrl, function (err, db) {
  if (err) return console.log(err);

  addVenues(db)
    .then( function(p) {
      return testWithinRadius(db);
    })
    .then( function(p) {
      return testOutsideRadius(db);
    })
    .then( function(p) {
      return testMixRadius(db);
    })
    /*
    .then( function(p) {
      return testUpdateGenres(db);
    })
    */
    .then( function(p) {
      return clearVenues(db);
    })
    .catch( function(err) {
      console.fail("Tests failed: " + err);
    });
});

var addVenues = function(db) {
  var deferred = Q.defer();

  var p1 = mapClient.updateVenue(db, dude1, ["rock"]);
  var p2 = mapClient.updateVenue(db, brownJug, ["rap"]);
  var p3 = mapClient.updateVenue(db, blueLep, ["trap"]);
  var p4 = mapClient.updateVenue(db, charlies, ["classics"]);
  var p5 = mapClient.updateVenue(db, whiteHouse, ["trumps"]);

  Q.all([p1, p2, p3, p4, p5])
    .then(function(values) {
      deferred.resolve();
    })
    .catch(function(err) {
      console.log("setup fail");
      deferred.reject("setup fail");
      process.exit();
    });

  return deferred.promise;
}

var clearVenues = function(db) {
  var deferred = Q.defer();

  console.log("clearing");

  db.collection('venues').remove(function(err) {
    if(err) {
      console.log(err);
      deferred.reject(err);
    }
    else {
      db.close();
      deferred.resolve();
    }
  });

  return deferred.promise;
}


var testWithinRadius = function(db) {
  var deferred = Q.defer();

  mapClient.getVenues(db, brownJug['lat'], brownJug['lng'], 100000000)
    .then(function(values) {
      if(values.length != 5) {
        console.log("testWithinRadius -- fail");
        deferred.reject();
      }
      else {
        console.log("testWithinRadius -- pass");
        deferred.resolve();
      }
    })
    .catch(function(err) {
      deferred.reject("testWithinRadius -- error");
    });

  return deferred.promise;
}

var testOutsideRadius = function(db) {
  var deferred = Q.defer();

  mapClient.getVenues(db, cancun['lat'], cancun['lng'], 10)
    .then(function(values) {
      if(values.length != 0) {
        console.log("testOutsideRadius -- fail");
        deferred.reject();
      }
      else {
        console.log("testOutsideRadius -- pass");
        deferred.resolve();
      }
    })
    .catch(function(err) {
      deferred.reject("testOutsideRadius -- error");
    });

  return deferred.promise;
}

var testMixRadius = function(db) {
  var deferred = Q.defer();

  mapClient.getVenues(db, brownJug['lat'], brownJug['lng'], 10000)
    .then(function(values) {
      if(values.length != 4) {
        console.log("testMixRadius -- fail");
        deferred.reject();
      }
      else {
        console.log("testMixRadius -- pass");
        deferred.resolve();
      }
    })
    .catch(function(err) {
      deferred.reject("testMixRadius -- error");
    });

  return deferred.promise;
}

var testUpdateGenres = function(db) {
  var deferred = Q.defer();

  mapClient.updateVenue(db,  dude2, dude2.genres)
    .then(function() {
      mapClient.getVenues(db, dude1['lat'], dude2['lng'], 1)
        .then(function(val) {
          console.log(val);
          console.log("testUpdateGenres -- pass");
          deferred.resolve();
        })
        .catch(function(err) {
          deferred.reject("testUpdateGenres -- error");
        });
    })
    .catch(function(err) {
      deferred.reject("testUpdateGenres -- error");
    });
  return deferred.promise;
}

