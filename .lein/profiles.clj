{:pedestal {}
 :yolo {}
 :marginalia {:plugins [[michaelblume/marginalia "0.9.0"]]}
 :user {:signing {:gpg-key "29B848141065B98D"}
        ;; :plugins [[cider/cider-nrepl "0.22.4"]]
        }
 :woot {:plugins [[lein-ancient "0.6.7"]]}
 ;; :cider-repl {:dependencies [[org.clojure/tools.nrepl "0.2.12"]]
 ;;              :plugins [[cider/cider-nrepl "0.14.0"]]}
 :repl {:plugins [[cider/cider-nrepl "0.50.2"]
                  ;; [mx.cider/enrich-classpath "1.9.0"]
                  ]}
 :emacs {:plugins [[cider/cider-nrepl "0.50.2"]]}
 :mavbozo {
           ;;:repl-options {:prompt (fn [ns] (str "[" *ns* "]" \newline "=> "))}
           :repl-options { ; for nREPL dev you really need to limit output
                          :init (set! *print-length* 50)
                          :nrepl-middleware [
                                             ;; cemerick.piggieback/wrap-cljs-repl
                                             ]

                          }
           :dependencies [ ;;[spyscope "0.1.6-SNAPSHOT"]
                          ;; [com.cemerick/piggieback "0.2.2"]
                          ;; [figwheel-sidecar "0.5.13"]
                          ;; [org.clojure/tools.namespace "0.2.10"]
                          ;; [fipp "0.6.6"]
                          ;; [clojure-complete "0.2.3"]
                          ;; [leiningen #=(leiningen.core.main/leiningen-version)]
                          ;; [io.aviso/pretty "0.1.8"]
                          ;; [im.chit/vinyasa "0.4.7"]
                          ]
           :plugins [
                     ;;[cider/cider-nrepl "0.15.1"]
                     ;; [jonase/eastwood "0.2.3"]
                     ;; [lein-ns-dep-graph "0.1.0-SNAPSHOT"]
                     ]
           :injections [
                        ;; (require '[fipp.edn :refer (pprint) :rename {pprint fipp}])
                        ]
           
           }
 
 :mavbozo-vinyasa {
                   ;;:repl-options {:prompt (fn [ns] (str "[" *ns* "]" \newline "=> "))}
                   :repl-options { ; for nREPL dev you really need to limit output
                                  :init (set! *print-length* 50)
                                  :nrepl-middleware [cemerick.piggieback/wrap-cljs-repl]

                                  }
                   :dependencies [[spyscope "0.1.6-SNAPSHOT"]
                                  [org.clojure/tools.namespace "0.2.10"]
                                  ;;[clojure-complete "0.2.3"]
                                  [leiningen #=(leiningen.core.main/leiningen-version)]
                                  ;;[io.aviso/pretty "0.1.8"]
                                  ;;[im.chit/vinyasa "0.4.7"]
                                  [figwheel-sidecar "0.5.13"]]
                   :plugins [[cider/cider-nrepl "0.12.0"]
                             [jonase/eastwood "0.2.3"]
                             [lein-ns-dep-graph "0.1.0-SNAPSHOT"]]
                   :injections
                   [(require '[fipp.edn :refer (pprint) :rename {pprint >fipp}])
                    #_(require 'spyscope.core)
                    #_(require '[vinyasa.inject :as inject])
                    #_(require 'io.aviso.repl)
                    #_(inject/in ;; the default injected namespace is `.` 

                       ;; note that `:refer, :all and :exclude can be used
                       [vinyasa.inject :refer [inject [in inject-in]]]  
                       [vinyasa.lein :exclude [*project*]]  

                       ;; imports all functions in vinyasa.pull
                       ;; imports all functions in vinyasa.pull
                       [vinyasa.maven pull]

                       ;; inject into clojure.core 
                       clojure.core
                       [vinyasa.reflection .> .? .* .% .%> .& .>ns .>var]

                       ;; inject into clojure.core with prefix
                       clojure.core >
                       [clojure.pprint pprint]
                       [clojure.java.shell sh])]}}
