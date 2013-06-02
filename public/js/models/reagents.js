define([ 'backbone'
       , 'models/reagentModel'
       ],

function(_, Backbone, ReagentModel){
  var Reagents = Backbone.Collection.extend({
    model: ReagentModel
  });

  return Reagents;
});