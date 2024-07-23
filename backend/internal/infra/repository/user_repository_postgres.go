package repository

import (
	"fmt"

	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/domain/entity"
	"github.com/jmoiron/sqlx"
)

type UserRepositoryPostgres struct {
	db *sqlx.DB
}

func NewUserRepositoryPostgres(db *sqlx.DB) *UserRepositoryPostgres {
	return &UserRepositoryPostgres{db: db}
}

func (r *UserRepositoryPostgres) CreateUser(user *entity.User) (*entity.User, error) {
	var userCreated entity.User
	err := r.db.QueryRow("INSERT INTO users (name, email, password, role, on_duty, profession) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id, name, email, role, on_duty, created_at, profession", user.Name, user.Email, user.Password, user.Role, user.OnDuty, user.Profession).Scan(&userCreated.ID, &userCreated.Name, &userCreated.Email, &userCreated.Role, &userCreated.OnDuty, &userCreated.CreatedAt, &userCreated.Profession)
	if err != nil {
		return nil, err
	}
	return &userCreated, nil
}

func (r *UserRepositoryPostgres) FindAllUsers() ([]*entity.User, error) {
	var users []*entity.User
	err := r.db.Select(&users, "SELECT * FROM users")
	if err != nil {
		return nil, err
	}
	return users, nil
}

func (r *UserRepositoryPostgres) FindUserById(id string) (*entity.User, error) {
	var user entity.User
	err := r.db.Get(&user, "SELECT * FROM users WHERE id = $1", id)
	if err != nil {
		return nil, err
	}
	return &user, nil
}

func (r *UserRepositoryPostgres) DeleteUser(id string) error {
	_, err := r.db.Exec("DELETE FROM users WHERE id = $1", id)
	if err != nil {
		return err
	}
	return nil
}

func (r *UserRepositoryPostgres) UpdateUser(userID string, updates map[string]interface{}) (*entity.User, error) {
	query := "UPDATE users SET updated_at = CURRENT_TIMESTAMP"
	params := []interface{}{}
	i := 1

	for k, v := range updates {
		query += fmt.Sprintf(", %s = $%d", k, i)
		params = append(params, v)
		i++
	}
	query += fmt.Sprintf(" WHERE id = $%d RETURNING id, name, email, role, on_duty, updated_at", i)
	params = append(params, userID)

	var userUpdated entity.User
	err := r.db.QueryRow(query, params...).Scan(&userUpdated.ID, &userUpdated.Name, &userUpdated.Email, &userUpdated.Role, &userUpdated.OnDuty, &userUpdated.UpdatedAt)
	if err != nil {
		return nil, err
	}
	return &userUpdated, nil
}

func (r *UserRepositoryPostgres) FindUserByEmail(email string) (*entity.User, error) {
	var user entity.User
	err := r.db.Get(&user, "SELECT * FROM users WHERE email = $1", email)
	if err != nil {
		return nil, err
	}
	return &user, nil
}
