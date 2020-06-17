devtools::load_all(devtools::as.package(".")$path)

if (interactive()) {
  suppressMessages(require(devtools))
  suppressMessages(require(testthat))
}

cat(crayon::blue("SUCCESS: iatlas.data package loaded and ready to go.\n"))
cat(crayon::blue("For more info, open README.md\n"))
