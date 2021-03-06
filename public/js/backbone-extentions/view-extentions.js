define([ 'backbone'
       , 'handlebars'
       ],

function(Backbone,Handlebars){

  Backbone.View.prototype.rendered = false;

  Backbone.View.prototype.close = function(onCloseFunctionality)
  {
    this.rendered = false;
    this.remove();
    this.unbind();

    if (isFunctionDefined(this.onCloseFunctionality)){
      this.onCloseFunctionality();
    }
  };

  Backbone.View.prototype.isRendered = function(){    
    return this.rendered == true;
  };

  Backbone.View.prototype.renderTemplate = function(template, bindings){
    var renderFunction = Handlebars.compile(template);
    var renderedTemplate = renderFunction(bindings);
    $(this.el).html(renderedTemplate);
    this.setElement(renderedTemplate);
    this.rendered = true; 	
  };

});
function isFunctionDefined(callback) {
 return typeof(callback) == "function";
}


