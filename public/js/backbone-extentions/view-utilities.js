define (['rx'],    
    
function (Rx) {
  
  var createRouteChangeObserver = function(context){

    var onNext = function(next){
      if(context.isRendered()){
	console.log("View Cleanup");
	context.close(); 
      }
    };

    var onError    = function(error)  { };
    var onComplete = function()       { };

    onNext = _.bind(onNext, context);
    return Rx.Observer.create( onNext
			     , onError
                             , onComplete
			     );
  };

  return { createRouteChangeObserver : createRouteChangeObserver };

});
