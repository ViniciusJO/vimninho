; ((comment_content) @_command (#match? @_command "^[ \n\r-]*:[^!]")) @vim
; ((comment_content) @_bash_command (#match? @_bash_command "^[ \n\r-]*(:?)!")) @bash
; ((comment_content) @injection.content (#match? @injection.content "^[ \n\r-]*:[^!]") (#set! injection.language "bash"))
((comment_content) @injection.content (#match? @injection.content "^[ \n\r-]*(:|!|:!)") (#set! injection.language "bash"))
