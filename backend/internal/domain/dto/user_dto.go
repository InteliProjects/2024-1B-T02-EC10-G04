package dto

import (
	"time"
)

type CreateUserInputDTO struct {
	Name       string `json:"name"`
	Email      string `json:"email"`
	Password   string `json:"password"`
	Role       string `json:"role"`
	Profession string `json:"profession"`
}

type LoginUserInputDTO struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type LoginUserOutputDTO struct {
	ID          string    `json:"id"`
	Name        string    `json:"name"`
	Email       string    `json:"email"`
	Role        string    `json:"role"`
	OnDuty      bool      `json:"on_duty"`
	Profession  string    `json:"profession"`
	CreatedAt   time.Time `json:"created_at"`
	AccessToken string    `json:"access_token"`
}

type FindUserByIdInputDTO struct {
	ID string `json:"id"`
}

type UpdateUserInputDTO struct {
	ID       string  `json:"id"`
	Name     *string `json:"name"`
	Email    *string `json:"email"`
	Password *string `json:"password"`
	Role     *string `json:"role"`
	OnDuty   *bool   `json:"on_duty"`
}

type DeleteUserInputDTO struct {
	ID string `json:"id"`
}

type CreateUserOutputDTO struct {
	ID        string    `json:"id"`
	Name      string    `json:"name"`
	Email     string    `json:"email"`
	Role      string    `json:"role"`
	OnDuty    bool      `json:"on_duty"`
	CreatedAt time.Time `json:"created_at"`
}

type FindUserOutputDTO struct {
	ID        string    `json:"id"`
	Name      string    `json:"name"`
	Email     string    `json:"email"`
	Role      string    `json:"role"`
	OnDuty    bool      `json:"on_duty"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

type UpdateUserOutputDTO struct {
	ID        string    `json:"id"`
	Name      string    `json:"name"`
	Email     string    `json:"email"`
	Role      string    `json:"role"`
	OnDuty    bool      `json:"on_duty"`
	UpdatedAt time.Time `json:"updated_at"`
}

type DeleteUserOutputDTO struct {
	ID string `json:"id"`
}
