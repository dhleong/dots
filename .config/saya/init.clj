(ns init
  (:require
   [saya.core :as saya]))

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

   ^{:modes "n"}
   ["gk" #send "up"]
   ^{:modes "n"}
   ["gj" #send "down"]])

(saya/config
 :clipboard :unnamedplus)
