# Preparing the folder full of dependencies and your script
resource null_resource packaging {
  # trigers only if your script or list of dependencies were changed
  triggers = {
    dependencies = join(" ", var.pip_dependencies)
    script_sha1  = sha1(file(var.script_path))
  }

  # clean the folder
  provisioner local-exec {
    command = "rm -rf /tmp/${var.temp_package_folder}"
  }

  # recreate the folder
  provisioner local-exec {
    command = "mkdir /tmp/${var.temp_package_folder}"
  }

  # install dependencies to the folder
  provisioner local-exec {
    command = "pip3 install ${join(" ", var.pip_dependencies)} --target /tmp/${var.temp_package_folder}"
  }

  # copy your script to the folder
  provisioner local-exec {
    command = "cp ${var.script_path} /tmp/${var.temp_package_folder}/"
  }
}

# this resource we need to turn explicit dependencies (which Terraform couldn't check) to
# implicit dependencies (which Terraform can control and check difference)
# for more information, take a look: https://github.com/hashicorp/terraform-provider-archive/issues/11
data null_data_source packaging_changes {
  inputs = {
    null_id      = null_resource.packaging.id
    package_path = var.package_filename
  }
}

# zipping all the folder!
data archive_file package {
  type        = "zip"
  source_dir  = "/tmp/${var.temp_package_folder}"
  output_path = data.null_data_source.packaging_changes.outputs["package_path"]
}
