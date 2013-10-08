<!doctype html>
<html lang="en">
<head>
    <title>Potion Soap</title>
    <link rel="stylesheet" type="text/css" href="/reagent-icon.css" />
    <script data-main="js/main" src="js/lib/require/require.js"></script>
    <script type="text/javascript">
      (function() {
      if (typeof window.janrain !== 'object') window.janrain = {};
      if (typeof window.janrain.settings !== 'object') window.janrain.settings = {};
      
      janrain.settings.tokenUrl = 'http://localhost:8000/social_login_submit';

      function isReady() { janrain.ready = true; };
      if (document.addEventListener) {
      document.addEventListener("DOMContentLoaded", isReady, false);
      } else {
      window.attachEvent('onload', isReady);
      }

      var e = document.createElement('script');
      e.type = 'text/javascript';
      e.id = 'janrainAuthWidget';

      if (document.location.protocol === 'https:') {
      e.src = 'https://rpxnow.com/js/lib/potion-soap/engage.js';
      } else {
      e.src = 'http://widget-cdn.rpxnow.com/js/lib/potion-soap/engage.js';
      }

      var s = document.getElementsByTagName('script')[0];
      s.parentNode.insertBefore(e, s);
      })();
</script>
</head>
<body>

<ifLoggedIn>
  <div id="container">
    <div id="menu"></div>
    <div id="content"></div>
  </div>
</ifLoggedIn>

<ifLoggedOut>
  <apply template="_login"/>
  <div id="janrainEngageEmbed"></div>
</ifLoggedOut>

</body>
</html>
