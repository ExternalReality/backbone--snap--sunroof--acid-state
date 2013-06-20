define([ 'backbone'
       , 'models/reagent-model'
       , 'text!/../templates/reagentInput.html'
       ],

function(Backbone, Reagent, ReagentForm){

  var ReagentInputView = Backbone.View.extend({
    events : { 'change input[name=name]'  : "bindInputs"
             , 'click input[type=submit]' : "submit"
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

    render: function() {
      var template = _.template(ReagentForm);
      this.$el.html(template);
      return this;
    }

  });

  return ReagentInputView;
});
