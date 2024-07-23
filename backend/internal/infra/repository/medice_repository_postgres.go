package repository

import (
	"fmt"
	"reflect"
	"strings"

	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/domain/entity"
	"github.com/jmoiron/sqlx"
)

type MediceRepositoryPostgres struct {
	db *sqlx.DB
}

func NewMediceRepositoryPostgres(db *sqlx.DB) *MediceRepositoryPostgres {
	return &MediceRepositoryPostgres{db: db}
}

func (r *MediceRepositoryPostgres) CreateMedicine(medice *entity.Medicine) (*entity.Medicine, error) {
	err := r.db.QueryRow("INSERT INTO Medicines (batch, name, stripe) VALUES ($1, $2, $3) RETURNING id, created_at, updated_at", medice.Batch, medice.Name, medice.Stripe).Scan(&medice.ID, &medice.CreatedAt, &medice.UpdatedAt)

	if err != nil {
		return nil, err
	}
	return medice, nil
}

func (r *MediceRepositoryPostgres) FindAllMedicines() ([]*entity.Medicine, error) {
	var medicinies []*entity.Medicine
	err := r.db.Select(&medicinies, "SELECT * FROM Medicines")

	if err != nil {
		return nil, err
	}
	return medicinies, nil
}

func (r *MediceRepositoryPostgres) FindMedicineById(id string) (*entity.Medicine, error) {
	var medicine entity.Medicine
	err := r.db.Get(&medicine, "SELECT * FROM Medicines WHERE id = $1", id)
	if err != nil {
		return nil, err
	}
	return &medicine, nil
}

func (r *MediceRepositoryPostgres) DeleteMedicine(id string) error {
	_, err := r.db.Exec("DELETE FROM Medicines WHERE id = $1", id)
	if err != nil {
		return err
	}
	return nil
}

func (r *MediceRepositoryPostgres) UpdateMedicine(medicine *entity.Medicine) (*entity.Medicine, error) {
	var setParts []string
	v := reflect.ValueOf(*medicine)
	t := v.Type()

	for i := 0; i < v.NumField(); i++ {
		field := v.Field(i)
		fieldType := t.Field(i)
		// Ignorar campos CreatedAt e UpdatedAt
		if fieldType.Name == "CreatedAt" || fieldType.Name == "UpdatedAt" {
			continue
		}

		// Verificar se o campo não é vazio
		if !r.reflectIsEmptyValue(field) {
			fieldName := fieldType.Tag.Get("db")
			setPart := fmt.Sprintf("%s = :%s", fieldName, fieldName)
			setParts = append(setParts, setPart)
		}
	}

	if len(setParts) == 0 {
		return nil, fmt.Errorf("no fields to update")
	}

	query := fmt.Sprintf("UPDATE medicines SET %s WHERE id = :id RETURNING *", strings.Join(setParts, ", "))
	stmt, err := r.db.PrepareNamed(query)
	if err != nil {
		return nil, err
	}
	defer stmt.Close()

	var updatedMedicine entity.Medicine
	err = stmt.Get(&updatedMedicine, medicine)
	if err != nil {
		return nil, err
	}

	return &updatedMedicine, nil
}

func (r *MediceRepositoryPostgres) reflectIsEmptyValue(v reflect.Value) bool {
	switch v.Kind() {
	case reflect.String:
		return v.String() == ""
	case reflect.Int, reflect.Int32, reflect.Int64:
		return v.Int() == 0
	case reflect.Float32, reflect.Float64:
		return v.Float() == 0.0
	case reflect.Bool:
		return !v.Bool()
	}
	return false
}
