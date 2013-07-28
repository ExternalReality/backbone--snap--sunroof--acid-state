define ([ 'backbone'
        ],    
    
function () {

  var replaceContentWith = function(view) { 
    return function(){
	var content = $('#content');
	var node    = view.render().el;
        replaceOrAppend(content, node);
    };
  };

  return { replaceContentWith : replaceContentWith };
  	
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


