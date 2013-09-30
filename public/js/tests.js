define([ 'backbone'       
       , 'views/reagent-icon-view'
       , 'models/reagent-model'
       , 'backbone-extentions/view-utilities'
       ], 

function(Backbone, ReagentIconView, ReagentModel){
  var reagentIconView = null;
  var reagentModel = null;

  test( "ReagentIconView should contain an 'events' object", function() {
    givenAInstanceOfABackboneJSViewGeneratedBySunroof();
    thenTheInstanceShouldContainAnAttributeWithTheKeyEvents();
    andTheEventsAttributeShouldBeAnObject();
  });

  test("ReagentIconView should contain a 'render' attribute", function(){
    givenAInstanceOfABackboneJSViewGeneratedBySunroof();
    thenTheInstanceShouldContainAnAttributeWithTheKeyRender();
    andTheEventsAttributeShouldBeAJavascriptFunction();
  });
    
  test( "ReagentIconView should be able to render its element", function() {
    givenAInstanceOfABackboneJSViewGeneratedBySunroof();
    whenTheInstanceIsRendered();
    thenItsElementShouldBeSet();
  });

  test( "RegentModel should contain 'save' attribute", function(){
    givenAnInstanceOfABackboneJSModuleGeneratedBySunroof();
    thenTheModelShouldContainASaveAttribute();
  });


  function givenAInstanceOfABackboneJSViewGeneratedBySunroof(){
    reagentModel    = new ReagentModel({ name : "name"				  
				       });    
    reagentIconView = new ReagentIconView({model: reagentModel}); 
  }

  function givenAnInstanceOfABackboneJSModuleGeneratedBySunroof(){
    reagentModel = new ReagentModel();    
  }

  function whenTheInstanceIsRendered(){
    reagentIconView.render();    
  }

  function thenTheInstanceShouldContainAnAttributeWithTheKeyRender (){
    ok(reagentIconView["render"] != undefined, "render attribute should be defined");
  }

  function andTheEventsAttributeShouldBeAJavascriptFunction (){
    equal(typeof(reagentIconView["render"]), "function", "render should be a function");
  }
  
  function thenTheModelShouldContainASaveAttribute(){
    ok(reagentModel.save != 'undefined');  
  }

  function thenTheInstanceShouldContainAnAttributeWithTheKeyEvents(){
    ok( reagentIconView["events"] != undefined, "events attribute should be defined");
  }

  
  function thenItsElementShouldBeSet(){
    var element = reagentIconView.el;
    var emptyDiv = document.createElement("div");
    ok( !element.isEqualNode(emptyDiv) );
  }   

  function andTheEventsAttributeShouldBeAnObject(){
    equal( typeof(reagentIconView["events"]), "object", "events should be an object");
  }  

});
