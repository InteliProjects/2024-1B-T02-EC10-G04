package entity

import "time"

type MedicinePyxisRepository interface {
	CreateMedicinePixys(pyxis_id string, medicines []string) ([]*MedicinePyxis, error)
	FindMedicinesPyxis(pyxis_id string) ([]*Medicine, error)
	DeleteMedicinesPyxis(pyxis_id string, medicines_id []string) ([]*MedicinePyxis, error)
	// FindMedicinePixys(pyxis_id string, medicine string)
	// DeleteMedicinePixys(pyxis_id string, medicine string)
}

type MedicinePyxis struct {
	ID         string    `json:"id" db:"id"`
	PyxisId    string    `json:"pyxis_id" db:"pyxis_id"`
	MedicineId string    `json:"medicine_id" db:"medicine_id"`
	CreatedAt  time.Time `json:"created_at" db:"created_at"`
}

func NewMedicinePyxis(pyxis_id string, medicine_id string) *MedicinePyxis {
	return &MedicinePyxis{
		PyxisId:    pyxis_id,
		MedicineId: medicine_id,
	}
}
