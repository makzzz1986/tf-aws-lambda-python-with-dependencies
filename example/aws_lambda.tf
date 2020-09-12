module lambda_python_w_deps {
  source           = "github.com/makzzz1986/tf-aws-lambda-python-with-dependencies"
  script_path      = "${path.module}/files/helloworld.py"
  pip_dependencies = ["pyfiglet==0.8.post1"]
}


resource aws_lambda_function hello_world {
  filename         = module.lambda_python_w_deps.package_path
  function_name    = "hello_world_dependencies"
  role             = aws_iam_role.lambdas_at_edge.arn
  description      = "Lambda for testing dependencies"
  handler          = "${module.lambda_python_w_deps.handler_file_name}.handler"
  source_code_hash = module.lambda_python_w_deps.package_sha
  runtime          = "python3.8"
  timeout          = 120
  publish          = true

  tags = var.tags
}