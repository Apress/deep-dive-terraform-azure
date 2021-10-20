package basictests

import (
	"fmt"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestResourceGroup(t *testing.T) {

	// Setting resource group configuration, including name and rg_identifier
	// the subscriptionId is not hard-coded in script. Rather it is read as environmental variable
	state_rgname := os.Getenv("STATE_RGNAME")
	state_storagename := os.Getenv("STATE_STORAGENAME")
	state_containername := os.Getenv("STATE_CONTAINERNAME")
	state_filename := os.Getenv("STATE_FILENAME")
	state_accesskey := os.Getenv("STATE_ACCESS_KEY")
	resourceGroupName := random.UniqueId()
	subscriptionID := os.Getenv("SUBSCRIPTION_ID")
	clientID := os.Getenv("Client_ID")
	tenantID := os.Getenv("Tenant_ID")
	clientSecret := os.Getenv("Client_Secret")
	resourceGroupId := fmt.Sprintf("/subscriptions/%s/resourceGroups/%s", subscriptionID, resourceGroupName)

	// Terraform configuration used for the test. This helps in generating the Terraform command
	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../fixtures",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"rg_name":  resourceGroupName,
			"location": "west europe",
			"client_id" : clientID,
			"client_secret" : clientSecret,
			"subscription_id" : subscriptionID,
			"tenant_id": tenantID,
		},

		BackendConfig: map[string]interface{}{
            "resource_group_name":  state_rgname,
            "storage_account_name": state_storagename,
            "container_name":       state_containername,
            "key":                  state_filename,


        },

        EnvVars: map[string]string{
            "ARM_ACCESS_KEY": state_accesskey,
        },
	}

	// This will cleanup all resources provisioned as part of test as final step
	defer terraform.Destroy(t, terraformOptions)

	// This will init and plan the resources and fail the test if there are any errors
	terraform.InitAndPlan(t, terraformOptions)

	// This will apply the resources and fail the test if there are any errors
	terraform.Apply(t, terraformOptions)

	// This will pull output values generated as part of Terraform script execution
	rg_identifier := terraform.Output(t, terraformOptions, "rg_identifier")
	rg_id := terraform.Output(t, terraformOptions, "rg_id")
	all_resource_groups := terraform.OutputListOfObjects(t, terraformOptions, "all_resource_groups")

	// Comparing the actual and expected values. Fail is they do not match
	assert.Equal(t, resourceGroupName, rg_identifier)
	assert.Equal(t, resourceGroupId, rg_id)

	assert.Equal(t, "RGCount-0", all_resource_groups[0]["name"])

}
