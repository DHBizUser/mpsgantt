;; -*- lexical-binding: t; -*-
;; 2025-07-09
;; Authored by David Harris



;; Snippets to develop and compile this project. Its part of my general deployment workflow that depends on some lisp outside this project. Similar to a makefile.

;; this file is meant to be opened in an emacs buffer and expressions evaluated as needed, not in strict order.


;; all the other files in the repo are the bricks. This is the mortar.



  (find-file "../env_config/env_config.el")



(defun MPSgantt-setup ()
  "load the lisp to get emacs to understand all the context we need from outside this repo about our computing environment"
  (load-file "../env_config/env_config.el")

  (load-file "../env_config/gnuplot-helper-lisp.el")
  
  (load-file "../SAPdata/code/charfix.el")
  (setq wrangle-repo "../SAPdata/"
        SAPspool-folder (file-name-concat wrangle-repo "UnprocessedData/SAPspool_20250710")
        charfixed-folder (file-name-concat wrangle-repo "Charfixdata/SAPspool_20250710"))

)


(MPSgantt-setup)



 ;; (charfix-folder SAPspool-folder charfixed-folder) 

;; iterate on this file until its done

(setq plot-file "s:/CC Concurrence Workspace/HARRISDM/RM06analyst/MPSgantt/schedule_gantt.plt")


(cli-gnuplot-file-runner plot-file)





;; open in emacs (can probably be set to open in web browser)
(browse-url "file:///s:/CC%20Concurrence%20Workspace/HARRISDM/RM06analyst/MPSgantt/MPSgantt.svg")

;; open in emacs
(find-file "s:/CC Concurrence Workspace/HARRISDM/RM06analyst/MPSgantt/MPSgantt.svg")





(setq test1 "./test1.plt")

(cli-gnuplot-file-runner test1)






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
