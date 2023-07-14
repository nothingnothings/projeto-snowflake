






COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_error_example

    file_format=(type=csv,
    field_delimiter=',',
    skip_header=1
    )
    ON_ERROR='CONTINUE';