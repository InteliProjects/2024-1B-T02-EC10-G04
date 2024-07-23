package repository

import (
	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/domain/entity"
	"github.com/jmoiron/sqlx"
)

type PyxisRepositoryPostgres struct {
	db *sqlx.DB
}

func NewPyxisRepositoryPostgres(db *sqlx.DB) *PyxisRepositoryPostgres {
	return &PyxisRepositoryPostgres{db: db}
}

func (r *PyxisRepositoryPostgres) CreatePyxis(pyxis *entity.Pyxis) (*entity.Pyxis, error) {
	var pyxisCreated entity.Pyxis
	err := r.db.QueryRow("INSERT INTO pyxis (label) VALUES ($1) RETURNING id, label, created_at", pyxis.Label).Scan(&pyxisCreated.ID, &pyxisCreated.Label, &pyxisCreated.CreatedAt)
	if err != nil {
		return nil, err
	}
	return &pyxisCreated, nil
}

func (r *PyxisRepositoryPostgres) FindAllPyxis() ([]*entity.Pyxis, error) {
	var pyxis []*entity.Pyxis
	err := r.db.Select(&pyxis, "SELECT * FROM pyxis")

	if err != nil {
		return nil, err
	}
	return pyxis, nil
}

func (r *PyxisRepositoryPostgres) FindPyxisById(id string) (*entity.Pyxis, error) {
	var pyxis entity.Pyxis
	err := r.db.Get(&pyxis, "SELECT * FROM pyxis WHERE id = $1", id)
	if err != nil {
		return nil, err
	}
	return &pyxis, nil
}

func (r *PyxisRepositoryPostgres) DeletePyxis(id string) error {
	_, err := r.db.Exec("DELETE FROM pyxis WHERE id = $1", id)
	if err != nil {
		return err
	}
	return nil
}

func (r *PyxisRepositoryPostgres) UpdatePyxis(pyxis *entity.Pyxis) (*entity.Pyxis, error) {
	var updatedPyxis entity.Pyxis
	err := r.db.QueryRow("UPDATE pyxis SET updated_at = CURRENT_TIMESTAMP, label = $1 WHERE id = $2 RETURNING id, label, updated_at", pyxis.Label, pyxis.ID).Scan(&updatedPyxis.ID, &updatedPyxis.Label, &updatedPyxis.UpdatedAt)
	if err != nil {
		return nil, err
	}
	return &updatedPyxis, nil
}
