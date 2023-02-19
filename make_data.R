library(arrow)
copy_files(
    s3_bucket("metill/metill_db/opnir_reikningar/"),
    "Data/"
)
