{:user
 {:plugins [[cider/cider-nrepl "0.21.1"]
            [lein-ancient "0.6.15"]
            [lein-kibit "0.1.6"]]}
 :android-user {:dependencies [[cider/cider-nrepl "0.9.1"]]
                :android {:aot-exclude-ns ["cider.nrepl.middleware.util.java.parser"
                                           "cider.nrepl" "cider-nrepl.plugin"]}}
 :android-common
 {:android {:sdk-path "/lib/android-sdk/"}}}
