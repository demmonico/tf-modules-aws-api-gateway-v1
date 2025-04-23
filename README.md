[![License](https://img.shields.io/github/license/demmonico/tf-modules-aws-api-gateway-v1)](LICENSE)
[![Tests](https://github.com/demmonico/tf-modules-aws-api-gateway-v1/actions/workflows/tests.yml/badge.svg)](https://github.com/demmonico/tf-modules-aws-api-gateway-v1/actions/workflows/tests.yml)
![GitHub Tag](https://img.shields.io/github/v/tag/demmonico/tf-modules-aws-api-gateway-v1)

# Terraform Modules Template

Bootstraps a new Terraform module repo.

## Usage

Lambda integration example:

```hcl
#...

module "apig" {
  source = "git::https://github.com/demmonico/tf-modules-aws-api-gateway-v1.git?ref=2.0.0"

  api_name   = local.lambda_name
  stage_name = local.env

  paths = [{
    path            = "/search/{id}"
    integration_uri = module.lambda.lambda_invoke_arn
  }]

  create_lambda_permissions    = true
  lambda_permission_names_list = [local.lambda_name]

  create_whitelist_api_resource_policy = true
  whitelist_ip_cidrs = [
    for p in data.aws_ec2_managed_prefix_list.internal_ips.entries : p.cidr
  ]

  create_custom_domain   = true
  custom_domain          = "${local.apig_subdomain}.${local.apig_root_domain}"
  custom_domain_cert_arn = data.aws_acm_certificate.this.arn
  custom_domain_zone_id  = data.aws_route53_zone.this.zone_id
}

#...
```

SQS integration example:

```hcl
# using integrations property (less verbose)
module "api_gateway" {
  source = "git::https://github.com/demmonico/tf-modules-aws-api-gateway-v1.git?ref=2.0.0"

  api_name = "my_api"
  stage_name = "staging"

  integrations = {
    "/example" = {
      "POST" = {
        uri         = "arn:aws:apigateway:${var.region}:sqs:path/${data.aws_caller_identity.current.account_id}/<YOUR_AWS_SQS_QUEUE_NAME>"
        type        = "AWS"
        credentials = "<YOUR_AWS_IAM_ROLE_ID>"
        "requestParameters" : {
          "integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'",
        }
        requestTemplates = {
          "application/json" = "Action=SendMessage&MessageBody=$input.body",
        }
        responses = {
          "default" = {
            statusCode = "200"
            responseTemplates = {
              "application/json" = {
                "message": "$input.path('$')"
              }
            }
            methodResponseContent = {
              "application/json" = {
                schema = {
                  type = "object"
                  properties = {
                    message = {
                      type = "string"
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

# using openapi_json property (more verbose, more control)
module "api_gateway" {
  source = "git::https://github.com/demmonico/tf-modules-aws-api-gateway-v1.git?ref=2.0.0"

  api_name   = "my_api"
  stage_name = "staging"

  openapi_json = jsonencode({
    info = {
      title   = "my_api"
      version = "1.0"
    }
    openapi = "3.0.1"
    paths = {
      "/example" = {
        post = {
          responses = {
            "200" = {
              content = {
                "application/json" = {
                  schema = {
                    properties = {
                      message = {
                        type = "string"
                      }
                    }
                    type = "object"
                  }
                }
              }
              description = "default"
            }
          }
          x-amazon-apigateway-integration = {
            credentials          = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/<YOUR_AWS_IAM_ROLE_ID>"
            httpMethod           = "POST"
            payloadFormatVersion = "2.0"
            requestParameters = {
              "integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'"
            }
            requestTemplates = {
              "application/json" = "Action=SendMessage&MessageBody=$input.body"
            }
            responses = {
              default = {
                responseTemplates = {
                  "application/json" = {
                    message = "$input.path('$')"
                  }
                }
                statusCode = "200"
              }
            }
            type = "AWS"
            uri  = "arn:aws:apigateway:${var.region}:sqs:path/${data.aws_caller_identity.current.account_id}/<YOUR_AWS_SQS_QUEUE_NAME>"
          }
        }
      }
    }
    x-amazon-apigateway-gateway-responses = {
      DEFAULT_4XX = {
        responseTemplates = {
          "application/json" = jsonencode(
            {
              message = "Access denied"
            }
          )
        }
        statusCode = "403"
      }
      MISSING_AUTHENTICATION_TOKEN = {
        responseTemplates = {
          "application/json" = jsonencode(
            {
              message = "Not found"
            }
          )
        }
        statusCode = "404"
      }
    }
  })
}
```

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
| [aws_api_gateway_method_settings.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_method_settings) | resource |
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
| <a name="input_apig_tags"></a> [apig\_tags](#input\_apig\_tags) | Tags to be applied to the API Gateway resource only | `map(string)` | `{}` | no |
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
| <a name="input_integrations"></a> [integrations](#input\_integrations) | API Gateway integration OpenAPI object. Example: {path: {http\_method: {<property\_name>: <property\_value>}}} | <pre>map(map(object({<br/>    uri                  = string<br/>    type                 = optional(string, "AWS_PROXY")<br/>    httpMethod           = optional(string, "POST") # integration method. For Lambda function invocations, the value must be POST.<br/>    payloadFormatVersion = optional(string, "2.0")<br/>    requestParameters    = optional(map(string))<br/>    requestTemplates     = optional(map(string))<br/>    responses = optional(map(object({<br/>      statusCode        = string<br/>      responseTemplates = optional(map(any))<br/>      methodResponseContent = optional(map(object({<br/>        schema = object({<br/>          type       = string<br/>          properties = optional(any)<br/>        })<br/>      })))<br/>    })))<br/><br/>    cacheKeyParameters  = optional(list(string))<br/>    cacheNamespace      = optional(string)<br/>    connectionId        = optional(string)<br/>    connectionType      = optional(string)<br/>    credentials         = optional(string)<br/>    contentHandling     = optional(string)<br/>    integrationSubtype  = optional(string)<br/>    passthroughBehavior = optional(string)<br/>    timeoutInMillis     = optional(number)<br/>    tlsConfig = optional(object({<br/>      insecureSkipVerification = optional(bool, true)<br/>      serverNameToVerify       = optional(string)<br/>    }))<br/>  })))</pre> | `{}` | no |
| <a name="input_lambda_permission_names_list"></a> [lambda\_permission\_names\_list](#input\_lambda\_permission\_names\_list) | n/a | `list(string)` | `[]` | no |
| <a name="input_openapi_json"></a> [openapi\_json](#input\_openapi\_json) | n/a | `string` | `null` | no |
| <a name="input_responses"></a> [responses](#input\_responses) | n/a | <pre>map(object({<br/>    statusCode        = string<br/>    responseTemplates = map(string)<br/>  }))</pre> | <pre>{<br/>  "DEFAULT_4XX": {<br/>    "responseTemplates": {<br/>      "application/json": "{\"message\": \"Access denied\"}"<br/>    },<br/>    "statusCode": "403"<br/>  },<br/>  "MISSING_AUTHENTICATION_TOKEN": {<br/>    "responseTemplates": {<br/>      "application/json": "{\"message\": \"Not found\"}"<br/>    },<br/>    "statusCode": "404"<br/>  }<br/>}</pre> | no |
| <a name="input_stage_cache_enabled"></a> [stage\_cache\_enabled](#input\_stage\_cache\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_stage_method_settings"></a> [stage\_method\_settings](#input\_stage\_method\_settings) | n/a | <pre>map(object({<br/>    caching_enabled      = optional(bool, false)<br/>    cache_data_encrypted = optional(bool, true)<br/>    metrics_enabled      = optional(bool, false)<br/>    logging_level        = optional(string, "OFF")<br/>    method_path          = optional(string, "*/*")<br/>    data_trace_enabled   = optional(bool, false)<br/>    throttling_burst     = optional(number, -1)<br/>    throttling_rate      = optional(number, -1)<br/>  }))</pre> | `{}` | no |
| <a name="input_stage_name"></a> [stage\_name](#input\_stage\_name) | n/a | `string` | n/a | yes |
| <a name="input_stage_tags"></a> [stage\_tags](#input\_stage\_tags) | Tags to be applied to the API Gateway stage resource only | `map(string)` | `{}` | no |
| <a name="input_stage_xray_tracing_enabled"></a> [stage\_xray\_tracing\_enabled](#input\_stage\_xray\_tracing\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to all resources | `map(string)` | `{}` | no |
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
