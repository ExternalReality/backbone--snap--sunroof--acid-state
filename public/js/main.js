require.config({
  paths: { jquery: 'lib/jquery/jquery-2.0.1.min'
         , underscore: 'lib/underscore/underscore-min'
         , backbone: 'lib/backbone/backbone-min'
	 },

  shim: {
    backbone: {
      deps: ['jquery','underscore'],
      exports: 'Backbone'
    }
  }
});

require([ 'app' ], function(App){
  App.initialize();
});
