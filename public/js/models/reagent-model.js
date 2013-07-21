define([ 'backbone'
       ],

function(Backbone){
  var ReagentModel = Backbone.Model.extend({
    urlRoot : "/api/reagents",

    name : function() {
      return this.get('name');
    }

  });

  return ReagentModel;
});
