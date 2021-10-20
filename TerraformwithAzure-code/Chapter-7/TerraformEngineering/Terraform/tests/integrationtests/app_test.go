package integrationtests

import (
	"fmt"

	"flag"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

		// get subscription id from command line
		var subscription_id = flag.String("subscription_id", "Xxx", "Azure subscription id")
		var client_id = flag.String("client_id", "Xxx", "Service Principal  id")
		var tenant_id = flag.String("tenant_id", "Xxx", "Azure tenant id")
		var client_secret = flag.String("client_secret", "Xxx", "Service Principal client secret")
		var state_resource_group = flag.String("state_resource_group", "Xxx", "storage account resource group name")
		var state_storage_account = flag.String("state_storage_account", "Xxx", "storage account name for storing terraform state")
		var state_storage_container = flag.String("state_storage_container", "Xxx", "Container name for storing terraform state")
		var state_file_name = flag.String("state_file_name", "Xxx", "Terraform state file name")
		var state_sas_token = flag.String("state_sas_token", "Xxx", "storage account SAS token")


func TestResourceGroup(t *testing.T) {
	t.Parallel()


	
	//generate random resource names
	rgname := fmt.Sprintf("%s", strings.ToLower(random.UniqueId()))
	storagename := fmt.Sprintf("%s", strings.ToLower(random.UniqueId()))

	terraformOptions := &terraform.Options{
		// Folder path to the Terraform script
		TerraformDir: "../../development",

		// Variables needed by Terraform script
		Vars: map[string]interface{}{
			"resource_group_location": "westeurope",
			"resource_group_name":     rgname,
			"client_id":               *client_id,
			"tenant_id":               *tenant_id,
			"subscription_id":         *subscription_id,
			"client_secret":           *client_secret,
			"storage_account_name": 	storagename,
		},

		// retry configuration
		MaxRetries:         5,
		TimeBetweenRetries: 60 * time.Second,
		RetryableTerraformErrors: map[string]string{
			"HTTP REQUEST": "Unable to reach Azure cloud provider",
		},
		BackendConfig: map[string]interface{}{
			"resource_group_name":  *state_resource_group,
			"storage_account_name": *state_storage_account,
			"container_name":       *state_storage_container,
			"key":                  *state_file_name,
			"sas_token":            *state_sas_token,
			},

	}

	// tear down the resource after the test is complete
	defer terraform.Destroy(t, terraformOptions)

	// initialize and apply the terraform script under test
	terraform.InitAndApply(t, terraformOptions)

	// capture the output from terraform execution
	storage_location := terraform.Output(t, terraformOptions, "storage_location")
	resource_group_id := terraform.Output(t, terraformOptions, "resource_group_id")
	resource_group_location := terraform.Output(t, terraformOptions, "resource_group_location")

	// assert and check for expected and actual values. Fails if they do not match

	assert.Equal(t, "westeurope", resource_group_location)
	assert.Equal(t, "westeurope", storage_location)
	assert.Equal(t, fmt.Sprintf("/subscriptions/%s/resourceGroups/%s", *subscription_id, rgname), resource_group_id)

}



