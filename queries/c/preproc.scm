;; extends

(_
  (preproc_call
    directive: _ @dir_1
    argument: _ @arg_1
    (#eq? @dir_1 "#pragma")
    (#match? @arg_1 "^region")
    ) @fold
  .
  _ @fold
  _? @fold
  .
  (preproc_call
    directive: _ @dir_2
    argument: _ @arg_2
    (#eq? @dir_2 "#pragma")
    (#match? @arg_2 "^endregion")
    ) @fold
)


