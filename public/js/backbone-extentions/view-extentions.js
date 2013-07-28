define([ 'backbone' ],

function(Backbone){

  Backbone.View.prototype.close = function(onCloseFunctionality)
  {
    this.remove();
    this.unbind();

    if (isFunctionDefined(this.onClose)){
      this.onClose();
    }

  };

});

function isFunctionDefined(callback) {
 return typeof(callback) == "function";
}


