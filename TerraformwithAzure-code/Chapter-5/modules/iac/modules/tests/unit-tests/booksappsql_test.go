package integrationtests

import (
    "os"
    "testing"
    "fmt"
    "strings"
    "github.com/gruntwork-io/terratest/modules/random"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)
func TestResourceGroupAndSQLServer(t *testing.T) {
	// Setting resource group configuration, including name and rg_identifier
    // the subscriptionId, clientId, Client_secret and tenantId is not hard-coded in script. Rather it is read as environmental variable
    resourceGroupName := random.UniqueId()
    subscriptionID := os.Getenv("SUBSCRIPTION_ID")
    resourceGroupId := fmt.Sprintf("/subscriptions/%s/resourceGroups/%s", subscriptionID,resourceGroupName)
	terraformOptions := &terraform.Options{
        TerraformDir: "../../fixtures/groups",

        // Variables to pass to our Terraform code using -var options
        Vars: map[string]interface{}{
            "resourceGroupName":     resourceGroupName,
            "resourceGroupLocation": "west europe",
            "resourceGroupTags": map[string]string{
                "owner":       "ritesh",
                "environment": "development",
            },
        },
    }

    defer terraform.Destroy(t, terraformOptions)

    terraform.InitAndApply(t, terraformOptions)

    rgname := terraform.Output(t, terraformOptions, "resourceGroupName")
    rgIdentifier := terraform.Output(t, terraformOptions, "resourceGroupIdentifier")

    assert.Equal(t, resourceGroupName, rgname)
	assert.Equal(t, resourceGroupId, rgIdentifier)

    
    sql_server_name := strings.ToLower( fmt.Sprintf("%s%s", random.UniqueId(),random.UniqueId()))
    sqlid := fmt.Sprintf("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Sql/servers/%s", subscriptionID, resourceGroupName, sql_server_name)

    sqlfqdn := fmt.Sprintf("%s.database.windows.net", sql_server_name)

    admin_name := fmt.Sprintf("%s%s", random.UniqueId(),random.UniqueId())    
    password := fmt.Sprintf("%s%s", random.UniqueId(),random.UniqueId())
    database_name := random.UniqueId()

    terraformOptions1 := &terraform.Options{

        TerraformDir: "../../fixtures/sqlserver",

        Vars: map[string]interface{}{
            "whitelist_ip_addresses":      []string{"0.0.0.0/32"},
            "sql_server_name":     sql_server_name,
            "admin_username":    admin_name,
            "admin_password": password,
            "database_name":        database_name,
            "resourceGroupName":      rgname,
            "location":               "west europe",
            "sql_tags": map[string]string{
                "owner":       "ritesh",
                "environment": "development",
            },
        },
    }

    // This will cleanup all resources provisioned as part of test as final step
    defer terraform.Destroy(t, terraformOptions1)

    // This will init and plan the resources and fail the test if there are any errors
    terraform.InitAndPlan(t, terraformOptions1)

    // This will apply the resources and fail the test if there are any errors
    terraform.Apply(t, terraformOptions1)

    // This will pull output values generated as part of Terraform script execution
    sql_server_id := terraform.OutputRequired(t, terraformOptions1, "sql_server_id")
    sql_server_fqdn := terraform.Output(t, terraformOptions1, "sql_server_fqdn")
    sql_databases_id := terraform.Output(t, terraformOptions1, "sql_databases_id")

    // Comparing the actual and expected values. Fail is they do not match
    assert.Equal(t, sqlid, sql_server_id)
    assert.Equal(t, sqlfqdn, sql_server_fqdn)
    
    assert.NotEmpty(t, sql_databases_id)
    assert.Regexp(t, database_name, sql_databases_id) 


	

}
