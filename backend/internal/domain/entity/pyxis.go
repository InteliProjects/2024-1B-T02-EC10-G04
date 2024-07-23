package entity

import (
	"time"
)

type PyxisRepository interface {
	CreatePyxis(pyxis *Pyxis) (*Pyxis, error)
	FindPyxisById(id string) (*Pyxis, error)
	FindAllPyxis() ([]*Pyxis, error)
	UpdatePyxis(pyxis *Pyxis) (*Pyxis, error)
	DeletePyxis(id string) error
}

type Pyxis struct {
	ID        string    `json:"id" db:"id"`
	Label     string    `json:"label" db:"label"`
	CreatedAt time.Time `json:"created_at" db:"created_at"`
	UpdatedAt time.Time `json:"updated_at" db:"updated_at"`
}

func NewPyxis(label string) *Pyxis {
	return &Pyxis{
		Label:     label,
	}
}
