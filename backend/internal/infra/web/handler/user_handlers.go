package handler

import (
	"fmt"
	"net/http"

	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/domain/dto"
	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/usecase"
	"github.com/gin-gonic/gin"
)

type UserHandlers struct {
	UserUseCase *usecase.UserUseCase
}

func NewUserHandlers(userUseCase *usecase.UserUseCase) *UserHandlers {
	return &UserHandlers{
		UserUseCase: userUseCase,
	}
}

// CreateUser
// @Summary Create a new User entity
// @Description Create a new User entity
// @Tags Users
// @Accept json
// @Produce json
// @Param input body dto.CreateUserInputDTO true "User entity to create"
// @Success 201 {object} dto.CreateUserOutputDTO
// @Router /users [post]
func (h *UserHandlers) CreateUser(c *gin.Context) {
	var input dto.CreateUserInputDTO
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	output, err := h.UserUseCase.CreateUser(&input)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, output)
}

// FindAllUsersHandler
// @Summary Retrieve all User entities
// @Description Retrieve all User entities
// @Tags Users
// @Accept json
// @Produce json
// @Success 200 {array} dto.FindUserOutputDTO
// @Security BearerAuth
// @Router /users [get]
func (h *UserHandlers) FindAllUsersHandler(c *gin.Context) {
	output, err := h.UserUseCase.FindAllUsers()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, output)
}

// FindUserByIdHandler
// @Summary Retrieve a User entity by ID
// @Description Retrieve a User entity by ID
// @Tags Users
// @Accept json
// @Produce json
// @Param id path string true "User ID"
// @Success 200 {object} dto.FindUserOutputDTO
// @Security BearerAuth
// @Router /users/{id} [get]
func (h *UserHandlers) FindUserByIdHandler(c *gin.Context) {
	var input dto.FindUserByIdInputDTO
	input.ID = c.Param("id")
	output, err := h.UserUseCase.FindUserById(input.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, output)
}

// UpdateUserHandler
// @Summary Update a User entity
// @Description Update a User entity
// @Tags Users
// @Accept json
// @Produce json
// @Param id path string true "User ID"
// @Param input body dto.UpdateUserInputDTO true "User entity to update"
// @Success 200 {object} dto.UpdateUserOutputDTO
// @Security BearerAuth
// @Router /users/{id} [put]
func (h *UserHandlers) UpdateUserHandler(c *gin.Context) {
	var input dto.UpdateUserInputDTO
	input.ID = c.Param("id")
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	output, err := h.UserUseCase.UpdateUser(&input)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, output)
}

// DeleteUserHandler
// @Summary Delete a User entity
// @Description Delete a User entity
// @Tags Users
// @Accept json
// @Produce json
// @Param id path string true "User ID"
// @Success 200 {string} string
// @Security BearerAuth
// @Router /users/{id} [delete]
func (h *UserHandlers) DeleteUserHandler(c *gin.Context) {
	var input dto.DeleteUserInputDTO
	input.ID = c.Param("id")
	err := h.UserUseCase.DeleteUser(input.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	message := fmt.Sprintf("User %s deleted successfully", input.ID)
	c.JSON(http.StatusOK, gin.H{"message": message})
}

// LoginUser
// @Summary Log in a user
// @Description Authenticate user credentials and return user session information
// @Tags Users
// @Accept json
// @Produce json
// @Param input body dto.LoginUserInputDTO true "Login credentials"
// @Success 200 {object} dto.LoginUserOutputDTO "Authentication successful, user details returned"
// @Failure 400 {object} map[string]string "Invalid credentials or bad request"
// @Failure 500 {object} map[string]string "Internal server error"
// @Router /users/login [post]
func (h *UserHandlers) LoginUser(c *gin.Context) {
	var input dto.LoginUserInputDTO
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	output, err := h.UserUseCase.LoginUser(&input)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, output)
}
