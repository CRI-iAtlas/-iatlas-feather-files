devtools::load_all(devtools::as.package(".")$path)
require(rlang)
require(magrittr)

cat(crayon::blue("SUCCESS: iatlas.data package loaded and ready to go.\n"))
cat(crayon::blue("For more info, open README.md\n"))
