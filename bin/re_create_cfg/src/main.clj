(ns main
  (:require [stencil.core :as stencil]
            [me.raynes.fs :as fs]
            [clojure.java.io :as io]
            [clojure.string :as str]))

(def ^:const cfg-template
  "
  [po4a_langs]{{#langs}} {{.}}{{/langs}}
  [po4a_paths] i18n/pot/$master/original.pot $lang:i18n/po/$master/$lang.po

  [po4a_alias:myadoc] asciidoc opt:\"-k 20 -M utf-8 -L utf-8\"

  {{#paths}}
  [type: {{ext}}] {{original}} $lang:{{target}} master:file={{master}}
  {{/paths}}
  ")

(def ^:const cfg-file-name "po4a.cfg")
(def ^:const src-lang "en")
(def ^:const target-langs ["ja"])

(def ^:const extention-table
  {".adoc" "myadoc"})

(def ^:const ignore-files
  #{"en/content/community/contributing_site.adoc"
    "en/content/community/contributors.adoc"
    "en/content/community/contributing.adoc"})

(defn -main [root-path]
  (let [cfg-file-path (str root-path "/" cfg-file-name)]
    (when (fs/exists? cfg-file-path)
      (let [root-regx (re-pattern (str root-path "/"))
            src-regx (re-pattern (str src-lang "/"))
            paths (->> (fs/find-files (str root-path "/" src-lang) #".*\.adoc$")
                       (map fs/normalized)
                       (map #(.getPath %))
                       (map #(str/replace-first % root-regx ""))
                       (filter (complement ignore-files)))
            paths (reduce (fn [v path]
                            (let [ext (fs/extension path)
                                  ext-regx (re-pattern ext)]
                              (conj v {:original path
                                       :target (str/replace-first path src-regx "\\$lang/")
                                       :ext (get extention-table ext)
                                       :master (-> path
                                                   (str/replace-first src-regx "")
                                                   (str/replace-first ext-regx ""))})))
                          []
                          paths)]
        (spit (io/file cfg-file-path)
              (stencil/render-string cfg-template {:langs target-langs
                                                   :paths paths}))
        (doseq [{:keys [master]} paths]
          (fs/mkdirs (str root-path "/i18n/po/" master))
          (fs/mkdirs (str root-path "/i18n/pot/" master))
          (fs/touch (str root-path "/i18n/pot/" master "/original.pot")))))))
