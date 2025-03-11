[![License](https://img.shields.io/github/license/demmonico/tf-modules-aws-api-gateway-v1)](LICENSE)
[![Tests](https://github.com/demmonico/tf-modules-aws-api-gateway-v1/actions/workflows/tests.yml/badge.svg)](https://github.com/demmonico/tf-modules-aws-api-gateway-v1/actions/workflows/tests.yml)
![GitHub Tag](https://img.shields.io/github/v/tag/demmonico/tf-modules-aws-api-gateway-v1)

# Terraform Modules Template

Bootstraps a new Terraform module repo.

## Usage

TODO add examples here

## Development

Steps:
- run `make init` to initialize the repo and hooks (see [Initialize the repo](#initialize-the-repo) section)

### Initialize the repo

```shell
make init
```


### Run tests

It triggers git pre-commit hooks

```shell
make test
```


# Auto-generated specs

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_base_path_mapping.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_base_path_mapping) | resource |
| [aws_api_gateway_deployment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_domain_name.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_domain_name) | resource |
| [aws_api_gateway_rest_api.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) | resource |
| [aws_api_gateway_rest_api_policy.extra](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api_policy) | resource |
| [aws_api_gateway_rest_api_policy.internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api_policy) | resource |
| [aws_api_gateway_stage.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage) | resource |
| [aws_cloudwatch_log_group.access_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_lambda_permission.lambda_perm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_iam_policy_document.internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_endpoint_type"></a> [api\_endpoint\_type](#input\_api\_endpoint\_type) | n/a | `string` | `"REGIONAL"` | no |
| <a name="input_api_name"></a> [api\_name](#input\_api\_name) | n/a | `string` | n/a | yes |
| <a name="input_attach_iam_policies"></a> [attach\_iam\_policies](#input\_attach\_iam\_policies) | List of extra IAM policies to be attached to the role | `list(string)` | `[]` | no |
| <a name="input_create_custom_domain"></a> [create\_custom\_domain](#input\_create\_custom\_domain) | n/a | `bool` | `false` | no |
| <a name="input_create_cw_log_group"></a> [create\_cw\_log\_group](#input\_create\_cw\_log\_group) | n/a | `bool` | `true` | no |
| <a name="input_create_lambda_permissions"></a> [create\_lambda\_permissions](#input\_create\_lambda\_permissions) | n/a | `bool` | `false` | no |
| <a name="input_create_whitelist_api_resource_policy"></a> [create\_whitelist\_api\_resource\_policy](#input\_create\_whitelist\_api\_resource\_policy) | n/a | `bool` | `false` | no |
| <a name="input_custom_domain"></a> [custom\_domain](#input\_custom\_domain) | n/a | `string` | `""` | no |
| <a name="input_custom_domain_cert_arn"></a> [custom\_domain\_cert\_arn](#input\_custom\_domain\_cert\_arn) | n/a | `string` | `""` | no |
| <a name="input_custom_domain_endpoint_type"></a> [custom\_domain\_endpoint\_type](#input\_custom\_domain\_endpoint\_type) | n/a | `string` | `"REGIONAL"` | no |
| <a name="input_custom_domain_security_policy"></a> [custom\_domain\_security\_policy](#input\_custom\_domain\_security\_policy) | n/a | `string` | `"TLS_1_2"` | no |
| <a name="input_custom_domain_zone_id"></a> [custom\_domain\_zone\_id](#input\_custom\_domain\_zone\_id) | n/a | `string` | `""` | no |
| <a name="input_cw_log_group_arn"></a> [cw\_log\_group\_arn](#input\_cw\_log\_group\_arn) | This is used only for existing log groups, thus 'create\_cw\_log\_group' should be 'false' | `string` | `""` | no |
| <a name="input_cw_log_group_name"></a> [cw\_log\_group\_name](#input\_cw\_log\_group\_name) | This is used only for new log group creation, thus 'create\_cw\_log\_group' should be 'true' | `string` | `""` | no |
| <a name="input_cw_logs_enabled"></a> [cw\_logs\_enabled](#input\_cw\_logs\_enabled) | n/a | `bool` | `true` | no |
| <a name="input_cw_logs_format"></a> [cw\_logs\_format](#input\_cw\_logs\_format) | n/a | `map(string)` | <pre>{<br/>  "caller": "$context.identity.caller",<br/>  "errorMessage": "$context.error.messageString",<br/>  "extendedRequestId": "$context.extendedRequestId",<br/>  "httpMethod": "$context.httpMethod",<br/>  "ip": "$context.identity.sourceIp",<br/>  "protocol": "$context.protocol",<br/>  "requestId": "$context.requestId",<br/>  "requestTime": "$context.requestTime",<br/>  "resourcePath": "$context.resourcePath",<br/>  "responseLength": "$context.responseLength",<br/>  "status": "$context.status",<br/>  "user": "$context.identity.user"<br/>}</pre> | no |
| <a name="input_cw_logs_retention"></a> [cw\_logs\_retention](#input\_cw\_logs\_retention) | CW logs retention in days | `number` | `7` | no |
| <a name="input_gateway_responses"></a> [gateway\_responses](#input\_gateway\_responses) | n/a | <pre>list(object({<br/>    key         = string<br/>    status_code = string<br/>    templates   = map(string)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "key": "DEFAULT_4XX",<br/>    "status_code": "403",<br/>    "templates": {<br/>      "application/json": "{\"message\": \"Access denied\"}"<br/>    }<br/>  },<br/>  {<br/>    "key": "MISSING_AUTHENTICATION_TOKEN",<br/>    "status_code": "404",<br/>    "templates": {<br/>      "application/json": "{\"message\": \"Not found\"}"<br/>    }<br/>  }<br/>]</pre> | no |
| <a name="input_lambda_permission_names_list"></a> [lambda\_permission\_names\_list](#input\_lambda\_permission\_names\_list) | n/a | `list(string)` | `[]` | no |
| <a name="input_paths"></a> [paths](#input\_paths) | n/a | <pre>list(object({<br/>    path               = string<br/>    http_method        = optional(string)<br/>    integration_uri    = string<br/>    integration_type   = optional(string)<br/>    integration_method = optional(string)<br/>    payload_version    = optional(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_stage_name"></a> [stage\_name](#input\_stage\_name) | n/a | `string` | n/a | yes |
| <a name="input_whitelist_ip_cidrs"></a> [whitelist\_ip\_cidrs](#input\_whitelist\_ip\_cidrs) | n/a | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_apig_arn"></a> [apig\_arn](#output\_apig\_arn) | n/a |
| <a name="output_apig_execution_arn"></a> [apig\_execution\_arn](#output\_apig\_execution\_arn) | n/a |
| <a name="output_apig_id"></a> [apig\_id](#output\_apig\_id) | n/a |
| <a name="output_cw_log_group_name"></a> [cw\_log\_group\_name](#output\_cw\_log\_group\_name) | n/a |
| <a name="output_deployment_id"></a> [deployment\_id](#output\_deployment\_id) | n/a |
| <a name="output_deployment_invoke_url"></a> [deployment\_invoke\_url](#output\_deployment\_invoke\_url) | n/a |
| <a name="output_iam_lambda_permissions"></a> [iam\_lambda\_permissions](#output\_iam\_lambda\_permissions) | n/a |
| <a name="output_stage_execution_arn"></a> [stage\_execution\_arn](#output\_stage\_execution\_arn) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
