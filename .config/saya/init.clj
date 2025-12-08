(ns init)

#_{:clojure-lsp/ignore [:clojure-lsp/unused-public-var]}
(def nav-maps
  [["K" #send "n"]
   ["J" #send "s"]
   ["L" #send "e"]
   ["H" #send "w"]

   ["O" #send "ne"]
   ["U" #send "nw"]
   ["<" #send "se"]
   ["M" #send "sw"]

   ["P" #send "up"]
   ^{:modes "n"}
   ["p" #send "down"]])
