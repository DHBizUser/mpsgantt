;; -*- lexical-binding: t; -*-
;; 2025-07-09
;; Authored by David Harris



;; Snippets to develop and compile this project. Its part of my general deployment workflow that depends on some lisp outside this project. Similar to a makefile.

;; this file is meant to be opened in an emacs buffer and expressions evaluated as needed, not in strict order.


;; all the other files in the repo are the bricks. This is the mortar.




;;  process to run the report --> timed it at  15:24.91  --- on 2025-07-18
;; this is with no hiccups -- some manual steps arranging the source data and directing the scripts to the correct locations on disk.


🌭🌭🌭🌭🌭🌭🌭🌭🌭🌭🌭🌭🌭
TODO:

- create a SQL test to catch a new or missed work center that came up on CM01 but isnt in the WorkCenter table on test-cm01-data.db
   if new Work Centers are created in the system, will SAPgrab.vbs pull them in?

- make the x axis major tics in one-month intervals with darker grid lines and labels for every month.
    Try iso week interval for minor tics, unlabeled

- verify WorkCenter table classification with SME

- classify the requirement types with colors to distinguish firm and forecast. using an index in the SQL.

- ?? map the BOMreport paths to the CM01 schedule [order, material, or line level?] and try to show those relationships in the plot.

- establish a benchmark chart that aligns to the month commitment process. Measure movement off of that using a simple animation or swipe
   mechanism

- write a .bat file or powershell script to run the whole pull-down and update process with less fiddling.



🌭🌭🌭🌭🌭🌭🌭🌭🌭🌭🌭🌭🌭



(defun MPSgantt-setup ()
  "load the lisp to get emacs to understand all the context we need from outside this repo about our computing environment"
  (load-file "../env_config/env_config.el")

  (load-file "../env_config/gnuplot-helper-lisp.el")
  (load-file "../env_config/sqlite-helper-lisp.el")  
  (load-file "../SAPdata/code/charfix.el")
  (setq wrangle-repo "../SAPdata/"
        SAPspool-folder (file-name-concat wrangle-repo "UnprocessedData/SAPspool_20250718")
        charfixed-folder (file-name-concat wrangle-repo "Charfixdata/SAPspool_20250718"))
(mkdir SAPspool-folder)
)


(MPSgantt-setup)






(setq plot-file "./CM01-mps.plt"

      project-DB "./test-cm01-data.db"

      project-sql "./CM01_RCCP.sql")




(cli-gnuplot-file-runner plot-file)







;; run CM01 and VL06F and send the output to the SAP spooler. I wrote a vbscript called SAPgrab to do this
;; the other reports are set to a schedule.

(async-shell-command "\"C:/Windows/System32/wscript.exe\" \"../SAPdata/code/SAPgrab.vbs\"")


;; manually download spool data from SP02 and move it into the unprocessed data folder, then run charfix

(charfix-folder SAPspool-folder charfixed-folder)





(cli-sqlite-file-runner project-DB project-sql)


(open-in-sqlite-browser project-DB)





;; open in web browser
(browse-url-of-file "CM01-mps.svg")

(browse-url-of-file "test-print.txt")   ;opens in notepad on windows
(browse-url "test-print.txt")   ;opens in notepad on windows

;; open in emacs
(find-file "s:/CC Concurrence Workspace/HARRISDM/RM06analyst/MPSgantt/MPSgantt.svg")

(browse-url "file:///s:/CC%20Concurrence%20Workspace/HARRISDM/RM06analyst/mpsgantt/test-print.txt")








;; git version control operations -- keeps a record of changes and keeps the project tidy & portable

(shell-command "git init")


(shell-command "git add .")

(shell-command "git status")

(shell-command "git commit -m \"working prototype\"")



(shell-command "git push origin")

(shell-command "git remote -v")


(shell-command "git config --local user.name RM06analyst")

(shell-command "git config --local user.email ******")





;; gnuplot manual
(browse-url "c:/Users/harrisdm/DataTools/programs/gnuplot/docs/gnuplot.pdf")

;; vectors pg 95
;; table pg 223
