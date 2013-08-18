require.config({
  paths: { 'jquery':      'lib/jquery/jquery-2.0.1.min'         
         , 'underscore':  'lib/underscore/underscore-min'
         , 'backbone':    'lib/backbone/backbone-min'
	 , 'rx':          'lib/rxjs/rx.min'
         , 'mustache':    'lib/mustache/mustache.js'
         },

  shim: {
    'backbone': {
      deps: ['jquery','underscore'],
      exports: 'Backbone'
    },

    'underscore': {
      exports: '_'
    }
  }
});

require([ 'app' ], function(App){
  App.initialize();
});

