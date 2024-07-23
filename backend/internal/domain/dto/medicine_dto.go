package dto

import (
	"time"

	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/domain/entity"
)

type CreateMedicineInputDTO struct {
	Batch  string            `json:"batch"`
	Name   string            `json:"name"`
	Stripe entity.StripeType `json:"stripe"`
}

type CreateMedicineOutputDTO struct {
	ID        string            `json:"id"`
	Batch     string            `json:"batch"`
	Name      string            `json:"name"`
	Stripe    entity.StripeType `json:"stripe"`
	CreatedAt time.Time         `json:"created_at"`
	UpdatedAt time.Time         `json:"updated_at"`
}

type FindMedicineOutputDTO struct {
	ID        string            `json:"id"`
	Batch     string            `json:"batch"`
	Name      string            `json:"name"`
	Stripe    entity.StripeType `json:"stripe"`
	CreatedAt time.Time         `json:"created_at"`
	UpdatedAt time.Time         `json:"updated_at"`
}


type UpdateMedicineInputDTO struct {
	ID        string            `json:"id"`
	Batch     string            `json:"batch"`
	Name      string            `json:"name"`
	Stripe    entity.StripeType `json:"stripe"`
	CreatedAt time.Time         `json:"created_at"`
	UpdatedAt time.Time         `json:"updated_at"`
}
