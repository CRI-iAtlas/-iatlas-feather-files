get_clinical_enum <- function(){
  return(c("ethnicity", "gender", "race"))
}

get_gender_enum <- function(){
  return(c("female", "male"))
}

get_ethnicity_enum <- function(){
  return(c("not hispanic or latino", "hispanic or latino"))
}

get_race_enum <- function(){
  return(c(
    c(
      "white",
      "black or african american",
      "asian",
      "native hawaiian or other pacific islander",
      "american indian or alaska native"
    )
  ))
}
