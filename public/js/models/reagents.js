define([ 'backbone'
       , 'models/reagent-model'
       ],

function(_, Backbone, ReagentModel){
  var Reagents = Backbone.Collection.extend({
    model: ReagentModel
  });

  return Reagents;
});