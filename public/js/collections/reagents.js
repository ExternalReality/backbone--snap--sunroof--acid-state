define([ 'backbone'
       , '/../reagentModelM.js'
       ],

function(Backbone, SunroofReagentModel){
  var Reagents = Backbone.Collection.extend({
    url: '/api/reagents',
    model: SunroofReagentModel
  });

  return Reagents;
});
