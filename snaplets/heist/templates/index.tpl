<!doctype html>
<html lang="en">
<head>
    <title>Potion Soap</title>
    <link rel="stylesheet" type="text/css" href="/reagent-icon.css" />
    <script data-main="js/main" src="js/lib/require/require.js"></script>
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
</ifLoggedOut>

</body>
</html>
