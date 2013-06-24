define([ 'backbone'
       , 'models/reagent-model'
       , 'text!/../templates/reagentInput.html'
       ],

function(Backbone, Reagent, ReagentForm){

  var ReagentInputView = Backbone.View.extend({
    events: { 'change input[name=name]'                : "bindInputs"
            , 'change input[name=imageUrl]'            : "bindInputs"
            , 'change textarea[name=shortDescription]' : "bindInputs"
            , 'change textarea[name=longDescription]'  : "bindInputs"
            , 'click input[type=button]'               : "submit"
            },

    initialize : function(){
      this.model = new Reagent();
    },

    bindInputs : function(evt){
      var target = $(evt.currentTarget);
      var data = {};
      data[target.attr('name')] = target.val();
      this.model.set(data);
    },

    submit : function(){
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
