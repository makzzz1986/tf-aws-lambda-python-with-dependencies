# tf-aws-lambda-python-dependencies

Terraform module for packaging Python script and it's dependecies to one zip file for aws_lambda_function

> NOTE: works for python3.8 pip only because of Atlantis image

## Example

```
module lambda_dep {
  source           = "git::ssh://git@mygitlab.org/tf-aws-lambda-python-dependencies"
  script_path      = "${path.module}/files/helloworld.py"
  pip_dependencies = ["zipfile36==0.1.3"]
}


resource aws_lambda_function test_lambda {
  filename         = module.lambda_dep.package_path
  function_name    = "lambda-python-deps"
  role             = aws_iam_role.lambdas_at_edge.arn
  description      = "Lambda for testing dependencies"
  handler          = "${module.lambda_dep.handler_file_name}.handler"
  source_code_hash = module.lambda_dep.package_sha
  runtime          = "python3.8"
  timeout          = 120
  publish          = true

  tags = var.tags
}
```

## Inputs

| Variable | Description | Type | Default | Required |
|---|---|---|---|---|
| script_path | Path to your script relative to Terraform entrypoint | string | - | Yes |
| pip_dependencies | List of dependencies in pip3 format, better use with locked version | list | - | Yes |
| temp_package_folder | Folder for building your package | string | `/tmp/python_lambda_package` | No |
| package_path  | In case you want to specify zip filename | string | `package.zip` | No |

## Outputs

| Name | Description |
|------|-------------|
| package_path | Path of zipped package, use it for aws_lambda_function.filename |
| package_sha | Changes control, use it for aws_lambda_function.source_code_hash |
| handler_file_name | Stripped to filename of you script, you can use it for the first part of aws_lambda_function.handler, don't forget to provide function name after that! | 