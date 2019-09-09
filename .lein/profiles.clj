{:user
 {:plugins [[refactor-nrepl "2.4.0"]
            [cider/cider-nrepl "0.22.2"]

            [lein-ancient "0.6.15"]
            [lein-kibit "0.1.6"]]}
 :repl-options {:nrepl-middleware [refactor-nrepl.middleware/wrap-refactor]}
 :android-user {:dependencies [[cider/cider-nrepl "0.9.1"]]
                :android {:aot-exclude-ns ["cider.nrepl.middleware.util.java.parser"
                                           "cider.nrepl" "cider-nrepl.plugin"]}}
 :android-common
 {:android {:sdk-path "/lib/android-sdk/"}}}
