{:user {:plugins [[lein-kibit "0.1.6"]]}
 :repl {:plugins [[cider/cider-nrepl "0.18.0-SNAPSHOT"]]
        :dependencies [[org.clojure/tools.nrepl "0.2.13"]
                       [cider/piggieback "0.3.8"]
                       [figwheel-sidecar "0.5.16"]
        :repl-options {:nrepl-middleware [cider.piggieback/wrap-cljs-repl]}}}
