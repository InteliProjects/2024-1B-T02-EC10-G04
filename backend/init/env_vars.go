package init

import (
	"fmt"
	"os"
)

func VerifyEnvs(vars ...string) error {
	if len(vars) == 0 {
		return fmt.Errorf("No vars provided to check")
	}

	for _, env := range vars {
		value := os.Getenv(env)

		if value == "" {
			return fmt.Errorf("Env variable: %s not set", env)
		}
	}

	return nil
}
