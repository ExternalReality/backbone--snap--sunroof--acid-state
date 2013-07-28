{-# LANGUAGE OverloadedStrings #-}

module CSS.ReagentIcon where

import Clay
------------------------------------------------------------------------------
reagentIconCss :: Css
reagentIconCss = ".reagent-icon" ?
  do display   inlineBlock
     height    (px 300)
     padding   (px 0) (px 26) (px 0) (px 26)     
     textAlign (alignSide sideLeft)


------------------------------------------------------------------------------
mixtureCss :: Css
mixtureCss = "#mixture" ?
  do marginRight (px 294)
     height      (pct 100)
     width       (pct 50)
     position    absolute 
     top         0
     

------------------------------------------------------------------------------
buttonCss :: Css
buttonCss = ".button" ?
  do display         inlineBlock
     outline         none none none
     textAlign       (alignSide sideCenter)
     textDecoration  none
     fontSize        (px 24)
     fontFamily      [] [sansSerif] 
     padding         (em 0.5) (em 0.55) (em 0.5) (em 0.55)
     textShadow      (px 0)   (px 1)   (px 1)    (rgba 0 0 0 40)
     borderRadius    (em 0.5) (em 0.5) (em 0.5)  (em 0.5)
     boxShadow       (px 1)   (px 2)   (px 0)    (rgba 0 0 0 40)

     
------------------------------------------------------------------------------
orangeGrandientCss :: Css
orangeGrandientCss = ".orange" ?
  do color            "#fef4e9"
     border           solid (px 1) "#da7c0c"
    -- backgroundColor  "#f78d1d" 
     background $ 
       linearGradient (straight sideTop) 
         [ ("#faa51a", pct 20.0)
         , ("#f47a20", pct 100.0)
         ]      
        
	-- color: #fef4e9;
	-- border: solid 1px #da7c0c;
	-- background: #f78d1d;
	-- background: -webkit-gradient(linear, left top, left bottom, from(#faa51a), to(#f47a20));
	-- background: -moz-linear-gradient(top,  #faa51a,  #f47a20);
	-- filter:  progid:DXImageTransform.Microsoft.gradient(startColorstr='#faa51a', endColorstr='#f47a20');     
