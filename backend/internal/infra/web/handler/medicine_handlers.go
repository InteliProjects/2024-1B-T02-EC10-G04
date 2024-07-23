package handler

import (
	"fmt"
	"net/http"

	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/domain/dto"
	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/usecase"
	"github.com/gin-gonic/gin"
)

type MedicineHandlers struct {
	MedicineUseCase *usecase.MedicineUseCase
}

func NewMedicineHandlers(medicineUsecase *usecase.MedicineUseCase) *MedicineHandlers {
	return &MedicineHandlers{
		MedicineUseCase: medicineUsecase,
	}
}

// CreateMedicineHandler
// @Summary Create a new Medicine entity
// @Description Create a new Medicine entity
// @Tags Medicines
// @Accept json
// @Produce json
// @Param input body dto.CreateMedicineInputDTO true "Medicine entity to create"
// @Success 200 {object} dto.CreateMedicineOutputDTO
// @Security BearerAuth
// @Router /medicines [post]
func (h *MedicineHandlers) CreateMedicineHandler(c *gin.Context) {
	var input dto.CreateMedicineInputDTO
	if err := c.BindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	output, err := h.MedicineUseCase.CreateMedicine(&input)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, output)
}

// FindAllMedicineHandler
// @Summary Retrieve all Medicines entities
// @Description Retrieve all Medicines entities
// @Tags Medicines
// @Accept json
// @Produce json
// @Success 200 {array} dto.FindMedicineOutputDTO
// @Security BearerAuth
// @Router /medicines [get]
func (h *MedicineHandlers) FindAllMedicinesHandler(c *gin.Context) {
	output, err := h.MedicineUseCase.FindAllMedicines()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, output)
}

// FindMedicineByIdHandler
// @Summary Retrieve a Medicine entity by ID
// @Description Retrieve a Medicine entity by ID
// @Tags Medicines
// @Accept json
// @Produce json
// @Param id path string true "Medicine ID"
// @Success 200 {object} dto.FindMedicineOutputDTO
// @Security BearerAuth
// @Router /medicines/{id} [get]
func (m *MedicineHandlers) FindMedicineByIdHandler(c *gin.Context) {
	medicineId := c.Param("id")
	output, err := m.MedicineUseCase.FindMedicineById(medicineId)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, output)
}

// UpdatePyxisHandler
// @Summary Update a Medicine entity
// @Description Update a Medicine entity
// @Tags Medicines
// @Accept json
// @Produce json
// @Param id path string true "Medicine ID"
// @Param input body dto.UpdateMedicineInputDTO true "Medicine entity to update"
// @Success 200 {object} dto.FindMedicineOutputDTO
// @Security BearerAuth
// @Router /medicines/{id} [put]
func (h *MedicineHandlers) UpdateMedicineHandler(c *gin.Context) {
	var input dto.UpdateMedicineInputDTO
	input.ID = c.Param("id")
	if err := c.BindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	output, err := h.MedicineUseCase.UpdateMedicine(&input)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, output)
}

// DeleteMedicineHandler
// @Summary Delete a Medicine entity
// @Description Delete a Medicine entity
// @Tags Medicines
// @Accept json
// @Produce json
// @Param id path string true "Medicine ID"
// @Success 200 {string} string
// @Security BearerAuth
// @Router /medicines/{id} [delete]
func (h *MedicineHandlers) DeleteMedicineHandler(c *gin.Context) {
	medicine_id := c.Param("id")
	err := h.MedicineUseCase.DeleteMedicine(medicine_id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	message := fmt.Sprintf("Medicine %s deleted successfully", medicine_id)
	c.JSON(http.StatusOK, gin.H{"message": message})
}

