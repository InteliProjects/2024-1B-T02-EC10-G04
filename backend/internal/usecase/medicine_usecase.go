package usecase

import (
	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/domain/dto"
	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/domain/entity"
)

type MedicineUseCase struct {
	MedicineRepository entity.MediceRepository
}

func NewMedicineUseCase(medicineRepository entity.MediceRepository) *MedicineUseCase {
	return &MedicineUseCase{MedicineRepository: medicineRepository}
}

func (m *MedicineUseCase) CreateMedicine(input *dto.CreateMedicineInputDTO) (*dto.CreateMedicineOutputDTO, error) {
	medicine := entity.NewMedice(input.Batch, input.Name, input.Stripe)
	res, err := m.MedicineRepository.CreateMedicine(medicine)
	if err != nil {
		return nil, err
	}
	return &dto.CreateMedicineOutputDTO{
		ID:        res.ID,
		Batch:     res.Batch,
		Name:      res.Name,
		Stripe:    res.Stripe,
		CreatedAt: res.CreatedAt,
		UpdatedAt: res.UpdatedAt,
	}, nil
}

func (m *MedicineUseCase) FindAllMedicines() ([]*dto.FindMedicineOutputDTO, error) {
	res, err := m.MedicineRepository.FindAllMedicines()
	if err != nil {
		return nil, err
	}
	var output []*dto.FindMedicineOutputDTO
	for _, medicine := range res {
		output = append(output, &dto.FindMedicineOutputDTO{
			ID:        medicine.ID,
			Batch:     medicine.Batch,
			Name:      medicine.Name,
			Stripe:    medicine.Stripe,
			CreatedAt: medicine.CreatedAt,
			UpdatedAt: medicine.UpdatedAt,
		})
	}
	return output, nil
}

func (m *MedicineUseCase) FindMedicineById(id string) (*dto.FindMedicineOutputDTO, error) {
	medicine, err := m.MedicineRepository.FindMedicineById(id)
	if err != nil {
		return nil, err
	}
	return &dto.FindMedicineOutputDTO{
		ID:        medicine.ID,
		Batch:     medicine.Batch,
		Name:      medicine.Name,
		Stripe:    medicine.Stripe,
		CreatedAt: medicine.CreatedAt,
		UpdatedAt: medicine.UpdatedAt,
	}, nil
}

func (m *MedicineUseCase) UpdateMedicine(input *dto.UpdateMedicineInputDTO) (*dto.FindMedicineOutputDTO, error) {
	res, err := m.MedicineRepository.FindMedicineById(input.ID)
	if err != nil {
		return nil, err
	}

	//TODO: Implement update that does not require all fields of input DTO (Maybe i can do this only in the repository?)
	res.Batch = input.Batch
	res.Name = input.Name
	res.Stripe = input.Stripe

	updated_medicine, err := m.MedicineRepository.UpdateMedicine(res)
	if err != nil {
		return nil, err
	}
	return &dto.FindMedicineOutputDTO{
		ID:        updated_medicine.ID,
		Batch:     updated_medicine.Batch,
		Name:      updated_medicine.Name,
		Stripe:    updated_medicine.Stripe,
		CreatedAt: updated_medicine.CreatedAt,
		UpdatedAt: updated_medicine.UpdatedAt,
	}, nil
}

func (m *MedicineUseCase) DeleteMedicine(id string) error {
	medicine, err := m.MedicineRepository.FindMedicineById(id)
	if err != nil {
		return err
	}
	return m.MedicineRepository.DeleteMedicine(medicine.ID)
}
