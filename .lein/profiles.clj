{:user 
 {:plugins [[cider/cider-nrepl "0.12.0"]
            [lein-kibit "0.0.8"]]}
 :android-user {:dependencies [[cider/cider-nrepl "0.9.1"]]
                :android {:aot-exclude-ns ["cider.nrepl.middleware.util.java.parser"
                                           "cider.nrepl" "cider-nrepl.plugin"]}}
 :android-common
 {:android {:sdk-path "/lib/android-sdk/"}}}
