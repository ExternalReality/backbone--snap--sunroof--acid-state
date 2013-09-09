define([ 'backbone'
       , 'text!/../templates/reagent_icon_template.html'
       , 'backbone-extentions/view-utilities'
       ],

function(Backbone, ReagentIconTemplate, ViewUtils){
  var ReagentIconView = Backbone.View.extend({
    
    events : { 'click' : 'iconClicked' }, 
    
    initialize: function(){
      this.model = this.options.model;
    },

    iconClicked : function() {
      this.trigger("icon-clicked", this.model);
    },

    templateBindings: function (){
      return { reagentName      : this.model.get("name")
	     , imageUrl         : this.model.get("imageUrl")
	     , imageNotFoundUrl : "images/reagent-icons/unavailable/imageNotFoundUrl"
	     , isImageUndefined : this.isImageUndefined()
	     };
    },

    isImageUndefined: function(){
	return typeof(this.model.get("imageUrl")) != "undefined";
    },

    disableImageDragEffect : function(){
       this.$('img').ondragstart = function() { return false; };
    },

    render: function(){
      this.renderTemplate(ReagentIconTemplate, this.templateBindings());
      this.disableImageDragEffect();
      return this;
    }
  });

  return ReagentIconView;
});
