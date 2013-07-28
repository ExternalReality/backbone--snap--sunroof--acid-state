define([ 'backbone'
       , 'views/potionmakers-mixture-view'
       ],

function( Backbone 
	, PotionMakersMixturesView
	){
    
  var MixtureRouter = Backbone.Router.extend({
    routes: { 'potionMakersMixtures' : 'potionMakersMixtures' }
  });

  var initialize = function(){
    var mixture_router           = new MixtureRouter();
    var potionMakersMixturesView = new PotionMakersMixturesView();

    mixture_router.on('route:potionMakersMixtures', function(){      
      var content                     = $('#content');
      var potionMakersMixturesElement = potionMakersMixturesView.render().$el;
      content.contents().replaceWith(potionMakersMixturesElement);
    });

  };

  return { initialize: initialize };
});

// function replaceOrAppend(elem, substitute){
//   if (elem.children().size() > 0){
//     elem.children().replaceWith(substitute);
//   }else{
//     elem.append(substitute);
//   }
// }

