;; -*- lexical-binding: t; -*-
;; 2025-07-09
;; Authored by David Harris



;; Snippets to develop and compile this project. Its part of my general deployment workflow that depends on some lisp outside this project. Similar to a makefile.

;; this file is meant to be opened in an emacs buffer and expressions evaluated as needed, not in strict order.


;; all the other files in the repo are the bricks. This is the mortar.






(defun MPSgantt-setup ()
  "load the lisp to get emacs to understand all the context we need from outside this repo about our computing environment"
  (load-file "../env_config/env_config.el")

  (load-file "../env_config/gnuplot-helper-lisp.el")
  (load-file "../env_config/sqlite-helper-lisp.el")  
  (load-file "../SAPdata/code/charfix.el")
  (setq wrangle-repo "../SAPdata/"
        SAPspool-folder (file-name-concat wrangle-repo "UnprocessedData/SAPspool_20250715")
        charfixed-folder (file-name-concat wrangle-repo "Charfixdata/SAPspool_20250715"))

)


(MPSgantt-setup)






(setq plot-file "./test1.plt"

      project-DB "./test-cm01-data.db"

      project-sql "./CM01_RCCP.sql")




(cli-gnuplot-file-runner plot-file)



(charfix-folder SAPspool-folder charfixed-folder)


(cli-sqlite-file-runner project-DB project-sql)


(open-in-sqlite-browser project-DB)





;; open in emacs (can probably be set to open in web browser)
(browse-url "file:///s:/CC%20Concurrence%20Workspace/HARRISDM/RM06analyst/mpsgantt/MPSgantt.svg")

;; open in emacs
(find-file "s:/CC Concurrence Workspace/HARRISDM/RM06analyst/MPSgantt/MPSgantt.svg")


(browse-url "file:///s:/CC%20Concurrence%20Workspace/HARRISDM/RM06analyst/mpsgantt/test-print.txt")








;; git version control operations -- keeps a record of changes and keeps the project tidy & portable

(shell-command "git init")


(shell-command "git add .")

(shell-command "git status")

(shell-command "git commit -m \"test plot\"")





;; push to Gitea portable

(shell-command "git push origin")

(shell-command "git remote -v")


(shell-command "git config --local user.name RM06analyst")

(shell-command "git config --local user.email dharris.richmond@fareva.com")





;; gnuplot manual
(browse-url "c:/Users/harrisdm/DataTools/programs/gnuplot/docs/gnuplot.pdf")

;; vectors pg 95
;; table pg 223
