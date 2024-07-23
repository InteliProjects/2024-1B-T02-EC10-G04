package handler

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/domain/dto"
	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/infra/kafka"
	"github.com/Inteli-College/2024-1B-T02-EC10-G04/internal/usecase"
	"github.com/gin-gonic/gin"
)

type OrderHandlers struct {
	OrderUseCase  *usecase.OrderUseCase
	KafkaProducer *kafka.KafkaProducer
}

func NewOrderHandlers(orderUsecase *usecase.OrderUseCase, KafkaProducer *kafka.KafkaProducer) *OrderHandlers {
	return &OrderHandlers{
		OrderUseCase:  orderUsecase,
		KafkaProducer: KafkaProducer,
	}
}

// CreateOrdersHandler
// @Summary Create a new Order entity
// @Description Create a new Order entity and produce an event to Kafka
// @Tags Orders
// @Accept json
// @Produce json
// @Param input body dto.CreateOrdersInputDTO true "Order entity to create"
// @Success 201 {object} string
// @Security BearerAuth
// @Router /orders [post]
func (h *OrderHandlers) CreateOrdersHandler(c *gin.Context) {
	var input dto.CreateOrdersInputDTO
	userID, exists := c.Get("userID")

	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}

	input.User_ID = userID.(string)

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	inputBytes, err := json.Marshal(input)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	err = h.KafkaProducer.Produce(inputBytes, []byte("new_order"), os.Getenv("CONFLUENT_KAFKA_TOPIC_NAME"))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": "Order created successfully"})
}

// FindOrdersByCollector
// @Summary Retrieve all Order entities by Collector ID
// @Description Retrieve all Order entities by Collector ID
// @Tags Orders
// @Accept json
// @Produce json
// @Success 200 {array} dto.FindOrderOutputDTO
// @Security BearerAuth
// @Router /orders/collector [get]
func (h *OrderHandlers) FindOrdersByCollectorHandler(c *gin.Context) {
	userID, exists := c.Get("userID")
	log.Printf("userID: %v", userID)
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}
	output, err := h.OrderUseCase.FindOrdersByCollector(userID.(string))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, output)
}

// FindOrdersByUserHandler
// @Summary Retrieve all Order entities by User ID
// @Description Retrieve all Order entities by User ID
// @Tags Orders
// @Accept json
// @Produce json
// @Success 200 {array} dto.FindOrderOutputDTO
// @Security BearerAuth
// @Router /orders/user [get]
func (h *OrderHandlers) FindOrdersByUserHandler(c *gin.Context) {
	userID, exists := c.Get("userID")
	log.Printf("userID: %v", userID)
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "Unauthorized"})
		return
	}
	output, err := h.OrderUseCase.FindOrdersByUser(userID.(string))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, output)
}

// FindAllOrdersHandler
// @Summary Retrieve all Order entities
// @Description Retrieve all Order entities
// @Tags Orders
// @Accept json
// @Produce json
// @Success 200 {array} dto.FindOrderOutputDTO
// @Security BearerAuth
// @Router /orders [get]
func (h *OrderHandlers) FindAllOrdersHandler(c *gin.Context) {
	output, err := h.OrderUseCase.FindAllOrders()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, output)
}

// FindOrderByIdHandler
// @Summary Retrieve an Order entity by ID
// @Description Retrieve an Order entity by ID
// @Tags Orders
// @Accept json
// @Produce json
// @Param id path string true "Order ID"
// @Success 200 {object} dto.FindOrderOutputDTO
// @Security BearerAuth
// @Router /orders/{id} [get]
func (h *OrderHandlers) FindOrderByIdHandler(c *gin.Context) {
	var input dto.FindOrderByIDInputDTO
	input.ID = c.Param("id")
	output, err := h.OrderUseCase.FindOrderById(input.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, output)
}

// UpdateOrderHandler
// @Summary Update an Order entity
// @Description Update an Order entity
// @Tags Orders
// @Accept json
// @Produce json
// @Param id path string true "Order ID"
// @Param input body dto.UpdateOrderInputDTO true "Order entity to update"
// @Success 200 {object} dto.UpdateOrderOutputDTO
// @Security BearerAuth
// @Router /orders/{id} [put]
func (h *OrderHandlers) UpdateOrderHandler(c *gin.Context) {
	var input dto.UpdateOrderInputDTO
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	input.Order_ID = c.Param("id")
	output, err := h.OrderUseCase.UpdateOrder(&input)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, output)
}

// DeleteOrderHandler
// @Summary Delete an Order entity
// @Description Delete an Order entity
// @Tags Orders
// @Accept json
// @Produce json
// @Param id path string true "Order ID"
// @Success 200 {string} string
// @Security BearerAuth
// @Router /orders/{id} [delete]
func (h *OrderHandlers) DeleteOrderHandler(c *gin.Context) {
	var input dto.DeleteOrderInputDTO
	input.ID = c.Param("id")
	err := h.OrderUseCase.DeleteOrder(input.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	message := fmt.Sprintf("Order %s deleted successfully", input.ID)
	c.JSON(http.StatusOK, gin.H{"message": message})
}
