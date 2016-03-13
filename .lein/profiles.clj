{:pedestal {}
 :yolo {}
 :marginalia {:plugins [[michaelblume/marginalia "0.9.0"]]}
 :user {:signing {:gpg-key "F5619DFC"}
        ;;:plugins [[cider/cider-nrepl "0.9.0"]]
        }
 :woot {:plugins [[lein-ancient "0.6.7"]]}
 :cider-only {:dependencies [[org.clojure/tools.nrepl "0.2.12"]]
              :plugins [[cider/cider-nrepl "0.11.0"]]}
 :mavbozo {
           ;;:repl-options {:prompt (fn [ns] (str "[" *ns* "]" \newline "=> "))}
           :dependencies [[spyscope "0.1.5"]
                          [clojure-complete "0.2.3"]
                          [org.clojure/tools.nrepl "0.2.12"]
                          [leiningen #=(leiningen.core.main/leiningen-version)]
                          [io.aviso/pretty "0.1.8"]
                          [im.chit/vinyasa "0.3.0"]]
           :plugins [[cider/cider-nrepl "0.11.0"]
                     ]
           :injections 
           [(require 'spyscope.core)
            (require '[vinyasa.inject :as inject])
            (require 'io.aviso.repl)
            (inject/in ;; the default injected namespace is `.` 

             ;; note that `:refer, :all and :exclude can be used
             [vinyasa.inject :refer [inject [in inject-in]]]  
             [vinyasa.lein :exclude [*project*]]  

             ;; imports all functions in vinyasa.pull
             [vinyasa.pull :all]      

             ;; same as [cemerick.pomegranate 
             ;;           :refer [add-classpath get-classpath resources]]
             [cemerick.pomegranate add-classpath get-classpath resources] 

             ;; inject into clojure.core 
             clojure.core
             [vinyasa.reflection .> .? .* .% .%> .& .>ns .>var]

             ;; inject into clojure.core with prefix
             clojure.core >
             [clojure.pprint pprint]
             [clojure.java.shell sh])]}}