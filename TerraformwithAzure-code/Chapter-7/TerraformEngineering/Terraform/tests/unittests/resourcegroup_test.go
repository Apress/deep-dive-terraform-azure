package unittests

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

func TestResourceGroup(t *testing.T) {
	t.Parallel()



	//generate random resource names
	rgname := fmt.Sprintf("%s", strings.ToLower(random.UniqueId()))

	terraformOptions := &terraform.Options{
		// Folder path to the Terraform script
		TerraformDir: "../fixtures/resourcegroup",

		// Variables needed by Terraform script
		Vars: map[string]interface{}{
			"resource_group_location": "westeurope",
			"resource_group_name":     rgname,
			"client_id":               *client_id,
			"tenant_id":               *tenant_id,
			"subscription_id":         *subscription_id,
			"client_secret":           *client_secret,
		},

		// retry configuration
		MaxRetries:         5,
		TimeBetweenRetries: 60 * time.Second,
		RetryableTerraformErrors: map[string]string{
			"HTTP REQUEST": "Unable to reach Azure cloud provider",
		},
	}

	// tear down the resource after the test is complete
	defer terraform.Destroy(t, terraformOptions)

	// initialize and apply the terraform script under test
	terraform.InitAndApply(t, terraformOptions)

	// capture the output from terraform execution

	resource_group_id := terraform.Output(t, terraformOptions, "resource_group_id")
	resource_group_location := terraform.Output(t, terraformOptions, "resource_group_location")

	// assert and check for expected and actual values. Fails if they do not match
	assert.Equal(t, "westeurope", resource_group_location)
	assert.Equal(t, fmt.Sprintf("/subscriptions/%s/resourceGroups/%s", *subscription_id, rgname), resource_group_id)

}



