var Q = require('q');
var MongoClient = require('mongodb').MongoClient;
var mongoUrl = 'mongodb://rishdosh:Moniter123@ds131320.mlab.com:31320/sphere';
var userClient = require('../user.js');
var venueapi = require('../venue.js');

MongoClient.connect(mongoUrl, function (err, db) {
  if (err) return console.log(err);
  else {
    testFn(db);
  }
});

var testFn = function(db) {
  userClient.findUser(db, "sgodbole")
    .then(function(doc) {
      console.log(doc);
      if (doc == null) {
        console.log("no user");
        // res.status(100).send("usernoexist");
      } else {
        var userType = doc.type;
        console.log(userType);
        // res.status(200).send(userType);
      }
      db.close();
    })
    .catch(function(err) {
      console.log(err);
      // res.status(500).send(err);
      db.close();
    });
}
