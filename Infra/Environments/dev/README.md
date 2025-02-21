<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecr"></a> [ecr](#module\_ecr) | ../../Modules/ECR | n/a |
| <a name="module_iam"></a> [iam](#module\_iam) | ../../Modules/IAM | n/a |
| <a name="module_lamda"></a> [lamda](#module\_lamda) | ../../Modules/LAMDA | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | The URL of the Hello-World service Docker image in ECR | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->