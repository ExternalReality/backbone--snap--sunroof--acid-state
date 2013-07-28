define([ 'backbone'
       , 'text!/../templates/reagentInput.html'
       ],

function(Backbone, ReagentForm){

  var ReagentInputView = Backbone.View.extend({
    events: { 'change input[name=name]'                : "bindInputs"
            , 'change input[name=imageUrl]'            : "bindInputs"
            , 'change textarea[name=shortDescription]' : "bindInputs"
            , 'change textarea[name=longDescription]'  : "bindInputs"
            , 'click input[type=button]'               : "submit"
            },

    initialize : function(reagentModel, reagentCollection){
      this.model    = reagentModel;
      this.reagents = reagentCollection;
      this.reagents.fetch();
    },

    bindInputs : function(evt){
      var target = $(evt.currentTarget);
      var data = {};
      data[target.attr('name')] = target.val();
      this.model.set(data);
    },

    submit : function(){
      var modelsName = this.model.get("name");
      var reagent = this.reagents.findWhere({name : modelsName});
      if (typeof reagent != 'undefined') {
	this.model.set({id : reagent.get("id")});
      }
      this.model.save();
    },


    render : function() {
      var template = _.template(ReagentForm);
      this.$el.html(template);
      return this;
    }

  });

  return ReagentInputView;
});
