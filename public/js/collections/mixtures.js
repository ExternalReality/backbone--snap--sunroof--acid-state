define([ 'backbone'
       , 'collections/mixture'
       ],

function(Backbone, Mixture){
  var Mixtures = Backbone.Collection.extend({
    url: '/api/mixtures',
    model: Mixture
  });

  return Mixtures;
});
