on_exit <- function(expr, env = parent.frame()) {
  args <- list(
    substitute(expr),
    add = TRUE,
    after = FALSE
  )
  do.call("on.exit", args, envir = env)
}

obj_address <- function(x) {
  .Call(ffi_obj_address, x)
}
