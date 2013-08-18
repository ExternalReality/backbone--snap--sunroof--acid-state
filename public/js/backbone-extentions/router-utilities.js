define ([ 'backbone'
	, 'rx'  
        ],    
    
function (Backbone, Rx) {

  var createObservable = function(event, context){
      function creationFn (observer){

	function handler(e) {
	  observer.onNext(e);
	}
	
	context.on(event, handler);

	function remove (){
	  context.off(event, handler);
	};
	
	return _.bind(remove, context);
      }

      var creationFn = _.bind(creationFn, context);

      return Rx.Observable.create(creationFn);
    };

  var replaceContentWith = function(view) { 
	var content = $('#content');
	var node    = view.render().el;
        replaceOrAppend(content, node);
  };


  function openView(view){
    replaceContentWith(view);
    view.open();
  }

  return { replaceContentWith : replaceContentWith
	 , createObservable   : createObservable
	 , openView           : openView
	 };
  	
});

function replaceOrAppend(content, replacement) {
  var innerContent   = content.children();
  var contentIsEmpty = innerContent.size() == 0;
  
  if (contentIsEmpty) {
    content.append(replacement);  
  }else{
    innerContent.replaceWith(replacement);
  }
}


