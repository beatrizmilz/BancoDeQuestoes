conectar_sql <- function() {
  con <- DBI::dbConnect(
    RPostgres::Postgres(),
    user = "postgres",
    host = "suddenly-big-reindeer.data-1.use1.tembo.io",
    port = 5432,
    password = Sys.getenv("SQL_TEMBO_PASSWORD")
  )

  con
}
