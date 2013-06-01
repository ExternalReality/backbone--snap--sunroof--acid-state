define([ 'backbone'
       ], 

function(Backbone){
  var ReagentModel = Backbone.Model.extend({urlRoot : "/api/reagents"});	
  return ReagentModel;
});