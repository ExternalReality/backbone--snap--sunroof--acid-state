define([ 'backbone'
       , 'models/reagentModel' 
       ], 

function(_, Backbone, ReagentNodel){
  var Reagents = Backbone.Collection.extend({
    model: ProjectModel
  });

  return Reagents;
});