package middleware

import (
	"errors"
	"log"
	"net/http"
	"os"
	"strings"

	"fmt"
	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/domain/entity"
	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v4"
)

const (
	ErrAuthorizationRequired = "authorization header is required"
	ErrInvalidTokenFormat    = "invalid token format"
	ErrInvalidToken          = "invalid token"
	ErrInternalServer        = "internal server error"
	ErrUserNotFound          = "user not found"
	ErrNoPermission          = "you don't have permission to access this route"
	JWTSecretKeyEnv          = "JWT_SECRET_KEY"
	BearerPrefix             = "Bearer "
)

func AuthMiddleware(userRepository entity.UserRepository, requiredRoles []string) gin.HandlerFunc {
	return func(c *gin.Context) {
		tokenString, err := getTokenFromHeader(c)
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
			c.Abort()
			return
		}

		claims, err := parseToken(tokenString)
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": ErrInvalidToken})
			c.Abort()
			return
		}

		user, err := userRepository.FindUserById(claims.Subject)
		if err != nil || user == nil {
			handleUserError(c, err)
			return
		}
		fmt.Println("user.Role: ", user.Role)
		fmt.Println("requiredRoles: ", requiredRoles)

		roleAuthorized := false
		for _, role := range requiredRoles {
			if user.Role == role {
				roleAuthorized = true
				break
			}
		}

		if !roleAuthorized {
			c.JSON(http.StatusForbidden, gin.H{"error": ErrNoPermission})
			c.Abort()
			return
		}

		c.Set("userID", user.ID)
		c.Next()
	}
}

func getTokenFromHeader(c *gin.Context) (string, error) {
	tokenHeader := c.GetHeader("Authorization")
	if tokenHeader == "" {
		return "", errors.New(ErrAuthorizationRequired)
	}

	splitToken := strings.Split(tokenHeader, BearerPrefix)
	if len(splitToken) != 2 {
		return "", errors.New(ErrInvalidTokenFormat)
	}

	return splitToken[1], nil
}

func parseToken(tokenString string) (*jwt.RegisteredClaims, error) {
	token, err := jwt.ParseWithClaims(tokenString, &jwt.RegisteredClaims{}, func(token *jwt.Token) (interface{}, error) {
		return []byte(os.Getenv(JWTSecretKeyEnv)), nil
	})

	if err != nil || !token.Valid {
		return nil, err
	}

	return token.Claims.(*jwt.RegisteredClaims), nil
}

func handleUserError(c *gin.Context, err error) {
	log.Println(err)
	status := http.StatusInternalServerError
	msg := ErrInternalServer

	if err == nil {
		status = http.StatusUnauthorized
		msg = ErrUserNotFound
	}

	c.JSON(status, gin.H{"error": msg})
	c.Abort()
}
