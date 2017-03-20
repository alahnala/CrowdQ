var Q = require('q');
var request = require('request');
var userMusic = require('./spotify');

var isEmptyObject = function(obj) {
  return !Object.keys(obj).length;
}

exports.tryNewVenue = function(db, newVendor) {
  var deferred = Q.defer();
  var loc = {'lat': newVendor.lat, 'lng': newVendor.lng};
  var self = this;

  self.findVenue(db, loc)
    .then(function(doc) {
      if (doc === null) {
        console.log("not found");
        var venue = {
          'name': newVendor.venueName,
          'lat': newVendor.lat,
          'lng': newVendor.lng,
          'genres': newVendor.musicTaste,
          'vendorIds': [ newVendor.spotifyUserId ]
        };
        return self.createNewVenue(db, venue);
      } else {
        return self.addExplorerTag(db, loc, newVendor.musicTaste);
      }
    })
    .then(function(status) {
      deferred.resolve(status);
    })
    .catch(function(err) {
      console.log(err);
      deferred.reject(err);
    });

  return deferred.promise;
}

exports.createNewVenue = function(db, venueInfo) {
  var deferred = Q.defer();

  var doc = {
    'name': venueInfo.name,
    'lat': venueInfo.lat,
    'lng': venueInfo.lng,
    'genres': venueInfo.genres,
    'vendorIds': venueInfo.vendorIds
  };

  db.collection('venues').insertOne(doc, function(err, r) {
    if (err) {
      console.log("create failed");
      deferred.reject(err);
    }
    else {
      console.log(r);
      deferred.resolve("success: createVenue")
    }
  });

  return deferred.promise;
}

exports.findVenue = function(db, loc) {
  var deferred = Q.defer();
  db.collection('venues').findOne(loc, function(err, doc) {
    if (err) deferred.reject(err);
    else deferred.resolve(doc);
  });
  return deferred.promise;
}

exports.addExplorerTag = function(db, loc, tag) {
  var deferred = Q.defer();
  console.log(tag);
  db.collection('venues').updateOne(loc, {$addToSet: {'genres': tag}}, function(err, r) {
    if (err) {
      // console.log(err);
      deferred.reject(err);
    }
    else {
      console.log("done");
      deferred.resolve("success: addExplorerTag");
    }
  });
  return deferred.promise;
}
