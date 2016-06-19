#!/usr/bin/env inlein

'{:dependencies [[org.clojure/clojure "1.8.0"]
                 [stencil "0.5.0"]
                 [me.raynes/fs "1.4.6"]]}

(require '[stencil.core :as stencil]
         '[me.raynes.fs :as fs]
         '[clojure.java.io :as io]
         '[clojure.string :as str])

(def ^:const cfg-template
  "
  [po4a_langs]{{#langs}} {{.}}{{/langs}}
  [po4a_paths] i18n/po/$master/original.pot $lang:i18n/po/$master/$lang.po

  [po4a_alias:myadoc] asciidoc opt:\"-k 0 -M utf-8 -L utf-8\"

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

(when (fs/exists? cfg-file-name)
  (let [root-regx (re-pattern (str (.getPath fs/*cwd*) "/"))
        src-regx (re-pattern (str src-lang "/"))
        paths (->> (fs/find-files src-lang #".*\.adoc$")
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
    (spit (io/file cfg-file-name)
          (stencil/render-string cfg-template {:langs target-langs
                                               :paths paths}))
    (doseq [{:keys [master]} paths]
      (fs/mkdirs (str "i18n/po/" master))
      (fs/touch (str "i18n/po/" master "/original.pot")))))
