package repository

import (
	"fmt"
	"strings"

	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/domain/entity"
	"github.com/jmoiron/sqlx"
)

type MedicinePyxisRepositoryPostgres struct {
	db *sqlx.DB
}

func NewMedicinePyxisRepositoryPostgres(db *sqlx.DB) *MedicinePyxisRepositoryPostgres {
	return &MedicinePyxisRepositoryPostgres{db: db}
}

func (r *MedicinePyxisRepositoryPostgres) CreateMedicinePixys(pyxis_id string, medicines []string) ([]*entity.MedicinePyxis, error) {
	medicinesAmount := len(medicines)

	if medicinesAmount <= 0 {
		return nil, fmt.Errorf("No medicines provided")
	}

	var medicinePyxisCreated []*entity.MedicinePyxis

	var placeholders []string
	var values []any

	for i, medicine_id := range medicines {
		placeholders = append(placeholders, fmt.Sprintf("($%d, $%d)", i*2+1, i*2+2))
		values = append(values, pyxis_id, medicine_id)
	}

	var query string

	if medicinesAmount == 1 {
		query = fmt.Sprintf("INSERT INTO Medicine_PYXIS (pyxis_id, medicine_id) VALUES %s RETURNING id, pyxis_id, medicine_id, created_at", strings.Join(placeholders, ""))
	} else {
		query = fmt.Sprintf("INSERT INTO Medicine_PYXIS (pyxis_id, medicine_id) VALUES %s RETURNING id, pyxis_id, medicine_id, created_at", strings.Join(placeholders, ","))
	}

	rows, err := r.db.Query(query, values...)
	if err != nil {
		return nil, fmt.Errorf("error executing query: %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		var mp entity.MedicinePyxis
		err := rows.Scan(&mp.ID, &mp.PyxisId, &mp.MedicineId, &mp.CreatedAt)
		if err != nil {
			return nil, fmt.Errorf("error scanning row: %v", err)
		}
		medicinePyxisCreated = append(medicinePyxisCreated, &mp)
	}

	if err = rows.Err(); err != nil {
		return nil, fmt.Errorf("error with rows: %v", err)
	}

	return medicinePyxisCreated, nil
}

func (r *MedicinePyxisRepositoryPostgres) FindMedicinesPyxis(pyxis_id string) ([]*entity.Medicine, error) {
	var medicines []*entity.Medicine

	query := `
    SELECT 
      m.* 
    FROM 
      medicine_pyxis mp
    INNER JOIN 
      medicines m 
    ON 
      mp.medicine_id = m.id
    WHERE 
      mp.pyxis_id = $1;
  `
	err := r.db.Select(&medicines, query, pyxis_id)

	if err != nil {
		return nil, err
	}
	return medicines, nil
}

func (r *MedicinePyxisRepositoryPostgres) DeleteMedicinesPyxis(pyxis_id string, medicines_id []string) ([]*entity.MedicinePyxis, error) {
	if len(medicines_id) == 0 {
		return nil, fmt.Errorf("Impossible to disassociate empty medicines\n")
	}

	var placeholders []string
	var args []any

	for i, medicine_id := range medicines_id {
		placeholder := fmt.Sprintf("($%d, $%d)", i*2+1, i*2+2)
		placeholders = append(placeholders, placeholder)

		args = append(args, pyxis_id, medicine_id)
	}

	query := fmt.Sprintf(`
    DELETE FROM medicine_pyxis
    WHERE
      (pyxis_id, medicine_id) IN (%s)
    RETURNING
      *
  `, strings.Join(placeholders, ","))

	rows, err := r.db.Queryx(query, args...)
	if err != nil {
		return nil, fmt.Errorf("error executing delete query: %v", err)
	}
	defer rows.Close()

	var deletedMedicines []*entity.MedicinePyxis
	for rows.Next() {
		var deletedMedicine entity.MedicinePyxis
		err := rows.StructScan(&deletedMedicine)
		if err != nil {
			return nil, fmt.Errorf("error scanning row: %v", err)
		}
		deletedMedicines = append(deletedMedicines, &deletedMedicine)
	}

	if err = rows.Err(); err != nil {
		return nil, fmt.Errorf("error with rows: %v", err)
	}

	return deletedMedicines, err
}

//////////////// TODO ////////////////

func (r *MedicinePyxisRepositoryPostgres) FindPyxisById(id string) (*entity.Pyxis, error) {
	var pyxis entity.Pyxis
	err := r.db.Get(&pyxis, "SELECT * FROM pyxis WHERE id = $1", id)
	if err != nil {
		return nil, err
	}
	return &pyxis, nil
}

func (r *MedicinePyxisRepositoryPostgres) DeletePyxis(id string) error {
	_, err := r.db.Exec("DELETE FROM pyxis WHERE id = $1", id)
	if err != nil {
		return err
	}
	return nil
}

func (r MedicinePyxisRepositoryPostgres) UpdatePyxis(pyxis *entity.Pyxis) (*entity.Pyxis, error) {
	var updatedPyxis entity.Pyxis
	err := r.db.QueryRow("UPDATE pyxis SET updated_at = CURRENT_TIMESTAMP, label = $1 WHERE id = $2 RETURNING id, label, updated_at", pyxis.Label, pyxis.ID).Scan(&updatedPyxis.ID, &updatedPyxis.Label, &updatedPyxis.UpdatedAt)
	if err != nil {
		return nil, err
	}
	return &updatedPyxis, nil
}
