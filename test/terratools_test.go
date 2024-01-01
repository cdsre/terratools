package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/docker"
	"github.com/stretchr/testify/assert"
)

// Ensure we are using the latest version on the MPL 2.0 licence. We need to ensure we don't upgrade beyond these versions
func TestHashicorpVersion(t *testing.T) {
	for product, version := range map[string]string{
		"Terraform": "v1.5.5",
		"Vault":     "v1.14.1",
	} {
		t.Run(product, func(t *testing.T) {
			t.Parallel()
			tag := "cdsre/terratools:test"
			productCommand := strings.ToLower(product)

			buildOptions := &docker.BuildOptions{
				Tags: []string{tag},
			}
			docker.Build(t, "../", buildOptions)

			opts := &docker.RunOptions{Command: []string{productCommand, "--version"}}
			output := docker.Run(t, tag, opts)

			expectedVersion := fmt.Sprintf("%s %s", product, version)
			assert.Contains(t, output, expectedVersion)
		})
	}

}
