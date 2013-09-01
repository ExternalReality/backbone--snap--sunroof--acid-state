define([ 'backbone'       
       , '../reagentIconViewM'
       , '../reagentModelM'
       ], 

function(Backbone, ReagentIconView, ReagentModel){
  var reagentIconView = null;
  var reagentModel = null;

  test( "ReagentIconView should an 'events' object", function() {
    givenAInstanceOfABackboneJSViewGeneratedBySunroof();
    thenTheInstanceShouldContainAnAttributeWithTheKeyEvents();
    andTheEventsAttributeShouldBeAnObject();
  });

  test( "ReagentIconView should an 'events' object", function() {
    givenAInstanceOfABackboneJSViewGeneratedBySunroof();
    whenTheInstanceIsRendered();
    thenItsElementShouldBeSet();
  });

  test( "RegentModel should contain 'save' attribute", function(){
    givenAnInstanceOfABackboneJSModuleGeneratedBySunroof();
    thenTheModelShouldContainASaveAttribute();
  });

  function givenAnInstanceOfABackboneJSModuleGeneratedBySunroof(){
    reagentModel = new ReagentModel();    
  }

  function thenTheModelShouldContainASaveAttribute(){
    ok(reagentModel.save != 'undefined');  
  }

  function givenAInstanceOfABackboneJSViewGeneratedBySunroof(){
    reagentIconView = new ReagentIconView(); 
  }

  function thenTheInstanceShouldContainAnAttributeWithTheKeyEvents(){
    ok( reagentIconView["events"] != undefined, "events attribute should be defined");
  }

  function andTheEventsAttributeShouldBeAnObject(){
    equal( typeof(reagentIconView["events"]), "object", "events Should be an object");
  }  

  function whenTheInstanceIsRendered(){
    reagentIconView.render();    
  }
  
  function thenItsElementShouldBeSet(){
    var element = reagentIconView.el;
    var emptyDiv = document.createElement("div");
    ok( !element.isEqualNode(emptyDiv) );
  }   
});
