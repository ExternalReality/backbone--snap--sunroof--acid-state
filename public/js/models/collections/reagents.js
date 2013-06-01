define([ 'backbone'
       , 'models/reagent' 
       ], 

function(_, Backbone, ProjectModel){
  var ProjectCollection = Backbone.Collection.extend({
    model: ProjectModel
  });

  return ProjectCollection;
});