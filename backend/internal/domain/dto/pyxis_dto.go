package dto

import (
	"time"
)

type CreatePyxisInputDTO struct {
	Label string `json:"label"`
}

type FindPyxisByIDInputDTO struct {
	ID string `json:"id"`
}

type UpdatePyxisInputDTO struct {
	ID    string `json:"id"`
	Label string `json:"label"`
}

type CreatePyxisOutputDTO struct {
	ID        string    `json:"id"`
	Label     string    `json:"label"`
	CreatedAt time.Time `json:"created_at"`
}

type FindPyxisOutputDTO struct {
	ID        string    `json:"id"`
	Label     string    `json:"label"`
	UpdatedAt time.Time `json:"updated_at"`
	CreatedAt time.Time `json:"created_at"`
}

type UpdatePyxisOutputDTO struct {
	ID       string    `json:"id"`
	Label    string    `json:"label"`
	UpdateAt time.Time `json:"updated_at"`
}

type DeletePyxisInputDTO struct {
	ID string `json:"id"`
}

type RegisterMedicinePyxisInputDTO struct {
	Medicines []string `json:"medicines"`
}

type DisassociateMedicineInputDTO struct {
	Medicines []string `json:"medicines"`
}

type DisassociateMedicineOutputDTO struct {
	PyxisID    string `json:"pyxis_id"`
	MedicineID string `json:"medicine_id"`
}

type DisassociateMedicinesOutputDTO struct {
	DisassociatedMedicines []DisassociateMedicineOutputDTO `json:"disassociated_medicines"`
}

type GenerateQRCodeOutputDTO struct {
	PyxisID string `json:"pyxis_id"`
}
