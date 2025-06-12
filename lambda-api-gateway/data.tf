data "archive_file" "lambda_hello" {
  type = "zip"

  source_dir  = "${path.module}/hello"
  output_path = "${path.module}/hello.zip"
}
