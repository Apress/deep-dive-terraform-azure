package basictests

import (
	"fmt"
	"math/rand"
	"os"
	"testing"
	"time"
	
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

const charset = "abcdefghijklmnopqrstuvwxyz0123456789"
const complexcharset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

var seededRand *rand.Rand = rand.New(rand.NewSource(time.Now().UnixNano()))

func TestResourceGroup(t *testing.T) {

	resourceGroupName := random.UniqueId()
	subscriptionID := os.Getenv("SUBSCRIPTION_ID")
	//resourceGroupId := fmt.Sprintf("/subscriptions/%s/resourceGroups/%s", subscriptionID, resourceGroupName)

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
	//rgIdentifier := terraform.Output(t, terraformOptions, "resourceGroupIdentifier")

	sql_server_name := StringWithCharset(20, charset)
	//sql_server_name := random.UniqueId()
	sqlid := fmt.Sprintf("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Sql/servers/%s", subscriptionID, resourceGroupName, sql_server_name)

	sqlfqdn := fmt.Sprintf("%s.database.windows.net", sql_server_name)

	//admin_name := StringWithCharset(20, complexcharset)
	//password := StringWithCharset(20, complexcharset)
	database_name := []string{random.UniqueId(), random.UniqueId()}

	terraformOptions1 := &terraform.Options{

		TerraformDir: "../../fixtures/sqlserver",

		Vars: map[string]interface{}{
			"server_version":         "12.0",
			"allowed_cidr_list":      []string{"0.0.0.0/32"},
			"server_custom_name":     sql_server_name,
			//"administrator_login":    admin_name,
		//	"administrator_password": password,
			"key_vault_name": "ritcosmoskey",
			"key_vault_rg": "ritcosmos-rg-cosmos",
			"databases_names":        database_name,
			"databases_collation":    "SQL_LATIN1_GENERAL_CP1_CI_AS",
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
	sql_databases_id := terraform.OutputList(t, terraformOptions1, "sql_databases_id")
	//default_administrator_databases_connection_strings := terraform.OutputListOfObjects(t, terraformOptions1, "default_administrator_databases_connection_strings")
	//db_details := terraform.OutputMap(t, terraformOptions1, "db_details")

	// Comparing the actual and expected values. Fail is they do not match
	assert.Equal(t, sqlid, sql_server_id)
	assert.Equal(t, sqlfqdn, sql_server_fqdn)

	assert.Len(t, sql_databases_id, 2)
	//assert.Contains(t,[]string{database_name[0]} , sql_databases_id)
	//assert.Contains(t,[]string{database_name[1]} , sql_databases_id)
	//assert.ElementsMatch(t, database_name, sql_databases_id)
	assert.NotEmpty(t, sql_databases_id)
	assert.Regexp(t, []string{database_name[0]}, sql_databases_id) 
	assert.Regexp(t, []string{database_name[1]}, sql_databases_id)
}

func StringWithCharset(length int, charset string) string {
	b := make([]byte, length)
	for i := range b {
		b[i] = charset[seededRand.Intn(len(charset))]
	}
	return string(b)
}
