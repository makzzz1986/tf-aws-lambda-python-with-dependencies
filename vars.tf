variable script_path {
  default = ""
}

# don't put boto3 inside: you have boto3 in Lambda python env
# you have a limit of 5MB package!
variable pip_dependencies {
  default = [] 
}

variable temp_package_folder {
  default = "/tmp/python_lambda_package"
}

variable package_path {
  default = "/tmp/package.zip"
}
