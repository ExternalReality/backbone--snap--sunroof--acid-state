require.config({
  paths: { 'jquery':      'lib/jquery/jquery.min'         
         , 'underscore':  'lib/underscore/underscore-min'
         , 'backbone':    'lib/backbone/backbone-min'
	 , 'rx':          'lib/rxjs/rx'
         , 'handlebars':  'lib/handlebars/handlebars'
	 , 'text':        'lib/text/text'
         },

  shim: {
    'backbone': {
      deps: ['jquery','underscore'],
      exports: 'Backbone'
    },

    'underscore': {
      exports: '_'
    },

    'handlebars': {
	exports: 'Handlebars'
    }
  }
});

require([ 'app' ], function(App){
  App.initialize();
});

