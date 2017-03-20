var Q = require('q');
var geoLib = require('geolib');
var venueClient = require('./venue');

var radiusCheck = function(lat, lng, venue, radius) {
  var dist = geoLib.getDistance(
      { latitude: lat, longitude: lng },
      { latitude: venue['lat'], longitude: venue['lng'] }
  );
  return dist <= radius;
};

exports.getVenues = function(db, lat, lng, radius) {
  var deferred = Q.defer();
  var venues = [];

  db.collection("venues").find({}).each(function(err, doc) {
    if(err) {
      deferred.reject();
    }
    if(doc) {
      if(radiusCheck(lat, lng, doc, radius)) {
        venues.push(doc);
      }
    }
    else {
      deferred.resolve(venues);
    }
  });

  return deferred.promise;
};

exports.addVenue = function(db, venue) {
  var deferred = Q.defer();

  db.collection("venues").insertOne(venue, function(err, r) {
    if(err) {
      console.log(err);
      deferred.reject();
    }
    else {
      deferred.resolve();
    }
  });

  return deferred.promise;
};

exports.updateVenue = function(db, venue, genres) {
  var deferred = Q.defer();

  var locationInfo = {
    "lat": venue["lat"],
    "lng": venue["lng"],
  };

  venueClient.findVenue(db, locationInfo)
    .then(function(doc) {
      if(doc === null) {
        venue['genres'] = genres;

        exports.addVenue(db, venue)
          .then(function() {
            deferred.resolve();
          })
          .catch(function(err) {
            console.log(err);
            deferred.reject(err);
          });
      }
      else {
        // deferred.resolve();
        venueClient.addExplorerTag(db, locationInfo, genres)
          .then(function() {
            console.log("done");
            deferred.resolve();
          })
          .catch(function() {
            console.log(err);
            deferred.reject(err);
          });
      }
    })
    .catch(function(err) {
      console.log(err);
      deferred.reject();
    });

  // return venueClient.tryNewVenue(db, venue);
  return deferred.promise;
};
