package usecase

import (
	"fmt"
	"log"
	"os"
	"reflect"
	"time"

	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/domain/dto"
	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/domain/entity"
	"github.com/golang-jwt/jwt/v4"
	"golang.org/x/crypto/bcrypt"
)

type UserUseCase struct {
	UserRepository entity.UserRepository
}

func NewUserUseCase(userRepository entity.UserRepository) *UserUseCase {
	return &UserUseCase{
		UserRepository: userRepository,
	}
}

func hashPassword(password string) string {
	bytes, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		log.Panic(err)
	}
	return string(bytes)
}

func (u *UserUseCase) CreateUser(input *dto.CreateUserInputDTO) (*dto.CreateUserOutputDTO, error) {
	existingUser, _ := u.UserRepository.FindUserByEmail(input.Email)

	if existingUser != nil {
		return nil, fmt.Errorf("user with email %s already exists", input.Email)
	}

	hashedPassword := hashPassword(input.Password)

	user := entity.NewUser(input.Name, input.Email, string(hashedPassword), input.Role, input.Profession)
	res, err := u.UserRepository.CreateUser(user)
	if err != nil {
		return nil, err
	}
	return &dto.CreateUserOutputDTO{
		ID:        res.ID,
		Name:      res.Name,
		Email:     res.Email,
		Role:      res.Role,
		OnDuty:    res.OnDuty,
		CreatedAt: res.CreatedAt,
	}, nil
}

func (u *UserUseCase) FindUserById(id string) (*dto.FindUserOutputDTO, error) {
	res, err := u.UserRepository.FindUserById(id)
	if err != nil {
		return nil, err
	}
	return &dto.FindUserOutputDTO{
		ID:        res.ID,
		Name:      res.Name,
		Email:     res.Email,
		Role:      res.Role,
		CreatedAt: res.CreatedAt,
		UpdatedAt: res.UpdatedAt,
	}, nil
}

func (u *UserUseCase) FindAllUsers() ([]*dto.FindUserOutputDTO, error) {
	res, err := u.UserRepository.FindAllUsers()
	if err != nil {
		return nil, err
	}
	var output []*dto.FindUserOutputDTO
	for _, user := range res {
		output = append(output, &dto.FindUserOutputDTO{
			ID:        user.ID,
			Name:      user.Name,
			Email:     user.Email,
			Role:      user.Role,
			CreatedAt: user.CreatedAt,
			UpdatedAt: user.UpdatedAt,
		})
	}
	return output, nil
}

func (u *UserUseCase) UpdateUser(input *dto.UpdateUserInputDTO) (*dto.UpdateUserOutputDTO, error) {
	_, err := u.UserRepository.FindUserById(input.ID)
	if err != nil {
		return nil, err
	}

	// Mapa para armazenar os campos a serem atualizados
	updates := make(map[string]interface{})
	v := reflect.ValueOf(input).Elem()

	for i := 0; i < v.NumField(); i++ {
		field := v.Field(i)
		fieldName := v.Type().Field(i).Tag.Get("json")
		if fieldName == "" || fieldName == "id" {
			continue
		}
		if !field.IsNil() {
			if fieldName == "password" {
				hashedPassword, err := bcrypt.GenerateFromPassword([]byte(*field.Interface().(*string)), bcrypt.DefaultCost)
				if err != nil {
					return nil, err
				}
				updates[fieldName] = string(hashedPassword)
			} else {
				updates[fieldName] = field.Interface()
			}
		}
	}

	res, err := u.UserRepository.UpdateUser(input.ID, updates)
	if err != nil {
		return nil, err
	}

	return &dto.UpdateUserOutputDTO{
		ID:        res.ID,
		Name:      res.Name,
		Email:     res.Email,
		Role:      res.Role,
		OnDuty:    res.OnDuty,
		UpdatedAt: res.UpdatedAt,
	}, nil
}

func (u *UserUseCase) DeleteUser(id string) error {
	user, err := u.UserRepository.FindUserById(id)
	if err != nil {
		return err
	}
	return u.UserRepository.DeleteUser(user.ID)
}

func verifyPassword(userPassword string, providedPassword string) (bool, string) {
	err := bcrypt.CompareHashAndPassword([]byte(userPassword), []byte(providedPassword))
	check := true
	msg := ""

	if err != nil {
		fmt.Println(err)
		msg = "E-Mail or Password is incorrect"
		check = false
	}
	return check, msg
}

func generateJWT(user *entity.User) (string, error) {
	expirationTime := time.Now().Add(72 * time.Hour) // Token expira em 72 horas
	claims := &jwt.RegisteredClaims{
		Subject:   user.ID,
		ExpiresAt: jwt.NewNumericDate(expirationTime),
		Issuer:    "InteliModulo10",
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString([]byte(os.Getenv("JWT_SECRET_KEY")))

	if err != nil {
		return "", err
	}

	return tokenString, nil
}

func (u *UserUseCase) LoginUser(input *dto.LoginUserInputDTO) (*dto.LoginUserOutputDTO, error) {
	user, err := u.UserRepository.FindUserByEmail(input.Email)

	if err != nil {
		return nil, err
	}

	check, msg := verifyPassword(user.Password, input.Password)

	if !check {
		return nil, fmt.Errorf(msg)
	}

	token, err := generateJWT(user)
	if err != nil {
		return nil, err
	}

	return &dto.LoginUserOutputDTO{
		ID:          user.ID,
		Name:        user.Name,
		Email:       user.Email,
		Role:        user.Role,
		OnDuty:      user.OnDuty,
		Profession:  user.Profession,
		CreatedAt:   user.CreatedAt,
		AccessToken: token,
	}, nil
}
