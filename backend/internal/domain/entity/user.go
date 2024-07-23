package entity

import (
	"time"
)

type UserRepository interface {
	CreateUser(user *User) (*User, error)
	FindUserById(id string) (*User, error)
	FindAllUsers() ([]*User, error)
	UpdateUser(userID string, updates map[string]interface{}) (*User, error)
	DeleteUser(id string) error
	FindUserByEmail(email string) (*User, error)
}

// type Role string

// const (
// 	AdminRole     Role = "admin"
// 	UserRole      Role = "user"
// 	CollectorRole Role = "collector"
// 	ManagerRole   Role = "manager"
// )

type User struct {
	ID         string    `json:"id" db:"id"`
	Name       string    `json:"name" db:"name"`
	Email      string    `json:"email" db:"email"`
	Password   string    `json:"password" db:"password"`
	Role       string    `json:"role" db:"role"`
	CreatedAt  time.Time `json:"created_at" db:"created_at"`
	UpdatedAt  time.Time `json:"updated_at" db:"updated_at"`
	OnDuty     bool      `json:"on_duty" db:"on_duty"`
	Profession string    `json:"profession" db:"profession"`
}

func NewUser(name string, email string, password string, role string, profession string) *User {
	return &User{
		Name:       name,
		Email:      email,
		Password:   password,
		Role:       role,
		Profession: profession,
	}
}
