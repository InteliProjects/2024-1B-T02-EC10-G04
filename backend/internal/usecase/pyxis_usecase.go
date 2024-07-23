package usecase

import (
	"context"
	"errors"
	"fmt"
	"log"

	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/domain/dto"
	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/domain/entity"
	cacheError "github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/errors"
)

type PyxisUseCase struct {
	PyxisRepository          entity.PyxisRepository
	MedicinePyxisRepository  entity.MedicinePyxisRepository
	MedicinesRedisRepository entity.MedicineRedisRepository
}

func NewPyxisUseCase(pyxisRepository entity.PyxisRepository, medicinePixysRepository entity.MedicinePyxisRepository, medicineRedisRepository entity.MedicineRedisRepository) *PyxisUseCase {
	return &PyxisUseCase{PyxisRepository: pyxisRepository, MedicinePyxisRepository: medicinePixysRepository, MedicinesRedisRepository: medicineRedisRepository}
}

func (p *PyxisUseCase) CreatePyxis(input *dto.CreatePyxisInputDTO) (*dto.CreatePyxisOutputDTO, error) {
	pyxis := entity.NewPyxis(input.Label)
	res, err := p.PyxisRepository.CreatePyxis(pyxis)
	if err != nil {
		return nil, err
	}
	return &dto.CreatePyxisOutputDTO{
		ID:        res.ID,
		Label:     res.Label,
		CreatedAt: res.CreatedAt,
	}, nil
}

func (p *PyxisUseCase) FindAllPyxis() ([]*dto.FindPyxisOutputDTO, error) {
	res, err := p.PyxisRepository.FindAllPyxis()
	if err != nil {
		return nil, err
	}
	var output []*dto.FindPyxisOutputDTO
	for _, pyxis := range res {
		output = append(output, &dto.FindPyxisOutputDTO{
			ID:        pyxis.ID,
			Label:     pyxis.Label,
			UpdatedAt: pyxis.UpdatedAt,
			CreatedAt: pyxis.CreatedAt,
		})
	}
	return output, nil
}

func (p *PyxisUseCase) FindPyxisById(id string) (*dto.FindPyxisOutputDTO, error) {
	pyxis, err := p.PyxisRepository.FindPyxisById(id)
	if err != nil {
		return nil, err
	}
	return &dto.FindPyxisOutputDTO{
		ID:        pyxis.ID,
		Label:     pyxis.Label,
		UpdatedAt: pyxis.UpdatedAt,
		CreatedAt: pyxis.CreatedAt,
	}, nil
}

func (p *PyxisUseCase) UpdatePyxis(input *dto.UpdatePyxisInputDTO) (*dto.UpdatePyxisOutputDTO, error) {
	res, err := p.PyxisRepository.FindPyxisById(input.ID)
	if err != nil {
		return nil, err
	}

	//TODO: Implement update that does not require all fields of input DTO (Maybe i can do this only in the repository?)
	res.Label = input.Label

	res, err = p.PyxisRepository.UpdatePyxis(res)
	if err != nil {
		return nil, err
	}
	return &dto.UpdatePyxisOutputDTO{
		ID:       res.ID,
		Label:    res.Label,
		UpdateAt: res.UpdatedAt,
	}, nil
}

func (p *PyxisUseCase) DeletePyxis(id string) error {
	pyxis, err := p.PyxisRepository.FindPyxisById(id)
	if err != nil {
		return err
	}
	if err := p.PyxisRepository.DeletePyxis(pyxis.ID); err != nil {
		return err
	} else {
		if err := p.MedicinesRedisRepository.RemoveMedicinesPyxis(context.Background(), id); err != nil {
			log.Printf("Error deleting from cache: %s\n", err.Error())
		}
		return nil
	}
}

func (p *PyxisUseCase) RegisterMedicine(id string, medicines []string) error {
	if _, err := p.PyxisRepository.FindPyxisById(id); err != nil {
		return err
	}

	_, err := p.MedicinePyxisRepository.CreateMedicinePixys(id, medicines)

	if err := p.MedicinesRedisRepository.RemoveMedicinesPyxis(context.Background(), id); err != nil {
		log.Printf("Error deleting from cache: %s\n", err.Error())
	}

	return err
}

func (p *PyxisUseCase) GetMedicinesFromPyxis(pyxis_id string) ([]*dto.FindMedicineOutputDTO, error) {
	ctx := context.Background()

	medicines, err := p.MedicinesRedisRepository.FindMedicinesFromPyxis(ctx, pyxis_id)

	if medicines == nil || err != nil {
		switch {
		case errors.Is(err, cacheError.KeyNil):
			medicines, err = p.MedicinePyxisRepository.FindMedicinesPyxis(pyxis_id)
			if err != nil {
				return nil, err
			}

			if medicines != nil || len(medicines) > 0 {
				err = p.MedicinesRedisRepository.InsertMedicinesPyxis(ctx, pyxis_id, medicines)
				if err != nil {
					return nil, err
				}
			}
		default:
			return nil, err
		}
	}

	var output []*dto.FindMedicineOutputDTO
	for _, medicine := range medicines {
		output = append(output, &dto.FindMedicineOutputDTO{
			ID:        medicine.ID,
			Batch:     medicine.Batch,
			Name:      medicine.Name,
			Stripe:    medicine.Stripe,
			CreatedAt: medicine.CreatedAt,
			UpdatedAt: medicine.UpdatedAt,
		})
	}

	return output, err
}

func (p *PyxisUseCase) DisassociateMedicinesFromPyxis(pyxis_id string, medicines_id []string) (*dto.DisassociateMedicinesOutputDTO, error) {
	deletedMedicines, err := p.MedicinePyxisRepository.DeleteMedicinesPyxis(pyxis_id, medicines_id)

	if len(deletedMedicines) == 0 {
		return nil, fmt.Errorf("Unable to disassociate medicines: these medicines doesn't exists in this pyxis")
	}

	output := dto.DisassociateMedicinesOutputDTO{
		DisassociatedMedicines: make([]dto.DisassociateMedicineOutputDTO, len(deletedMedicines)),
	}

	for i, deletedMedicine := range deletedMedicines {
		output.DisassociatedMedicines[i].MedicineID = deletedMedicine.MedicineId
		output.DisassociatedMedicines[i].PyxisID = deletedMedicine.PyxisId
	}

	if err := p.MedicinesRedisRepository.RemoveMedicinesPyxis(context.Background(), pyxis_id); err != nil {
		log.Printf("Error deleting from cache: %s\n", err.Error())
	}

	return &output, err
}
